# iOS 빌드 문제 해결 가이드

## 🚀 빠른 해결 방법

빌드 문제가 발생하면 다음 스크립트를 실행하세요:

```bash
./scripts/build_ios.sh
```

## 🔧 수동 해결 단계

### 1. 완전 정리 (Clean Everything)

```bash
# Flutter 캐시 정리
flutter clean

# iOS CocoaPods 정리
rm -rf ios/Pods ios/Podfile.lock

# Xcode DerivedData 정리
rm -rf ~/Library/Developer/Xcode/DerivedData/Runner*

# Build 폴더 정리
rm -rf build
```

### 2. 의존성 재설치

```bash
# Flutter 의존성 설치
flutter pub get

# iOS CocoaPods 설치
cd ios && pod install && cd ..
```

### 3. Xcode 설정 확인

1. **Xcode 워크스페이스 열기**: `open ios/Runner.xcworkspace`
2. **서명 확인**: Runner → TARGETS → Runner → Signing & Capabilities
3. **팀 설정**: Development Team이 설정되어 있는지 확인
4. **Clean Build**: Product → Clean Build Folder (⇧⌘K)

## 🚨 자주 발생하는 문제들

### 1. `Pods_Runner` 프레임워크를 찾을 수 없음

**원인**: CocoaPods 설정 문제
**해결**: 
```bash
cd ios
rm -rf Pods Podfile.lock
pod install
```

### 2. `Manifest.lock` 동기화 문제

**원인**: CocoaPods와 Xcode 캐시 불일치
**해결**:
```bash
flutter clean
rm -rf ~/Library/Developer/Xcode/DerivedData
cd ios && pod install
```

### 3. Firebase 관련 에러

**원인**: Firebase 의존성이 완전히 제거되지 않음
**확인 사항**:
- `pubspec.yaml`에서 Firebase 패키지 주석 처리
- Dart 파일에서 Firebase import 주석 처리
- `AppDelegate.swift`에서 Firebase import 주석 처리

### 4. 코드 서명 문제

**원인**: 물리적 디바이스에 설치 시 서명 필요
**해결**:
1. Xcode에서 Apple Developer 계정 로그인
2. Signing & Capabilities에서 Team 선택
3. Automatically manage signing 체크

### 5. Stale files 에러

**원인**: 이전 빌드 산출물이 남아있음
**해결**:
```bash
rm -rf build
flutter clean
```

## 📱 빌드 권장 방법

### 시뮬레이터용
```bash
flutter run -d [시뮬레이터_ID]
```

### 물리적 디바이스용 (권장)
1. **Xcode 사용** (가장 안정적):
   ```bash
   open ios/Runner.xcworkspace
   ```
   - Product → Run 클릭

2. **Flutter 명령어**:
   ```bash
   flutter run -d [디바이스_ID]
   ```

## 🔍 디바이스 확인

```bash
flutter devices
```

## 📋 환경 체크리스트

- [ ] Flutter 3.4.0+ 설치
- [ ] Xcode 14+ 설치
- [ ] CocoaPods 1.10+ 설치
- [ ] Apple Developer 계정 설정 (물리적 디바이스용)
- [ ] iOS 디바이스 또는 시뮬레이터 연결

## 🎯 빌드 성공 확인

1. **시뮬레이터 테스트**: 먼저 시뮬레이터에서 정상 실행 확인
2. **물리적 디바이스**: 시뮬레이터 성공 후 실제 디바이스 테스트
3. **기능 확인**: 
   - 사진 업로드 기능
   - 얼굴 인증 기능
   - 회원가입 플로우

## 💡 예방 조치

1. **정기적인 정리**: 주기적으로 캐시 정리
2. **안정적인 환경**: 가능하면 USB 연결 사용
3. **Xcode 우선**: 물리적 디바이스는 Xcode 사용 권장
4. **Git 관리**: 빌드 산출물은 Git에 포함하지 않음

## 🆘 최후의 수단

모든 방법이 실패할 경우:

```bash
# 1. 프로젝트 전체 백업
cp -r . ../kupid_backup

# 2. Flutter 프로젝트 새로 생성
flutter create kupid_new

# 3. 소스 코드만 복사
cp -r lib/ ../kupid_new/
cp pubspec.yaml ../kupid_new/
cp -r assets/ ../kupid_new/
cp -r ios/Runner/Info.plist ../kupid_new/ios/Runner/

# 4. 새 프로젝트에서 빌드
cd ../kupid_new
flutter pub get
cd ios && pod install
```

---

*이 문서는 Kupid 프로젝트의 빌드 문제 해결을 위해 작성되었습니다.*