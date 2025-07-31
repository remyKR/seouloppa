# UI 개발 강제 검증 프로토콜

## 🎯 UI 개발 1순위 법칙
**1. Figma Frame 구조(Column, Row) 완벽 일치 구현**
**2. Column, Row, Container 이름을 그대로 사용**
**3. 사용자가 Figma 노드(프레임) 이름 언급 시 동일한 위젯으로 인식**

## 🎯 UI 개발 최종 목표
**Figma 디자인을 있는 그대로 100% 정확히 구현하는 것**

## ⚠️ 절대 원칙
**UI 요소 발견 즉시 작업 중단 → Figma 확인 → 노드 추출 → 반응형 구현**

## 금지 사항 (절대 사용 금지)
- ❌ `Icons.` (Material Icons)
- ❌ `Text('🇰🇷')` (이모지)
- ❌ `CupertinoIcons.`
- ❌ **폰트 스타일 하드코딩** (개발해 놓은 스타일 사용 필수)
- ❌ **컬러, Gap, Margin, Spacing 하드코딩** (디자인 토큰 사용 필수)
- ❌ **컴포넌트 요소 하드코딩** (개발해 놓은 컴포넌트 사용 필수)
- ❌ 임의 색상 코드
- ❌ 추측에 의한 구현
- ❌ **Gap 값 추측 또는 임의 설정** (신규 추가)
- ❌ **SizedBox 높이값 임의 지정** (반드시 Figma gap 추출)

## 허용 사항 (오직 이것만)
- ✅ `SvgPicture.asset('assets/icon/...')`
- ✅ `Image.asset('assets/icon/...')`
- ✅ **개발해 놓은 폰트 스타일 (AppTypography.*** 사용 필수)
- ✅ **개발해 놓은 디자인 토큰 (AppColors.**, **AppSpacing.*** 사용 필수)
- ✅ **개발해 놓은 컴포넌트 (CustomButton, 기타 위젯 사용 필수)**
- ✅ Figma에서 추출한 정확한 색상 코드
- ✅ **Figma에서 추출한 정확한 gap 값만 사용** (신규 추가)
- ✅ **Auto Layout gap → SizedBox(height: 정확한_gap값)** (신규 추가)

## 강제 검증 6단계 (Figma 노드 기반)

### STEP 1: Figma 노드 추출
```
mcp__figma__get_code 실행 → 노드의 모든 속성 추출
- Layout (Row, Column, Stack)
- Alignment (MainAxis, CrossAxis)
- 크기 (width, height, constraints)
- 색상 (정확한 hex 코드)
- Spacing (padding, margin, gap)
- Sizing (hug, fill, fixed)
```

### STEP 1.5: Figma Gap 값 필수 추출 ⚠️ 신규 추가
```
🚨 모든 Auto Layout 프레임의 gap 값 필수 추출
- main_content gap 값 확인
- button_container gap 값 확인
- 모든 wrapper 프레임 gap 값 확인
- SizedBox(height: XX) 대신 정확한 gap 값 사용
- 추측 금지, 임의 설정 금지, 반드시 Figma에서 추출
```

### STEP 2: 에셋 파일 확인
```
LS assets/ → 이미지/아이콘 파일 존재 여부 확인
```

### STEP 3: 반응형 레이아웃 구조 설계 (Figma Frame 구조 완벽 일치)
```
🚨 Figma Frame 이름 그대로 사용 필수
- Figma "main_content" → Widget 이름도 "main_content"
- Figma "button_container" → Widget 이름도 "button_container"  
- Figma "text_container" → Widget 이름도 "text_container"

Figma 노드 구조 → Flutter Widget Tree 1:1 매핑
- Frame → Container/Column/Row (이름 동일하게)
- Auto Layout → Flex properties
- Constraints → Expanded/Flexible
```

### STEP 4: 정확한 스타일 적용 (하드코딩 금지)
```
🚨 반드시 개발해 놓은 스타일/토큰 사용
- 폰트: AppTypography.s16rg26 (하드코딩 금지)
- 색상: AppColors.primary (Color(0xFF123456) 금지)
- 간격: AppSpacing.medium (EdgeInsets.all(16) 금지)
- 컴포넌트: CustomButton() (ElevatedButton 직접 구현 금지)

Figma 스타일 → Flutter 개발 토큰 1:1 매핑
- Figma 색상 → AppColors.*** 
- Figma 폰트 → AppTypography.***
- Figma 간격 → AppSpacing.***
- Figma 컴포넌트 → Custom위젯()
```

### STEP 5: 반응형 검증
```
다양한 화면 크기에서 Figma와 동일하게 작동하는지 검증
- 작은 화면 (iPhone SE)
- 중간 화면 (iPhone 14)
- 큰 화면 (iPhone 14 Pro Max)
```

## 작업 중단 트리거
다음 상황에서 즉시 작업 중단:
- UI 요소(아이콘, 이미지, 색상, 레이아웃) 작업 시
- `Icons.`를 타이핑하려는 순간  
- 색상을 추측하려는 순간
- **Figma 노드 정보 없이 레이아웃 구성하려는 순간**
- **임의의 크기나 간격을 사용하려는 순간**
- **🚨 Gap 값을 추측하거나 임의로 설정하려는 순간 (신규 추가)**
- **🚨 SizedBox 높이를 Figma gap 확인 없이 설정하려는 순간 (신규 추가)**
- **텍스트에 반응형 속성(Auto Scale, Fit Box 등) 적용하려는 순간**
- **Figma 지정 height를 무시하고 자동 늘어나는 반응형 height 적용하려는 순간**

## Figma → Flutter 매핑 규칙

### 레이아웃 매핑
```
Figma Frame (Vertical) → Column
Figma Frame (Horizontal) → Row  
Figma Frame (Manual) → Stack
Figma Auto Layout → Flex/Expanded
```

### 크기 제약 매핑
```
Figma "Hug contents" → MainAxisSize.min
Figma "Fill container" → Expanded/Flexible
Figma "Fixed" → 고정 width/height
```

### 텍스트 처리 규칙
```
- 텍스트에 반응형 속성 부여하지 않음 (anti-aliasing 퀄리티 유지)
- 고정 fontSize 사용 (Figma 디자인 그대로)
- 텍스트 크기 자동 조절 금지
```

### Height 값 처리 규칙
```
- Figma에서 지정된 height 설정 그대로 적용 (Fixed/Fill/Hug 등)
- 반응형으로 자동 늘어나는 height 기능 적용 금지
- Figma "Fixed height" → 고정 height 값 사용
- Figma "Fill height" → 지정된 비율/제약에 따른 height
- Figma "Hug height" → 콘텐츠에 맞춘 height (하지만 동적 확장 없음)
- 화면 크기 변화에 따른 height 자동 조절 금지
```

### 정렬 매핑
```
Figma 정렬 → MainAxisAlignment/CrossAxisAlignment
Figma 간격 → Gap/SizedBox/EdgeInsets
```

## 완료 후 검증
- `Grep "Icons\."` → 0개 결과
- `Grep "🇰🇷"` → 0개 결과  
- **Figma와 픽셀 퍼펙트 일치 확인**
- **반응형 동작 3가지 화면 크기 테스트**
- 모든 UI 요소가 assets에서 로드되는지 확인

## 위반 시 조치
1. 즉시 작업 중단
2. 문제 코드 제거
3. **Figma에서 정확한 노드 정보 재추출**
4. **노드 속성 기반으로 정확한 반응형 구현**
5. **픽셀 퍼펙트 검증 후 완료**