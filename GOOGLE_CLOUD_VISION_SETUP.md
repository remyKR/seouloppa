# Google Cloud Vision API 설정 가이드

## 1. Google Cloud Console 설정

1. [Google Cloud Console](https://console.cloud.google.com/)에 접속
2. 새 프로젝트 생성 또는 기존 프로젝트 선택
3. "API 및 서비스" > "라이브러리" 이동
4. "Cloud Vision API" 검색 및 활성화

## 2. API 키 생성

1. "API 및 서비스" > "사용자 인증 정보" 이동
2. "사용자 인증 정보 만들기" > "API 키" 선택
3. 생성된 API 키 복사

## 3. API 키 설정

### 옵션 1: 직접 코드에 입력 (개발용)
```dart
// lib/services/google_cloud_vision_service.dart
static const String _apiKey = 'YOUR_API_KEY_HERE'; // 여기에 API 키 입력
```

### 옵션 2: 환경 변수 사용 (권장)
```bash
# .env 파일 생성
GOOGLE_CLOUD_VISION_API_KEY=your_api_key_here
```

## 4. API 키 보안

- **중요**: API 키를 Git에 커밋하지 마세요
- `.gitignore`에 `.env` 파일 추가
- 프로덕션에서는 서버 사이드 프록시 사용 권장

## 5. 사용량 및 요금

- 무료 할당량: 월 1,000건
- 이후 요금: $1.50 / 1,000건
- [가격 정책 상세](https://cloud.google.com/vision/pricing)

## 6. API 키 제한 설정 (권장)

1. Google Cloud Console > "사용자 인증 정보"
2. 생성한 API 키 클릭
3. "애플리케이션 제한사항" 설정
   - Android: 패키지 이름 추가
   - iOS: 번들 ID 추가
4. "API 제한사항" 설정
   - Cloud Vision API만 선택

## 7. 테스트

1. 프로필 사진 업로드
2. "얼굴 인증하기" 버튼 클릭
3. 카메라로 셀카 촬영
4. 인증 결과 확인