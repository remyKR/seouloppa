# Figma Design Variables 추출 보고서

## 개요
Figma API를 사용하여 SeoulOppa 프로젝트의 디자인 시스템에서 정의된 Variables와 Styles를 추출했습니다.

## API 정보
- **API Endpoint**: `https://api.figma.com/v1/files/dwrMToEyrZlrXr9UYBOlz5`
- **File ID**: `dwrMToEyrZlrXr9UYBOlz5`
- **추출일**: 2024년 7월 31일

## 추출된 Design System 구성요소

### 1. Color Styles (색상 스타일)
총 **39개**의 색상 스타일이 정의되어 있습니다.

#### Primary Colors (메인 컬러)
- `primary/pri500` - Primary Normal
- `primary/pri400` 
- `primary/pri300` - Press
- `primary/pri975`
- `main/pri 100`

#### Gray Scale (그레이 스케일)
- `gray/white` - Text, Btn, Bg, darkgray(font MainTitle, font SubTitle)
- `gray/100` - Btn, Title, white-theme(fontSubTitle), black-theme(BG-Main-111에서 바뀜)
- `gray/200` - Normal-Icon, Title, white-theme(fontMaintitle), black-theme(Line Normal)
- `gray/300` - Main Text, white-theme(fontSubDesc-626262에서바뀜), black-theme, darkgray-theme (BG Sub-5454에서바뀜)
- `gray/400` - white-theme(font mainDesc)
- `gray/500` - Icon, Guide
- `gray/600` - Disabled element, black-theme (fontMainDesc,fontSubDesc), darkgray(font MainDesc)
- `gray/700` - Disabled Text
- `gray/800` - Vertical Line, white-theme(Line-Normal)
- `gray/900` - Horizontal Line
- `gray/bg` - Background

#### Semantic Colors (시맨틱 컬러)
- `error/err500` - Normal
- `success/suc500` - Normal
- `system/ec`

#### Theme Colors (테마 컬러)
- `🌕/Black`
- `🌕/White`

#### Label Colors
- `Label Color/Light/Primary`
- `Label Color/Dark/Primary`

#### Basic Colors
- `black`
- `red`

### 2. Text Styles (텍스트 스타일)
총 **67개**의 텍스트 스타일이 정의되어 있습니다.

#### 명명 규칙
텍스트 스타일은 `{size}/{weight}/{line-height}` 형식으로 구성됩니다:
- **Size**: 11, 12, 13, 14, 15, 16, 18, 20, 24, 25, 28, 30, 32, 40, 60
- **Weight**: `bd` (bold), `sb` (semibold), `rg` (regular)
- **Line Height**: 120, 130, 140, 160

#### 주요 텍스트 스타일 예시
- `60/bd/60` - 가장 큰 제목용
- `40/bd/120` - 큰 제목용
- `32/bd/120` - 중간 제목용
- `24/bd/140` - 서브 제목용
- `20/bd/140` - 본문 제목용
- `16/rg/140` - 일반 본문용
- `14/rg/140` - 작은 본문용
- `12/rg/140` - 캡션용
- `11/rg/140` - 가장 작은 텍스트용

### 3. Effect Styles (효과 스타일)
- `shadowBox` - 박스 그림자 효과

## 실제 사용된 색상 값 (샘플)

추출된 실제 색상 값들 중 주요 색상들:

| 색상명 | HEX 값 | RGB 값 | 사용 용도 |
|--------|--------|---------|-----------|
| White | `#ffffff` | (255, 255, 255) | 배경, 텍스트 |
| Black | `#000000` | (0, 0, 0) | 텍스트, 아이콘 |
| Primary Red | `#ff3265` | (255, 50, 101) | 메인 액션 |
| Primary Blue | `#2d92f1` | (45, 146, 241) | 버튼, 링크 |
| Gray Scale | `#222222` - `#eeeeee` | 다양한 회색 톤 | UI 요소 |

## 디자인 시스템 특징

### 1. 체계적인 명명 규칙
- 색상: `카테고리/레벨` 형식 (예: `gray/500`, `primary/pri400`)
- 텍스트: `크기/굵기/행간` 형식 (예: `16/rg/140`)

### 2. 테마 지원
- Light/Dark 테마를 고려한 색상 체계
- `🌕/Black`, `🌕/White` 등 테마별 색상 정의

### 3. 시맨틱 컬러 체계
- `error`, `success`, `primary` 등 의미 기반 색상 분류
- 각 색상별로 다양한 톤 제공 (100, 300, 400, 500 등)

### 4. 다양한 텍스트 스타일
- 11px부터 60px까지 다양한 크기
- Bold, Semibold, Regular 세 가지 굵기
- 120%, 130%, 140%, 160% 네 가지 행간

## 권장사항

1. **Flutter 프로젝트 적용**: 이 색상과 텍스트 스타일을 Flutter의 `ThemeData`와 `TextTheme`에 적용
2. **일관성 유지**: 디자인 시스템에 정의된 색상과 텍스트 스타일만 사용
3. **다크 모드 지원**: 정의된 테마 색상을 활용하여 다크 모드 구현
4. **접근성 고려**: 충분한 색상 대비를 위해 정의된 그레이 스케일 활용

## 파일 정보
- 전체 Figma 데이터: `/Users/remy/Desktop/works/seouloppa/figma_full_data.json`
- 색상 추출 데이터: `/Users/remy/Desktop/works/seouloppa/figma_colors_extracted.json`
- 스타일 정리 데이터: `/Users/remy/Desktop/works/seouloppa/organized_styles.json`