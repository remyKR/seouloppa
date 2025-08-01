import 'dart:io';
import 'dart:convert';

class ErrorTracker {
  static const String errorDbPath = 'error_logs/error_database.json';
  static const String solutionDbPath = 'error_logs/solution_database.json';
  
  static Future<void> initialize() async {
    final errorDir = Directory('error_logs');
    if (!await errorDir.exists()) {
      await errorDir.create(recursive: true);
    }
    
    // 초기 오류 데이터베이스 생성
    if (!await File(errorDbPath).exists()) {
      await _createInitialErrorDatabase();
    }
    
    if (!await File(solutionDbPath).exists()) {
      await _createInitialSolutionDatabase();
    }
    
    print('✅ 오류 추적 시스템 초기화 완료');
  }
  
  static Future<void> recordError(String category, String errorMessage, String context) async {
    await initialize();
    
    final errorDb = await _loadErrorDatabase();
    final timestamp = DateTime.now().toIso8601String();
    final errorId = _generateErrorId(errorMessage);
    
    final errorRecord = {
      'id': errorId,
      'timestamp': timestamp,
      'category': category,
      'message': errorMessage,
      'context': context,
      'frequency': 1,
      'last_seen': timestamp,
      'resolved': false,
      'solution_applied': null,
    };
    
    // 동일한 오류가 이미 있는지 확인
    bool found = false;
    for (int i = 0; i < errorDb['errors'].length; i++) {
      if (errorDb['errors'][i]['id'] == errorId) {
        errorDb['errors'][i]['frequency']++;
        errorDb['errors'][i]['last_seen'] = timestamp;
        found = true;
        break;
      }
    }
    
    if (!found) {
      errorDb['errors'].add(errorRecord);
    }
    
    await _saveErrorDatabase(errorDb);
    print('📝 오류 기록됨: $category - ${errorMessage.substring(0, 50)}...');
    
    // 자동으로 솔루션 찾기 시도
    await _findAndSuggestSolution(errorId, errorMessage, category);
  }
  
  static Future<void> markErrorResolved(String errorId, String solutionUsed) async {
    final errorDb = await _loadErrorDatabase();
    
    for (int i = 0; i < errorDb['errors'].length; i++) {
      if (errorDb['errors'][i]['id'] == errorId) {
        errorDb['errors'][i]['resolved'] = true;
        errorDb['errors'][i]['solution_applied'] = solutionUsed;
        errorDb['errors'][i]['resolved_at'] = DateTime.now().toIso8601String();
        break;
      }
    }
    
    await _saveErrorDatabase(errorDb);
    print('✅ 오류 해결로 표시됨: $errorId');
  }
  
  static Future<void> updateSolutionDatabase(String errorPattern, String solution, bool effective) async {
    final solutionDb = await _loadSolutionDatabase();
    
    final solutionRecord = {
      'pattern': errorPattern,
      'solution': solution,
      'effectiveness_score': effective ? 100 : 0,
      'usage_count': 1,
      'last_updated': DateTime.now().toIso8601String(),
    };
    
    // 기존 솔루션 업데이트 또는 새로 추가
    bool found = false;
    for (int i = 0; i < solutionDb['solutions'].length; i++) {
      if (solutionDb['solutions'][i]['pattern'] == errorPattern) {
        if (effective) {
          solutionDb['solutions'][i]['effectiveness_score'] = 
              (solutionDb['solutions'][i]['effectiveness_score'] + 100) / 2;
        } else {
          solutionDb['solutions'][i]['effectiveness_score'] = 
              solutionDb['solutions'][i]['effectiveness_score'] * 0.8;
        }
        solutionDb['solutions'][i]['usage_count']++;
        solutionDb['solutions'][i]['last_updated'] = DateTime.now().toIso8601String();
        found = true;
        break;
      }
    }
    
    if (!found) {
      solutionDb['solutions'].add(solutionRecord);
    }
    
    await _saveSolutionDatabase(solutionDb);
    print('💡 솔루션 데이터베이스 업데이트됨');
  }
  
