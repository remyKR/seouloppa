import 'package:flutter/material.dart';

/// SeoulOppa 앱의 간격 및 패딩 시스템
/// design-tokens.tokens.json에서 추출된 정확한 토큰명 사용
class AppSpacing {
  // Private constructor to prevent instantiation
  AppSpacing._();

  // Spacing Tokens (design-tokens: string.spacing.*)
  static const double s2 = 2.0;   // string.spacing.s-2
  static const double s4 = 4.0;   // string.spacing.s-4
  static const double s6 = 6.0;   // string.spacing.s-6
  static const double s8 = 8.0;   // string.spacing.s-8
  static const double s10 = 10.0; // string.spacing.s-10
  static const double s12 = 12.0; // string.spacing.s-12
  static const double s16 = 16.0; // string.spacing.s-16
  static const double s20 = 20.0; // string.spacing.s-20
  static const double s24 = 24.0; // string.spacing.s-24
  static const double s32 = 32.0; // string.spacing.s-32
  static const double s40 = 40.0; // string.spacing.s-40
  static const double s60 = 60.0; // string.spacing.s-60
  static const double s80 = 80.0; // string.spacing.s-80

  // Margin Tokens (design-tokens: string.margin.*)
  static const double m12 = 12.0; // string.margin.m-12
  static const double m16 = 16.0; // string.margin.m-16
  static const double m20 = 20.0; // string.margin.m-20
  static const double m24 = 24.0; // string.margin.m-24
  static const double m32 = 32.0; // string.margin.m-32
  static const double m40 = 40.0; // string.margin.m-40

  // StartScreen specific gaps (Design Tokens 기반)
  static const double startScreenMainContentGap = s20;      // main_content gap
  static const double startScreenTextContainerGap = s24;   // text_container gap  
  static const double startScreenButtonContainerGap = s16; // button_container gap
  static const double startScreenSocialButtonsGap = s8;   // social_buttons_wrapper gap

  // Padding values using Design Tokens
  static const EdgeInsets paddingS2 = EdgeInsets.all(s2);
  static const EdgeInsets paddingS4 = EdgeInsets.all(s4);
  static const EdgeInsets paddingS6 = EdgeInsets.all(s6);
  static const EdgeInsets paddingS8 = EdgeInsets.all(s8);
  static const EdgeInsets paddingS10 = EdgeInsets.all(s10);
  static const EdgeInsets paddingS12 = EdgeInsets.all(s12);
  static const EdgeInsets paddingS16 = EdgeInsets.all(s16);
  static const EdgeInsets paddingS20 = EdgeInsets.all(s20);
  static const EdgeInsets paddingS24 = EdgeInsets.all(s24);
  static const EdgeInsets paddingS32 = EdgeInsets.all(s32);
  static const EdgeInsets paddingS40 = EdgeInsets.all(s40);

  // Symmetric padding using Design Tokens
  static const EdgeInsets paddingHorizontalS2 = EdgeInsets.symmetric(horizontal: s2);
  static const EdgeInsets paddingHorizontalS4 = EdgeInsets.symmetric(horizontal: s4);
  static const EdgeInsets paddingHorizontalS6 = EdgeInsets.symmetric(horizontal: s6);
  static const EdgeInsets paddingHorizontalS8 = EdgeInsets.symmetric(horizontal: s8);
  static const EdgeInsets paddingHorizontalS10 = EdgeInsets.symmetric(horizontal: s10);
  static const EdgeInsets paddingHorizontalS12 = EdgeInsets.symmetric(horizontal: s12);
  static const EdgeInsets paddingHorizontalS16 = EdgeInsets.symmetric(horizontal: s16);
  static const EdgeInsets paddingHorizontalS20 = EdgeInsets.symmetric(horizontal: s20);
  static const EdgeInsets paddingHorizontalS24 = EdgeInsets.symmetric(horizontal: s24);
  static const EdgeInsets paddingHorizontalS32 = EdgeInsets.symmetric(horizontal: s32);
  static const EdgeInsets paddingHorizontalS40 = EdgeInsets.symmetric(horizontal: s40);

  static const EdgeInsets paddingVerticalS2 = EdgeInsets.symmetric(vertical: s2);
  static const EdgeInsets paddingVerticalS4 = EdgeInsets.symmetric(vertical: s4);
  static const EdgeInsets paddingVerticalS6 = EdgeInsets.symmetric(vertical: s6);
  static const EdgeInsets paddingVerticalS8 = EdgeInsets.symmetric(vertical: s8);
  static const EdgeInsets paddingVerticalS10 = EdgeInsets.symmetric(vertical: s10);
  static const EdgeInsets paddingVerticalS12 = EdgeInsets.symmetric(vertical: s12);  
  static const EdgeInsets paddingVerticalS16 = EdgeInsets.symmetric(vertical: s16);
  static const EdgeInsets paddingVerticalS20 = EdgeInsets.symmetric(vertical: s20);
  static const EdgeInsets paddingVerticalS24 = EdgeInsets.symmetric(vertical: s24);
  static const EdgeInsets paddingVerticalS32 = EdgeInsets.symmetric(vertical: s32);
  static const EdgeInsets paddingVerticalS40 = EdgeInsets.symmetric(vertical: s40);

