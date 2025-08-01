import 'dart:io';
import 'dart:convert';
import 'dart:math';

class ErrorPatternAnalyzer {
  static const String patternsDbPath = 'error_logs/error_patterns.json';
  
  static Future<void> analyzeErrorPatterns() async {
    print('🔬 오류 패턴 분석 시작...');
    
    // 기존 오류 데이터 로드
    final errorTracker = await _loadErrorDatabase();
    final errors = List<Map<String, dynamic>>.from(errorTracker['errors'] ?? []);
    
    if (errors.isEmpty) {
      print('⚠️ 분석할 오류 데이터가 없습니다.');
      return;
    }
    
    // 패턴 분석 수행
    final patterns = await _identifyPatterns(errors);
    
    // 예측 모델 구축
    final predictions = await _buildPredictiveModel(errors, patterns);
    
    // 결과 저장
    await _savePatternsDatabase(patterns, predictions);
    
    // 리포트 생성
    await _generatePatternReport(patterns, predictions);
    
    print('✅ 오류 패턴 분석 완료');
  }
  
  static Future<Map<String, dynamic>> _identifyPatterns(List<Map<String, dynamic>> errors) async {
    print('🔍 패턴 식별 중...');
    
    final patterns = <String, dynamic>{
      'time_patterns': _analyzeTimePatterns(errors),
      'category_correlations': _analyzeCategoryCorrelations(errors),
      'frequency_trends': _analyzeFrequencyTrends(errors),
      'resolution_patterns': _analyzeResolutionPatterns(errors),
      'context_patterns': _analyzeContextPatterns(errors),
    };
    
    return patterns;
  }
  
  static Map<String, dynamic> _analyzeTimePatterns(List<Map<String, dynamic>> errors) {
    final hourCounts = <int, int>{};
    final dayOfWeekCounts = <int, int>{};
    final monthCounts = <int, int>{};
    
    for (final error in errors) {
      final timestamp = DateTime.parse(error['timestamp']);
      
      hourCounts[timestamp.hour] = (hourCounts[timestamp.hour] ?? 0) + 1;
      dayOfWeekCounts[timestamp.weekday] = (dayOfWeekCounts[timestamp.weekday] ?? 0) + 1;
      monthCounts[timestamp.month] = (monthCounts[timestamp.month] ?? 0) + 1;
    }
    
    return {
      'peak_hours': _findPeaks(hourCounts),
      'peak_days': _findPeaks(dayOfWeekCounts),
      'peak_months': _findPeaks(monthCounts),
      'insights': _generateTimeInsights(hourCounts, dayOfWeekCounts),
    };
  }
  
  static Map<String, dynamic> _analyzeCategoryCorrelations(List<Map<String, dynamic>> errors) {
    final categoryPairs = <String, int>{};
    final categories = errors.map((e) => e['category'].toString()).toSet();
    
    // 시간순으로 정렬
    errors.sort((a, b) => DateTime.parse(a['timestamp']).compareTo(DateTime.parse(b['timestamp'])));
    
    // 연속으로 발생하는 카테고리 쌍 분석
    for (int i = 0; i < errors.length - 1; i++) {
      final currentCategory = errors[i]['category'];
      final nextCategory = errors[i + 1]['category'];
      
      final timeDiff = DateTime.parse(errors[i + 1]['timestamp'])
          .difference(DateTime.parse(errors[i]['timestamp']));
      
      // 1시간 이내에 발생한 오류들만 연관성 분석
      if (timeDiff.inHours <= 1) {
        final pair = '$currentCategory -> $nextCategory';
        categoryPairs[pair] = (categoryPairs[pair] ?? 0) + 1;
      }
    }
    
    return {
      'correlations': categoryPairs,
      'strongest_correlations': _findStrongestCorrelations(categoryPairs),
    };
  }
  