  static Future<void> generateErrorReport() async {
    final errorDb = await _loadErrorDatabase();
    final solutionDb = await _loadSolutionDatabase();
    
    print('\n📊 오류 분석 리포트');
    print('━' * 80);
    
    // 가장 빈번한 오류 상위 10개
    final errors = List<Map<String, dynamic>>.from(errorDb['errors']);
    errors.sort((a, b) => b['frequency'].compareTo(a['frequency']));
    
    print('\n🔥 가장 빈번한 오류 (상위 10개):');
    for (int i = 0; i < errors.length && i < 10; i++) {
      final error = errors[i];
      final status = error['resolved'] ? '✅' : '❌';
      print('${i + 1}. $status [${error['frequency']}회] ${error['category']}: ${error['message'].substring(0, 60)}...');
    }
    
    // 카테고리별 통계
    final categoryStats = <String, Map<String, int>>{};
    for (final error in errors) {
      final category = error['category'];
      categoryStats[category] ??= {'total': 0, 'resolved': 0};
      categoryStats[category]!['total']++;
      if (error['resolved']) {
        categoryStats[category]!['resolved']++;
      }
    }
    
    print('\n📈 카테고리별 통계:');
    categoryStats.forEach((category, stats) {
      final resolveRate = stats['total']! > 0 ? 
          (stats['resolved']! / stats['total']! * 100).toStringAsFixed(1) : '0.0';
      print('  $category: ${stats['total']}개 오류, ${stats['resolved']}개 해결 ($resolveRate%)');
    });
    
    // 최근 7일간 오류 트렌드
    final now = DateTime.now();
    final sevenDaysAgo = now.subtract(Duration(days: 7));
    final recentErrors = errors.where((error) => 
        DateTime.parse(error['last_seen']).isAfter(sevenDaysAgo)).toList();
    
    print('\n📅 최근 7일간: ${recentErrors.length}개 오류 발생');
    
    // 효과적인 솔루션 상위 5개
    final solutions = List<Map<String, dynamic>>.from(solutionDb['solutions']);
    solutions.sort((a, b) => b['effectiveness_score'].compareTo(a['effectiveness_score']));
    
    print('\n💡 가장 효과적인 솔루션 (상위 5개):');
    for (int i = 0; i < solutions.length && i < 5; i++) {
      final solution = solutions[i];
      print('${i + 1}. [${solution['effectiveness_score'].toStringAsFixed(1)}점] ${solution['pattern']}');
      print('   └─ ${solution['solution']}');
    }
    
    // 미해결 오류 우선순위 제안
    final unresolvedErrors = errors.where((error) => !error['resolved']).toList();
    if (unresolvedErrors.isNotEmpty) {
      print('\n⚠️  우선 해결 필요한 오류들:');
      for (int i = 0; i < unresolvedErrors.length && i < 5; i++) {
        final error = unresolvedErrors[i];
        print('${i + 1}. [${error['frequency']}회] ${error['category']}: ${error['message'].substring(0, 50)}...');
      }
    }
  }
  
  static Future<void> autoDetectErrors() async {
    print('🔍 프로젝트에서 자동 오류 감지 중...');
    
    // Flutter 로그 파일 검사
    await _scanFlutterLogs();
    
    // Git 히스토리에서 오류 관련 커밋 검사
    await _scanGitHistory();
    
    // Build 로그 검사
    await _scanBuildLogs();
    
    print('✅ 자동 오류 감지 완료');
  }
  
  static Future<void> _scanFlutterLogs() async {
    try {
      final result = await Process.run('flutter', ['logs', '--device-id=all'], 
          timeout: Duration(seconds: 10));
      
      if (result.exitCode == 0) {
        final logs = result.stdout.toString();
        
        // 일반적인 Flutter 오류 패턴 검사
        final errorPatterns = [
          RegExp(r'EXCEPTION CAUGHT BY.*?\n(.*?)(?=\n\n|\$)', multiLine: true, dotAll: true),
          RegExp(r'ERROR.*?:(.*)', caseSensitive: false),
          RegExp(r'FAILED.*?:(.*)', caseSensitive: false),
        ];
        
        for (final pattern in errorPatterns) {
          final matches = pattern.allMatches(logs);
          for (final match in matches) {
            await recordError('Flutter Runtime', match.group(1)?.trim() ?? 'Unknown error', 'Flutter logs');
          }
        }
      }
    } catch (e) {
      // Flutter logs 실행 실패는 무시 (선택적 기능)
    }
  }
  
