import 'dart:io';
import 'dart:convert';

class SensitiveDataGuardian {
  static const List<RegExp> sensitivePatterns = [
    RegExp(r'fig-[a-zA-Z0-9]{40}', caseSensitive: false), // Figma tokens
    RegExp(r'figd_[a-zA-Z0-9_-]+', caseSensitive: false), // Figma design tokens
    RegExp(r'sk-[a-zA-Z0-9]{48}', caseSensitive: false), // OpenAI API keys
    RegExp(r'AIza[0-9A-Za-z\\-_]{35}', caseSensitive: false), // Google API keys
    RegExp(r'AAAA[A-Za-z0-9_-]{7}:[A-Za-z0-9_-]{140}', caseSensitive: false), // Firebase server keys
    RegExp(r'ya29\\.[0-9A-Za-z\\-_]+', caseSensitive: false), // Google OAuth tokens
    RegExp(r'[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}'), // Email addresses
    RegExp(r'password[\"\'\\s]*[:=][\"\'\\s]*[^\\s\"\']+', caseSensitive: false), // Passwords
    RegExp(r'secret[\"\'\\s]*[:=][\"\'\\s]*[^\\s\"\']+', caseSensitive: false), // Secrets
    RegExp(r'token[\"\'\\s]*[:=][\"\'\\s]*[^\\s\"\']+', caseSensitive: false), // Generic tokens
  ];

  static const List<String> sensitiveFiles = [
    '.env',
    '.env.local',
    '.env.production',
    'google-services.json',
    'GoogleService-Info.plist',
    'firebase_options.dart',
  ];

  static const List<String> excludeDirectories = [
    '.git',
    'node_modules',
    'build',
    '.dart_tool',
    'ios/Pods',
    'android/.gradle',
  ];

  static Future<void> scanProject() async {
    print('🔍 민감정보 스캔 시작...');
    
    final results = <String, List<String>>{};
    
    await _scanDirectory(Directory('.'), results);
    
    if (results.isEmpty) {
      print('✅ 민감정보가 발견되지 않았습니다.');
    } else {
      print('🚨 민감정보 발견!');
      _displayResults(results);
      await _generateCleanupScript(results);
    }
  }

  static Future<void> _scanDirectory(Directory dir, Map<String, List<String>> results) async {
    await for (final entity in dir.list()) {
      final name = entity.path.split('/').last;
      
      // 제외 디렉토리 스킵
      if (excludeDirectories.any((exclude) => entity.path.contains(exclude))) {
        continue;
      }
      
      if (entity is Directory) {
        await _scanDirectory(entity, results);
      } else if (entity is File) {
        await _scanFile(entity, results);
      }
    }
  }

  static Future<void> _scanFile(File file, Map<String, List<String>> results) async {
    try {
      // 바이너리 파일 스킵
      if (_isBinaryFile(file.path)) {
        return;
      }
      
      final content = await file.readAsString();
      final lines = content.split('\n');
      
      for (int i = 0; i < lines.length; i++) {
        final line = lines[i];
        
        for (final pattern in sensitivePatterns) {
          if (pattern.hasMatch(line)) {
            final relativePath = file.path.replaceFirst(Directory.current.path + '/', '');
            
            if (!results.containsKey(relativePath)) {
              results[relativePath] = [];
            }
            
            results[relativePath]!.add('Line ${i + 1}: ${line.trim()}');
          }
        }
      }
    } catch (e) {
      // 읽을 수 없는 파일은 스킵
    }
  }

  static bool _isBinaryFile(String path) {
    final binaryExtensions = [
      '.png', '.jpg', '.jpeg', '.gif', '.ico', '.pdf',
      '.zip', '.tar', '.gz', '.exe', '.dll', '.so',
      '.dylib', '.app', '.dmg', '.deb', '.rpm'
    ];
    
    return binaryExtensions.any((ext) => path.toLowerCase().endsWith(ext));
  }

  static void _displayResults(Map<String, List<String>> results) {
    print('\n📋 발견된 민감정보:');
    print('━' * 80);
    
    for (final entry in results.entries) {
      print('📄 ${entry.key}');
      for (final issue in entry.value) {
        print('   🚨 $issue');
      }
      print('');
    }
  }

  static Future<void> _generateCleanupScript(Map<String, List<String>> results) async {
    print('🛠️  정리 스크립트 생성 중...');
    
    final scriptFile = File('scripts/cleanup_sensitive_data.sh');
    final buffer = StringBuffer();
    
    buffer.writeln('#!/bin/bash');
    buffer.writeln('# 민감정보 정리 스크립트 (자동 생성됨)');
    buffer.writeln('#');
    buffer.writeln('# 주의: 이 스크립트를 실행하기 전에 백업을 만드세요!');
    buffer.writeln('#');
    buffer.writeln('echo "🚨 민감정보 정리 시작..."');
    buffer.writeln('');
    
    // Git에서 민감정보 파일 제거
    buffer.writeln('# Git에서 민감정보 파일 제거');
    for (final filePath in results.keys) {
      buffer.writeln('echo "🗑️  Git에서 제거: $filePath"');
      buffer.writeln('git rm --cached "$filePath" 2>/dev/null || true');
    }
    buffer.writeln('');
    
    // .gitignore에 추가
    buffer.writeln('# .gitignore에 패턴 추가');
    buffer.writeln('echo "📝 .gitignore 업데이트 중..."');
    
    final sensitivePatterns = [
      '.env*',
      'google-services.json',
      'GoogleService-Info.plist',
      'firebase_options.dart',
      'figma_*.json',
      '*.tokens.json',
      'secrets/',
      '.secrets',
    ];
    
    for (final pattern in sensitivePatterns) {
      buffer.writeln('grep -q "$pattern" .gitignore || echo "$pattern" >> .gitignore');
    }
    buffer.writeln('');
    
    // 백업 생성
    buffer.writeln('# 백업 생성');
    buffer.writeln('mkdir -p backups/sensitive_data');
    for (final filePath in results.keys) {
      buffer.writeln('cp "$filePath" "backups/sensitive_data/" 2>/dev/null || true');
    }
    buffer.writeln('');
    
    buffer.writeln('echo "✅ 민감정보 정리 완료"');
    buffer.writeln('echo "📋 다음 단계:"');
    buffer.writeln('echo "   1. 백업된 파일 확인: backups/sensitive_data/"');
    buffer.writeln('echo "   2. .env.example 파일 생성"');
    buffer.writeln('echo "   3. git add . && git commit -m \\"Remove sensitive data\\""');
    
    await scriptFile.writeAsString(buffer.toString());
    
    // 실행 권한 부여
    await Process.run('chmod', ['+x', scriptFile.path]);
    
    print('✅ 정리 스크립트 생성됨: ${scriptFile.path}');
    print('⚠️  주의: 스크립트 실행 전 백업을 만드세요!');
  }

