// lib/core/widgets/tactile_button.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';

/// Duolingo-inspired 3D Tactile Button.
/// Provides a physical depth effect that depresses on tap with haptic feedback.
class TactileButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final Color backgroundColor;
  final Color shadowColor;
  final Color textColor;
  final double height;
  final double? width;
  final Widget? leading;
  final Widget? trailing;
  final bool isFullWidth;
  final double depth;

  const TactileButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.backgroundColor = AppColors.coral,
    this.shadowColor = const Color(0xFFC02A16), // Darker coral bevel
    this.textColor = AppColors.white,
    this.height = 50,
    this.width,
    this.leading,
    this.trailing,
    this.isFullWidth = true,
    this.depth = 4.0,
  });

  const TactileButton.secondary({
    super.key,
    required this.label,
    required this.onPressed,
    this.backgroundColor = AppColors.blue,
    this.shadowColor = const Color(0xFF0D2254),
    this.textColor = AppColors.white,
    this.height = 50,
    this.width,
    this.leading,
    this.trailing,
    this.isFullWidth = true,
    this.depth = 4.0,
  });

  const TactileButton.outlined({
    super.key,
    required this.label,
    required this.onPressed,
    this.backgroundColor = AppColors.white,
    this.shadowColor = const Color(0xFFD0D7E2),
    this.textColor = AppColors.blue,
    this.height = 48,
    this.width,
    this.leading,
    this.trailing,
    this.isFullWidth = true,
    this.depth = 3.0,
  });

  @override
  State<TactileButton> createState() => _TactileButtonState();
}

class _TactileButtonState extends State<TactileButton> {
  bool _isPressed = false;

  void _handleTapDown(TapDownDetails _) {
    if (widget.onPressed == null) return;
    HapticFeedback.lightImpact();
    setState(() => _isPressed = true);
  }

  void _handleTapUp(TapUpDetails _) {
    if (widget.onPressed == null) return;
    setState(() => _isPressed = false);
    widget.onPressed?.call();
  }

  void _handleTapCancel() {
    if (_isPressed) {
      setState(() => _isPressed = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final double depth = widget.depth;
    final double currentOffset = _isPressed ? depth - 1.0 : 0.0;
    final double currentBottomBorder = _isPressed ? 1.0 : depth;

    Widget buttonContent = GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 60),
        curve: Curves.easeOut,
        transform: Matrix4.translationValues(0, currentOffset, 0),
        child: Container(
          height: widget.height,
          width: widget.width,
          decoration: BoxDecoration(
            color: widget.backgroundColor,
            borderRadius: BorderRadius.circular(16),
            border: Border(
              top: BorderSide(color: widget.shadowColor.withOpacity(0.2), width: 1),
              left: BorderSide(color: widget.shadowColor.withOpacity(0.2), width: 1),
              right: BorderSide(color: widget.shadowColor.withOpacity(0.2), width: 1),
              bottom: BorderSide(color: widget.shadowColor, width: currentBottomBorder),
            ),
          ),
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisSize: widget.isFullWidth ? MainAxisSize.max : MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.leading != null) ...[
                widget.leading!,
                const SizedBox(width: 8),
              ],
              Text(
                widget.label,
                style: AppTypography.montserrat(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: widget.textColor,
                  letterSpacing: 0.4,
                ),
              ),
              if (widget.trailing != null) ...[
                const SizedBox(width: 8),
                widget.trailing!,
              ],
            ],
          ),
        ),
      ),
    );

    if (widget.isFullWidth) {
      return SizedBox(
        width: double.infinity,
        height: widget.height + depth,
        child: buttonContent,
      );
    }

    return SizedBox(
      height: widget.height + depth,
      child: buttonContent,
    );
  }
}
