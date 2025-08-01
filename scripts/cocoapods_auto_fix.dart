import 'dart:io';

class CocoaPodsAutoFix {
  static const Map<String, String> xconfigTemplates = {
    'Debug': '''#include? "Pods/Target Support Files/Pods-Runner/Pods-Runner.debug.xcconfig"
#include "Generated.xcconfig"
''',
    'Release': '''#include? "Pods/Target Support Files/Pods-Runner/Pods-Runner.release.xcconfig"
#include "Generated.xcconfig"
''',
    'Profile': '''#include? "Pods/Target Support Files/Pods-Runner/Pods-Runner.profile.xcconfig"
#include "Generated.xcconfig"
''',
  };

  static Future<void> diagnoseAndFix() async {
    print('🍎 CocoaPods 진단 및 자동 수정 시작...');
    
    await _checkXconfigFiles();
    await _checkPodfile();
    await _checkPodfileLock();
    await _runDiagnostics();
    
    print('✅ CocoaPods 진단 완료');
  }
  
  static Future<void> _checkXconfigFiles() async {
    print('📁 .xcconfig 파일 확인 중...');
    
    final flutterDir = Directory('ios/Flutter');
    if (!await flutterDir.exists()) {
      print('❌ ios/Flutter 디렉토리가 없습니다.');
      return;
    }
    
    for (String config in xconfigTemplates.keys) {
      final configFile = File('ios/Flutter/$config.xcconfig');
      
      if (!await configFile.exists()) {
        print('⚠️  $config.xcconfig 파일이 없습니다. 생성 중...');
        await configFile.writeAsString(xconfigTemplates[config]!);
        print('✅ $config.xcconfig 파일 생성 완료');
      } else {
        final content = await configFile.readAsString();
        if (!content.contains('Pods/Target Support Files')) {
          print('⚠️  $config.xcconfig 파일이 올바르지 않습니다. 수정 중...');
          await configFile.writeAsString(xconfigTemplates[config]!);
          print('✅ $config.xcconfig 파일 수정 완료');
        } else {
          print('✅ $config.xcconfig 파일 정상');
        }
      }
    }
  }
  
  static Future<void> _checkPodfile() async {
    print('📋 Podfile 확인 중...');
    
    final podfile = File('ios/Podfile');
    if (!await podfile.exists()) {
      print('❌ Podfile이 없습니다.');
      print('💡 해결방안: flutter create . 명령어를 실행하여 Podfile을 생성하세요.');
      return;
    }
    
    final content = await podfile.readAsString();
    
    // 기본적인 Podfile 구조 확인
    if (!content.contains('platform :ios')) {
      print('⚠️  Podfile에 iOS 플랫폼 설정이 없습니다.');
    }
    
    if (!content.contains('use_frameworks!')) {
      print('⚠️  Podfile에 use_frameworks! 설정이 없습니다.');
    }
    
    print('✅ Podfile 확인 완료');
  }
  
  static Future<void> _checkPodfileLock() async {
    print('🔒 Podfile.lock 확인 중...');
    
    final podfileLock = File('ios/Podfile.lock');
    final podsDir = Directory('ios/Pods');
    
    if (await podfileLock.exists() && await podsDir.exists()) {
      // Podfile.lock과 실제 Pods의 동기화 상태 확인
      final lockModified = await podfileLock.lastModified();
      final podfile = File('ios/Podfile');
      final podfileModified = await podfile.lastModified();
      
      if (podfileModified.isAfter(lockModified)) {
        print('⚠️  Podfile이 Podfile.lock보다 최신입니다. pod install 필요');
        await _runPodInstall();
      } else {
        print('✅ Podfile.lock 동기화 상태 정상');
      }
    } else {
      print('⚠️  Podfile.lock 또는 Pods 디렉토리가 없습니다. pod install 필요');
      await _runPodInstall();
    }
  }
  
