import 'package:flutter/material.dart';

/// 서울오빠 앱의 텍스트 스타일 정의
/// Figma 디자인 시스템 기반 - Seoul Oppa 텍스트 스타일
/// 네이밍: {size}{weight}{lineheight}
/// weight: bd(Bold), sb(SemiBold), rg(Regular)
/// 한글: Pretendard, 영문/숫자/특수문자: Outfit
class AppTypography {
  // Private constructor
  AppTypography._();

  // Font families
  static const String pretendard = 'Pretendard';
  static const String outfit = 'Outfit';

  /// 텍스트를 한글과 영문/숫자/특수문자로 분리하여 각각 다른 폰트 적용
  static Widget mixedText(String text, TextStyle baseStyle, {TextAlign? textAlign, Color? color}) {
    final List<TextSpan> spans = [];
    final RegExp koreanRegex = RegExp(r'[ㄱ-ㅎㅏ-ㅣ가-힣]');
    final RegExp nonKoreanRegex = RegExp(r'[a-zA-Z0-9\s!@#$%^&*()_+\-=\[\]{};:"\\|,.<>/?`~]');
    
    int i = 0;
    while (i < text.length) {
      if (koreanRegex.hasMatch(text[i])) {
        // 한글 부분 추출
        int start = i;
        while (i < text.length && (koreanRegex.hasMatch(text[i]) || text[i] == '\n')) {
          i++;
        }
        spans.add(TextSpan(
          text: text.substring(start, i),
          style: baseStyle.copyWith(
            fontFamily: pretendard,
            color: color ?? baseStyle.color ?? Colors.black,
          ),
        ));
      } else if (nonKoreanRegex.hasMatch(text[i]) || text[i] == '\n') {
        // 영문/숫자/특수문자 부분 추출
        int start = i;
        while (i < text.length && (nonKoreanRegex.hasMatch(text[i]) || text[i] == '\n')) {
          i++;
        }
        spans.add(TextSpan(
          text: text.substring(start, i),
          style: baseStyle.copyWith(
            fontFamily: outfit,
            fontFamilyFallback: [pretendard],
            color: color ?? baseStyle.color ?? Colors.black,
          ),
        ));
      } else {
        // 기타 문자 (공백, 특수문자 등)
        spans.add(TextSpan(
          text: text[i],
          style: baseStyle.copyWith(
            fontFamily: pretendard,
            color: color ?? baseStyle.color ?? Colors.black,
          ),
        ));
        i++;
      }
    }

    return RichText(
      textAlign: textAlign ?? TextAlign.left,
      text: TextSpan(children: spans),
    );
  }

  // 60px - Bold only
  static const TextStyle s60bd60 = TextStyle(
    fontFamily: pretendard,
    fontFamilyFallback: [outfit],
    fontSize: 60.0,
    fontWeight: FontWeight.w700,
    height: 1.0, // 60px / 60px
    letterSpacing: 0.0,
  );

  // 40px - Bold only
  static const TextStyle s40bd48 = TextStyle(
    fontFamily: pretendard,
    fontFamilyFallback: [outfit],
    fontSize: 40.0,
    fontWeight: FontWeight.w700,
    height: 1.2, // 48px / 40px
    letterSpacing: 0.0,
  );

  // 32px - Bold only
  static const TextStyle s32bd38 = TextStyle(
    fontFamily: pretendard,
    fontFamilyFallback: [outfit],
    fontSize: 32.0,
    fontWeight: FontWeight.w700,
    height: 1.2, // 38.4px / 32px
    letterSpacing: 0.0,
  );

  // 28px - Bold only
  static const TextStyle s28bd34 = TextStyle(
    fontFamily: pretendard,
    fontFamilyFallback: [outfit],
    fontSize: 28.0,
    fontWeight: FontWeight.w700,
    height: 1.2, // 33.6px / 28px
    letterSpacing: 0.0,
  );

  // 24px styles
  static const TextStyle s24bd29 = TextStyle(
    fontFamily: pretendard,
    fontFamilyFallback: [outfit],
    fontSize: 24.0,
    fontWeight: FontWeight.w700,
    height: 1.2, // 28.8px / 24px
    letterSpacing: 0.0,
  );

  static const TextStyle s24bd34 = TextStyle(
    fontFamily: pretendard,
    fontFamilyFallback: [outfit],
    fontSize: 24.0,
    fontWeight: FontWeight.w700,
    height: 1.4, // 33.6px / 24px
    letterSpacing: 0.0,
  );

