import 'package:flutter/material.dart';

/// SeoulOppa 앱의 색상 시스템
/// design-tokens.tokens.json에서 추출된 정확한 토큰명 사용
class AppColors {
  // Private constructor to prevent instantiation
  AppColors._();

  // Text Colors (design-tokens: color.text.*)
  static const Color text100 = Color(0xFF000000); // color.text.100 - 가장 진한 텍스트
  static const Color text200 = Color(0xFF333333); // color.text.200 - 진한 텍스트
  static const Color text300 = Color(0xFF666666); // color.text.300 - 중간 텍스트
  static const Color text400 = Color(0xFF999999); // color.text.400 - 연한 텍스트
  static const Color text500 = Color(0xFFAAAAAA); // color.text.500 - 더 연한 텍스트
  static const Color text600 = Color(0xFFCCCCCC); // color.text.600 - 매우 연한 텍스트
  static const Color text700 = Color(0xFFDDDDDD); // color.text.700 - 거의 흰색에 가까운 텍스트
  static const Color text800 = Color(0xFFE6E6E6); // color.text.800 - 아주 연한 텍스트
  static const Color text900 = Color(0xFFFFFFFF); // color.text.900 - 흰색 텍스트

  // Brand Colors (design-tokens: color.brand.*)
  static const Color brandPrimary100 = Color(0xFFFF2058); // color.brand.primary.100 - 메인 브랜드 색상 (핑크/빨강)
  static const Color brandSecondary100 = Color(0xFF2D92F2); // color.brand.secondary.100 - 보조 브랜드 색상 (파란색)

  // Line Colors (design-tokens: color.line.*)
  static const Color lineDivider = Color(0xFFF0F0F0); // color.line.divider - 구분선
  static const Color lineDefault = Color(0xFFDDDDDD); // color.line.default - 기본 테두리
  static const Color lineSubtle = Color(0xFFF9F9F9); // color.line.subtle - 미묘한 선

  // State Colors - Black (design-tokens: color.state.black.*)
  static const Color stateBlackDefault = Color(0xFF000000); // color.state.black.default - 기본 검정
  static const Color stateBlackPressed = Color(0xFF333333); // color.state.black.pressed - 눌렸을 때 검정
  static const Color stateBlackDisabled = Color(0xFFAAAAAA); // color.state.black.disabled - 비활성화된 검정

  // State Colors - White (design-tokens: color.state.white.*)
  static const Color stateWhiteDefault = Color(0xFFFFFFFF); // color.state.white.default - 기본 흰색
  static const Color stateWhitePressed = Color(0xFFCCCCCC); // color.state.white.pressed - 눌렸을 때 흰색
  static const Color stateWhiteDisabled = Color(0xFFEAEAEA); // color.state.white.disabled - 비활성화된 흰색

  // State Colors - Alert (design-tokens: color.state.alert.*)
  static const Color stateAlertRed = Color(0xFFFF0000); // color.state.alert.red - 경고/에러 색상

  // StartScreen specific colors (기존 구현 호환용)
  static const Color startScreenBackground = Color(0xFFF0E0FF); // startScreen background
  static const Color startScreenMainText = Color(0xFFA77F94); // 낯선 누군가와 함께...
  static const Color startScreenEmailButtonBg = Color(0xB3FFFFFF); // rgba(1.00, 1.00, 1.00, 0.70)
  static const Color startScreenBottomText = Color(0xFF878787); // KUPID에 처음이신가요?

  // Legacy colors for compatibility - Design Tokens 기반으로 매핑
  static const Color primary = brandPrimary100; // 메인 브랜드 색상
  static const Color primaryLight = Color(0xFFFF4D79); // primary 밝은 버전
  static const Color primaryDark = Color(0xFFE01847); // primary 어두운 버전
  
  static const Color secondary = text600; // 보조 색상
  static const Color secondaryLight = text700;
  static const Color secondaryDark = text400;
  
  static const Color background = stateWhiteDefault; // 배경색
  static const Color backgroundSecondary = lineSubtle;
  static const Color surface = stateWhiteDefault;
  static const Color surfaceVariant = lineDivider;
  