  static Future<void> _runPodInstall() async {
    print('🔧 pod install 실행 중...');
    
    try {
      final result = await Process.run(
        'pod',
        ['install'],
        workingDirectory: 'ios',
        runInShell: true,
      );
      
      if (result.exitCode == 0) {
        print('✅ pod install 성공');
      } else {
        print('❌ pod install 실패');
        print('Error: ${result.stderr}');
        await _suggestPodInstallFix(result.stderr.toString());
      }
    } catch (e) {
      print('❌ pod install 실행 오류: $e');
      print('💡 CocoaPods가 설치되어 있는지 확인하세요: sudo gem install cocoapods');
    }
  }
  
  static Future<void> _suggestPodInstallFix(String error) async {
    print('🔧 pod install 오류 해결 방안:');
    
    if (error.contains('Unable to find a specification')) {
      print('   1. pod repo update');
      print('   2. pod install');
    }
    
    if (error.contains('incompatible')) {
      print('   1. pod deintegrate');
      print('   2. pod install');
    }
    
    if (error.contains('Permission denied')) {
      print('   1. sudo pod install');
      print('   2. 또는 sudo chown -R \$(whoami) ~/.cocoapods');
    }
    
    if (error.contains('dependency') || error.contains('version')) {
      print('   1. flutter clean');
      print('   2. flutter pub get');
      print('   3. cd ios && pod install');
    }
  }
  
  static Future<void> _runDiagnostics() async {
    print('🔍 종합 진단 실행 중...');
    
    // Flutter doctor 실행
    try {
      final result = await Process.run('flutter', ['doctor', '-v']);
      
      if (result.stdout.toString().contains('CocoaPods')) {
        print('📋 Flutter Doctor CocoaPods 상태:');
        final lines = result.stdout.toString().split('\n');
        for (String line in lines) {
          if (line.contains('CocoaPods')) {
            print('   $line');
          }
        }
      }
    } catch (e) {
      print('⚠️  Flutter doctor 실행 실패: $e');
    }
    
    // iOS 시뮬레이터 빌드 테스트 (빠른 검증)
    print('🧪 빠른 빌드 테스트 실행 중...');
    try {
      final buildResult = await Process.run(
        'flutter',
        ['build', 'ios', '--simulator', '--debug'],
        timeout: Duration(minutes: 3),
      );
      
      if (buildResult.exitCode == 0) {
        print('✅ iOS 빌드 테스트 성공');
      } else {
        print('⚠️  iOS 빌드 테스트 실패 (시간 초과 또는 오류)');
        final errorOutput = buildResult.stderr.toString();
        if (errorOutput.contains('sandbox is not in sync')) {
          print('🔧 자동 수정 시도: pod install');
          await _runPodInstall();
        }
      }
    } on ProcessException catch (e) {
      if (e.toString().contains('timeout')) {
        print('⚠️  빌드 테스트 시간 초과 (3분) - 실제 빌드 시 주의 필요');
      }
    }
  }
  
  static Future<void> emergencyCleanup() async {
    print('🚨 긴급 정리 작업 시작...');
    
    final itemsToDelete = [
      'ios/Pods',
      'ios/Podfile.lock',
      'ios/.symlinks',
      'ios/Flutter/ephemeral',
      '.flutter-plugins',
      '.flutter-plugins-dependencies',
      'build',
    ];
    
    for (String path in itemsToDelete) {
      final item = FileSystemEntity.isDirectorySync(path) 
          ? Directory(path) 
          : File(path);
          
      if (await item.exists()) {
        print('🗑️  삭제 중: $path');
        await item.delete(recursive: true);
      }
    }
    
    print('🔄 재설정 중...');
    
    // flutter clean
    await Process.run('flutter', ['clean']);
    
    // flutter pub get
    await Process.run('flutter', ['pub', 'get']);
    
    // .xcconfig 파일 재생성
    await _checkXconfigFiles();
    
    // pod install
    await _runPodInstall();
    
    print('✅ 긴급 정리 완료');
  }
}

void main(List<String> args) async {
  if (args.isNotEmpty && args[0] == '--emergency') {
    await CocoaPodsAutoFix.emergencyCleanup();
  } else {
    await CocoaPodsAutoFix.diagnoseAndFix();
  }
  
  print('\n📋 사용 가능한 명령어:');
  print('  dart cocoapods_auto_fix.dart            # 진단 및 자동 수정');
  print('  dart cocoapods_auto_fix.dart --emergency # 긴급 정리 및 재설정');
}