  static const TextStyle s24sb29 = TextStyle(
    fontFamily: pretendard,
    fontFamilyFallback: [outfit],
    fontSize: 24.0,
    fontWeight: FontWeight.w600,
    height: 1.2, // 28.8px / 24px
    letterSpacing: 0.0,
  );

  static const TextStyle s24sb34 = TextStyle(
    fontFamily: pretendard,
    fontFamilyFallback: [outfit],
    fontSize: 24.0,
    fontWeight: FontWeight.w600,
    height: 1.4, // 33.6px / 24px
    letterSpacing: 0.0,
  );

  // 20px styles
  static const TextStyle s20bd28 = TextStyle(
    fontFamily: pretendard,
    fontFamilyFallback: [outfit],
    fontSize: 20.0,
    fontWeight: FontWeight.w700,
    height: 1.4, // 28px / 20px
    letterSpacing: 0.0,
  );

  static const TextStyle s20bd32 = TextStyle(
    fontFamily: pretendard,
    fontFamilyFallback: [outfit],
    fontSize: 20.0,
    fontWeight: FontWeight.w700,
    height: 1.6, // 32px / 20px
    letterSpacing: 0.0,
  );

  static const TextStyle s20sb28 = TextStyle(
    fontFamily: pretendard,
    fontFamilyFallback: [outfit],
    fontSize: 20.0,
    fontWeight: FontWeight.w600,
    height: 1.4, // 28px / 20px
    letterSpacing: 0.0,
  );

  static const TextStyle s20sb32 = TextStyle(
    fontFamily: pretendard,
    fontFamilyFallback: [outfit],
    fontSize: 20.0,
    fontWeight: FontWeight.w600,
    height: 1.6, // 32px / 20px
    letterSpacing: 0.0,
  );

  static const TextStyle s20rg28 = TextStyle(
    fontFamily: pretendard,
    fontFamilyFallback: [outfit],
    fontSize: 20.0,
    fontWeight: FontWeight.w400,
    height: 1.4, // 28px / 20px
    letterSpacing: 0.0,
  );

  static const TextStyle s20rg32 = TextStyle(
    fontFamily: pretendard,
    fontFamilyFallback: [outfit],
    fontSize: 20.0,
    fontWeight: FontWeight.w400,
    height: 1.6, // 32px / 20px
    letterSpacing: 0.0,
  );

  // 18px styles
  static const TextStyle s18bd25 = TextStyle(
    fontFamily: pretendard,
    fontFamilyFallback: [outfit],
    fontSize: 18.0,
    fontWeight: FontWeight.w700,
    height: 1.4, // 25.2px / 18px
    letterSpacing: 0.0,
  );

  static const TextStyle s18bd29 = TextStyle(
    fontFamily: pretendard,
    fontFamilyFallback: [outfit],
    fontSize: 18.0,
    fontWeight: FontWeight.w700,
    height: 1.6, // 28.8px / 18px
    letterSpacing: 0.0,
  );

  static const TextStyle s18sb25 = TextStyle(
    fontFamily: pretendard,
    fontFamilyFallback: [outfit],
    fontSize: 18.0,
    fontWeight: FontWeight.w600,
    height: 1.4, // 25.2px / 18px
    letterSpacing: 0.0,
  );

  static const TextStyle s18sb29 = TextStyle(
    fontFamily: pretendard,
    fontFamilyFallback: [outfit],
    fontSize: 18.0,
    fontWeight: FontWeight.w600,
    height: 1.6, // 28.8px / 18px
    letterSpacing: 0.0,
  );

  static const TextStyle s18rg25 = TextStyle(
    fontFamily: pretendard,
    fontFamilyFallback: [outfit],
    fontSize: 18.0,
    fontWeight: FontWeight.w400,
    height: 1.4, // 25.2px / 18px
    letterSpacing: 0.0,
  );

  static const TextStyle s18rg29 = TextStyle(
    fontFamily: pretendard,
    fontFamilyFallback: [outfit],
    fontSize: 18.0,
    fontWeight: FontWeight.w400,
    height: 1.6, // 28.8px / 18px
    letterSpacing: 0.0,
  );

