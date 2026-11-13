// lib/core/widgets/tactile_option_card.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';

/// Duolingo-style Option Card for quizzes, assessments, and onboarding choices.
/// Features high-contrast border, bottom 3D bevel, and animated selection state.
class TactileOptionCard extends StatefulWidget {
  final String label;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final bool isSelected;
  final VoidCallback onSelect;

  TactileOptionCard({
    super.key,
    String? label,
    String? title,
    this.subtitle,
    Widget? leading,
    Widget? leadingWidget,
    Widget? trailing,
    Widget? trailingWidget,
    required this.isSelected,
    VoidCallback? onSelect,
    VoidCallback? onTap,
  })  : label = label ?? title ?? '',
        leading = leading ?? leadingWidget,
        trailing = trailing ?? trailingWidget,
        onSelect = onSelect ?? onTap ?? (() {});

  @override
  State<TactileOptionCard> createState() => _TactileOptionCardState();
}

class _TactileOptionCardState extends State<TactileOptionCard> {
  bool _isPressed = false;

  void _handleTapDown(TapDownDetails _) {
    HapticFeedback.selectionClick();
    setState(() => _isPressed = true);
  }

  void _handleTapUp(TapUpDetails _) {
    setState(() => _isPressed = false);
    widget.onSelect();
  }

  void _handleTapCancel() {
    if (_isPressed) setState(() => _isPressed = false);
  }

  @override
  Widget build(BuildContext context) {
    const double depth = 4.0;
    final double currentOffset = _isPressed ? depth - 1.0 : 0.0;
    final double currentBottom = _isPressed ? 1.0 : depth;

    final Color bgColor = widget.isSelected ? const Color(0xFFEFF5FF) : AppColors.white;
    final Color borderColor = widget.isSelected ? AppColors.blue : const Color(0xFFE4E8F0);
    final Color bevelColor = widget.isSelected ? const Color(0xFF0F2459) : const Color(0xFFD0D7E5);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.only(bottom: depth),
        child: GestureDetector(
          onTapDown: _handleTapDown,
          onTapUp: _handleTapUp,
          onTapCancel: _handleTapCancel,
          behavior: HitTestBehavior.opaque,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 60),
            curve: Curves.easeOut,
            transform: Matrix4.translationValues(0, currentOffset, 0),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: borderColor,
                width: 2.0,
              ),
              boxShadow: [
                BoxShadow(
                  color: bevelColor,
                  offset: Offset(0, currentBottom),
                  blurRadius: 0, // Sharp 3D tactile bevel
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                if (widget.leading != null) ...[
                  widget.leading!,
                  const SizedBox(width: 14),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.label,
                        style: AppTypography.montserrat(
                          fontSize: 14,
                          fontWeight: widget.isSelected ? FontWeight.w800 : FontWeight.w600,
                          color: widget.isSelected ? AppColors.blue : AppColors.black,
                        ),
                      ),
                      if (widget.subtitle != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          widget.subtitle!,
                          style: AppTypography.body(fontSize: 12, color: AppColors.darkGrey),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                if (widget.trailing != null)
                  widget.trailing!
                else
                  // Selection Indicator Ring / Checkmark
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: widget.isSelected ? AppColors.blue : Colors.transparent,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: widget.isSelected ? AppColors.blue : const Color(0xFFD0D7E5),
                        width: 2,
                      ),
                    ),
                    child: widget.isSelected
                        ? const Icon(Icons.check, size: 16, color: AppColors.white)
                        : null,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
