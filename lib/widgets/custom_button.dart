import 'package:flutter/material.dart';
import '../theme/typography.dart';
import '../theme/app_colors.dart';

/// SeoulOppa 커스텀 버튼 컴포넌트
/// Figma 디자인 시스템 기반으로 개발된 버튼
enum ButtonSize { large, xSmall }
enum ButtonColor { dark, bright }
enum ButtonCorner { radius, square }

class CustomButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonSize size;
  final ButtonColor color;
  final ButtonCorner corner;
  final bool isEnabled;
  final Widget? icon;
  final bool iconOnRight;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.size = ButtonSize.large,
    this.color = ButtonColor.dark,
    this.corner = ButtonCorner.square,
    this.isEnabled = true,
    this.icon,
    this.iconOnRight = false,
  });

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  bool _isPressed = false;

  /// 버튼 배경색 가져오기
  Color get _backgroundColor {
    if (!widget.isEnabled) {
      return widget.color == ButtonColor.dark 
          ? AppColors.stateBlackDisabled  // color.state.black.disabled
          : AppColors.stateWhiteDisabled; // color.state.white.disabled
    }
    
    if (widget.color == ButtonColor.dark) {
      return AppColors.stateBlackDefault; // color.state.black.default
    } else {
      // Bright color - 모든 크기에서 흰색 배경
      return AppColors.stateWhiteDefault; // color.state.white.default
    }
  }

  /// 텍스트 색상 가져오기
  Color get _textColor {
    if (!widget.isEnabled) {
      return widget.color == ButtonColor.dark
          ? AppColors.text700  // color.text.700 - disabled dark button text
          : AppColors.text500; // color.text.500 - disabled bright button text
    }
    
    if (widget.color == ButtonColor.dark) {
      return AppColors.text900; // color.text.900 - 흰색
    } else {
      // Bright color - Large는 검정, xSmall은 다크 그레이
      return widget.size == ButtonSize.large
          ? AppColors.text100  // color.text.100 - 검정색
          : AppColors.text300; // color.text.300 - 다크 그레이
    }
  }

  /// 텍스트 스타일 가져오기
  TextStyle get _textStyle {
    final baseStyle = widget.size == ButtonSize.large 
        ? AppTypography.s14bd20  // 14px Bold
        : AppTypography.s11sb15; // 11px SemiBold
    
    return baseStyle.copyWith(color: _textColor);
  }

  /// 패딩 가져오기
  EdgeInsets get _padding {
    if (widget.size == ButtonSize.large) {
      return const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0);
    } else {
      return EdgeInsets.symmetric(
        horizontal: widget.corner == ButtonCorner.radius ? 10.0 : 8.0,
        vertical: 6.0,
      );
    }
  }

  /// 테두리 반지름 가져오기
  double get _borderRadius {
    if (widget.size == ButtonSize.large) {
      return widget.corner == ButtonCorner.square ? 4.0 : 24.0;
    } else {
      return widget.corner == ButtonCorner.radius ? 24.0 : 2.0;
    }
  }

  /// 최소 사이즈 가져오기
  Size get _minimumSize {
    if (widget.size == ButtonSize.large) {
      return const Size(362, 48);
    } else {
      return widget.corner == ButtonCorner.radius 
          ? const Size(67, 24) 
          : const Size(61, 24);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: widget.isEnabled ? (_) => setState(() => _isPressed = true) : null,
      onTapUp: widget.isEnabled ? (_) => setState(() => _isPressed = false) : null,
      onTapCancel: widget.isEnabled ? () => setState(() => _isPressed = false) : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        constraints: BoxConstraints(
          minWidth: _minimumSize.width,
          minHeight: _minimumSize.height,
        ),
        padding: _padding,
        decoration: BoxDecoration(
          color: _isPressed 
              ? _backgroundColor.withOpacity(0.8) 
              : _backgroundColor,
          borderRadius: BorderRadius.circular(_borderRadius),
          border: widget.color == ButtonColor.bright
              ? Border.all(
                  color: AppColors.lineDefault, // color.line.default - bright 버튼 테두리
                  width: 1.0,
                )
              : null,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.isEnabled ? widget.onPressed : null,
            borderRadius: BorderRadius.circular(_borderRadius),
            child: Container(
              alignment: Alignment.center,
              child: _buildButtonContent(),
            ),
          ),
        ),
      ),
    );
  }

  /// 버튼 내용 구성 (텍스트 + 아이콘)
  Widget _buildButtonContent() {
    if (widget.icon == null) {
      return AppTypography.mixedText(
        widget.text,
        _textStyle,
        textAlign: TextAlign.center,
        color: _textColor,
      );
    }

    final iconWidget = SizedBox(
      width: widget.size == ButtonSize.large ? 20 : 16,
      height: widget.size == ButtonSize.large ? 20 : 16,
      child: widget.icon,
    );

    final textWidget = AppTypography.mixedText(
      widget.text,
      _textStyle,
      textAlign: TextAlign.center,
      color: _textColor,
    );

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: widget.iconOnRight
          ? [textWidget, const SizedBox(width: 8), iconWidget]
          : [iconWidget, const SizedBox(width: 8), textWidget],
    );
  }
}

/// CustomButton 사용을 위한 헬퍼 클래스
class ButtonStyles {
  /// Primary 버튼 (Dark theme, Large, Square)
  static CustomButton primary({
    required String text,
    required VoidCallback? onPressed,
    bool isEnabled = true,
    Widget? icon,
  }) {
    return CustomButton(
      text: text,
      onPressed: onPressed,
      size: ButtonSize.large,
      color: ButtonColor.dark,
      corner: ButtonCorner.square,
      isEnabled: isEnabled,
      icon: icon,
    );
  }

  /// Secondary 버튼 (Bright theme, Large, Square)
  static CustomButton secondary({
    required String text,
    required VoidCallback? onPressed,
    bool isEnabled = true,
    Widget? icon,
  }) {
    return CustomButton(
      text: text,
      onPressed: onPressed,
      size: ButtonSize.large,
      color: ButtonColor.bright,
      corner: ButtonCorner.square,
      isEnabled: isEnabled,
      icon: icon,
    );
  }

  /// 작은 태그 버튼 (Bright theme, xSmall, Radius)
  static CustomButton tag({
    required String text,
    required VoidCallback? onPressed,
    bool isEnabled = true,
  }) {
    return CustomButton(
      text: text,
      onPressed: onPressed,
      size: ButtonSize.xSmall,
      color: ButtonColor.bright,
      corner: ButtonCorner.radius,
      isEnabled: isEnabled,
    );
  }

  /// 작은 사각 버튼 (Bright theme, xSmall, Square)
  static CustomButton smallSquare({
    required String text,
    required VoidCallback? onPressed,
    bool isEnabled = true,
  }) {
    return CustomButton(
      text: text,
      onPressed: onPressed,
      size: ButtonSize.xSmall,
      color: ButtonColor.bright,
      corner: ButtonCorner.square,
      isEnabled: isEnabled,
    );
  }
}