import 'dart:io';
import 'dart:convert';

class BuildTimeMonitor {
  static const int warningThresholdMinutes = 5;
  static const int criticalThresholdMinutes = 10;
  
  static Future<void> monitorBuild(String platform) async {
    print('⏱️  빌드 시간 모니터링 시작: $platform');
    
    final startTime = DateTime.now();
    final logFile = File('build_logs/${platform}_build_${startTime.millisecondsSinceEpoch}.log');
    
    // 로그 디렉토리 생성
    if (!await logFile.parent.exists()) {
      await logFile.parent.create(recursive: true);
    }
    
    Process? buildProcess;
    
    try {
      // 플랫폼별 빌드 명령어
      List<String> buildCommand = [];
      switch (platform.toLowerCase()) {
        case 'ios':
          buildCommand = ['flutter', 'build', 'ios', '--simulator'];
          break;
        case 'android':
          buildCommand = ['flutter', 'build', 'apk'];
          break;
        default:
          throw ArgumentError('지원하지 않는 플랫폼: $platform');
      }
      
      print('🚀 빌드 시작: ${buildCommand.join(' ')}');
      
      buildProcess = await Process.start(
        buildCommand[0],
        buildCommand.sublist(1),
        runInShell: true,
      );
      
      // 타이머 시작
      final timer = Stream.periodic(Duration(minutes: 1), (count) => count + 1);
      final timerSubscription = timer.listen((minutes) {
        if (minutes == warningThresholdMinutes) {
          print('⚠️  빌드 시간이 ${warningThresholdMinutes}분을 초과했습니다.');
          _suggestOptimization();
        } else if (minutes == criticalThresholdMinutes) {
          print('🚨 빌드 시간이 ${criticalThresholdMinutes}분을 초과했습니다!');
          print('🛑 빌드를 중단할지 고려해보세요.');
          _suggestEmergencyActions(buildProcess!);
        }
        
        print('⏱️  빌드 진행 시간: ${minutes}분');
      });
      
      // 빌드 출력 로그 저장
      final logSink = logFile.openWrite();
      buildProcess.stdout.transform(utf8.decoder).listen((data) {
        print(data);
        logSink.write(data);
      });
      
      buildProcess.stderr.transform(utf8.decoder).listen((data) {
        print(data);
        logSink.write('[ERROR] $data');
      });
      
      final exitCode = await buildProcess.exitCode;
      final endTime = DateTime.now();
      final duration = endTime.difference(startTime);
      
      timerSubscription.cancel();
      await logSink.close();
      
      // 빌드 결과 분석
      await _analyzeBuildResult(platform, duration, exitCode, logFile);
      
    } catch (e) {
      print('❌ 빌드 모니터링 오류: $e');
      if (buildProcess != null) {
        buildProcess.kill();
      }
    }
  }
  
  static void _suggestOptimization() {
    print('💡 빌드 최적화 제안:');
    print('   1. flutter clean 실행');
    print('   2. CocoaPods 캐시 정리: cd ios && pod cache clean --all');
    print('   3. Firebase 의존성 확인');
    print('   4. 불필요한 패키지 제거');
    print('   5. RAM 사용량 확인 (최소 8GB 권장)');
  }
  
  static void _suggestEmergencyActions(Process buildProcess) {
    print('🚨 긴급 조치 방안:');
    print('   1. Ctrl+C로 빌드 중단');
    print('   2. 시스템 리소스 확인');
    print('   3. 최근 추가된 의존성 제거 고려');
    print('   4. 백업에서 복원 고려');
  }
  
  static Future<void> _analyzeBuildResult(String platform, Duration duration, int exitCode, File logFile) async {
    print('\n📊 빌드 결과 분석:');
    print('   플랫폼: $platform');
    print('   소요 시간: ${duration.inMinutes}분 ${duration.inSeconds % 60}초');
    print('   종료 코드: $exitCode');
    
    if (exitCode == 0) {
      print('   상태: ✅ 성공');
      
      if (duration.inMinutes > warningThresholdMinutes) {
        print('   ⚠️  빌드 시간이 예상보다 깁니다.');
        await _savePerformanceData(platform, duration, true);
      }
    } else {
      print('   상태: ❌ 실패');
      await _analyzeErrors(logFile);
      await _savePerformanceData(platform, duration, false);
    }
    
    print('   로그 파일: ${logFile.path}');
  }
  