  static Map<String, dynamic> _analyzeFrequencyTrends(List<Map<String, dynamic>> errors) {
    final dailyFrequency = <String, int>{};
    final categoryTrends = <String, List<int>>{};
    
    // 일별 빈도 계산
    for (final error in errors) {
      final date = DateTime.parse(error['timestamp']).toIso8601String().substring(0, 10);
      dailyFrequency[date] = (dailyFrequency[date] ?? 0) + error['frequency'];
    }
    
    // 카테고리별 트렌드 계산
    final categories = errors.map((e) => e['category'].toString()).toSet();
    for (final category in categories) {
      final categoryErrors = errors.where((e) => e['category'] == category).toList();
      categoryErrors.sort((a, b) => DateTime.parse(a['timestamp']).compareTo(DateTime.parse(b['timestamp'])));
      
      categoryTrends[category] = categoryErrors.map<int>((e) => e['frequency']).toList();
    }
    
    return {
      'daily_frequency': dailyFrequency,
      'category_trends': categoryTrends,
      'trend_analysis': _analyzeTrends(categoryTrends),
    };
  }
  
  static Map<String, dynamic> _analyzeResolutionPatterns(List<Map<String, dynamic>> errors) {
    final resolutionTimes = <String, List<int>>{};
    final resolutionMethods = <String, int>{};
    
    for (final error in errors) {
      if (error['resolved'] == true && error['resolved_at'] != null) {
        final category = error['category'];
        final timeToResolve = DateTime.parse(error['resolved_at'])
            .difference(DateTime.parse(error['timestamp']))
            .inHours;
        
        resolutionTimes[category] ??= [];
        resolutionTimes[category]!.add(timeToResolve);
        
        final solution = error['solution_applied']?.toString() ?? 'Unknown';
        resolutionMethods[solution] = (resolutionMethods[solution] ?? 0) + 1;
      }
    }
    
    // 평균 해결 시간 계산
    final avgResolutionTimes = <String, double>{};
    resolutionTimes.forEach((category, times) {
      avgResolutionTimes[category] = times.reduce((a, b) => a + b) / times.length;
    });
    
    return {
      'avg_resolution_times': avgResolutionTimes,
      'popular_solutions': resolutionMethods,
      'resolution_insights': _generateResolutionInsights(avgResolutionTimes, resolutionMethods),
    };
  }
  
  static Map<String, dynamic> _analyzeContextPatterns(List<Map<String, dynamic>> errors) {
    final contextKeywords = <String, int>{};
    final contextCategories = <String, Set<String>>{};
    
    for (final error in errors) {
      final context = error['context']?.toString().toLowerCase() ?? '';
      final category = error['category'];
      
      // 키워드 추출
      final words = context.split(RegExp(r'\W+')).where((w) => w.length > 3).toList();
      for (final word in words) {
        contextKeywords[word] = (contextKeywords[word] ?? 0) + 1;
      }
      
      // 카테고리별 컨텍스트 그룹화
      contextCategories[category] ??= {};
      contextCategories[category]!.add(context);
    }
    
    return {
      'common_keywords': _sortByValue(contextKeywords).take(20).toList(),
      'context_by_category': contextCategories.map((k, v) => MapEntry(k, v.toList())),
    };
  }
  
  static Future<Map<String, dynamic>> _buildPredictiveModel(
      List<Map<String, dynamic>> errors, Map<String, dynamic> patterns) async {
    print('🔮 예측 모델 구축 중...');
    
    final predictions = <String, dynamic>{
      'risk_factors': _identifyRiskFactors(errors, patterns),
      'prevention_suggestions': _generatePreventionSuggestions(patterns),
      'early_warning_signals': _identifyEarlyWarnings(errors),
      'resource_recommendations': _generateResourceRecommendations(patterns),
    };
    
    return predictions;
  }
  
  static Map<String, dynamic> _identifyRiskFactors(
      List<Map<String, dynamic>> errors, Map<String, dynamic> patterns) {
    final riskFactors = <String, double>{};
    
    // 빈도 기반 위험도
    final categoryFrequency = <String, int>{};
    for (final error in errors) {
      final category = error['category'];
      categoryFrequency[category] = (categoryFrequency[category] ?? 0) + error['frequency'];
    }
    
    final maxFrequency = categoryFrequency.values.reduce(max);
    categoryFrequency.forEach((category, frequency) {
      riskFactors['$category 재발 위험'] = frequency / maxFrequency;
    });
    
    // 해결 시간 기반 위험도
    final resolutionPatterns = patterns['resolution_patterns'];
    final avgTimes = resolutionPatterns['avg_resolution_times'];
    if (avgTimes != null) {
      final maxTime = avgTimes.values.reduce(max);
      avgTimes.forEach((category, time) {
        riskFactors['$category 해결 복잡성'] = time / maxTime;
      });
    }
    
    return {
      'factors': riskFactors,
      'high_risk_categories': _findHighRiskCategories(riskFactors),
    };
  }
  
