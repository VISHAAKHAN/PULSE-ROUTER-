import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_theme.dart';
import '../core/widgets/radar_beacon_widget.dart';
import '../core/widgets/swipe_action_button.dart';
import '../viewmodels/app_view_model.dart';

class Screen3IncomingCall extends StatelessWidget {
  final AppViewModel viewModel;

  const Screen3IncomingCall({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    final vm = viewModel;
    final c = vm.activeCase;

    return Container(
      color: const Color(0xFF060C18),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Top Incoming Pill Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.emergencyRed.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppColors.emergencyRed.withValues(alpha: 0.4),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.emergencyRed.withValues(alpha: 0.2),
                      blurRadius: 12,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      '(( ))',
                      style: TextStyle(
                        color: AppColors.emergencyRed,
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      vm.tr('incoming_badge'),
                      style: AppTheme.plusJakartaStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                        color: const Color(0xFFFDA4AF),
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 6),

              // Neon Red Flashing Siren Radar
              const RadarBeaconWidget(
                isEmergency: true,
                size: 110,
              ),

              // Title & Call Center Subtitle
              Column(
                children: [
                  Text(
                    'EMERGENCY DISPATCH',
                    style: AppTheme.plusJakartaStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'CONTROL ROOM  •  CALL CENTER',
                    style: AppTheme.plusJakartaStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w900,
                      color: AppColors.emergencyRed,
                      letterSpacing: 2.0,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 6),

              // Translucent Main Case Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F172A).withValues(alpha: 0.85),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.12),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.5),
                      blurRadius: 30,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Assigned Case Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          vm.tr('lbl_case_id'),
                          style: AppTheme.plusJakartaStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textSubtle,
                            letterSpacing: 0.5,
                          ),
                        ),
                        Text(
                          c?.caseId ?? 'ER-2026-69655',
                          style: AppTheme.monoStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),

                    const Divider(height: 20, color: Color(0xFF334155)),

                    // Emergency Location
                    Text(
                      vm.tr('lbl_incident_loc'),
                      style: AppTheme.plusJakartaStyle(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textSubtle,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      c?.address ?? 'GST Road, Guindy Junction, Chennai',
                      style: AppTheme.plusJakartaStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        height: 1.25,
                      ),
                    ),

                    const SizedBox(height: 14),

                    // 3-Column Metrics Grid
                    Row(
                      children: [
                        // Distance
                        Expanded(
                          child: _buildMetricPill(
                            icon: Icons.location_on_rounded,
                            label: vm.tr('lbl_distance'),
                            value: '${c?.distanceKm ?? 5.4} km',
                          ),
                        ),
                        const SizedBox(width: 8),

                        // Est. Time
                        Expanded(
                          child: _buildMetricPill(
                            icon: Icons.access_time_rounded,
                            label: vm.tr('lbl_est_eta'),
                            value: '${c?.etaMinutes ?? 12} min',
                          ),
                        ),
                        const SizedBox(width: 8),

                        // Severity
                        Expanded(
                          child: _buildMetricPill(
                            icon: Icons.error_outline_rounded,
                            label: vm.tr('lbl_severity'),
                            value: vm.tr('high_priority_label'),
                            valueColor: AppColors.emergencyRed,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 4),

              // Alert Active Indicator
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.notifications_active_rounded,
                    color: AppColors.emergencyRed,
                    size: 14,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'RINGTONE & HAPTIC ALERT ACTIVE',
                    style: AppTheme.plusJakartaStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textSubtle,
                      letterSpacing: 1.0,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 4),

              // Slide to Attend Swipe Button
              Column(
                children: [
                  SwipeActionButton(
                    text: vm.tr('slide_to_attend'),
                    icon: Icons.phone_in_talk_rounded,
                    onSwipeComplete: vm.acceptEmergencyCall,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    vm.tr('slide_attend_sub'),
                    style: AppTheme.plusJakartaStyle(
                      fontSize: 9.5,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textSubtle,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 2),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetricPill({
    required IconData icon,
    required String label,
    required String value,
    Color valueColor = Colors.white,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF08101E).withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: AppColors.emergencyRed.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.emergencyRed, size: 14),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTheme.plusJakartaStyle(
              fontSize: 8.5,
              fontWeight: FontWeight.w700,
              color: AppColors.textSubtle,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: AppTheme.plusJakartaStyle(
              fontSize: 11,
              fontWeight: FontWeight.w900,
              color: valueColor,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
