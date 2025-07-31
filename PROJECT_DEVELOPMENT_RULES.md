# 프로젝트 개발 15대 법칙

## 🚨 절대 원칙
**이 15가지 법칙은 절대적이며, 어떤 상황에서도 위반할 수 없습니다.**

### 🔴 최우선 원칙: 법칙 준수 > 문제 해결
**모든 행동의 1번 체크사항: 법칙 위반 여부 검증**
- 문제 해결보다 법칙 준수가 우선
- 법칙을 위반해야만 해결 가능한 문제는 해결하지 않음
- 대안이 없다면 문제를 그대로 유지

---

## 📋 15대 법칙

### 📌 법칙 1: Flutter 버전 & 환경 고정
- Flutter는 반드시 3.19.6 (Stable) 사용 (변경 금지)
- Dart는 3.3.4 고정
- CocoaPods는 1.13.0 고정 (정확히 1.13.0만 사용)
- **activesupport는 7.0.8 고정** (CocoaPods 1.13.0 호환성)
- 프로젝트 최상단에 .tool-versions 또는 .flutter-version 명시
- fvm을 도입하여 버전 고정 (fvm use 3.19.6)

### 📌 법칙 2: 필수 설치 및 초기 설정 순서
```bash
flutter clean
flutter pub get
cd ios
pod deintegrate  # 문제 발생시에만 실행
pod install
cd ..
```
- flutter pub upgrade는 절대 사용 금지 (충돌 유발)
- flutter doctor에서 경고가 남아있다면, 다음 단계 금지
- `pod deintegrate`는 CocoaPods 문제 발생시에만 사용

### 📌 법칙 3: iOS 프로젝트 설정 체크리스트
- ios/Podfile: platform :ios, '13.0' 또는 이상만 사용
- GoogleService-Info.plist는 ios/Runner/ 안에 정확히 위치해야 함
- REVERSED_CLIENT_ID는 Info.plist에 반드시 포함
- Runner.xcworkspace로만 Xcode 열기 (.xcodeproj 사용 금지)
```bash
xattr -w com.apple.xcode.CreatedByBuildSystem true ./build/ios/iphoneos
rm -rf ~/Library/Developer/Xcode/DerivedData
```

### 📌 법칙 4: Android 설정 룰
- minSdkVersion은 21 이상으로 고정
- compileSdkVersion과 targetSdkVersion은 34로 맞춤
- android/gradle.properties에 다음 추가:
```properties
android.useAndroidX=true
android.enableJetifier=true
```
- NDK, JDK 버전은 권장 버전 이외 절대 사용 금지

### 📌 법칙 5: Firebase 연동 시 유의사항
- Firebase 패키지는 반드시 버전 명시 (안정 버전):
```yaml
firebase_core: ^2.30.0
firebase_auth: ^4.17.4
firebase_messaging: ^14.9.1
firebase_storage: ^11.7.1
cloud_firestore: ^4.15.8
```
- firebase_options.dart는 flutterfire configure로 자동 생성 후 수정 금지
- GoogleService-Info.plist, google-services.json 위치 정확히 지정
- **분기별 검토**: 3개월마다 Firebase 패키지 버전 업데이트 검토

### 📌 법칙 6: 의존성 추가 및 관리 룰
- 새 패키지 추가 전 pub.dev 최신 버전 확인
- 항상 pubspec.yaml에 버전 명시:
```yaml
flutter_hooks: ^0.20.3
```
- 추가 후 순서: flutter pub get → flutter clean → flutter run

### 📌 법칙 7: 코드 구조 및 상태관리
- UI 로직은 view/, 상태 로직은 model/, 비즈니스 로직은 services/로 분리
- StatefulWidget은 반드시 initState/dispose 구조 갖춰야 함
- 위젯 이름은 PascalCase로, 기능명과 일치

### 📌 법칙 8: 캐시 및 빌드 클린 룰
- 에러 발생 시 가장 먼저 수행하는 순서:
```bash
flutter clean
rm -rf ios/Pods
rm -rf ios/Podfile.lock
cd ios && pod install && cd ..
```
- Simulator에서 갑자기 앱이 실행 안 되면:
```bash
rm -rf ~/Library/Developer/Xcode/DerivedData
```