  // 16px styles
  static const TextStyle s16bd22 = TextStyle(
    fontFamily: pretendard,
    fontFamilyFallback: [outfit],
    fontSize: 16.0,
    fontWeight: FontWeight.w700,
    height: 1.4, // 22.4px / 16px
    letterSpacing: 0.0,
  );

  static const TextStyle s16bd26 = TextStyle(
    fontFamily: pretendard,
    fontFamilyFallback: [outfit],
    fontSize: 16.0,
    fontWeight: FontWeight.w700,
    height: 1.6, // 25.6px / 16px
    letterSpacing: 0.0,
  );

  static const TextStyle s16sb22 = TextStyle(
    fontFamily: pretendard,
    fontFamilyFallback: [outfit],
    fontSize: 16.0,
    fontWeight: FontWeight.w600,
    height: 1.4, // 22.4px / 16px
    letterSpacing: 0.0,
  );

  static const TextStyle s16sb26 = TextStyle(
    fontFamily: pretendard,
    fontFamilyFallback: [outfit],
    fontSize: 16.0,
    fontWeight: FontWeight.w600,
    height: 1.6, // 25.6px / 16px
    letterSpacing: 0.0,
  );

  static const TextStyle s16rg22 = TextStyle(
    fontFamily: pretendard,
    fontFamilyFallback: [outfit],
    fontSize: 16.0,
    fontWeight: FontWeight.w400,
    height: 1.4, // 22.4px / 16px
    letterSpacing: 0.0,
  );

  static const TextStyle s16rg26 = TextStyle(
    fontFamily: pretendard,
    fontFamilyFallback: [outfit],
    fontSize: 16.0,
    fontWeight: FontWeight.w400,
    height: 1.6, // 25.6px / 16px
    letterSpacing: 0.0,
  );

  // 14px styles
  static const TextStyle s14bd20 = TextStyle(
    fontFamily: pretendard,
    fontFamilyFallback: [outfit],
    fontSize: 14.0,
    fontWeight: FontWeight.w700,
    height: 1.4, // 19.6px / 14px
    letterSpacing: 0.0,
  );

  static const TextStyle s14bd22 = TextStyle(
    fontFamily: pretendard,
    fontFamilyFallback: [outfit],
    fontSize: 14.0,
    fontWeight: FontWeight.w700,
    height: 1.6, // 22.4px / 14px
    letterSpacing: 0.0,
  );

  static const TextStyle s14sb20 = TextStyle(
    fontFamily: pretendard,
    fontFamilyFallback: [outfit],
    fontSize: 14.0,
    fontWeight: FontWeight.w600,
    height: 1.4, // 19.6px / 14px
    letterSpacing: 0.0,
  );

  static const TextStyle s14sb22 = TextStyle(
    fontFamily: pretendard,
    fontFamilyFallback: [outfit],
    fontSize: 14.0,
    fontWeight: FontWeight.w600,
    height: 1.6, // 22.4px / 14px
    letterSpacing: 0.0,
  );

  static const TextStyle s14rg20 = TextStyle(
    fontFamily: pretendard,
    fontFamilyFallback: [outfit],
    fontSize: 14.0,
    fontWeight: FontWeight.w400,
    height: 1.4, // 19.6px / 14px
    letterSpacing: 0.0,
  );

  static const TextStyle s14rg22 = TextStyle(
    fontFamily: pretendard,
    fontFamilyFallback: [outfit],
    fontSize: 14.0,
    fontWeight: FontWeight.w400,
    height: 1.6, // 22.4px / 14px
    letterSpacing: 0.0,
  );

  // 13px styles
  static const TextStyle s13bd18 = TextStyle(
    fontFamily: pretendard,
    fontFamilyFallback: [outfit],
    fontSize: 13.0,
    fontWeight: FontWeight.w700,
    height: 1.4, // 18.2px / 13px
    letterSpacing: 0.0,
  );

  static const TextStyle s13bd21 = TextStyle(
    fontFamily: pretendard,
    fontFamilyFallback: [outfit],
    fontSize: 13.0,
    fontWeight: FontWeight.w700,
    height: 1.6, // 20.8px / 13px
    letterSpacing: 0.0,
  );

  static const TextStyle s13sb18 = TextStyle(
    fontFamily: pretendard,
    fontFamilyFallback: [outfit],
    fontSize: 13.0,
    fontWeight: FontWeight.w600,
    height: 1.4, // 18.2px / 13px
    letterSpacing: 0.0,
  );

