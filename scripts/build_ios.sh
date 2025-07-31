#!/bin/bash

# iOS 빌드 스크립트 (법칙 8 기반)
# 빌드 문제 발생시 자동으로 클린업 수행

echo "🧹 iOS 빌드 준비 시작..."

# 1. Flutter 클린
echo "📦 Flutter 클린..."
flutter clean

# 2. iOS 폴더 클린
echo "🍎 iOS 폴더 클린..."
rm -rf ios/Pods
rm -rf ios/Podfile.lock
rm -rf ios/.symlinks

# 3. Xcode DerivedData 클린
echo "🔧 Xcode DerivedData 클린..."
rm -rf ~/Library/Developer/Xcode/DerivedData

# 4. Flutter pub get
echo "📥 패키지 설치..."
flutter pub get

# 5. CocoaPods 설치
echo "🌱 CocoaPods 설치..."
cd ios
pod install
cd ..

# 6. 빌드 준비 완료
echo "✅ iOS 빌드 준비 완료!"
echo "실행: flutter run -d [device_id]"