  static const Color onPrimary = stateWhiteDefault; // primary 위의 텍스트
  static const Color onSecondary = stateBlackDefault; // secondary 위의 텍스트
  static const Color onBackground = text100; // 배경 위의 텍스트
  static const Color onSurface = text100; // surface 위의 텍스트
  
  static const Color textPrimary = text100; // 주 텍스트
  static const Color textSecondary = text300; // 보조 텍스트
  static const Color textTertiary = text400; // 3차 텍스트
  static const Color textDisabled = text500; // 비활성화 텍스트
  
  static const Color success = Color(0xFF00C851); // 성공 색상
  static const Color successLight = Color(0xFF69F0A3);
  static const Color successDark = Color(0xFF007E33);
  
  static const Color warning = Color(0xFFFFBB33); // 경고 색상
  static const Color warningLight = Color(0xFFFFD54F);
  static const Color warningDark = Color(0xFFFF8F00);
  
  static const Color error = stateAlertRed; // 에러 색상
  static const Color errorLight = Color(0xFFFF5252);
  static const Color errorDark = Color(0xFFD32F2F);
  
  static const Color info = brandSecondary100; // 정보 색상
  static const Color infoLight = Color(0xFF64B5F6);
  static const Color infoDark = Color(0xFF1976D2);
  
  static const Color selected = stateBlackDefault;
  static const Color unselected = text600;
  static const Color hover = lineDivider;
  static const Color pressed = stateWhitePressed;
  static const Color disabled = stateWhiteDisabled;
  static const Color disabledText = stateBlackDisabled;
  
  static const Color border = lineDefault;
  static const Color borderLight = lineSubtle;
  static const Color borderDark = text400;
  static const Color divider = lineDivider;
  
  static const Color shadow = Color(0x1A000000); // 10% black
  static const Color shadowLight = Color(0x0D000000); // 5% black
  static const Color shadowDark = Color(0x33000000); // 20% black
  
  static const Color overlay = Color(0x80000000); // 50% black overlay
  static const Color overlayLight = Color(0x40000000); // 25% black overlay
  static const Color backdrop = stateBlackDefault;
  
  static const Color statusBar = stateWhiteDefault;
  static const Color navigationBar = stateWhiteDefault;

  // Gradient Colors (Design Tokens 기반)
  static const List<Color> primaryGradient = [
    brandPrimary100,
    primaryDark,
  ];

  static const List<Color> backgroundGradient = [
    stateWhiteDefault,
    lineSubtle,
  ];

  /// Returns a Material Color swatch for the primary color
  static MaterialColor get primarySwatch {
    return MaterialColor(
      brandPrimary100.value,
      const <int, Color>{
        50: Color(0xFFFFE8ED),
        100: Color(0xFFFFD0DA),
        200: Color(0xFFFFA1B5),
        300: Color(0xFFFF7290),
        400: Color(0xFFFF436B),
        500: brandPrimary100, // #FF2058
        600: Color(0xFFE01847),
        700: Color(0xFFC01436),
        800: Color(0xFFA01025),
        900: Color(0xFF800C14),
      },
    );
  }

  /// Returns the ColorScheme for light theme (Design Tokens 기반)
  static ColorScheme get lightColorScheme {
    return ColorScheme.light(
      primary: brandPrimary100,
      onPrimary: stateWhiteDefault,
      secondary: text600,
      onSecondary: stateBlackDefault,
      background: stateWhiteDefault,
      onBackground: text100,
      surface: stateWhiteDefault,
      onSurface: text100,
      error: stateAlertRed,
      onError: stateWhiteDefault,
    );
  }

  /// Returns the ColorScheme for dark theme (Design Tokens 기반)
  static ColorScheme get darkColorScheme {
    return ColorScheme.dark(
      primary: brandPrimary100,
      onPrimary: stateBlackDefault,
      secondary: text400,
      onSecondary: stateWhiteDefault,
      background: stateBlackDefault,
      onBackground: stateWhiteDefault,
      surface: text200,
      onSurface: stateWhiteDefault,
      error: stateAlertRed,
      onError: stateWhiteDefault,
    );
  }
}