  static List<String> _generatePreventionSuggestions(Map<String, dynamic> patterns) {
    final suggestions = <String>[];
    
    // 시간 패턴 기반 제안
    final timePatterns = patterns['time_patterns'];
    if (timePatterns['peak_hours'] != null) {
      suggestions.add('피크 시간대(${timePatterns['peak_hours'].join(', ')}시)에는 중요한 배포나 변경을 피하세요.');
    }
    
    // 카테고리 상관관계 기반 제안
    final correlations = patterns['category_correlations']['strongest_correlations'];
    if (correlations != null && correlations.isNotEmpty) {
      suggestions.add('${correlations.keys.first} 오류 발생 시 연쇄적으로 발생할 수 있는 오류들을 미리 점검하세요.');
    }
    
    // 컨텍스트 패턴 기반 제안
    final contextPatterns = patterns['context_patterns'];
    final commonKeywords = contextPatterns['common_keywords'];
    if (commonKeywords != null && commonKeywords.isNotEmpty) {
      suggestions.add('${commonKeywords[0]['key']} 관련 작업 시 특별한 주의가 필요합니다.');
    }
    
    return suggestions;
  }
  
  static List<String> _identifyEarlyWarnings(List<Map<String, dynamic>> errors) {
    final warnings = <String>[];
    
    // 빈도 급증 패턴 감지
    final recentErrors = errors.where((error) {
      final errorDate = DateTime.parse(error['last_seen']);
      return errorDate.isAfter(DateTime.now().subtract(Duration(days: 7)));
    }).toList();
    
    if (recentErrors.length > errors.length * 0.3) {
      warnings.add('최근 7일간 오류 발생 빈도가 급증했습니다.');
    }
    
    // 새로운 오류 카테고리 감지
    final recentCategories = recentErrors.map((e) => e['category']).toSet();
    final oldCategories = errors.where((error) {
      final errorDate = DateTime.parse(error['timestamp']);
      return errorDate.isBefore(DateTime.now().subtract(Duration(days: 30)));
    }).map((e) => e['category']).toSet();
    
    final newCategories = recentCategories.difference(oldCategories);
    if (newCategories.isNotEmpty) {
      warnings.add('새로운 오류 카테고리가 감지되었습니다: ${newCategories.join(', ')}');
    }
    
    return warnings;
  }
  
  static Map<String, List<String>> _generateResourceRecommendations(Map<String, dynamic> patterns) {
    final recommendations = <String, List<String>>{};
    
    // 카테고리별 추천 리소스
    recommendations['CocoaPods'] = [
      'CocoaPods 공식 문서 검토',
      'iOS 빌드 환경 최적화',
      'Xcode 설정 점검',
    ];
    
    recommendations['Video Player'] = [
      'Flutter video_player 플러그인 문서',
      'iOS/Android 권한 설정 가이드',
      '성능 최적화 방안 검토',
    ];
    
    recommendations['Git'] = [
      '.gitignore 템플릿 업데이트',
      '민감정보 관리 정책 수립',
      'pre-commit hook 설정',
    ];
    
    return recommendations;
  }
  
  // 유틸리티 함수들
  static List<int> _findPeaks(Map<int, int> data) {
    final sortedEntries = data.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
    return sortedEntries.take(3).map((e) => e.key).toList();
  }
  
  static List<String> _generateTimeInsights(Map<int, int> hourCounts, Map<int, int> dayOfWeekCounts) {
    final insights = <String>[];
    
    final peakHour = hourCounts.entries.reduce((a, b) => a.value > b.value ? a : b);
    insights.add('오류가 가장 많이 발생하는 시간: ${peakHour.key}시');
    
    final peakDay = dayOfWeekCounts.entries.reduce((a, b) => a.value > b.value ? a : b);
    final dayNames = ['', '월', '화', '수', '목', '금', '토', '일'];
    insights.add('오류가 가장 많이 발생하는 요일: ${dayNames[peakDay.key]}요일');
    
    return insights;
  }
  
  static Map<String, int> _findStrongestCorrelations(Map<String, int> categoryPairs) {
    final sorted = Map.fromEntries(
        categoryPairs.entries.toList()..sort((a, b) => b.value.compareTo(a.value))
    );
    return Map.fromEntries(sorted.entries.take(5));
  }
  
