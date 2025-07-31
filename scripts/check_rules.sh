#!/bin/bash

# 프로젝트 법칙 검증 스크립트 (15대 법칙 준수)

echo "🔍 Seouloppa 프로젝트 법칙 검증 시작..."

# 1. 버전 확인 (법칙 1)
echo -e "\n📌 법칙 1: 버전 확인"
flutter --version | grep "3.19.6" && echo "✅ Flutter 버전 OK" || echo "❌ Flutter 버전 불일치!"
dart --version | grep "3.3.4" && echo "✅ Dart 버전 OK" || echo "❌ Dart 버전 불일치!"
pod --version | grep -E "1\.1[3-9]|1\.[2-9][0-9]|[2-9]\." && echo "✅ CocoaPods 버전 OK" || echo "❌ CocoaPods 버전 불일치!"

# 2. 금지된 아이콘 사용 확인 (UI 개발 규칙)
echo -e "\n📌 UI 규칙: Material Icons 사용 확인"
if grep -r "Icons\." lib/ 2>/dev/null; then
    echo "❌ Material Icons 사용 발견! (금지됨)"
else
    echo "✅ Material Icons 미사용 OK"
fi

# 3. API 키 하드코딩 확인 (법칙 13)
echo -e "\n📌 법칙 13: API 키 하드코딩 확인"
if grep -r "sk-\|key.*=.*['\"]" lib/ --exclude-dir=.git 2>/dev/null | grep -v "env\["; then
    echo "❌ API 키 하드코딩 발견!"
else
    echo "✅ API 키 하드코딩 없음 OK"
fi

# 4. dispose 누락 확인 (법칙 15)
echo -e "\n📌 법칙 15: StatefulWidget dispose 확인"
STATEFUL_COUNT=$(grep -r "extends StatefulWidget" lib/ 2>/dev/null | wc -l)
DISPOSE_COUNT=$(grep -r "void dispose()" lib/ 2>/dev/null | wc -l)
echo "StatefulWidget 개수: $STATEFUL_COUNT"
echo "dispose 메서드 개수: $DISPOSE_COUNT"
if [ $STATEFUL_COUNT -ne $DISPOSE_COUNT ] && [ $STATEFUL_COUNT -gt 0 ]; then
    echo "⚠️ dispose 메서드 누락 가능성!"
else
    echo "✅ dispose 메서드 OK"
fi

# 5. .env 파일 Git 제외 확인
echo -e "\n📌 법칙 13: .env 파일 보안"
if grep -q "^\.env$" .gitignore; then
    echo "✅ .env가 .gitignore에 포함됨 OK"
else
    echo "❌ .env가 .gitignore에 없음!"
fi

# 6. iOS 플랫폼 버전 확인 (법칙 3)
echo -e "\n📌 법칙 3: iOS 플랫폼 버전"
if [ -f "ios/Podfile" ] && grep -q "platform :ios, '1[3-9]\." ios/Podfile; then
    echo "✅ iOS 플랫폼 버전 OK"
else
    echo "⚠️ iOS Podfile 확인 필요"
fi

echo -e "\n✅ 법칙 검증 완료!"