### 📌 법칙 9: 실시간 Hot Reload 충돌 방지
- State<> 관련 오류 발생 방지:
  - State<MyWidget> 선언 시 클래스와 정확히 일치해야 함
  - 클래스명 오타, dynamic 사용 금지

### 📌 법칙 10: 에러 처리 표준화
- **개발 환경**: try-catch는 반드시 다음 구조로 작성:
```dart
try {
  await someAsyncCode();
} catch (e, stackTrace) {
  debugPrint('ERROR: $e');
  debugPrintStack(stackTrace: stackTrace);
}
```
- **프로덕션 환경**: 사용자 친화적 에러 처리 추가:
```dart
try {
  await someAsyncCode();
} catch (e, stackTrace) {
  debugPrint('ERROR: $e');
  debugPrintStack(stackTrace: stackTrace);
  // 사용자에게 적절한 에러 메시지 표시
  showErrorDialog('작업 중 문제가 발생했습니다.');
}
```

### 📌 법칙 11: 버전 관리 규칙 (개선됨)
- **일상적 금지**: flutter upgrade, flutter pub upgrade, pod update 사용 금지
- **정기 검토**: 월 1회 팀 검토 후 필요시 업데이트 허용
- **보안 업데이트**: 중요 보안 패치는 즉시 적용
- **업데이트 절차**:
  1. 팀 합의 후 테스트 브랜치에서 검증
  2. 모든 기능 정상 작동 확인
  3. 메인 브랜치 적용
- **예외 상황**: 치명적 버그나 보안 취약점 발견시 즉시 업데이트

### 📌 법칙 12: 코드 수정 전 필수 백업
- **모든 수정 전**: 현재 작업 상태를 Git commit 또는 stash
- **중요 파일 수정시**: 별도 백업 파일(.backup) 생성
- **실험적 변경**: 새 브랜치 생성 후 작업
```bash
# 안전한 수정 절차
git add . && git commit -m "작업 전 백업"
cp important_file.dart important_file.dart.backup
git checkout -b feature/experiment
```
- **되돌리기 불가능한 작업 금지**: 복구 방법 없는 변경 절대 금지

### 📌 법칙 13: API 키 및 민감정보 보안
- **하드코딩 절대 금지**: 모든 API 키, 토큰, 비밀번호는 환경변수 사용
- **`.env` 파일 관리**: 
  - `.env` 파일은 `.gitignore`에 반드시 추가
  - `.env.example` 파일로 구조만 공유
```dart
// ❌ 절대 금지
const String apiKey = 'sk-1234567890abcdef';

// ✅ 올바른 방법
final String apiKey = dotenv.env['API_KEY'] ?? '';
```
- **커밋 전 검증**: `git diff`로 민감정보 포함 여부 확인
- **실수 커밋시**: 즉시 Git history에서 완전 제거

### 📌 법칙 14: 디바이스별 테스트 의무화
- **시뮬레이터 우선**: 모든 기능을 시뮬레이터에서 먼저 테스트
- **물리 디바이스 필수**: 다음 기능은 반드시 실제 디바이스에서 테스트
  - 카메라 기능
  - 위치 서비스  
  - 푸시 알림
  - 생체 인증
- **다양한 화면 크기**: 최소 3가지 다른 화면 크기에서 테스트
- **iOS/Android 동시**: 양쪽 플랫폼에서 동일하게 작동하는지 확인

### 📌 법칙 15: 메모리 누수 및 성능 모니터링
- **StatefulWidget dispose**: 모든 컨트롤러, 스트림, 애니메이션 정리
```dart
@override
void dispose() {
  _controller.dispose();
  _subscription.cancel();
  _animationController.dispose();
  super.dispose();
}
```
- **대용량 데이터 처리**: 
  - 이미지는 적절한 크기로 리사이징
  - 무한 스크롤에서 메모리 해제
  - 캐시 크기 제한 설정
