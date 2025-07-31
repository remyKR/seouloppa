#!/usr/bin/env node

/**
 * Figma Variables Sync Script
 * 
 * Figma에서 Variables를 가져와서 Flutter 앱의 app_colors.dart와 app_strings.dart를 자동으로 업데이트합니다.
 * 
 * 사용법:
 * node scripts/sync_figma_variables.js
 * 
 * 환경변수:
 * FIGMA_ACCESS_TOKEN - Figma API 토큰
 * FIGMA_FILE_KEY - Figma 파일 키
 */

const fs = require('fs');
const path = require('path');
const https = require('https');

// 설정
const CONFIG = {
  FIGMA_ACCESS_TOKEN: process.env.FIGMA_ACCESS_TOKEN || 'YOUR_FIGMA_TOKEN_HERE',
  FIGMA_FILE_KEY: process.env.FIGMA_FILE_KEY || 'dwrMToEyrZlrXr9UYBOlz5',
  OUTPUT_DIR: path.join(__dirname, '..', 'lib', 'theme'),
  COLORS_FILE: 'app_colors.dart',
  STRINGS_FILE: 'app_strings.dart'
};

/**
 * Figma API 호출 함수
 */
function makeRequest(url) {
  return new Promise((resolve, reject) => {
    const options = {
      headers: {
        'X-Figma-Token': CONFIG.FIGMA_ACCESS_TOKEN
      }
    };

    https.get(url, options, (res) => {
      let data = '';
      
      res.on('data', (chunk) => {
        data += chunk;
      });
      
      res.on('end', () => {
        try {
          const jsonData = JSON.parse(data);
          resolve(jsonData);
        } catch (error) {
          reject(new Error(`JSON 파싱 오류: ${error.message}`));
        }
      });
    }).on('error', (error) => {
      reject(error);
    });
  });
}

/**
 * RGB 색상을 Hex로 변환
 */
function rgbToHex(r, g, b, a = 1) {
  const toHex = (value) => {
    const hex = Math.round(value * 255).toString(16);
    return hex.length === 1 ? '0' + hex : hex;
  };
  
  if (a < 1) {
    return `0x${toHex(a)}${toHex(r)}${toHex(g)}${toHex(b)}`.toUpperCase();
  } else {
    return `0xFF${toHex(r)}${toHex(g)}${toHex(b)}`.toUpperCase();
  }
}

/**
 * 변수명을 Dart 스타일로 변환
 */
function toDartVariableName(name) {
  return name
    .replace(/[^a-zA-Z0-9가-힣]/g, '_')
    .replace(/^_+|_+$/g, '')
    .replace(/_+/g, '_')
    .toLowerCase();
}

/**
 * Figma Variables 가져오기
 */
async function fetchFigmaVariables() {
  try {
    console.log('Figma Variables 가져오는 중...');
    
    // 여러 엔드포인트 시도
    const endpoints = [
      `https://api.figma.com/v1/files/${CONFIG.FIGMA_FILE_KEY}/variables/local_variables`,
      `https://api.figma.com/v1/files/${CONFIG.FIGMA_FILE_KEY}/variables`,
      `https://api.figma.com/v1/files/${CONFIG.FIGMA_FILE_KEY}`
    ];
    
    let fileData = null;
    let variablesData = null;
    
    for (const endpoint of endpoints) {
      try {
        const data = await makeRequest(endpoint);
        if (data.status !== 404) {
          if (endpoint.includes('variables')) {
            variablesData = data;
          } else {
            fileData = data;
          }
          console.log(`✓ 데이터 가져오기 성공: ${endpoint}`);
          break;
        }
      } catch (error) {
        console.log(`✗ 엔드포인트 실패: ${endpoint} - ${error.message}`);
      }
    }
    
    return { fileData, variablesData };
    
  } catch (error) {
    console.error('Figma API 오류:', error.message);
    throw error;
  }
}

/**
 * 파일 데이터에서 색상 추출
 */