  static Future<void> _scanGitHistory() async {
    try {
      final result = await Process.run('git', ['log', '--oneline', '-20', '--grep=fix', '--grep=error', '--grep=bug', '-i']);
      
      if (result.exitCode == 0) {
        final commits = result.stdout.toString().split('\n');
        for (final commit in commits) {
          if (commit.trim().isNotEmpty) {
            await recordError('Git History', commit.trim(), 'Git commit analysis');
          }
        }
      }
    } catch (e) {
      // Git 명령어 실패는 무시
    }
  }
  
  static Future<void> _scanBuildLogs() async {
    final buildLogsDir = Directory('build_logs');
    if (await buildLogsDir.exists()) {
      await for (final file in buildLogsDir.list()) {
        if (file is File && file.path.endsWith('.log')) {
          final content = await file.readAsString();
          
          // 빌드 오류 패턴 검사
          final errorPatterns = [
            RegExp(r'error:(.*)', caseSensitive: false),
            RegExp(r'failed:(.*)', caseSensitive: false),
            RegExp(r'exception:(.*)', caseSensitive: false),
          ];
          
          for (final pattern in errorPatterns) {
            final matches = pattern.allMatches(content);
            for (final match in matches) {
              await recordError('Build Error', match.group(1)?.trim() ?? 'Unknown build error', file.path);
            }
          }
        }
      }
    }
  }
  
  static Future<void> _findAndSuggestSolution(String errorId, String errorMessage, String category) async {
    final solutionDb = await _loadSolutionDatabase();
    
    // 오류 메시지와 가장 유사한 솔루션 찾기
    double bestMatch = 0;
    Map<String, dynamic>? bestSolution;
    
    for (final solution in solutionDb['solutions']) {
      final similarity = _calculateSimilarity(errorMessage.toLowerCase(), solution['pattern'].toLowerCase());
      if (similarity > bestMatch && similarity > 0.3) {
        bestMatch = similarity;
        bestSolution = solution;
      }
    }
    
    if (bestSolution != null) {
      print('💡 추천 솔루션 (${(bestMatch * 100).toStringAsFixed(1)}% 일치):');
      print('   ${bestSolution['solution']}');
      print('   효과도: ${bestSolution['effectiveness_score'].toStringAsFixed(1)}점');
    }
  }
  
  static double _calculateSimilarity(String str1, String str2) {
    final words1 = str1.split(' ').toSet();
    final words2 = str2.split(' ').toSet();
    final intersection = words1.intersection(words2);
    final union = words1.union(words2);
    return union.isEmpty ? 0 : intersection.length / union.length;
  }
  
  static String _generateErrorId(String errorMessage) {
    return errorMessage.hashCode.abs().toString();
  }
  
  static Future<Map<String, dynamic>> _loadErrorDatabase() async {
    final file = File(errorDbPath);
    if (await file.exists()) {
      final content = await file.readAsString();
      return jsonDecode(content);
    }
    return {'errors': []};
  }
  
  static Future<void> _saveErrorDatabase(Map<String, dynamic> data) async {
    final file = File(errorDbPath);
    await file.writeAsString(jsonEncode(data));
  }
  
  static Future<Map<String, dynamic>> _loadSolutionDatabase() async {
    final file = File(solutionDbPath);
    if (await file.exists()) {
      final content = await file.readAsString();
      return jsonDecode(content);
    }
    return {'solutions': []};
  }
  
  static Future<void> _saveSolutionDatabase(Map<String, dynamic> data) async {
    final file = File(solutionDbPath);
    await file.writeAsString(jsonEncode(data));
  }
  
