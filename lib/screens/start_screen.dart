import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_svg/flutter_svg.dart';
import '../theme/typography.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../widgets/custom_button.dart';

/// StartScreen - Figma Frame 구조 완벽 일치 구현
/// main_content, text_container, button_container, social_buttons_wrapper
/// 390×844 크기, 연보라색 배경, 텍스트 애니메이션, 네비게이션 dot
class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> with TickerProviderStateMixin {
  int _currentTextIndex = 0;
  Timer? _textTimer;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  // Figma에서 추출한 5초마다 변경되는 텍스트들
  final List<String> _texts = [
    '낯선 누군가와 함께\n따스한 이야기를 나누어보세요',
    '한국인 친구를 만들고 싶어요 :)',
    '10월에 한국 갈거예요, 친구해요!',
    '외국인 친구가 친절하게 답장해줄거예요.',
  ];

  @override
  void initState() {
    super.initState();
    
    // 페이드 애니메이션 설정
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    // 첫 애니메이션 시작
    _fadeController.forward();
    
    // 5초마다 텍스트 변경 타이머
    _startTextTimer();
  }

  void _startTextTimer() {
    _textTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      _changeText();
    });
  }

  void _changeText() {
    _fadeController.reverse().then((_) {
      setState(() {
        _currentTextIndex = (_currentTextIndex + 1) % _texts.length;
      });
      _fadeController.forward();
    });
  }

  @override
  void dispose() {
    _textTimer?.cancel();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Figma 배경색: rgba(0.94, 0.88, 1.00, 1.00)
      backgroundColor: AppColors.startScreenBackground,
      body: SafeArea(
        child: container_body(),
      ),
    );
  }

  /// container_body - Figma Frame 이름 그대로
  Widget container_body() {
    return Padding(
      // Figma container_body padding: right 24px, bottom 40px, left 24px
      padding: AppSpacing.paddingHorizontalXXL.copyWith(bottom: 40),
      child: Column(
        children: [
          // main_content Frame (Figma 구조 일치)
          Expanded(
            child: main_content(),
          ),
        ],
      ),
    );
  }

  /// main_content - Figma Frame 이름 그대로 (width=342px, height=HUG)
  Widget main_content() {
    return SizedBox(
      width: 342, // Figma Fixed width
      // height: HUG contents - 고정 크기 제거
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end, // 하단 정렬
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // text_container Frame
          text_container(),
          
          AppSpacing.startScreenTextContainerGapWidget, // 24px gap
          
          // 네비게이션 dots (text_navigator)
          text_navigator(),
          
          AppSpacing.startScreenMainContentGapWidget, // 20px gap
          
          // button_container Frame
          button_container(),
        ],
      ),
    );
  }

  /// text_container - Figma Frame 이름 그대로 (width=340px, height=HUG)
  Widget text_container() {
    return SizedBox(
      width: 340, // Figma HUG contents
      // height: HUG contents - 고정 크기 제거
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
          alignment: Alignment.center,
          child: AppTypography.mixedText(
            _texts[_currentTextIndex],
            AppTypography.s16sb22, // Figma: Pretendard Medium 16px, 24px line height
            textAlign: TextAlign.center,
            color: AppColors.startScreenMainText, // rgba(0.66, 0.50, 0.58, 1.00)
          ),
        ),
      ),
    );
  }

  /// text_navigator - Figma Frame 이름 그대로 (네비게이션 dots)
  Widget text_navigator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        _texts.length,
        (index) => Container(
          margin: const EdgeInsets.symmetric(horizontal: 4), // 8px 간격을 위한 4px 마진
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(
              index == _currentTextIndex ? 1.0 : 0.3, // 활성/비활성 opacity
            ),
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }

  /// button_container - Figma Frame 이름 그대로 (width=342px, height=HUG)
  Widget button_container() {
    return SizedBox(
      width: 342, // Figma FILL container
      // height: HUG contents - 고정 크기 제거
      child: Column(
        children: [
          // 이메일 버튼 (ButtonEmail)
          ButtonEmail(),
          
          AppSpacing.startScreenButtonContainerGapWidget, // 20px gap
          
          // social_buttons_wrapper Frame
          social_buttons_wrapper(),
        ],
      ),
    );
  }

  /// ButtonEmail - Figma Frame 이름 그대로
  /// Design System: size=large, color=bright, corner=square
  Widget ButtonEmail() {
    return CustomButton(
      text: '이메일로 시작하기',
      onPressed: () {
        // TODO: 이메일 시작하기 페이지로 이동
      },
      size: ButtonSize.large, // 362×48px
      color: ButtonColor.bright, // 흰색 배경
      corner: ButtonCorner.square, // 4px border radius
      isEnabled: true,
    );
  }


  /// social_buttons_wrapper - Figma Frame 이름 그대로 (width=342px, height=HUG)
  Widget social_buttons_wrapper() {
    return SizedBox(
      width: 342, // Figma FILL container
      // height: HUG contents - 고정 크기 제거
      child: Column(
        children: [
          // Google 버튼 - Design System: size=large, color=dark, corner=square
          CustomButton(
            text: 'Google로 시작하기',
            onPressed: () {
              // TODO: 구글 로그인
            },
            size: ButtonSize.large, // 362×48px
            color: ButtonColor.dark, // Figma: color=dark = 검정 배경
            corner: ButtonCorner.square, // 4px border radius
            isEnabled: true,
            icon: Image.asset(
              'assets/icons/icon-google-24.png',
              width: 24,
              height: 24,
            ),
          ),
          
          AppSpacing.startScreenSocialButtonsGapWidget, // 10px gap
          
          // Apple 버튼 - Design System: size=large, color=dark, corner=square
          CustomButton(
            text: 'Apple로 시작하기',
            onPressed: () {
              // TODO: 애플 로그인
            },
            size: ButtonSize.large, // 362×48px
            color: ButtonColor.dark, // Figma: color=dark = 검정 배경
            corner: ButtonCorner.square, // 4px border radius
            isEnabled: true,
            icon: Icon(
              Icons.apple,
              size: 24,
              color: AppColors.text900, // color.text.900 - 흰색
            ),
          ),
        ],
      ),
    );
  }
}