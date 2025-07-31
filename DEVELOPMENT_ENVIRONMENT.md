# 개발환경 설정 가이드

## 🚨 중요 알림
**이 프로젝트는 아래 명시된 버전으로만 개발합니다.**
**임의로 소프트웨어 버전을 업그레이드하거나 다운그레이드하지 마세요!**

## 📋 필수 개발환경

### ✅ Xcode
- **버전**: Xcode 15.3 (15E204a)
- **이유**: Xcode 16.x는 일부 플러그인 충돌 있음
- **확인**: `xcode-select --version`

### ✅ Flutter
- **버전**: Flutter 3.19.6 (Stable)
- **이유**: Firebase, iOS, Android 모두 안정적
- **확인**: `flutter --version`

### ✅ Dart SDK
- **버전**: Dart 3.3.4
- **이유**: Flutter 3.19.6과 호환
- **자동 설치**: Flutter와 함께 설치됨

### ✅ CocoaPods
- **버전**: CocoaPods 1.13.0 (정확히 이 버전만 사용)
- **Ruby 의존성**: activesupport 7.0.8 (호환성 필수)
- **이유**: Apple Silicon 호환성 가장 우수한 버전 중 하나
- **확인**: `pod --version`

## 🔧 설치 가이드

### 1. Xcode 설치
1. App Store에서 Xcode 15.3 설치
2. Xcode Command Line Tools 설치:
   ```bash
   xcode-select --install
   ```

### 2. Flutter 설치
```bash
# Flutter 3.19.6 다운로드
curl -o ~/Downloads/flutter_macos_3.19.6-stable.zip https://storage.googleapis.com/flutter_infra_release/releases/stable/macos/flutter_macos_3.19.6-stable.zip

# 압축 해제 및 설치
cd ~/Downloads
unzip flutter_macos_3.19.6-stable.zip
mkdir -p ~/development
mv flutter ~/development/

# PATH 설정
echo 'export PATH="$PATH:$HOME/development/flutter/bin"' >> ~/.zshrc
source ~/.zshrc
```

### 3. CocoaPods 설치
```bash
# activesupport 7.0.8 설치 (호환성 필수)
gem install activesupport -v 7.0.8 --user-install

# CocoaPods 1.13.0 설치
gem install cocoapods -v 1.13.0 --user-install

# PATH 설정
echo 'export PATH="$PATH:$HOME/.local/share/gem/ruby/3.2.0/bin"' >> ~/.zshrc
source ~/.zshrc
```

## 🔍 설치 확인

모든 소프트웨어가 올바른 버전으로 설치되었는지 확인:

```bash
# 버전 확인 스크립트
echo "=== 개발환경 버전 확인 ==="
echo "Xcode:"
xcode-select --version

echo -e "\nFlutter:"
flutter --version

echo -e "\nCocoaPods:"
pod --version
```

**예상 출력:**
```
=== 개발환경 버전 확인 ===
Xcode:
xcode-select version 2408.

Flutter:
Flutter 3.19.6 • channel stable • https://github.com/flutter/flutter.git
Framework • revision 54e66469a9 (1 year, 3 months ago) • 2024-04-17 13:08:03 -0700
Engine • revision c4cd48e186
Tools • Dart 3.3.4 • DevTools 2.31.1

CocoaPods:
1.13.0
```

## ⚠️ 버전 관리 규칙

### 절대 금지 사항
- ❌ `flutter upgrade` 실행 금지
- ❌ `pod update` 대신 `pod install` 사용
- ❌ Xcode 자동 업데이트 허용 금지
- ❌ 임의적인 버전 변경 금지

### 권장 사항
- ✅ 새로운 팀원은 반드시 이 문서의 버전으로 설치
- ✅ 프로젝트 시작 전 항상 버전 확인
- ✅ 빌드 문제 발생시 버전 불일치 먼저 확인

## 🚀 Flutter Doctor 설정

Flutter 설치 후 필수 설정:

```bash
# Flutter doctor 실행하여 문제점 확인
flutter doctor

# iOS 개발을 위한 추가 설정
flutter doctor --android-licenses (선택사항)
```

## 📱 iOS 개발 환경

### Xcode 설정
1. Xcode 실행
2. Preferences → Accounts → Apple ID 로그인 (물리적 디바이스용)
3. iOS 시뮬레이터 설치 확인

### 시뮬레이터 확인
```bash
# 사용 가능한 시뮬레이터/디바이스 목록
flutter devices
```

## 🔄 환경 초기화 (문제 발생시)

개발환경에 문제가 발생한 경우:

```bash
# Flutter 캐시 정리
flutter clean

# CocoaPods 정리
rm -rf ios/Pods ios/Podfile.lock

# Xcode DerivedData 정리
rm -rf ~/Library/Developer/Xcode/DerivedData/Runner*

# 의존성 재설치
flutter pub get
cd ios && pod install
```

## 📄 참고 문서

- [BUILD_TROUBLESHOOTING.md](BUILD_TROUBLESHOOTING.md) - 빌드 문제 해결
- [GOOGLE_CLOUD_VISION_SETUP.md](GOOGLE_CLOUD_VISION_SETUP.md) - API 설정
- [UI_DEVELOPMENT_RULES.md](UI_DEVELOPMENT_RULES.md) - UI 개발 규칙

---

**⚡ 중요**: 이 개발환경은 Kupid 프로젝트의 안정적인 개발을 위해 신중히 선택된 버전들입니다. 다른 버전 사용시 예상치 못한 오류가 발생할 수 있습니다.