  static Future<void> _createInitialErrorDatabase() async {
    final initialData = {
      'errors': [
        {
          'id': '1',
          'timestamp': '2024-08-01T00:00:00.000Z',
          'category': 'CocoaPods',
          'message': 'The sandbox is not in sync with the Podfile.lock',
          'context': 'iOS build failure',
          'frequency': 3,
          'last_seen': '2024-08-01T00:00:00.000Z',
          'resolved': true,
          'solution_applied': 'pod install after creating .xcconfig files',
        },
        {
          'id': '2',
          'timestamp': '2024-08-01T00:00:00.000Z',
          'category': 'Video Player',
          'message': 'LateInitializationError: VideoPlayerController',
          'context': 'StartScreen video background',
          'frequency': 2,
          'last_seen': '2024-08-01T00:00:00.000Z',
          'resolved': true,
          'solution_applied': 'Changed to nullable type with null checks',
        },
        {
          'id': '3',
          'timestamp': '2024-08-01T00:00:00.000Z',
          'category': 'Git',
          'message': 'remote: error: File contains sensitive information',
          'context': 'Figma API tokens in committed files',
          'frequency': 1,
          'last_seen': '2024-08-01T00:00:00.000Z',
          'resolved': true,
          'solution_applied': 'Created new branch with token placeholders',
        },
      ]
    };
    
    await File(errorDbPath).writeAsString(jsonEncode(initialData));
  }
  
  static Future<void> _createInitialSolutionDatabase() async {
    final initialData = {
      'solutions': [
        {
          'pattern': 'sandbox is not in sync',
          'solution': 'cd ios && pod install. Create missing .xcconfig files if needed.',
          'effectiveness_score': 95.0,
          'usage_count': 3,
          'last_updated': '2024-08-01T00:00:00.000Z',
        },
        {
          'pattern': 'LateInitializationError',
          'solution': 'Change to nullable type and add null checks before usage.',
          'effectiveness_score': 90.0,
          'usage_count': 2,
          'last_updated': '2024-08-01T00:00:00.000Z',
        },
        {
          'pattern': 'sensitive information',
          'solution': 'Add files to .gitignore and use git rm --cached to remove from tracking.',
          'effectiveness_score': 100.0,
          'usage_count': 1,
          'last_updated': '2024-08-01T00:00:00.000Z',
        },
        {
          'pattern': 'build timeout',
          'solution': 'flutter clean && cd ios && pod install. Check available RAM (8GB minimum).',
          'effectiveness_score': 85.0,
          'usage_count': 1,
          'last_updated': '2024-08-01T00:00:00.000Z',
        },
        {
          'pattern': 'Undefined symbols',
          'solution': 'Check iOS permissions in Info.plist and verify all required frameworks are linked.',
          'effectiveness_score': 80.0,
          'usage_count': 1,
          'last_updated': '2024-08-01T00:00:00.000Z',
        },
      ]
    };
    
    await File(solutionDbPath).writeAsString(jsonEncode(initialData));
  }
}

void main(List<String> args) async {
  if (args.isEmpty) {
    print('사용법:');
    print('  dart error_tracker.dart init                    # 초기화');
    print('  dart error_tracker.dart record <category> <message> # 오류 기록');
    print('  dart error_tracker.dart resolve <id> <solution>     # 오류 해결 표시');
    print('  dart error_tracker.dart report                      # 분석 리포트');
    print('  dart error_tracker.dart auto-detect                 # 자동 오류 감지');
    print('  dart error_tracker.dart update-solution <pattern> <solution> <effective>');
    exit(1);
  }
  
  final command = args[0];
  
  try {
    switch (command) {
      case 'init':
        await ErrorTracker.initialize();
        break;
      
      case 'record':
        if (args.length < 3) {
          print('오류: category와 message가 필요합니다.');
          exit(1);
        }
        await ErrorTracker.recordError(args[1], args[2], args.length > 3 ? args[3] : 'Manual entry');
        break;
      
      case 'resolve':
        if (args.length < 3) {
          print('오류: error ID와 solution이 필요합니다.');
          exit(1);
        }
        await ErrorTracker.markErrorResolved(args[1], args[2]);
        break;
      
      case 'report':
        await ErrorTracker.generateErrorReport();
        break;
      
      case 'auto-detect':
        await ErrorTracker.autoDetectErrors();
        break;
      
      case 'update-solution':
        if (args.length < 4) {
          print('오류: pattern, solution, effective(true/false)가 필요합니다.');
          exit(1);
        }
        final effective = args[3].toLowerCase() == 'true';
        await ErrorTracker.updateSolutionDatabase(args[1], args[2], effective);
        break;
      
      default:
        print('알 수 없는 명령어: $command');
        exit(1);
    }
  } catch (e) {
    print('❌ 오류 발생: $e');
    exit(1);
  }
}