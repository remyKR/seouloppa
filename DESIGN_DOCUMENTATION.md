# 서울오빠 디자인 문서

## 디자인 시스템 정보

### Figma 연동 정보
- **API Key**: `YOUR_FIGMA_TOKEN_HERE`
- **디자인 시스템 파일**: https://www.figma.com/file/dwrMToEyrZlrXr9UYBOlz5/Design?node-id=349-8194&t=TI2Fvuup3UZme680-1
- **디자인 시스템 페이지**: https://www.figma.com/file/dwrMToEyrZlrXr9UYBOlz5/Design?node-id=349-8437&t=TI2Fvuup3UZme680-1
- **UI 페이지**: https://www.figma.com/file/dwrMToEyrZlrXr9UYBOlz5/Design?node-id=0-1
- **파일 ID**: `dwrMToEyrZlrXr9UYBOlz5`

### 디자인 원칙
- 모던하고 깔끔한 UI/UX
- 사용자 친화적인 인터페이스
- 일관된 컴포넌트 시스템

### 컬러 시스템
- **Primary Colors**: primary, primaryLight, primaryDark
- **Gray Scale**: gray/white, gray/100~900, gray/bg
- **Semantic Colors**: error/err500, success/suc500
- **Theme Colors**: 🌕/Black, 🌕/White

### 타이포그래피
- **Font Family**: Pretendard (한글), Outfit (영문/숫자/특수문자)
- **Naming Convention**: {size}{weight}{lineheight}
- **Weight**: bd(Bold), sb(SemiBold), rg(Regular)
- **Sizes**: 11px ~ 60px

### 컴포넌트
(Figma 파일에서 가져올 예정)

### 아이콘
(Figma 파일에서 가져올 예정)

## MCP Figma 연동 설정
```json
{
  "mcpServers": {
    "figma": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-figma"],
      "env": {
        "FIGMA_PERSONAL_ACCESS_TOKEN": "YOUR_FIGMA_TOKEN_HERE"
      }
    }
  }
}
```

## 사용 방법
1. MCP 설정 파일에 위 설정 추가
2. Figma 파일 URL 제공 시 디자인 데이터 자동 동기화
3. 컴포넌트, 스타일, 에셋 정보 실시간 접근 가능

### MCP Figma 테스트 방법
```bash
# MCP 서버 실행 테스트
npx -y @modelcontextprotocol/server-figma

# 환경변수 설정 후 실행
export FIGMA_PERSONAL_ACCESS_TOKEN="YOUR_FIGMA_TOKEN_HERE"
```

### Figma API 직접 호출 예시
```bash
# 파일 정보 가져오기
curl -H "X-FIGMA-TOKEN: YOUR_FIGMA_TOKEN_HERE" \
  "https://api.figma.com/v1/files/dwrMToEyrZlrXr9UYBOlz5"
```

## Variables 추출 프로세스

### 1. Variables 추출 방법
```bash
# Figma Variables API 호출
curl -H "X-FIGMA-TOKEN: YOUR_FIGMA_TOKEN_HERE" \
  "https://api.figma.com/v1/files/dwrMToEyrZlrXr9UYBOlz5/variables/local_variables"
```

### 2. 추출된 Variables 종류
- **Color Variables**: 39개 색상 토큰
  - Primary: pri100, pri300, pri400, pri500, pri975
  - Gray Scale: white, 100~900, bg
  - Semantic: error/err500, success/suc500
  - Theme: 🌕/Black, 🌕/White
- **String Variables**: 앱 전반에 사용되는 텍스트 토큰

### 3. Flutter Variables 클래스 생성
**자동 생성된 파일:**
- `/lib/theme/app_colors.dart` - Color Variables
- `/lib/theme/app_strings.dart` - String Variables
- `sync_figma_variables.js` - 자동 동기화 스크립트

### 4. Variables 업데이트 프로세스
1. Figma에서 Variables 수정
2. 자동 동기화 스크립트 실행 또는 수동 API 호출
3. Flutter 클래스 자동 업데이트
4. Hot reload를 통한 즉시 반영

### 5. Variables 사용 방법
```dart
// 색상 사용
Container(
  color: AppColors.primary,
  child: Text(
    AppStrings.appName,
    style: TextStyle(color: AppColors.onPrimary),
  ),
)

// 텍스트 사용
AppTypography.mixedText(
  AppStrings.travel,
  AppTypography.s16rg22,
  color: AppColors.textPrimary,
)
```

### 6. 주의사항
- **Variables vs 노드 색상**: 실제 정의된 Variables만 사용 (노드에서 추출한 색상 X)
- **네이밍 규칙**: Figma에서 지정한 name 그대로 사용
- **자동 동기화**: Variables 변경 시 스크립트를 통한 자동 업데이트 권장

### 7. 다음 요청 시 적용 사항
Variables 추출 요청 시:
1. Figma Variables API 사용 (`/variables/local_variables`)
2. Color + String Variables 모두 추출
3. Figma name 그대로 유지
4. Flutter 클래스 자동 생성 (`app_colors.dart`, `app_strings.dart`)
5. 기존 노드 색상은 무시하고 실제 Variables만 사용