// lib/core/widgets/tactile_card.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/app_colors.dart';

/// Duolingo-grade Tactile Interactive Card.
/// Features high-contrast border and bottom bevel extrusion that depresses on press.
class TactileCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final Color backgroundColor;
  final Color borderColor;
  final Color bevelColor;
  final double depth;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;

  const TactileCard({
    super.key,
    required this.child,
    this.onTap,
    this.backgroundColor = AppColors.white,
    this.borderColor = const Color(0xFFE4E8F0),
    this.bevelColor = const Color(0xFFD0D7E5),
    this.depth = 4.0,
    this.borderRadius = 18.0,
    this.padding = const EdgeInsets.all(16.0),
    this.margin,
  });

  const TactileCard.primary({
    super.key,
    required this.child,
    this.onTap,
    this.backgroundColor = const Color(0xFF173883),
    this.borderColor = const Color(0xFF2E5CB8),
    this.bevelColor = const Color(0xFF0D2254),
    this.depth = 4.0,
    this.borderRadius = 20.0,
    this.padding = const EdgeInsets.all(18.0),
    this.margin,
  });

  @override
  State<TactileCard> createState() => _TactileCardState();
}

class _TactileCardState extends State<TactileCard> {
  bool _isPressed = false;

  void _handleTapDown(TapDownDetails _) {
    if (widget.onTap == null) return;
    HapticFeedback.selectionClick();
    setState(() => _isPressed = true);
  }

  void _handleTapUp(TapUpDetails _) {
    if (widget.onTap == null) return;
    setState(() => _isPressed = false);
    widget.onTap?.call();
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
    final double currentBottom = _isPressed ? 1.0 : depth;

    return Container(
      margin: widget.margin,
      child: Padding(
        padding: EdgeInsets.only(bottom: depth),
        child: GestureDetector(
          onTapDown: widget.onTap != null ? _handleTapDown : null,
          onTapUp: widget.onTap != null ? _handleTapUp : null,
          onTapCancel: widget.onTap != null ? _handleTapCancel : null,
          behavior: HitTestBehavior.opaque,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 60),
            curve: Curves.easeOut,
            transform: Matrix4.translationValues(0, currentOffset, 0),
            decoration: BoxDecoration(
              color: widget.backgroundColor,
              borderRadius: BorderRadius.circular(widget.borderRadius),
              border: Border.all(
                color: widget.borderColor,
                width: 2.0,
              ),
              boxShadow: [
                BoxShadow(
                  color: widget.bevelColor,
                  offset: Offset(0, currentBottom),
                  blurRadius: 0, // Sharp 3D tactile bevel
                ),
              ],
            ),
            padding: widget.padding,
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