- **성능 모니터링**: 
  - `flutter run --profile`로 성능 확인
  - DevTools에서 메모리 사용량 모니터링
- **최적화 기준**: 앱 시작 시간 3초 이내, 메모리 사용량 100MB 이하

### 📌 법칙 16: 데이터 무결성 및 허위 정보 금지 (신규 추가)
- **API 실패 시 허위 데이터 생성 절대 금지**: API 접근 실패나 데이터 추출 불가능 시 가짜 데이터 생성 금지
- **정직한 실패 보고 의무**: 실패한 작업은 정확히 "실패했습니다"라고 보고
- **추측성 데이터 금지**: 확인되지 않은 데이터나 추측으로 만든 값 사용 금지
- **허위 성공 보고 금지**: 실제로는 실패했으나 성공한 것처럼 보고하는 행위 금지
```dart
// ❌ 절대 금지 - 가짜 데이터 생성
const fakeApiData = {
  'navigation': '네비게이션',
  'profile': '프로필'  // 실제 API에 없는 데이터
};

// ✅ 올바른 방법 - 실패 정직 보고
try {
  final apiData = await fetchRealData();
  return apiData;
} catch (e) {
  debugPrint('API 접근 실패: $e');
  throw Exception('실제 데이터를 가져올 수 없습니다');
}
```
- **확인된 데이터만 사용**: 실제로 존재하고 검증된 데이터만 개발에 활용
- **개발 신뢰성 최우선**: 빠른 해결보다 정확한 데이터 사용이 우선
- **허위 정보로 인한 시간 낭비 방지**: 가짜 데이터로 개발 후 전체 재작업 방지

---

## 🔧 법칙 준수 체크리스트

### 작업 시작 전 필수 확인
```bash
# 1. 버전 확인
flutter --version
dart --version
pod --version

# 2. Flutter doctor 확인
flutter doctor

# 3. 프로젝트 초기화 (필요시)
flutter clean
flutter pub get
cd ios && pod install && cd ..
```

### 에러 발생시 복구 순서
```bash
# 1단계: 기본 클린
flutter clean
rm -rf ios/Pods ios/Podfile.lock
cd ios && pod install && cd ..

# 2단계: Xcode 캐시 클린 (Simulator 문제시)
rm -rf ~/Library/Developer/Xcode/DerivedData

# 3단계: 속성 설정 (iOS 빌드 문제시)
xattr -w com.apple.xcode.CreatedByBuildSystem true ./build/ios/iphoneos
```

## ⚠️ 위반시 조치

### 즉시 중단해야 하는 상황
- 무분별한 flutter upgrade, flutter pub upgrade, pod update 시도
- 버전 명시 없는 패키지 추가
- .xcodeproj 파일로 Xcode 열기
- Firebase 설정 파일 잘못된 위치
- 정기 검토 없는 버전 업데이트
- **신규 추가**: API 키 하드코딩 발견
- **신규 추가**: 백업 없는 중요 파일 수정
- **신규 추가**: dispose 누락된 StatefulWidget
- **신규 추가**: 물리 디바이스 테스트 생략
- **🚨 최우선 중단**: 가짜 데이터 생성 또는 허위 정보 제공 시도

### 위반 발견시 절차
1. **즉시 작업 중단**
2. **법칙에 따른 올바른 방법으로 수정**
3. **체크리스트로 검증**
4. **정상 작동 확인 후 계속**

---

## 🚨 실시간 법칙 위반 알림 시스템

### 알림 발생 조건
- 15가지 법칙 중 하나라도 위반이 필요한 상황 발생시
- 보안 취약점, 치명적 버그 등 긴급 상황
- 프로젝트 요구사항과 법칙이 충돌하는 경우

