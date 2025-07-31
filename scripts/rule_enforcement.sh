#!/bin/bash

# 법칙 강제 실행 자동화 스크립트
# 모든 행동 전 법칙 위반 여부 자동 체크

echo "🔴 법칙 준수 체크 시작..."

# 1. 버전 고정 체크 (법칙 1)
check_version_compliance() {
    echo "📌 법칙 1: 버전 고정 검증"
    
    # Flutter 버전 체크
    FLUTTER_VERSION=$(flutter --version | grep "Flutter" | awk '{print $2}')
    if [ "$FLUTTER_VERSION" != "3.19.6" ]; then
        echo "❌ 법칙 위반: Flutter 버전이 3.19.6이 아님 ($FLUTTER_VERSION)"
        exit 1
    fi
    
    # CocoaPods 버전 체크  
    POD_VERSION=$(pod --version 2>/dev/null || echo "not found")
    if [ "$POD_VERSION" != "1.13.0" ]; then
        echo "❌ 법칙 위반: CocoaPods 버전이 1.13.0이 아님 ($POD_VERSION)"
        exit 1
    fi
    
    echo "✅ 버전 고정 준수"
}

# 2. Firebase 버전 체크 (법칙 5)
check_firebase_versions() {
    echo "📌 법칙 5: Firebase 버전 검증"
    
    if [ -f "pubspec.yaml" ]; then
        # 지정된 Firebase 버전 체크
        FIREBASE_CORE=$(grep "firebase_core:" pubspec.yaml | awk '{print $2}')
        FIREBASE_AUTH=$(grep "firebase_auth:" pubspec.yaml | awk '{print $2}')
        CLOUD_FIRESTORE=$(grep "cloud_firestore:" pubspec.yaml | awk '{print $2}')
        
        if [ "$FIREBASE_CORE" != "2.27.0" ] && [ -n "$FIREBASE_CORE" ]; then
            echo "❌ 법칙 위반: firebase_core 버전이 2.27.0이 아님 ($FIREBASE_CORE)"
            exit 1
        fi
        
        if [ "$FIREBASE_AUTH" != "4.19.0" ] && [ -n "$FIREBASE_AUTH" ]; then
            echo "❌ 법칙 위반: firebase_auth 버전이 4.19.0이 아님 ($FIREBASE_AUTH)"
            exit 1
        fi
        
        if [ "$CLOUD_FIRESTORE" != "4.17.0" ] && [ -n "$CLOUD_FIRESTORE" ]; then
            echo "❌ 법칙 위반: cloud_firestore 버전이 4.17.0이 아님 ($CLOUD_FIRESTORE)"
            exit 1
        fi
    fi
    
    echo "✅ Firebase 버전 준수"
}

# 3. 금지된 코드 패턴 체크
check_forbidden_patterns() {
    echo "📌 UI 규칙: 금지된 패턴 검증"
    
    # Material Icons 사용 체크
    if grep -r "Icons\." lib/ 2>/dev/null; then
        echo "❌ 법칙 위반: Material Icons 사용 발견!"
        exit 1
    fi
    
    # 이모지 사용 체크
    if grep -r "🇰🇷\|😊\|📱" lib/ 2>/dev/null; then
        echo "❌ 법칙 위반: 이모지 사용 발견!"
        exit 1
    fi
    
    # API 키 하드코딩 체크
    if grep -r "sk-\|key.*=.*['\"]" lib/ --exclude-dir=.git 2>/dev/null | grep -v "env\["; then
        echo "❌ 법칙 위반: API 키 하드코딩 발견!"
        exit 1
    fi
    
    echo "✅ 금지된 패턴 없음"
}

# 4. 법칙 위반 알림 함수
send_violation_alert() {
    local rule_number=$1
    local rule_name=$2
    local violation_reason=$3
    local risk_level=$4
    
    echo ""
    echo "🚨 **법칙 위반 알림**"
    echo ""
    echo "**위반 법칙**: 법칙 $rule_number ($rule_name)"
    echo "**위반 사유**: $violation_reason"
    echo "**위험도**: $risk_level"
    echo "**영향 범위**: 프로젝트 법칙 준수 실패"
    echo "**제안 사항**: "
    echo "  1. 법칙을 지키면서 해결하는 방법 검토"
    echo "  2. 불가피한 경우 사용자 승인 요청"  
    echo "  3. 위반 후 복구 계획 수립"
    echo ""
    echo "**승인 요청**: 진행하시겠습니까? (예/아니오/대안 검토)"
    echo ""
}

# 메인 실행
main() {
    check_version_compliance
    check_firebase_versions  
    check_forbidden_patterns
    
    echo "🎯 모든 법칙 준수 확인 완료!"
}

# 스크립트 실행
main