  static Map<String, String> _analyzeTrends(Map<String, List<int>> categoryTrends) {
    final trendAnalysis = <String, String>{};
    
    categoryTrends.forEach((category, trend) {
      if (trend.length >= 2) {
        final isIncreasing = trend.last > trend.first;
        final changeRate = ((trend.last - trend.first) / trend.first * 100).abs();
        
        if (changeRate > 50) {
          trendAnalysis[category] = isIncreasing ? 'sharp_increase' : 'sharp_decrease';
        } else if (changeRate > 20) {
          trendAnalysis[category] = isIncreasing ? 'moderate_increase' : 'moderate_decrease';
        } else {
          trendAnalysis[category] = 'stable';
        }
      }
    });
    
    return trendAnalysis;
  }
  
  static List<String> _generateResolutionInsights(
      Map<String, double> avgTimes, Map<String, int> methods) {
    final insights = <String>[];
    
    if (avgTimes.isNotEmpty) {
      final slowest = avgTimes.entries.reduce((a, b) => a.value > b.value ? a : b);
      insights.add('${slowest.key} 카테고리의 평균 해결 시간이 ${slowest.value.toStringAsFixed(1)}시간으로 가장 깁니다.');
    }
    
    if (methods.isNotEmpty) {
      final mostUsed = methods.entries.reduce((a, b) => a.value > b.value ? a : b);
      insights.add('가장 자주 사용되는 해결 방법: ${mostUsed.key}');
    }
    
    return insights;
  }
  
  static List<MapEntry<String, int>> _sortByValue(Map<String, int> data) {
    final entries = data.entries.toList();
    entries.sort((a, b) => b.value.compareTo(a.value));
    return entries;
  }
  
  static List<String> _findHighRiskCategories(Map<String, double> riskFactors) {
    final sortedRisks = riskFactors.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    return sortedRisks.take(3).map((e) => e.key).toList();
  }
  
  static Future<Map<String, dynamic>> _loadErrorDatabase() async {
    final file = File('error_logs/error_database.json');
    if (await file.exists()) {
      final content = await file.readAsString();
      return jsonDecode(content);
    }
    return {'errors': []};
  }
  
  static Future<void> _savePatternsDatabase(Map<String, dynamic> patterns, Map<String, dynamic> predictions) async {
    final data = {
      'generated_at': DateTime.now().toIso8601String(),
      'patterns': patterns,
      'predictions': predictions,
    };
    
    final file = File(patternsDbPath);
    await file.writeAsString(jsonEncode(data));
  }
  
  static Future<void> _generatePatternReport(Map<String, dynamic> patterns, Map<String, dynamic> predictions) async {
    print('\n🔬 오류 패턴 분석 결과');
    print('━' * 80);
    
    // 시간 패턴
    final timePatterns = patterns['time_patterns'];
    print('\n⏰ 시간 패턴:');
    print('   피크 시간: ${timePatterns['peak_hours'].join(', ')}시');
    for (final insight in timePatterns['insights']) {
      print('   💡 $insight');
    }
    
    // 카테고리 상관관계
    final correlations = patterns['category_correlations'];
    print('\n🔗 카테고리 상관관계:');
    correlations['strongest_correlations'].forEach((pair, count) {
      print('   $pair: ${count}회 연속 발생');
    });
    
    // 예측 및 권장사항
    final prevention = predictions['prevention_suggestions'];
    print('\n🛡️ 예방 권장사항:');
    for (final suggestion in prevention) {
      print('   • $suggestion');
    }
    
    // 위험 요인
    final riskFactors = predictions['risk_factors'];
    print('\n⚠️ 고위험 카테고리:');
    for (final category in riskFactors['high_risk_categories']) {
      print('   🚨 $category');
    }
    
    // 조기 경고 신호
    final warnings = predictions['early_warning_signals'];
    if (warnings.isNotEmpty) {
      print('\n🚨 조기 경고 신호:');
      for (final warning in warnings) {
        print('   ⚠️ $warning');
      }
    }
    
    print('\n📊 상세 패턴 데이터가 $patternsDbPath에 저장되었습니다.');
  }
}

void main(List<String> args) async {
  try {
    await ErrorPatternAnalyzer.analyzeErrorPatterns();
  } catch (e) {
    print('❌ 패턴 분석 오류: $e');
    exit(1);
  }
}