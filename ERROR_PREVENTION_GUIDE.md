# 🛡️ Flutter 프로젝트 오류 방지 가이드

이 문서는 SeoulOppa 프로젝트에서 발생했던 주요 오류들을 분석하고, 동일한 문제를 방지하기 위한 종합적인 솔루션을 제공합니다.

## 📊 발생했던 주요 오류들

### 1. 🍎 CocoaPods 관련 오류
- **문제**: "The sandbox is not in sync with the Podfile.lock"
- **원인**: .xcconfig 파일 누락, Podfile.lock 동기화 문제
- **영향**: iOS 빌드 실패, 20분+ 빌드 시간

### 2. 📹 Video Player 의존성 오류
- **문제**: LateInitializationError, 권한 설정 누락
- **원인**: 필수 권한 설정 없이 패키지 추가
- **영향**: 앱 크래시, 기능 동작 안함

### 3. 🔐 민감정보 Git 차단
- **문제**: Figma API 토큰이 포함된 파일 커밋 차단
- **원인**: .gitignore 설정 부족
- **영향**: Git push 불가능

### 4. ⏱️ 빌드 시간 급증
- **문제**: 단순 기능 추가로 20분+ 빌드 시간
- **원인**: Firebase 의존성, 8GB RAM 한계
- **영향**: 개발 생산성 급격히 저하

## 🛠️ 자동화된 오류 방지 도구들

### 1. 의존성 안전 검증 시스템
```bash
# 새 패키지 추가 전 실행
dart scripts/dependency_safety_check.dart video_player

# 설치 후 검증
dart scripts/dependency_safety_check.dart --post-install
```

**주요 기능:**
- 고위험 패키지 감지 및 경고
- 필수 권한 설정 자동 확인
- 프로젝트 상태 백업
- 설치 후 빌드 테스트

### 2. 빌드 시간 모니터링
```bash
# iOS 빌드 모니터링
dart scripts/build_time_monitor.dart ios

# Android 빌드 모니터링  
dart scripts/build_time_monitor.dart android

# 성능 리포트 확인
dart scripts/build_time_monitor.dart report
```

**주요 기능:**
- 실시간 빌드 시간 추적
- 5분/10분 임계값 경고
- 자동 최적화 제안
- 성능 기록 및 분석

### 3. CocoaPods 자동 수정
```bash
# 일반 진단 및 수정
dart scripts/cocoapods_auto_fix.dart

# 긴급 상황 완전 정리
dart scripts/cocoapods_auto_fix.dart --emergency
```

**주요 기능:**
- .xcconfig 파일 자동 생성/수정
- Podfile 상태 확인
- pod install 자동 실행
- 오류별 맞춤 해결책 제시

### 4. 민감정보 보호 시스템
```bash
# 전체 프로젝트 스캔
dart scripts/sensitive_data_guardian.dart

# Git commit 전 검사
dart scripts/sensitive_data_guardian.dart --check-staged

# 보안 템플릿 생성
dart scripts/sensitive_data_guardian.dart --templates
```

**주요 기능:**
- Figma 토큰, API 키 등 자동 감지
- .gitignore 자동 업데이트
- pre-commit hook 자동 설치
- .env.example 템플릿 생성

## 📋 개발 워크플로우 개선

### Before: 기존 방식 (문제 발생)
```bash
flutter pub add video_player  # ❌ 권한 설정 없이 추가
flutter run                   # ❌ 빌드 실패 후 발견
git add .                     # ❌ 민감정보 포함하여 커밋 시도
git push                      # ❌ 차단됨
```

### After: 개선된 방식 (오류 방지)
```bash
# 1. 의존성 추가 전 안전성 검사
dart scripts/dependency_safety_check.dart video_player

# 2. 안전하게 의존성 추가
flutter pub add video_player

# 3. 빌드 시간 모니터링과 함께 테스트
dart scripts/build_time_monitor.dart ios

# 4. 민감정보 검사 후 커밋
dart scripts/sensitive_data_guardian.dart --check-staged
git add .
git commit -m "Add video player with safety checks"
git push
```

## 🚨 긴급 상황 대응 매뉴얼

### CocoaPods 완전 망가진 경우
```bash
dart scripts/cocoapods_auto_fix.dart --emergency
```

### 빌드가 10분 이상 걸리는 경우
```bash
# 빌드 중단 (Ctrl+C)
dart scripts/build_time_monitor.dart report  # 이전 빌드 분석
flutter clean
dart scripts/cocoapods_auto_fix.dart
```

### 민감정보 커밋된 경우
```bash
dart scripts/sensitive_data_guardian.dart    # 스캔 후 정리 스크립트 생성
bash scripts/cleanup_sensitive_data.sh       # 자동 생성된 정리 스크립트 실행
```

## 🎯 예방 체크리스트

### 새 의존성 추가 시
- [ ] `dart scripts/dependency_safety_check.dart <package_name>` 실행
- [ ] 필요한 권한 설정 확인 및 적용
- [ ] 빌드 테스트 (시간 모니터링 포함)
- [ ] 기능 동작 확인

### 커밋 전
- [ ] `dart scripts/sensitive_data_guardian.dart --check-staged` 실행
- [ ] 민감정보 없음 확인
- [ ] .gitignore 적절히 설정됨

### 빌드 문제 발생 시
- [ ] CocoaPods 상태 확인: `dart scripts/cocoapods_auto_fix.dart`
- [ ] 빌드 시간 분석: `dart scripts/build_time_monitor.dart report`
- [ ] 필요시 긴급 정리: `--emergency` 옵션 사용

## 📈 성능 최적화 권장사항

### 개발 환경
- **최소 RAM**: 16GB (8GB는 Firebase + video_player 조합에서 부족)
- **SSD 사용**: 빌드 캐시 성능 향상
- **Xcode 최신 버전**: CocoaPods 호환성

### 프로젝트 설정
- **불필요한 Firebase 모듈 제거**: 빌드 시간 단축
- **개발용 빌드 설정**: `--debug --simulator` 옵션 활용
- **캐시 정리 주기적 실행**: `flutter clean`, `pod cache clean --all`

## 🔄 정기 유지보수

### 주간 점검
```bash
# 성능 리포트 확인
dart scripts/build_time_monitor.dart report

# 민감정보 전체 스캔
dart scripts/sensitive_data_guardian.dart

# CocoaPods 상태 점검
dart scripts/cocoapods_auto_fix.dart
```

### 월간 점검
- 의존성 업데이트 전 안전성 검사
- 빌드 시간 추세 분석
- 백업 파일 정리

## ⚡ 빠른 참조

```bash
# 긴급 상황 원스톱 해결
dart scripts/cocoapods_auto_fix.dart --emergency

# 새 패키지 안전 추가
dart scripts/dependency_safety_check.dart <package_name>

# 빌드 시간 모니터링
dart scripts/build_time_monitor.dart ios

# 민감정보 전체 검사
dart scripts/sensitive_data_guardian.dart
```

---

💡 **팁**: 이 도구들을 VS Code task나 shell alias로 등록하여 더 쉽게 사용할 수 있습니다.

🚀 **목표**: 동일한 오류를 반복하지 않고, 안정적이고 효율적인 개발 환경 구축