  static Future<void> _analyzeErrors(File logFile) async {
    print('\n🔍 오류 분석:');
    
    final logContent = await logFile.readAsString();
    
    if (logContent.contains('CocoaPods')) {
      print('   🍎 CocoaPods 관련 오류 감지');
      print('   해결방안: cd ios && pod install');
    }
    
    if (logContent.contains('Firebase')) {
      print('   🔥 Firebase 관련 오류 감지');
      print('   해결방안: Firebase 설정 확인');
    }
    
    if (logContent.contains('video_player')) {
      print('   📹 Video Player 관련 오류 감지');
      print('   해결방안: 권한 설정 및 의존성 확인');
    }
    
    if (logContent.contains('Undefined symbols')) {
      print('   🔗 링킹 오류 감지');
      print('   해결방안: 누락된 라이브러리 확인');
    }
  }
  
  static Future<void> _savePerformanceData(String platform, Duration duration, bool success) async {
    final performanceFile = File('build_logs/performance_history.json');
    
    Map<String, dynamic> data = {};
    if (await performanceFile.exists()) {
      final content = await performanceFile.readAsString();
      data = jsonDecode(content);
    }
    
    if (!data.containsKey('builds')) {
      data['builds'] = [];
    }
    
    data['builds'].add({
      'timestamp': DateTime.now().toIso8601String(),
      'platform': platform,
      'duration_minutes': duration.inMinutes,
      'duration_seconds': duration.inSeconds,
      'success': success,
    });
    
    // 최근 50개 빌드만 유지
    if (data['builds'].length > 50) {
      data['builds'] = data['builds'].sublist(data['builds'].length - 50);
    }
    
    await performanceFile.writeAsString(jsonEncode(data));
    print('📈 성능 데이터 저장됨: ${performanceFile.path}');
  }
  
  static Future<void> showPerformanceReport() async {
    final performanceFile = File('build_logs/performance_history.json');
    
    if (!await performanceFile.exists()) {
      print('📊 성능 데이터가 없습니다.');
      return;
    }
    
    final content = await performanceFile.readAsString();
    final data = jsonDecode(content);
    final builds = data['builds'] as List;
    
    if (builds.isEmpty) {
      print('📊 빌드 기록이 없습니다.');
      return;
    }
    
    print('📊 빌드 성능 리포트 (최근 ${builds.length}개):');
    print('━' * 60);
    
    final recentBuilds = builds.take(10).toList();
    for (var build in recentBuilds) {
      final timestamp = DateTime.parse(build['timestamp']);
      final duration = '${build['duration_minutes']}분 ${build['duration_seconds'] % 60}초';
      final status = build['success'] ? '✅' : '❌';
      
      print('${timestamp.toString().substring(0, 19)} | ${build['platform'].toString().padRight(7)} | ${duration.padRight(10)} | $status');
    }
    
    // 통계
    final avgDuration = builds.map((b) => b['duration_minutes'] as int).reduce((a, b) => a + b) / builds.length;
    final successRate = builds.where((b) => b['success']).length / builds.length * 100;
    
    print('━' * 60);
    print('평균 빌드 시간: ${avgDuration.toStringAsFixed(1)}분');
    print('성공률: ${successRate.toStringAsFixed(1)}%');
  }
}

void main(List<String> args) async {
  if (args.isEmpty) {
    print('사용법:');
    print('  dart build_time_monitor.dart ios     # iOS 빌드 모니터링');
    print('  dart build_time_monitor.dart android # Android 빌드 모니터링');
    print('  dart build_time_monitor.dart report  # 성능 리포트 보기');
    exit(1);
  }
  
  final command = args[0].toLowerCase();
  
  try {
    if (command == 'report') {
      await BuildTimeMonitor.showPerformanceReport();
    } else if (['ios', 'android'].contains(command)) {
      await BuildTimeMonitor.monitorBuild(command);
    } else {
      print('❌ 지원하지 않는 명령어: $command');
      exit(1);
    }
  } catch (e) {
    print('❌ 오류 발생: $e');
    exit(1);
  }
}