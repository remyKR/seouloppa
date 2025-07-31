# SeoulOppa - 한국 남성과 외국인 여성 매칭 앱

A new Flutter project.

## 🚀 빠른 시작

### iOS 빌드
```bash
./scripts/build_ios.sh
```

### 빌드 문제 해결
빌드 문제가 발생하면 [BUILD_TROUBLESHOOTING.md](BUILD_TROUBLESHOOTING.md)를 참조하세요.

### 개발환경 설정
처음 설치하는 경우 [DEVELOPMENT_ENVIRONMENT.md](DEVELOPMENT_ENVIRONMENT.md)를 참조하세요.

## 📱 프로젝트 구조

### 주요 기능
- 탭-투-업로드 사진/동영상 기능
- Google Cloud Vision API 얼굴 인증
- 완전한 회원가입 플로우
- 크로스 플랫폼 지원 (iOS/Web)

### 회원가입 단계
1. **기본정보**: 닉네임, 생년월일, 성별
2. **프로필사진**: 사진/동영상 업로드 + 얼굴 인증
3. **자기소개**: 키, 체형, 국적, MBTI, 언어

## 🛠 개발 환경

⚠️ **버전 고정**: 아래 버전으로만 개발하며, 임의 업그레이드/다운그레이드 금지

- **Xcode**: 15.3 (15E204a)
- **Flutter**: 3.19.6 (Stable)
- **Dart**: 3.3.4 (Flutter와 함께 설치)
- **CocoaPods**: 1.13.0
- **Google Cloud Vision API**: 얼굴 인증용

자세한 설치 가이드: [DEVELOPMENT_ENVIRONMENT.md](DEVELOPMENT_ENVIRONMENT.md)

## 📋 개발 규칙

모든 개발은 [project_rules.md](lib/project_rules.md)를 따릅니다.

## 🔧 빌드 스크립트

### 자동 빌드 준비
```bash
./scripts/build_ios.sh
```

### 수동 정리 (문제 발생 시)
```bash
flutter clean
rm -rf ios/Pods ios/Podfile.lock
rm -rf ~/Library/Developer/Xcode/DerivedData/Runner*
flutter pub get
cd ios && pod install
```

## 📱 실행 방법

### 시뮬레이터
```bash
flutter run -d [시뮬레이터_ID]
```

### 물리적 디바이스 (권장: Xcode)
```bash
open ios/Runner.xcworkspace
```
Xcode에서 Product → Run

## 🔍 디바이스 확인
```bash
flutter devices
```

## ⚠️ 알려진 문제

1. **Pods_Runner 프레임워크 에러**: CocoaPods 재설치 필요
2. **Manifest.lock 동기화 문제**: 캐시 정리 후 재설치
3. **코드 서명 문제**: Xcode에서 Apple Developer 계정 설정

자세한 해결 방법은 [BUILD_TROUBLESHOOTING.md](BUILD_TROUBLESHOOTING.md) 참조

## 🎨 디자인 통합

### Figma 연동
디자인 시스템과 I.A는 Figma를 통해 관리됩니다.
자세한 설정: [FIGMA_INTEGRATION.md](FIGMA_INTEGRATION.md)

## 📄 라이선스

This project is a starting point for a Flutter application.