function extractColorsFromFile(fileData) {
  const colors = new Map();
  
  function traverseNode(node) {
    // 색상 정보 추출
    if (node.fills && Array.isArray(node.fills)) {
      node.fills.forEach((fill, index) => {
        if (fill.type === 'SOLID' && fill.color) {
          const colorName = `${node.name || 'unnamed'}_fill_${index}`;
          const colorValue = rgbToHex(fill.color.r, fill.color.g, fill.color.b, fill.opacity || 1);
          colors.set(toDartVariableName(colorName), colorValue);
        }
      });
    }
    
    if (node.strokes && Array.isArray(node.strokes)) {
      node.strokes.forEach((stroke, index) => {
        if (stroke.type === 'SOLID' && stroke.color) {
          const colorName = `${node.name || 'unnamed'}_stroke_${index}`;
          const colorValue = rgbToHex(stroke.color.r, stroke.color.g, stroke.color.b, stroke.opacity || 1);
          colors.set(toDartVariableName(colorName), colorValue);
        }
      });
    }
    
    // 자식 노드 탐색
    if (node.children && Array.isArray(node.children)) {
      node.children.forEach(child => traverseNode(child));
    }
  }
  
  if (fileData && fileData.document) {
    traverseNode(fileData.document);
  }
  
  return colors;
}

/**
 * 파일 데이터에서 텍스트 추출
 */
function extractStringsFromFile(fileData) {
  const strings = new Map();
  
  function traverseNode(node) {
    // 텍스트 노드에서 문자열 추출
    if (node.type === 'TEXT' && node.characters) {
      const stringName = toDartVariableName(node.characters);
      if (stringName && stringName.length > 0) {
        strings.set(stringName, node.characters);
      }
    }
    
    // 컴포넌트 및 프레임 이름 추출
    if ((node.type === 'COMPONENT' || node.type === 'FRAME') && node.name) {
      const stringName = toDartVariableName(node.name);
      if (stringName && stringName.length > 0) {
        strings.set(stringName, node.name);
      }
    }
    
    // 자식 노드 탐색
    if (node.children && Array.isArray(node.children)) {
      node.children.forEach(child => traverseNode(child));
    }
  }
  
  if (fileData && fileData.document) {
    traverseNode(fileData.document);
  }
  
  return strings;
}

/**
 * app_colors.dart 파일 생성
 */
function generateColorsFile(colors) {
  const now = new Date().toISOString();
  
  let content = `import 'package:flutter/material.dart';

/// SeoulOppa 앱의 색상 시스템
/// Figma Variables에서 자동 생성됨 (${now})
class AppColors {
  // Private constructor to prevent instantiation
  AppColors._();

  // Figma에서 추출된 색상들
`;

  // 기본 색상들 (항상 포함)
  const defaultColors = {
    'primary': '0xFF000000',
    'primaryLight': '0xFF333333', 
    'primaryDark': '0xFF000000',
    'secondary': '0xFFCCCCCC',
    'secondaryLight': '0xFFE6E6E6',
    'secondaryDark': '0xFF999999',
    'background': '0xFFFFFFFF',
    'surface': '0xFFFFFFFF',
    'error': '0xFFF44336',
    'onPrimary': '0xFFFFFFFF',
    'onSecondary': '0xFF000000',
    'onBackground': '0xFF000000',
    'onSurface': '0xFF000000',
    'onError': '0xFFFFFFFF'
  };

  // 기본 색상 추가
  Object.entries(defaultColors).forEach(([name, value]) => {
    content += `  static const Color ${name} = Color(${value});\n`;
  });

  // Figma에서 추출된 색상 추가
  if (colors.size > 0) {
    content += '\n  // Figma에서 추출된 색상들\n';
    colors.forEach((colorValue, colorName) => {
      if (!defaultColors[colorName]) {
        content += `  static const Color ${colorName} = Color(${colorValue});\n`;
      }
    });
  }

  content += `
  /// Primary color의 MaterialColor swatch 반환
  static MaterialColor get primarySwatch {
    return MaterialColor(
      primary.value,
      <int, Color>{
        50: const Color(0xFFE0E0E0),
        100: const Color(0xFFB3B3B3),
        200: const Color(0xFF808080),
        300: const Color(0xFF4D4D4D),
        400: const Color(0xFF262626),
        500: primary,
        600: const Color(0xFF000000),
        700: const Color(0xFF000000),
        800: const Color(0xFF000000),
        900: const Color(0xFF000000),
      },
    );
  }

  /// Light theme ColorScheme 반환
  static ColorScheme get lightColorScheme {
    return ColorScheme.light(
      primary: primary,
      onPrimary: onPrimary,
      secondary: secondary,
      onSecondary: onSecondary,
      background: background,
      onBackground: onBackground,
      surface: surface,
      onSurface: onSurface,
      error: error,
      onError: onError,
    );
  }

  /// Dark theme ColorScheme 반환
  static ColorScheme get darkColorScheme {
    return ColorScheme.dark(
      primary: primary,
      onPrimary: onPrimary,
      secondary: secondary,
      onSecondary: onSecondary,
      background: const Color(0xFF121212),
      onBackground: const Color(0xFFFFFFFF),
      surface: const Color(0xFF1E1E1E),
      onSurface: const Color(0xFFFFFFFF),
      error: error,
      onError: onError,
    );
  }
}
`;

  return content;
}

