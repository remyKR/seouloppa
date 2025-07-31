#!/usr/bin/env python3
"""
Figma Variables Extractor
Figma API를 사용해서 디자인 토큰(색상, 폰트, 간격 등)을 추출하는 스크립트
"""

import requests
import json
from collections import defaultdict
import os

class FigmaVariablesExtractor:
    def __init__(self, api_key):
        self.api_key = api_key
        self.base_url = "https://api.figma.com/v1"
        self.headers = {"X-Figma-Token": api_key}
        
        # 추출된 디자인 토큰들을 저장할 딕셔너리
        self.design_tokens = {
            "colors": defaultdict(set),
            "fonts": defaultdict(set),
            "font_sizes": defaultdict(set),
            "spacing": defaultdict(set),
            "border_radius": defaultdict(set),
            "line_heights": defaultdict(set),
            "letter_spacing": defaultdict(set),
            "opacity": defaultdict(set)
        }
    
    def rgb_to_hex(self, r, g, b, a=1.0):
        """RGB 값을 HEX 색상코드로 변환"""
        r = int(r * 255)
        g = int(g * 255)  
        b = int(b * 255)
        
        if a < 1.0:
            return f"rgba({r}, {g}, {b}, {a:.2f})"
        else:
            return f"#{r:02x}{g:02x}{b:02x}"
    
    def extract_colors_from_fills(self, fills):
        """fills에서 색상 정보 추출"""
        colors = []
        if not fills:
            return colors
            
        for fill in fills:
            if fill.get("type") == "SOLID" and "color" in fill:
                color = fill["color"]
                hex_color = self.rgb_to_hex(
                    color.get("r", 0),
                    color.get("g", 0), 
                    color.get("b", 0),
                    color.get("a", 1.0)
                )
                colors.append(hex_color)
        return colors
    
    def extract_text_styles(self, style):
        """텍스트 스타일에서 폰트 정보 추출"""
        if not style:
            return
            
        # 폰트 패밀리
        if "fontFamily" in style:
            self.design_tokens["fonts"]["family"].add(style["fontFamily"])
        
        # 폰트 크기
        if "fontSize" in style:
            self.design_tokens["font_sizes"]["size"].add(f"{style['fontSize']}px")
        
        # 폰트 두께
        if "fontWeight" in style:
            self.design_tokens["fonts"]["weight"].add(style["fontWeight"])
        
        # 라인 높이
        if "lineHeightPx" in style:
            self.design_tokens["line_heights"]["px"].add(f"{style['lineHeightPx']}px")
        elif "lineHeightPercent" in style:
            self.design_tokens["line_heights"]["percent"].add(f"{style['lineHeightPercent']}%")
        
        # 글자 간격
        if "letterSpacing" in style:
            self.design_tokens["letter_spacing"]["spacing"].add(f"{style['letterSpacing']}px")
    
    def extract_layout_properties(self, node):
        """레이아웃 속성에서 간격 정보 추출"""
        # 패딩
        for prop in ["paddingLeft", "paddingRight", "paddingTop", "paddingBottom"]:
            if prop in node:
                self.design_tokens["spacing"]["padding"].add(f"{node[prop]}px")
        
        # 아이템 간격
        if "itemSpacing" in node:
            self.design_tokens["spacing"]["item"].add(f"{node['itemSpacing']}px")
        
        # 테두리 반지름
        if "cornerRadius" in node:
            self.design_tokens["border_radius"]["radius"].add(f"{node['cornerRadius']}px")
    
    def extract_effects(self, effects):
        """효과에서 그림자, 블러 등 추출"""
        if not effects:
            return
            
        for effect in effects:
            if effect.get("type") == "DROP_SHADOW":
                # 그림자 색상
                if "color" in effect:
                    color = effect["color"]
                    hex_color = self.rgb_to_hex(
                        color.get("r", 0),
                        color.get("g", 0),
                        color.get("b", 0), 
                        color.get("a", 1.0)
                    )
                    self.design_tokens["colors"]["shadow"].add(hex_color)
    
    def process_node(self, node, node_type="unknown"):
        """노드를 재귀적으로 처리하여 디자인 토큰 추출"""
        # 색상 추출
        if "fills" in node:
            colors = self.extract_colors_from_fills(node["fills"])
            for color in colors:
                self.design_tokens["colors"][node_type].add(color)
        
        if "strokes" in node:
            colors = self.extract_colors_from_fills(node["strokes"])
            for color in colors:
                self.design_tokens["colors"]["stroke"].add(color)
        
        # 텍스트 스타일 추출
        if "style" in node and node.get("type") == "TEXT":
            self.extract_text_styles(node["style"])
        
        # 레이아웃 속성 추출
        self.extract_layout_properties(node)
        
        # 효과 추출
        if "effects" in node:
            self.extract_effects(node["effects"])
        
        # 투명도
        if "opacity" in node and node["opacity"] != 1.0:
            self.design_tokens["opacity"]["values"].add(node["opacity"])
        
        # 자식 노드들 처리
        if "children" in node:
            for child in node["children"]:
                child_type = child.get("type", "unknown").lower()
                self.process_node(child, child_type)
    
    def get_file_data(self, file_key):
        """Figma 파일 데이터 가져오기"""
        try:
            url = f"{self.base_url}/files/{file_key}"
            response = requests.get(url, headers=self.headers)
            response.raise_for_status()
            return response.json()
        except requests.exceptions.RequestException as e:
            print(f"파일 데이터를 가져오는데 실패했습니다: {e}")
            return None
    
    def get_variables(self, file_key):
        """Figma Variables API 시도 (권한이 있다면)"""
        try:
            url = f"{self.base_url}/files/{file_key}/variables/local"
            response = requests.get(url, headers=self.headers)
            if response.status_code == 200:
                return response.json()
            else:
                print(f"Variables API 접근 불가 (권한 필요): {response.status_code}")
                return None
        except Exception as e:
            print(f"Variables API 호출 실패: {e}")
            return None
    
    def extract_tokens_from_file(self, file_key):
        """파일에서 디자인 토큰 추출"""
        print(f"Figma 파일 {file_key}에서 디자인 토큰을 추출 중...")
        
        # Variables API 시도
        variables_data = self.get_variables(file_key)
        if variables_data:
            print("Variables API를 통해 데이터를 가져왔습니다.")
            # Variables 데이터 처리 로직 추가 가능
        
        # 일반 파일 API로 노드 데이터 가져오기
        file_data = self.get_file_data(file_key)
        if not file_data:
            return
        
        # 문서 노드부터 시작해서 모든 노드 처리
        document = file_data.get("document")
        if document:
            self.process_node(document, "document")
        
        print("디자인 토큰 추출 완료!")
    
    def generate_css_variables(self):
        """CSS 변수 형태로 토큰 생성"""
        css_vars = [":root {"]
        
        # 색상
        color_index = 1
        for category, colors in self.design_tokens["colors"].items():
            for color in sorted(colors):
                css_vars.append(f"  --color-{category}-{color_index}: {color};")
                color_index += 1
        
        # 폰트
        for category, fonts in self.design_tokens["fonts"].items():
            font_index = 1
            for font in sorted(fonts):
                css_vars.append(f"  --font-{category}-{font_index}: {font};")
                font_index += 1
        
        # 폰트 크기
        for category, sizes in self.design_tokens["font_sizes"].items():
            size_index = 1
            for size in sorted(sizes, key=lambda x: float(x.replace('px', ''))):
                css_vars.append(f"  --font-size-{size_index}: {size};")
                size_index += 1
        
        # 간격
        for category, spacings in self.design_tokens["spacing"].items():
            spacing_index = 1
            for spacing in sorted(spacings, key=lambda x: float(x.replace('px', ''))):
                css_vars.append(f"  --spacing-{category}-{spacing_index}: {spacing};")
                spacing_index += 1
        
        css_vars.append("}")
        return "\n".join(css_vars)
    
    def generate_design_tokens_json(self):
        """디자인 토큰을 JSON 형태로 생성"""
        # Set을 list로 변환하여 JSON serializable하게 만들기
        tokens_dict = {}
        for category, subcategories in self.design_tokens.items():
            tokens_dict[category] = {}
            for subcategory, values in subcategories.items():
                tokens_dict[category][subcategory] = sorted(list(values))
        
        return tokens_dict
    
    def save_to_files(self, output_dir="./design_tokens"):
        """추출된 토큰을 파일로 저장"""
        os.makedirs(output_dir, exist_ok=True)
        
        # JSON 파일로 저장
        tokens_json = self.generate_design_tokens_json()
        with open(f"{output_dir}/design_tokens.json", "w", encoding="utf-8") as f:
            json.dump(tokens_json, f, indent=2, ensure_ascii=False)
        
        # CSS 변수로 저장
        css_vars = self.generate_css_variables()
        with open(f"{output_dir}/design_tokens.css", "w", encoding="utf-8") as f:
            f.write(css_vars)
        
        print(f"디자인 토큰이 {output_dir} 디렉토리에 저장되었습니다:")
        print(f"- design_tokens.json: JSON 형태의 토큰")
        print(f"- design_tokens.css: CSS 변수 형태의 토큰")
    
    def print_summary(self):
        """추출된 토큰 요약 출력"""
        print("\n=== 추출된 디자인 토큰 요약 ===")
        
        for category, subcategories in self.design_tokens.items():
            if any(subcategories.values()):
                print(f"\n{category.upper()}:")
                for subcategory, values in subcategories.items():
                    if values:
                        print(f"  {subcategory}: {len(values)}개")
                        # 처음 5개만 예시로 보여주기
                        examples = [str(item) for item in list(values)[:5]]
                        print(f"    예시: {', '.join(examples)}")


def main():
    # API 키와 파일 정보
    API_KEY = "YOUR_FIGMA_TOKEN_HERE"
    FILE_KEY = "dwrMToEyrZlrXr9UYBOlz5"  # URL에서 추출한 파일 키
    
    # 추출기 생성 및 실행
    extractor = FigmaVariablesExtractor(API_KEY)
    extractor.extract_tokens_from_file(FILE_KEY)
    
    # 결과 출력 및 저장
    extractor.print_summary()
    extractor.save_to_files()


if __name__ == "__main__":
    main()