### 알림 형식
```
🚨 **법칙 위반 알림**

**위반 법칙**: 법칙 X (법칙명)
**위반 사유**: 구체적인 이유 설명
**위험도**: 높음/중간/낮음
**영향 범위**: 예상되는 영향 설명
**제안 사항**: 
  1. 법칙을 지키면서 해결하는 방법
  2. 불가피한 경우 최소한의 위반 방법
  3. 위반 후 복구 계획

**승인 요청**: 진행하시겠습니까? (예/아니오/대안 검토)
```

### 알림 대응 절차
1. **즉시 작업 중단** - 사용자 응답 대기
2. **상황 분석** - 위반 필요성과 대안 검토
3. **사용자 승인** - 명시적 허가 후에만 진행
4. **최소 위반** - 필요한 최소한의 범위만 위반
5. **즉시 복구** - 위반 후 가능한 빨리 정상화
6. **사후 검토** - 위반 사유와 개선 방안 문서화

### 자동 차단 상황
다음 경우는 알림 없이 **즉시 차단**:
- `flutter upgrade` 무분별한 실행 시도
- 버전 명시 없는 패키지 추가
- `.xcodeproj` 파일로 Xcode 열기 시도
- Firebase 설정 파일 잘못된 위치 배치
- **🔴 최고 우선순위**: 가짜 데이터 생성이나 허위 정보 제공 시도

### 예외 승인 권한
- **보안 패치**: 즉시 승인 가능
- **치명적 버그**: 테스트 후 승인
- **기능 요구사항**: 대안 검토 후 승인
- **팀 결정사항**: 문서화 후 승인

---

## 📈 법칙 개선 내역

### v3.0 주요 개선사항 (오류 및 사고 방지 강화)
- **법칙 12**: 코드 수정 전 필수 백업 시스템
- **법칙 13**: API 키 및 민감정보 보안 강화
- **법칙 14**: 디바이스별 테스트 의무화
- **법칙 15**: 메모리 누수 및 성능 모니터링
- **안전장치 강화**: 4가지 신규 즉시 차단 상황 추가

### v2.1 주요 개선사항
- **실시간 알림 시스템** 도입
- **위반 상황별 대응 절차** 명시
- **자동 차단 vs 승인 요청** 구분

### v2.0 주요 개선사항
- **법칙 2**: `pod deintegrate` 조건부 실행으로 완화
- **법칙 5**: Firebase 패키지 분기별 검토 추가
- **법칙 10**: 개발/프로덕션 환경별 에러 처리 구분
- **법칙 11**: 정기 검토를 통한 유연한 업데이트 정책

## 🛡️ 안전성 검증 체크리스트

### 매 작업 전 필수 확인
```bash
# 1. 백업 확인
git status
git log --oneline -5

# 2. 환경변수 검증
grep -r "sk-\|key.*=" lib/ --exclude-dir=.git

# 3. dispose 누락 확인
grep -r "class.*StatefulWidget" lib/ | while read file; do
  if ! grep -q "dispose()" "$file"; then
    echo "⚠️ dispose 누락: $file"
  fi
done

# 4. 성능 모니터링
flutter run --profile
```

---

## 🤖 자동화된 법칙 강제 실행 시스템

### 재발방지 자동화 도구
```bash
# 모든 개발 명령어 실행 전 자동 법칙 체크
./scripts/auto_rule_check.sh flutter_run
./scripts/auto_rule_check.sh pub_get
./scripts/auto_rule_check.sh pod_install

# 수동 법칙 검증
./scripts/rule_enforcement.sh
```

### 자동 차단 시스템
- ❌ 법칙 위반 시 모든 명령어 실행 자동 차단
- 🚨 즉시 위반 알림 출력
- 📋 3가지 선택지 제시 (수정/승인요청/포기)
- ✅ 법칙 준수 확인 후에만 명령어 실행

### Claude의 행동 제약
앞으로 Claude의 모든 개발 관련 행동은:
1. **스크립트를 통해서만** 실행
2. **법칙 위반 시 자동 차단**
3. **사용자 승인 없이 법칙 변경 불가**

---

**🎯 자동화된 강제 실행 시스템으로 15가지 법칙을 100% 준수하여 안전하고 신뢰할 수 있는 개발 환경을 유지합니다!**