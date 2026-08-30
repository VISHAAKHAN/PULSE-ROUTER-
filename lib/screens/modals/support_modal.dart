import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../viewmodels/app_view_model.dart';

class SupportModal extends StatelessWidget {
  final AppViewModel viewModel;

  const SupportModal({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    final vm = viewModel;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.all(22),
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.emergencyRed.withValues(alpha: 0.2),
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.emergencyRed.withValues(alpha: 0.5)),
              ),
              child: const Icon(
                Icons.headset_mic_rounded,
                color: Color(0xFFFDA4AF),
                size: 24,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              vm.tr('support_title'),
              style: AppTheme.plusJakartaStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              vm.tr('support_sub'),
              style: AppTheme.plusJakartaStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.textSubtle,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 14),
            GestureDetector(
              onTap: () => vm.makePhoneCall('+914428880108'),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF334155)),
                ),
                child: Text(
                  '108 / +91 44 2888 0108',
                  style: AppTheme.monoStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFFFDA4AF),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: vm.closeSupportModal,
              child: Container(
                width: double.infinity,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    vm.tr('close_btn'),
                    style: AppTheme.plusJakartaStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
