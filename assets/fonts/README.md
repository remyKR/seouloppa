# 폰트 파일 정보

## Pretendard 폰트 (한글)
서울오빠 앱의 주요 한글 폰트입니다.

### 필요한 폰트 파일:
- Pretendard-Bold.otf (또는 .ttf) - Font Weight: 700
- Pretendard-SemiBold.otf (또는 .ttf) - Font Weight: 600
- Pretendard-Regular.otf (또는 .ttf) - Font Weight: 400

### 다운로드
[Pretendard 공식 GitHub](https://github.com/orioncactus/pretendard)에서 다운로드 가능합니다.

## Outfit 폰트 (영문/숫자/특수문자)
영문, 숫자, 특수문자 전용 폰트입니다.

### 필요한 폰트 파일:
- Outfit-Bold.ttf - Font Weight: 700
- Outfit-SemiBold.ttf - Font Weight: 600
- Outfit-Regular.ttf - Font Weight: 400

### 다운로드
[Google Fonts - Outfit](https://fonts.google.com/specimen/Outfit)에서 다운로드 가능합니다.

## 폰트 작동 방식
- **한글**: Pretendard 폰트 사용
- **영문/숫자/특수문자**: Outfit 폰트 사용 (fontFamilyFallback)
- Flutter에서 자동으로 문자 유형에 따라 적절한 폰트 선택

### 설치 방법
1. 위 폰트 파일들을 이 폴더(assets/fonts/)에 복사합니다.
2. pubspec.yaml 파일의 fonts 섹션이 올바르게 설정되어 있는지 확인합니다.
3. `flutter pub get` 실행