  // SizedBox helpers for gaps using Design Tokens
  static const SizedBox gapS2 = SizedBox(height: s2);
  static const SizedBox gapS4 = SizedBox(height: s4);
  static const SizedBox gapS6 = SizedBox(height: s6);
  static const SizedBox gapS8 = SizedBox(height: s8);
  static const SizedBox gapS10 = SizedBox(height: s10);
  static const SizedBox gapS12 = SizedBox(height: s12);
  static const SizedBox gapS16 = SizedBox(height: s16);
  static const SizedBox gapS20 = SizedBox(height: s20);
  static const SizedBox gapS24 = SizedBox(height: s24);
  static const SizedBox gapS32 = SizedBox(height: s32);
  static const SizedBox gapS40 = SizedBox(height: s40);
  static const SizedBox gapS60 = SizedBox(height: s60);
  static const SizedBox gapS80 = SizedBox(height: s80);

  // StartScreen specific gap widgets (Design Tokens 기반)
  static const SizedBox startScreenMainContentGapWidget = SizedBox(height: startScreenMainContentGap);     // s20
  static const SizedBox startScreenTextContainerGapWidget = SizedBox(height: startScreenTextContainerGap); // s24
  static const SizedBox startScreenButtonContainerGapWidget = SizedBox(height: startScreenButtonContainerGap); // s20
  static const SizedBox startScreenSocialButtonsGapWidget = SizedBox(height: startScreenSocialButtonsGap); // s10

  // Horizontal gaps using Design Tokens
  static const SizedBox gapHorizontalS2 = SizedBox(width: s2);
  static const SizedBox gapHorizontalS4 = SizedBox(width: s4);
  static const SizedBox gapHorizontalS6 = SizedBox(width: s6);
  static const SizedBox gapHorizontalS8 = SizedBox(width: s8);
  static const SizedBox gapHorizontalS10 = SizedBox(width: s10);
  static const SizedBox gapHorizontalS12 = SizedBox(width: s12);
  static const SizedBox gapHorizontalS16 = SizedBox(width: s16);
  static const SizedBox gapHorizontalS20 = SizedBox(width: s20);
  static const SizedBox gapHorizontalS24 = SizedBox(width: s24);
  static const SizedBox gapHorizontalS32 = SizedBox(width: s32);
  static const SizedBox gapHorizontalS40 = SizedBox(width: s40);

  // Margin values using Design Tokens
  static const EdgeInsets marginM12 = EdgeInsets.all(m12);
  static const EdgeInsets marginM16 = EdgeInsets.all(m16);
  static const EdgeInsets marginM20 = EdgeInsets.all(m20);
  static const EdgeInsets marginM24 = EdgeInsets.all(m24);
  static const EdgeInsets marginM32 = EdgeInsets.all(m32);
  static const EdgeInsets marginM40 = EdgeInsets.all(m40);

  // Legacy support (기존 코드 호환용)
  static const double none = 0.0;
  static const double xs = s4;
  static const double sm = s8;
  static const double md = s12;
  static const double lg = s16;
  static const double xl = s20;
  static const double xxl = s24;
  static const double xxxl = s32;

  static const EdgeInsets paddingXS = EdgeInsets.all(xs);
  static const EdgeInsets paddingSM = EdgeInsets.all(sm);
  static const EdgeInsets paddingMD = EdgeInsets.all(md);
  static const EdgeInsets paddingLG = EdgeInsets.all(lg);
  static const EdgeInsets paddingXL = EdgeInsets.all(xl);
  static const EdgeInsets paddingXXL = EdgeInsets.all(xxl);

  static const EdgeInsets paddingHorizontalXS = EdgeInsets.symmetric(horizontal: xs);
  static const EdgeInsets paddingHorizontalSM = EdgeInsets.symmetric(horizontal: sm);
  static const EdgeInsets paddingHorizontalMD = EdgeInsets.symmetric(horizontal: md);
  static const EdgeInsets paddingHorizontalLG = EdgeInsets.symmetric(horizontal: lg);
  static const EdgeInsets paddingHorizontalXL = EdgeInsets.symmetric(horizontal: xl);
  static const EdgeInsets paddingHorizontalXXL = EdgeInsets.symmetric(horizontal: xxl);

  static const EdgeInsets paddingVerticalXS = EdgeInsets.symmetric(vertical: xs);
  static const EdgeInsets paddingVerticalSM = EdgeInsets.symmetric(vertical: sm);
  static const EdgeInsets paddingVerticalMD = EdgeInsets.symmetric(vertical: md);
  static const EdgeInsets paddingVerticalLG = EdgeInsets.symmetric(vertical: lg);
  static const EdgeInsets paddingVerticalXL = EdgeInsets.symmetric(vertical: xl);
  static const EdgeInsets paddingVerticalXXL = EdgeInsets.symmetric(vertical: xxl);

  static const SizedBox gapXS = SizedBox(height: xs);
  static const SizedBox gapSM = SizedBox(height: sm);
  static const SizedBox gapMD = SizedBox(height: md);
  static const SizedBox gapLG = SizedBox(height: lg);
  static const SizedBox gapXL = SizedBox(height: xl);
  static const SizedBox gapXXL = SizedBox(height: xxl);
  static const SizedBox gapXXXL = SizedBox(height: xxxl);

  static const SizedBox gapHorizontalXS = SizedBox(width: xs);
  static const SizedBox gapHorizontalSM = SizedBox(width: sm);
  static const SizedBox gapHorizontalMD = SizedBox(width: md);
  static const SizedBox gapHorizontalLG = SizedBox(width: lg);
  static const SizedBox gapHorizontalXL = SizedBox(width: xl);
  static const SizedBox gapHorizontalXXL = SizedBox(width: xxl);
}