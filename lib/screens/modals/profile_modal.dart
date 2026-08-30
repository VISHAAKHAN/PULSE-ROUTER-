import 'package:flutter/material.dart';
import '../../core/services/audio_haptic_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../viewmodels/app_view_model.dart';

class ProfileModal extends StatefulWidget {
  final AppViewModel viewModel;

  const ProfileModal({super.key, required this.viewModel});

  @override
  State<ProfileModal> createState() => _ProfileModalState();
}

class _ProfileModalState extends State<ProfileModal> {
  bool _isPlayingTest = false;

  void _toggleTestSiren(String tone) {
    if (_isPlayingTest) {
      AudioHapticService.stopEmergencySiren();
      setState(() => _isPlayingTest = false);
    } else {
      AudioHapticService.previewSirenTone(tone);
      setState(() => _isPlayingTest = true);
      Future.delayed(const Duration(milliseconds: 3300), () {
        if (mounted) setState(() => _isPlayingTest = false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = widget.viewModel;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF0F172A),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: const Color(0xFF334155), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.85),
              blurRadius: 35,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E293B),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFF334155)),
                        ),
                        child: const Icon(
                          Icons.person_rounded,
                          color: AppColors.activeGreen,
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            vm.tr('driver_profile_title'),
                            style: AppTheme.plusJakartaStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'ID: ${vm.driver.id}',
                            style: AppTheme.monoStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textSubtle,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      AudioHapticService.stopEmergencySiren();
                      vm.closeProfileModal();
                    },
                    child: const Icon(
                      Icons.close_rounded,
                      color: AppColors.textSubtle,
                      size: 20,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // Driver Badge Card
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B).withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF334155)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppColors.activeGreen.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: AppColors.activeGreen.withValues(alpha: 0.5)),
                      ),
                      child: Center(
                        child: Text(
                          'AK',
                          style: AppTheme.monoStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            color: AppColors.activeGreen,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          vm.driver.name,
                          style: AppTheme.plusJakartaStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          vm.tr('first_responder_role'),
                          style: AppTheme.monoStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: AppColors.activeGreen,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // Language Selector Segmented Widget
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B).withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF334155)),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.language_rounded,
                              color: AppColors.trustBlue,
                              size: 16,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              vm.tr('language_heading'),
                              style: AppTheme.plusJakartaStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0C4A6E),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: const Color(0xFF0284C7)),
                          ),
                          child: Text(
                            vm.currentLanguage == 'ta' ? 'தமிழ்' : 'ENGLISH',
                            style: AppTheme.monoStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w900,
                              color: const Color(0xFF38BDF8),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0F172A),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFF334155)),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => vm.setLanguage('en'),
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                decoration: BoxDecoration(
                                  color: vm.currentLanguage == 'en'
                                      ? AppColors.activeGreen
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: Text(
                                    'English',
                                    style: AppTheme.plusJakartaStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w900,
                                      color: vm.currentLanguage == 'en'
                                          ? Colors.white
                                          : AppColors.textSubtle,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => vm.setLanguage('ta'),
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                decoration: BoxDecoration(
                                  color: vm.currentLanguage == 'ta'
                                      ? AppColors.activeGreen
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: Text(
                                    'தமிழ்',
                                    style: AppTheme.plusJakartaStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w900,
                                      color: vm.currentLanguage == 'ta'
                                          ? Colors.white
                                          : AppColors.textSubtle,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // Siren Selector & Test Button
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B).withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF334155)),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.volume_up_rounded,
                              color: AppColors.amberWarning,
                              size: 16,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              vm.tr('siren_sound_heading'),
                              style: AppTheme.plusJakartaStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFF78350F),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: const Color(0xFFD97706)),
                          ),
                          child: Text(
                            vm.sirenTone == 'yelp'
                                ? '⚡ RAPID YELP'
                                : (vm.sirenTone == 'q2b'
                                    ? '🚨 THE BEAST Q2B'
                                    : '💥 THE RUMBLER'),
                            style: AppTheme.monoStyle(
                              fontSize: 8.5,
                              fontWeight: FontWeight.w900,
                              color: const Color(0xFFFDE68A),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              color: const Color(0xFF0F172A),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: const Color(0xFF334155)),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: vm.sirenTone,
                                dropdownColor: const Color(0xFF0F172A),
                                isExpanded: true,
                                icon: const Icon(
                                    Icons.keyboard_arrow_down_rounded,
                                    color: Colors.white,
                                    size: 18),
                                items: const [
                                  DropdownMenuItem(
                                    value: 'yelp',
                                    child: Text('⚡ Rapid Yelp (Recommended)',
                                        style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white)),
                                  ),
                                  DropdownMenuItem(
                                    value: 'q2b',
                                    child: Text('🚨 The Mechanical Q2B',
                                        style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white)),
                                  ),
                                  DropdownMenuItem(
                                    value: 'rumbler',
                                    child: Text('💥 The Rumbler (Sub-Bass)',
                                        style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white)),
                                  ),
                                ],
                                onChanged: (val) {
                                  if (val != null) vm.setSirenTone(val);
                                },
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () => _toggleTestSiren(vm.sirenTone),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 10),
                            decoration: BoxDecoration(
                              color: AppColors.amberWarning,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  _isPlayingTest
                                      ? Icons.stop_rounded
                                      : Icons.play_arrow_rounded,
                                  color: const Color(0xFF0F172A),
                                  size: 16,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  _isPlayingTest ? 'Stop' : 'Test',
                                  style: AppTheme.plusJakartaStyle(
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.w900,
                                    color: const Color(0xFF0F172A),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // Profile Details Card
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B).withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF334155)),
                ),
                child: Column(
                  children: [
                    _buildDetailRow(vm.tr('lbl_ambulance_unit'),
                        vm.driver.ambulanceUnit),
                    const Divider(height: 12, color: Color(0xFF334155)),
                    _buildDetailRow(
                        vm.tr('license_no_lbl'), vm.driver.licenseNo),
                    const Divider(height: 12, color: Color(0xFF334155)),
                    _buildDetailRow(
                        vm.tr('base_station_lbl'), vm.driver.baseStation),
                    const Divider(height: 12, color: Color(0xFF334155)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          vm.tr('duty_status_lbl'),
                          style: AppTheme.monoStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textSubtle,
                          ),
                        ),
                        Text(
                          vm.driver.isOnDuty
                              ? vm.tr('on_duty_badge')
                              : vm.tr('off_duty_badge'),
                          style: AppTheme.monoStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w900,
                            color: vm.driver.isOnDuty
                                ? AppColors.activeGreen
                                : AppColors.amberWarning,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // End Shift & Logout CTA Button
              GestureDetector(
                onTap: () => vm.tryEndDuty(context),
                child: Container(
                  width: double.infinity,
                  height: 46,
                  decoration: BoxDecoration(
                    color: AppColors.emergencyRed.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                        color: AppColors.emergencyRed.withValues(alpha: 0.6)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.logout_rounded,
                          color: Color(0xFFFDA4AF), size: 18),
                      const SizedBox(width: 8),
                      Text(
                        vm.tr('end_shift_logout'),
                        style: AppTheme.plusJakartaStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w900,
                          color: const Color(0xFFFDA4AF),
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
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTheme.monoStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: AppColors.textSubtle,
          ),
        ),
        Text(
          value,
          style: AppTheme.monoStyle(
            fontSize: 10.5,
            fontWeight: FontWeight.w900,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
