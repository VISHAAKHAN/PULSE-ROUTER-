import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_theme.dart';
import '../core/widgets/radar_beacon_widget.dart';
import '../data/models/driver_model.dart';
import '../viewmodels/app_view_model.dart';

class Screen2Waiting extends StatelessWidget {
  final AppViewModel viewModel;

  const Screen2Waiting({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    final vm = viewModel;
    final isDuty = vm.driver.status == DriverStatus.onDuty;

    return Container(
      color: AppColors.cardLight,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Top Bar with Duty Header and Profile/History buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isDuty ? AppColors.activeGreen : AppColors.amberWarning,
                          boxShadow: isDuty
                              ? [
                                  BoxShadow(
                                    color: AppColors.activeGreen.withValues(alpha: 0.6),
                                    blurRadius: 8,
                                    spreadRadius: 2,
                                  ),
                                ]
                              : null,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isDuty ? vm.tr('on_duty_header') : vm.tr('off_duty_header'),
                            style: AppTheme.plusJakartaStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w900,
                              color: AppColors.textNavy,
                            ),
                          ),
                          Text(
                            isDuty ? vm.tr('on_duty_sub') : vm.tr('off_duty_sub'),
                            style: AppTheme.plusJakartaStyle(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  Row(
                    children: [
                      // Profile Button
                      _buildHeaderButton(
                        icon: Icons.person_rounded,
                        label: vm.tr('profile_btn'),
                        onTap: vm.openProfileModal,
                      ),
                      const SizedBox(width: 8),
                      // History Button
                      _buildHeaderButton(
                        icon: Icons.history_rounded,
                        label: vm.tr('history_btn'),
                        onTap: vm.openHistoryModal,
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // Interactive Duty Switcher Card
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.borderLight),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: isDuty
                                ? const Color(0xFFECFDF5)
                                : const Color(0xFFFEF3C7),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isDuty
                                  ? const Color(0xFFA7F3D0)
                                  : const Color(0xFFFDE68A),
                            ),
                          ),
                          child: Icon(
                            isDuty
                                ? Icons.verified_user_rounded
                                : Icons.coffee_rounded,
                            color: isDuty
                                ? AppColors.activeGreen
                                : AppColors.amberWarning,
                            size: 18,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 6,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: isDuty
                                        ? AppColors.activeGreen
                                        : AppColors.amberWarning,
                                  ),
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  isDuty
                                      ? vm.tr('active_duty_label')
                                      : vm.tr('off_duty_label'),
                                  style: AppTheme.plusJakartaStyle(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w900,
                                    color: AppColors.textNavy,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              isDuty
                                  ? vm.tr('active_duty_sub')
                                  : vm.tr('off_duty_sub'),
                              style: AppTheme.plusJakartaStyle(
                                fontSize: 9.5,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    // Toggle Button
                    GestureDetector(
                      onTap: vm.toggleDutyMode,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: isDuty
                              ? const Color(0xFF0F172A)
                              : AppColors.activeGreen,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: isDuty
                                  ? Colors.black.withValues(alpha: 0.2)
                                  : AppColors.activeGreen.withValues(alpha: 0.35),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Icon(
                              isDuty ? Icons.coffee_rounded : Icons.power_settings_new_rounded,
                              color: isDuty ? const Color(0xFFFBBF24) : Colors.white,
                              size: 14,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              isDuty
                                  ? vm.tr('go_off_duty_btn')
                                  : vm.tr('resume_duty_btn'),
                              style: AppTheme.plusJakartaStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(flex: 1),

              // Center Radar Beacon
              Column(
                children: [
                  RadarBeaconWidget(
                    isOffDuty: !isDuty,
                    size: 125,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    isDuty
                        ? vm.tr('waiting_radar_title')
                        : vm.tr('off_duty_radar_title'),
                    style: AppTheme.plusJakartaStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                      color: AppColors.textNavy,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      isDuty
                          ? vm.tr('waiting_radar_sub')
                          : vm.tr('off_duty_radar_sub'),
                      style: AppTheme.plusJakartaStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textMuted,
                        height: 1.3,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),

              const Spacer(flex: 1),

              // Unit Details Card
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.borderLight),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildUnitRow(
                      icon: Icons.local_shipping_outlined,
                      label: vm.tr('lbl_ambulance_unit'),
                      value: vm.driver.ambulanceUnit,
                      isMono: true,
                    ),
                    const Divider(height: 16, color: Color(0xFFF1F5F9)),
                    _buildUnitRow(
                      icon: Icons.person_outline_rounded,
                      label: vm.tr('lbl_driver'),
                      value: vm.driver.name,
                      isMono: false,
                    ),
                    const Divider(height: 16, color: Color(0xFFF1F5F9)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: const Color(0xFFECFDF5),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons.shield_outlined,
                                color: AppColors.activeGreenDark,
                                size: 16,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              vm.tr('lbl_status'),
                              style: AppTheme.plusJakartaStyle(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textMuted,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isDuty
                                    ? AppColors.activeGreen
                                    : AppColors.amberWarning,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              isDuty
                                  ? vm.tr('available_dispatch')
                                  : vm.tr('paused_dispatch'),
                              style: AppTheme.plusJakartaStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                                color: isDuty
                                    ? AppColors.activeGreen
                                    : AppColors.amberWarning,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // Dispatch Simulator Card
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF8F8),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: const Color(0xFFFECDD3),
                    style: BorderStyle.solid,
                    width: 1.5,
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.radio_rounded,
                              color: AppColors.emergencyRed,
                              size: 16,
                            ),
                            const SizedBox(width: 6),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  vm.tr('dispatch_simulator'),
                                  style: AppTheme.plusJakartaStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w900,
                                    color: AppColors.textNavy,
                                  ),
                                ),
                                Text(
                                  vm.tr('test_sub'),
                                  style: AppTheme.plusJakartaStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textMuted,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFE4E6),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: const Color(0xFFFECDD3)),
                          ),
                          child: Text(
                            vm.tr('test_mode'),
                            style: AppTheme.plusJakartaStyle(
                              fontSize: 8.5,
                              fontWeight: FontWeight.w800,
                              color: AppColors.emergencyRed,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    // Test Dispatch CTA Button
                    GestureDetector(
                      onTap: vm.triggerEmergencyAssignment,
                      child: Container(
                        width: double.infinity,
                        height: 42,
                        decoration: BoxDecoration(
                          color: AppColors.emergencyRed,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.emergencyRed.withValues(alpha: 0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.notifications_active_rounded,
                                color: Colors.white, size: 16),
                            const SizedBox(width: 6),
                            Text(
                              vm.tr('assign_test_btn'),
                              style: AppTheme.plusJakartaStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.borderLight),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: const Color(0xFF334155), size: 16),
            const SizedBox(height: 2),
            Text(
              label,
              style: AppTheme.plusJakartaStyle(
                fontSize: 9.5,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF334155),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUnitRow({
    required IconData icon,
    required String label,
    required String value,
    required bool isMono,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: const Color(0xFFECFDF5),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: AppColors.activeGreenDark, size: 16),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: AppTheme.plusJakartaStyle(
                fontSize: 10.5,
                fontWeight: FontWeight.w700,
                color: AppColors.textMuted,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        Text(
          value,
          style: isMono
              ? AppTheme.monoStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textNavy,
                )
              : AppTheme.plusJakartaStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textNavy,
                ),
        ),
      ],
    );
  }
}