  static Future<void> createSecureTemplates() async {
    print('📝 보안 템플릿 파일 생성 중...');
    
    // .env.example 생성
    final envExampleFile = File('.env.example');
    if (!await envExampleFile.exists()) {
      await envExampleFile.writeAsString('''# 환경 변수 템플릿
# 실제 값은 .env 파일에 설정하세요

# Figma API
FIGMA_TOKEN=your_figma_token_here
FIGMA_FILE_ID=your_figma_file_id_here

# Firebase (선택사항)
FIREBASE_API_KEY=your_firebase_api_key_here
FIREBASE_PROJECT_ID=your_firebase_project_id_here

# 기타 API 키
# API_KEY=your_api_key_here
''');
      print('✅ .env.example 생성됨');
    }
    
    // .gitignore 업데이트
    final gitignoreFile = File('.gitignore');
    if (await gitignoreFile.exists()) {
      final content = await gitignoreFile.readAsString();
      final patterns = [
        '.env',
        '.env.local',
        '.env.production',
        'google-services.json',
        'GoogleService-Info.plist',
        'figma_*.json',
        '*.tokens.json',
        'secrets/',
        '.secrets',
        'backups/',
      ];
      
      final newPatterns = <String>[];
      for (final pattern in patterns) {
        if (!content.contains(pattern)) {
          newPatterns.add(pattern);
        }
      }
      
      if (newPatterns.isNotEmpty) {
        await gitignoreFile.writeAsString(content + '\n# 민감정보 파일들\n' + newPatterns.join('\n') + '\n');
        print('✅ .gitignore 업데이트됨');
      }
    }
    
    // pre-commit hook 생성
    final preCommitFile = File('.git/hooks/pre-commit');
    if (!await preCommitFile.exists()) {
      await preCommitFile.writeAsString('''#!/bin/bash
# 민감정보 커밋 방지 hook

echo "🔍 민감정보 검사 중..."

# Dart 스크립트로 민감정보 검사
dart scripts/sensitive_data_guardian.dart --check-staged

if [ \$? -ne 0 ]; then
    echo "🚨 민감정보가 감지되었습니다. 커밋을 중단합니다."
    echo "💡 'dart scripts/sensitive_data_guardian.dart' 명령어로 전체 스캔을 실행하세요."
    exit 1
fi

echo "✅ 민감정보 검사 통과"
''');
      
      await Process.run('chmod', ['+x', preCommitFile.path]);
      print('✅ pre-commit hook 생성됨');
    }
  }

  static Future<void> checkStagedFiles() async {
    print('🔍 staged 파일 민감정보 검사 중...');
    
    final result = await Process.run('git', ['diff', '--cached', '--name-only']);
    if (result.exitCode != 0) {
      print('⚠️  git staged 파일을 확인할 수 없습니다.');
      exit(1);
    }
    
    final stagedFiles = result.stdout.toString().trim().split('\n');
    bool foundSensitive = false;
    
    for (final filePath in stagedFiles) {
      if (filePath.isEmpty) continue;
      
      final file = File(filePath);
      if (await file.exists() && !_isBinaryFile(filePath)) {
        final content = await file.readAsString();
        
        for (final pattern in sensitivePatterns) {
          if (pattern.hasMatch(content)) {
            print('🚨 민감정보 감지: $filePath');
            foundSensitive = true;
            break;
          }
        }
      }
    }
    
    if (foundSensitive) {
      exit(1);
    } else {
      print('✅ staged 파일에서 민감정보 없음');
    }
  }
}

void main(List<String> args) async {
  if (args.isNotEmpty && args[0] == '--check-staged') {
    await SensitiveDataGuardian.checkStagedFiles();
  } else if (args.isNotEmpty && args[0] == '--templates') {
    await SensitiveDataGuardian.createSecureTemplates();
  } else {
    await SensitiveDataGuardian.scanProject();
    await SensitiveDataGuardian.createSecureTemplates();
  }
  
  print('\n📋 사용 가능한 명령어:');
  print('  dart sensitive_data_guardian.dart                # 전체 프로젝트 스캔');
  print('  dart sensitive_data_guardian.dart --check-staged # staged 파일만 검사');
  print('  dart sensitive_data_guardian.dart --templates    # 보안 템플릿 생성');
}