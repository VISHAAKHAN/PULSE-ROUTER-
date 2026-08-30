import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';

class SwipeActionButton extends StatefulWidget {
  final String text;
  final IconData icon;
  final VoidCallback onSwipeComplete;
  final double height;

  const SwipeActionButton({
    super.key,
    required this.text,
    required this.icon,
    required this.onSwipeComplete,
    this.height = 64,
  });

  @override
  State<SwipeActionButton> createState() => _SwipeActionButtonState();
}

class _SwipeActionButtonState extends State<SwipeActionButton> {
  double _dragPosition = 0.0;
  bool _isCompleted = false;

  void _onHorizontalDragUpdate(DragUpdateDetails details, double maxDrag) {
    if (_isCompleted) return;
    setState(() {
      _dragPosition = (_dragPosition + details.delta.dx).clamp(0.0, maxDrag);
    });

    if (_dragPosition >= maxDrag * 0.80 && !_isCompleted) {
      _isCompleted = true;
      widget.onSwipeComplete();
    }
  }

  void _onHorizontalDragEnd(DragEndDetails details, double maxDrag) {
    if (_isCompleted) return;
    setState(() {
      _dragPosition = 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final trackWidth = constraints.maxWidth;
        final thumbSize = widget.height - 12;
        final maxDrag = trackWidth - thumbSize - 12;

        return Container(
          width: double.infinity,
          height: widget.height,
          decoration: BoxDecoration(
            color: const Color(0xFF0F172A).withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(widget.height / 2),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.12),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.5),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.centerLeft,
            children: [
              // Progress fill bar behind thumb
              Container(
                width: _dragPosition + thumbSize,
                height: widget.height,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(widget.height / 2),
                  gradient: LinearGradient(
                    colors: [
                      AppColors.activeGreen.withValues(alpha: 0.25),
                      AppColors.activeGreen.withValues(alpha: 0.60),
                    ],
                  ),
                ),
              ),

              // Center text instruction
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(left: 36, right: 16),
                  child: Text(
                    widget.text,
                    style: AppTheme.plusJakartaStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textSubtle,
                      letterSpacing: 0.5,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),

              // Draggable thumb
              Positioned(
                left: 6 + _dragPosition,
                child: GestureDetector(
                  onHorizontalDragUpdate: (details) =>
                      _onHorizontalDragUpdate(details, maxDrag),
                  onHorizontalDragEnd: (details) =>
                      _onHorizontalDragEnd(details, maxDrag),
                  onTap: () {
                    if (!_isCompleted) {
                      _isCompleted = true;
                      widget.onSwipeComplete();
                    }
                  },
                  child: Container(
                    width: thumbSize,
                    height: thumbSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [AppColors.activeGreen, AppColors.activeGreenDark],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.activeGreen.withValues(alpha: 0.7),
                          blurRadius: 16,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Icon(
                      widget.icon,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
