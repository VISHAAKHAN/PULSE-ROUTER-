import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../viewmodels/app_view_model.dart';

class ActiveGuardModal extends StatelessWidget {
  final AppViewModel viewModel;

  const ActiveGuardModal({super.key, required this.viewModel});

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
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: AppColors.emergencyRed.withValues(alpha: 0.2),
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.emergencyRed, width: 2),
              ),
              child: const Icon(
                Icons.shield_outlined,
                color: Color(0xFFFDA4AF),
                size: 26,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              vm.tr('active_emergency_title'),
              style: AppTheme.plusJakartaStyle(
                fontSize: 14,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              vm.tr('cannot_end_duty_msg'),
              style: AppTheme.plusJakartaStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
                color: AppColors.textSlate300,
                height: 1.3,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 18),
            GestureDetector(
              onTap: vm.closeActiveGuardModal,
              child: Container(
                width: double.infinity,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFF334155)),
                ),
                child: Center(
                  child: Text(
                    vm.tr('return_active_case'),
                    style: AppTheme.plusJakartaStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
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