/**
 * app_strings.dart 파일 생성
 */
function generateStringsFile(strings) {
  const now = new Date().toISOString();
  
  let content = `/// SeoulOppa 앱의 문자열 시스템
/// Figma Variables에서 자동 생성됨 (${now})
class AppStrings {
  // Private constructor to prevent instantiation
  AppStrings._();

  // 앱 기본 정보
  static const String appName = 'SeoulOppa';
  static const String appTagline = '서울에서 만나는 특별한 인연';

`;

  // 기본 문자열들
  const defaultStrings = {
    'meeting': '만남',
    'nearby': '근처', 
    'travel': '여행',
    'community': '커뮤니티',
    'loading': '로딩 중...',
    'error': '오류가 발생했습니다',
    'confirm': '확인',
    'cancel': '취소',
    'save': '저장',
    'delete': '삭제'
  };

  // 기본 문자열 추가
  content += '  // 기본 문자열\n';
  Object.entries(defaultStrings).forEach(([key, value]) => {
    content += `  static const String ${key} = '${value}';\n`;
  });

  // Figma에서 추출된 문자열 추가
  if (strings.size > 0) {
    content += '\n  // Figma에서 추출된 문자열\n';
    strings.forEach((stringValue, stringName) => {
      if (!defaultStrings[stringName] && stringValue.length <= 50) { // 너무 긴 문자열은 제외
        content += `  static const String ${stringName} = '${stringValue.replace(/'/g, "\\'")}';\\n`;
      }
    });
  }

  content += '}\n';
  
  return content;
}

/**
 * 파일에 내용 쓰기
 */
function writeToFile(filename, content) {
  const filePath = path.join(CONFIG.OUTPUT_DIR, filename);
  
  // 디렉토리가 없으면 생성
  if (!fs.existsSync(CONFIG.OUTPUT_DIR)) {
    fs.mkdirSync(CONFIG.OUTPUT_DIR, { recursive: true });
  }
  
  fs.writeFileSync(filePath, content, 'utf8');
  console.log(`✓ 파일 생성 완료: ${filePath}`);
}

/**
 * 메인 실행 함수
 */
async function main() {
  try {
    console.log('🚀 Figma Variables 동기화 시작...\n');
    
    // Figma 데이터 가져오기
    const { fileData, variablesData } = await fetchFigmaVariables();
    
    if (!fileData && !variablesData) {
      throw new Error('Figma에서 데이터를 가져올 수 없습니다.');
    }
    
    // 색상 추출
    const colors = extractColorsFromFile(fileData);
    console.log(`✓ ${colors.size}개의 색상을 추출했습니다.`);
    
    // 문자열 추출  
    const strings = extractStringsFromFile(fileData);
    console.log(`✓ ${strings.size}개의 문자열을 추출했습니다.`);
    
    // 파일 생성
    const colorsContent = generateColorsFile(colors);
    const stringsContent = generateStringsFile(strings);
    
    // 파일 쓰기
    writeToFile(CONFIG.COLORS_FILE, colorsContent);
    writeToFile(CONFIG.STRINGS_FILE, stringsContent);
    
    console.log('\n🎉 Figma Variables 동기화가 완료되었습니다!');
    console.log('변경사항을 확인하고 커밋해주세요.');
    
  } catch (error) {
    console.error('\n❌ 동기화 실패:', error.message);
    process.exit(1);
  }
}

// 스크립트 실행
if (require.main === module) {
  main();
}

module.exports = {
  main,
  fetchFigmaVariables,
  generateColorsFile,
  generateStringsFile
};