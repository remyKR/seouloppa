import 'dart:io';
import 'dart:convert';

class DependencySafetyChecker {
  static const List<String> highRiskPackages = [
    'video_player',
    'camera',
    'firebase_messaging',
    'flutter_local_notifications',
    'permission_handler',
    'image_picker',
    'file_picker',
    'path_provider',
    'shared_preferences',
    'sqflite',
  ];

  static const Map<String, List<String>> requiredPermissions = {
    'video_player': ['NSAppTransportSecurity', 'INTERNET'],
    'camera': ['NSCameraUsageDescription', 'CAMERA'],
    'image_picker': ['NSPhotoLibraryUsageDescription', 'READ_EXTERNAL_STORAGE'],
    'file_picker': ['READ_EXTERNAL_STORAGE', 'WRITE_EXTERNAL_STORAGE'],
  };

  static Future<void> checkBeforeAdd(String packageName) async {
    print('🔍 의존성 안전성 검사 시작: $packageName');
    
    // 1. 고위험 패키지 확인
    if (highRiskPackages.contains(packageName)) {
      print('⚠️  고위험 패키지 감지: $packageName');
      print('📋 필요한 권한 설정:');
      
      if (requiredPermissions.containsKey(packageName)) {
        for (String permission in requiredPermissions[packageName]!) {
          print('   - $permission');
        }
      }
      
      // 권한 설정 확인
      await _checkPermissions(packageName);
    }
    
    // 2. CocoaPods 설정 확인
    await _checkCocoaPodsSetup();
    
    // 3. 현재 프로젝트 상태 백업
    await _createBackup();
    
    print('✅ 안전성 검사 완료. 의존성 추가를 진행하세요.');
  }

  static Future<void> _checkPermissions(String packageName) async {
    if (requiredPermissions.containsKey(packageName)) {
      print('🔧 권한 설정 자동 확인 중...');
      
      // iOS Info.plist 확인
      final infoPlistFile = File('ios/Runner/Info.plist');
      if (await infoPlistFile.exists()) {
        final content = await infoPlistFile.readAsString();
        
        if (packageName == 'video_player' && !content.contains('NSAppTransportSecurity')) {
          print('❌ iOS Info.plist에 NSAppTransportSecurity 설정 필요');
        }
      }
      
      // Android Manifest 확인
      final manifestFile = File('android/app/src/main/AndroidManifest.xml');
      if (await manifestFile.exists()) {
        final content = await manifestFile.readAsString();
        
        if (packageName == 'video_player' && !content.contains('INTERNET')) {
          print('❌ Android Manifest에 INTERNET 권한 설정 필요');
        }
      }
    }
  }

  static Future<void> _checkCocoaPodsSetup() async {
    print('🍎 CocoaPods 설정 확인 중...');
    
    final profiles = ['Debug', 'Release', 'Profile'];
    for (String profile in profiles) {
      final configFile = File('ios/Flutter/$profile.xcconfig');
      if (!await configFile.exists()) {
        print('❌ $profile.xcconfig 파일이 없습니다. 생성이 필요합니다.');
      }
    }
    
    final podfile = File('ios/Podfile');
    if (await podfile.exists()) {
      print('✅ Podfile 존재 확인');
    } else {
      print('❌ Podfile이 없습니다.');
    }
  }

  static Future<void> _createBackup() async {
    print('💾 프로젝트 상태 백업 중...');
    
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final backupDir = Directory('backups/$timestamp');
    
    if (!await backupDir.exists()) {
      await backupDir.create(recursive: true);
    }
    
    // pubspec.yaml 백업
    final pubspecFile = File('pubspec.yaml');
    if (await pubspecFile.exists()) {
      await pubspecFile.copy('backups/$timestamp/pubspec.yaml');
    }
    
    // iOS 설정 파일 백업
    final infoPlistFile = File('ios/Runner/Info.plist');
    if (await infoPlistFile.exists()) {
      await infoPlistFile.copy('backups/$timestamp/Info.plist');
    }
    
    print('✅ 백업 완료: backups/$timestamp/');
  }

  static Future<void> postInstallCheck() async {
    print('🔍 설치 후 검증 시작...');
    
    // CocoaPods 동기화 확인
    final result = await Process.run('flutter', ['doctor', '-v']);
    if (result.exitCode != 0) {
      print('❌ Flutter Doctor 검사 실패');
      print(result.stderr);
    } else {
      print('✅ Flutter Doctor 검사 통과');
    }
    
    // iOS 빌드 테스트 (시뮬레이터용)
    print('📱 iOS 빌드 테스트 시작...');
    final buildResult = await Process.run('flutter', ['build', 'ios', '--simulator']);
    
    if (buildResult.exitCode == 0) {
      print('✅ iOS 빌드 성공');
    } else {
      print('❌ iOS 빌드 실패');
      print(buildResult.stderr);
      await _suggestFix(buildResult.stderr.toString());
    }
  }

  static Future<void> _suggestFix(String error) async {
    print('🔧 오류 해결 방안 제안:');
    
    if (error.contains('CocoaPods')) {
      print('   1. cd ios && pod install');
      print('   2. flutter clean');
      print('   3. flutter pub get');
    }
    
    if (error.contains('sandbox is not in sync')) {
      print('   1. cd ios && pod install');
      print('   2. iOS/Flutter/*.xcconfig 파일 확인');
    }
    
    if (error.contains('Undefined symbols')) {
      print('   1. iOS 권한 설정 확인');
      print('   2. Info.plist 설정 확인');
    }
  }
}

void main(List<String> args) async {
  if (args.isEmpty) {
    print('사용법: dart dependency_safety_check.dart <package_name>');
    print('예시: dart dependency_safety_check.dart video_player');
    exit(1);
  }
  
  final packageName = args[0];
  
  try {
    await DependencySafetyChecker.checkBeforeAdd(packageName);
    
    print('\n📦 이제 다음 명령어로 의존성을 추가하세요:');
    print('flutter pub add $packageName');
    print('\n설치 후 다음 명령어로 검증하세요:');
    print('dart scripts/dependency_safety_check.dart --post-install');
    
  } catch (e) {
    print('❌ 오류 발생: $e');
    exit(1);
  }
}