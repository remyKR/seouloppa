# Figma 통합 설정 가이드

## 🎨 Figma MCP 연동 설정

### API 토큰 정보
- **토큰**: `YOUR_FIGMA_TOKEN_HERE`
- **용도**: Figma 디자인 파일 및 FigJam 보드 읽기
- **권한**: 읽기 전용 (Read-only)

### 지원 기능
- ✅ Figma 디자인 파일 읽기
- ✅ FigJam 보드 읽기
- ✅ I.A (정보 구조) 분석
- ✅ 컴포넌트 구조 파싱
- ✅ 디자인 시스템 추출

## 📋 I.A 개발 워크플로우

### 1. FigJam에서 I.A 작성
- 앱의 전체 정보 구조 설계
- 화면별 연결 관계 정의
- 사용자 플로우 매핑

### 2. MCP를 통한 자동 분석
```bash
# Figma 파일 읽기 (예시)
mcp__figma__get_file [FILE_ID]
```

### 3. 코드 구조 자동 생성
- I.A 기반 폴더 구조 생성
- 라우팅 설정 자동 구성
- 화면별 템플릿 파일 생성

## 🔧 사용 방법

### Figma 파일 URL에서 ID 추출
```
https://www.figma.com/file/[FILE_ID]/[FILE_NAME]
```

### FigJam 보드 URL에서 ID 추출
```
https://www.figma.com/board/[BOARD_ID]/[BOARD_NAME]
```

### MCP 명령어 예시
```bash
# 파일 정보 가져오기
mcp__figma__get_file abc123

# 특정 페이지 정보 가져오기
mcp__figma__get_page abc123 page_name

# 컴포넌트 정보 가져오기
mcp__figma__get_components abc123
```

## 📱 프로젝트 적용

### Kupid 앱 I.A 구조
1. **인증 플로우**
   - 로그인/회원가입
   - 소셜 로그인 연동

2. **프로필 설정**
   - 기본정보 입력
   - 사진/동영상 업로드
   - 얼굴 인증

3. **매칭 시스템**
   - 사용자 탐색
   - 매칭 알고리즘
   - 채팅 기능

### 자동 생성될 파일 구조
```
lib/
├── views/
│   ├── auth/
│   ├── profile/
│   └── matching/
├── models/
│   ├── user_model.dart
│   └── match_model.dart
└── services/
    ├── auth_service.dart
    └── matching_service.dart
```

## ⚠️ 보안 고려사항

### 토큰 관리
- **환경변수 설정**: `.env` 파일에 저장
- **Git 제외**: `.gitignore`에 토큰 정보 추가
- **권한 최소화**: 읽기 전용 권한만 사용

### 접근 제한
- **팀 멤버만**: 승인된 사용자만 접근
- **프로젝트 전용**: Kupid 프로젝트만 사용
- **정기 갱신**: 3개월마다 토큰 갱신 검토

## 🔄 업데이트 정책

### 디자인 변경시
1. FigJam에서 I.A 업데이트
2. MCP로 최신 구조 읽기
3. 코드 구조 동기화
4. 팀 공유 및 검토

### 버전 관리
- **I.A 버전**: v1.0, v1.1... 형태로 관리
- **변경 이력**: 각 버전별 변경사항 기록
- **롤백 계획**: 이전 버전으로 복구 가능한 구조

---

**🎯 Figma MCP 연동으로 디자인과 개발의 완벽한 동기화를 실현합니다!**