  static const TextStyle s13sb21 = TextStyle(
    fontFamily: pretendard,
    fontFamilyFallback: [outfit],
    fontSize: 13.0,
    fontWeight: FontWeight.w600,
    height: 1.6, // 20.8px / 13px
    letterSpacing: 0.0,
  );

  static const TextStyle s13rg18 = TextStyle(
    fontFamily: pretendard,
    fontFamilyFallback: [outfit],
    fontSize: 13.0,
    fontWeight: FontWeight.w400,
    height: 1.4, // 18.2px / 13px
    letterSpacing: 0.0,
  );

  static const TextStyle s13rg21 = TextStyle(
    fontFamily: pretendard,
    fontFamilyFallback: [outfit],
    fontSize: 13.0,
    fontWeight: FontWeight.w400,
    height: 1.6, // 20.8px / 13px
    letterSpacing: 0.0,
  );

  // 12px styles
  static const TextStyle s12bd17 = TextStyle(
    fontFamily: pretendard,
    fontFamilyFallback: [outfit],
    fontSize: 12.0,
    fontWeight: FontWeight.w700,
    height: 1.4, // 16.8px / 12px
    letterSpacing: 0.0,
  );

  static const TextStyle s12bd19 = TextStyle(
    fontFamily: pretendard,
    fontFamilyFallback: [outfit],
    fontSize: 12.0,
    fontWeight: FontWeight.w700,
    height: 1.6, // 19.2px / 12px
    letterSpacing: 0.0,
  );

  static const TextStyle s12sb17 = TextStyle(
    fontFamily: pretendard,
    fontFamilyFallback: [outfit],
    fontSize: 12.0,
    fontWeight: FontWeight.w600,
    height: 1.4, // 16.8px / 12px
    letterSpacing: 0.0,
  );

  static const TextStyle s12sb19 = TextStyle(
    fontFamily: pretendard,
    fontFamilyFallback: [outfit],
    fontSize: 12.0,
    fontWeight: FontWeight.w600,
    height: 1.6, // 19.2px / 12px
    letterSpacing: 0.0,
  );

  static const TextStyle s12rg17 = TextStyle(
    fontFamily: pretendard,
    fontFamilyFallback: [outfit],
    fontSize: 12.0,
    fontWeight: FontWeight.w400,
    height: 1.4, // 16.8px / 12px
    letterSpacing: 0.0,
  );

  static const TextStyle s12rg19 = TextStyle(
    fontFamily: pretendard,
    fontFamilyFallback: [outfit],
    fontSize: 12.0,
    fontWeight: FontWeight.w400,
    height: 1.6, // 19.2px / 12px
    letterSpacing: 0.0,
  );

  // 11px styles
  static const TextStyle s11bd15 = TextStyle(
    fontFamily: pretendard,
    fontFamilyFallback: [outfit],
    fontSize: 11.0,
    fontWeight: FontWeight.w700,
    height: 1.4, // 15.4px / 11px
    letterSpacing: 0.0,
  );

  static const TextStyle s11bd18 = TextStyle(
    fontFamily: pretendard,
    fontFamilyFallback: [outfit],
    fontSize: 11.0,
    fontWeight: FontWeight.w700,
    height: 1.6, // 17.6px / 11px
    letterSpacing: 0.0,
  );

  static const TextStyle s11sb15 = TextStyle(
    fontFamily: pretendard,
    fontFamilyFallback: [outfit],
    fontSize: 11.0,
    fontWeight: FontWeight.w600,
    height: 1.4, // 15.4px / 11px
    letterSpacing: 0.0,
  );

  static const TextStyle s11sb18 = TextStyle(
    fontFamily: pretendard,
    fontFamilyFallback: [outfit],
    fontSize: 11.0,
    fontWeight: FontWeight.w600,
    height: 1.6, // 17.6px / 11px
    letterSpacing: 0.0,
  );

  static const TextStyle s11rg15 = TextStyle(
    fontFamily: pretendard,
    fontFamilyFallback: [outfit],
    fontSize: 11.0,
    fontWeight: FontWeight.w400,
    height: 1.4, // 15.4px / 11px
    letterSpacing: 0.0,
  );

  static const TextStyle s11rg18 = TextStyle(
    fontFamily: pretendard,
    fontFamilyFallback: [outfit],
    fontSize: 11.0,
    fontWeight: FontWeight.w400,
    height: 1.6, // 17.6px / 11px
    letterSpacing: 0.0,
  );
}