import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class RadarBeaconWidget extends StatefulWidget {
  final bool isOffDuty;
  final bool isEmergency; // Red glowing siren radar for incoming calls
  final double size;

  const RadarBeaconWidget({
    super.key,
    this.isOffDuty = false,
    this.isEmergency = false,
    this.size = 130,
  });

  @override
  State<RadarBeaconWidget> createState() => _RadarBeaconWidgetState();
}

class _RadarBeaconWidgetState extends State<RadarBeaconWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.isEmergency ? 1600 : 2600),
    )..repeat();
  }

  @override
  void didUpdateWidget(covariant RadarBeaconWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isOffDuty) {
      _controller.stop();
    } else if (!_controller.isAnimating) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color activeColor = widget.isEmergency
        ? AppColors.emergencyRed
        : (widget.isOffDuty ? AppColors.textMuted : AppColors.activeGreen);

    final Color coreGradient1 = widget.isEmergency
        ? AppColors.emergencyRed
        : (widget.isOffDuty ? const Color(0xFF475569) : AppColors.activeGreenDark);

    final Color coreGradient2 = widget.isEmergency
        ? const Color(0xFFFB7185)
        : (widget.isOffDuty ? const Color(0xFF64748B) : AppColors.activeGreen);

    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Stack(
            alignment: Alignment.center,
            children: [
              // Wave 1
              if (!widget.isOffDuty)
                _buildWave((_controller.value + 0.0) % 1.0, activeColor),
              // Wave 2
              if (!widget.isOffDuty)
                _buildWave((_controller.value + 0.33) % 1.0, activeColor),
              // Wave 3
              if (!widget.isOffDuty)
                _buildWave((_controller.value + 0.66) % 1.0, activeColor),

              // Glowing center core
              Container(
                width: widget.size * 0.48,
                height: widget.size * 0.48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [coreGradient1, coreGradient2],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: activeColor.withValues(alpha: widget.isEmergency ? 0.8 : 0.45),
                      blurRadius: widget.isEmergency ? 25 : 18,
                      spreadRadius: widget.isEmergency ? 4 : 2,
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(
                    widget.isEmergency
                        ? Icons.notifications_active_rounded
                        : (widget.isOffDuty ? Icons.coffee_rounded : Icons.wifi_tethering_rounded),
                    color: Colors.white,
                    size: widget.size * 0.24,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildWave(double progress, Color color) {
    final double minSize = widget.size * 0.48;
    final double currentSize = minSize + (widget.size - minSize) * progress;
    final double opacity = (1.0 - progress).clamp(0.0, 1.0);

    return Container(
      width: currentSize,
      height: currentSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: color.withValues(alpha: opacity * 0.6),
          width: 1.8,
        ),
      ),
    );
  }
}
