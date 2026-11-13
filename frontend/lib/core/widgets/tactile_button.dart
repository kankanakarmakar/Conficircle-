// lib/core/widgets/tactile_button.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';

/// Duolingo-inspired 3D Tactile Button.
/// Provides physical depth with bottom bevel extrusion that depresses on tap with haptic feedback.
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
  final bool enabled;

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
    this.enabled = true,
  });

  /// Factory for primary coral button accepting either 'text' or 'label'
  factory TactileButton.primary({
    Key? key,
    String? text,
    String? label,
    required VoidCallback? onPressed,
    bool enabled = true,
    double height = 50,
    Widget? leading,
    Widget? trailing,
  }) {
    return TactileButton(
      key: key,
      label: text ?? label ?? '',
      onPressed: enabled ? onPressed : null,
      enabled: enabled,
      height: height,
      leading: leading,
      trailing: trailing,
      backgroundColor: enabled ? AppColors.coral : const Color(0xFFE2E8F0),
      shadowColor: enabled ? const Color(0xFFC02A16) : const Color(0xFFCBD5E0),
      textColor: enabled ? AppColors.white : const Color(0xFFA0AEC0),
    );
  }

  /// Factory for secondary white button accepting either 'text' or 'label'
  factory TactileButton.secondary({
    Key? key,
    String? text,
    String? label,
    required VoidCallback? onPressed,
    bool enabled = true,
    double height = 48,
  }) {
    return TactileButton(
      key: key,
      label: text ?? label ?? '',
      onPressed: enabled ? onPressed : null,
      enabled: enabled,
      height: height,
      backgroundColor: AppColors.white,
      shadowColor: const Color(0xFFD0D7E2),
      textColor: AppColors.blue,
    );
  }

  /// Factory for navy button
  factory TactileButton.navy({
    Key? key,
    String? text,
    String? label,
    required VoidCallback? onPressed,
    bool enabled = true,
    double height = 50,
  }) {
    return TactileButton(
      key: key,
      label: text ?? label ?? '',
      onPressed: enabled ? onPressed : null,
      enabled: enabled,
      height: height,
      backgroundColor: AppColors.blue,
      shadowColor: const Color(0xFF0D2254),
      textColor: AppColors.white,
    );
  }

  @override
  State<TactileButton> createState() => _TactileButtonState();
}

class _TactileButtonState extends State<TactileButton> {
  bool _isPressed = false;

  void _handleTapDown(TapDownDetails _) {
    if (widget.onPressed == null || !widget.enabled) return;
    HapticFeedback.lightImpact();
    setState(() => _isPressed = true);
  }

  void _handleTapUp(TapUpDetails _) {
    if (widget.onPressed == null || !widget.enabled) return;
    setState(() => _isPressed = false);
    widget.onPressed!();
  }

  void _handleTapCancel() {
    if (_isPressed) {
      setState(() => _isPressed = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final double currentTranslate = _isPressed ? widget.depth - 1.0 : 0.0;
    final double currentShadowHeight = _isPressed ? 1.0 : widget.depth;
    final bool isInteractive = widget.onPressed != null && widget.enabled;

    Widget buttonContent = AnimatedContainer(
      duration: const Duration(milliseconds: 60),
      curve: Curves.easeInOut,
      height: widget.height,
      width: widget.isFullWidth ? double.infinity : widget.width,
      transform: Matrix4.translationValues(0, currentTranslate, 0),
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: widget.shadowColor.withOpacity(0.4),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: widget.shadowColor,
            offset: Offset(0, currentShadowHeight),
            blurRadius: 0, // Solid 3D tactile bevel
          ),
        ],
      ),
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (widget.leading != null) ...[
              widget.leading!,
              const SizedBox(width: 8),
            ],
            Text(
              widget.label,
              style: AppTypography.montserrat(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: widget.textColor,
                letterSpacing: 0.5,
              ),
            ),
            if (widget.trailing != null) ...[
              const SizedBox(width: 8),
              widget.trailing!,
            ],
          ],
        ),
      ),
    );

    return GestureDetector(
      onTapDown: isInteractive ? _handleTapDown : null,
      onTapUp: isInteractive ? _handleTapUp : null,
      onTapCancel: isInteractive ? _handleTapCancel : null,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: EdgeInsets.only(bottom: widget.depth),
        child: buttonContent,
      ),
    );
  }
}
