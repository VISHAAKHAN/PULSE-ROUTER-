import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/emergency_case_model.dart';
import '../../viewmodels/app_view_model.dart';

class HistoryModal extends StatelessWidget {
  final AppViewModel viewModel;

  const HistoryModal({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    final vm = viewModel;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Container(
        constraints: const BoxConstraints(maxHeight: 600),
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
        child: Column(
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
                        Icons.history_rounded,
                        color: AppColors.activeGreen,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          vm.tr('response_records_title'),
                          style: AppTheme.plusJakartaStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          vm.tr('shift_history_sub'),
                          style: AppTheme.plusJakartaStyle(
                            fontSize: 9.5,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSubtle,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: vm.closeHistoryModal,
                  child: const Icon(
                    Icons.close_rounded,
                    color: AppColors.textSubtle,
                    size: 20,
                  ),
                ),
              ],
            ),

            const Divider(height: 20, color: Color(0xFF334155)),

            // Records Scroll List
            Expanded(
              child: vm.history.isEmpty
                  ? Center(
                      child: Text(
                        'No response records recorded for current shift.',
                        style: AppTheme.plusJakartaStyle(
                          fontSize: 12,
                          color: AppColors.textSubtle,
                        ),
                      ),
                    )
                  : ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      itemCount: vm.history.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final item = vm.history[index];
                        return _buildRecordCard(context, vm, item);
                      },
                    ),
            ),

            const Divider(height: 20, color: Color(0xFF334155)),

            // Close Button
            GestureDetector(
              onTap: vm.closeHistoryModal,
              child: Container(
                width: double.infinity,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    vm.tr('close_records_btn'),
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

  Widget _buildRecordCard(
      BuildContext context, AppViewModel vm, ShiftHistoryRecord item) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B).withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF334155)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                item.caseId,
                style: AppTheme.monoStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFF064E3B),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFF047857)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 5,
                      height: 5,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.activeGreen,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      vm.currentLanguage == 'ta' ? 'முடிந்தது' : 'COMPLETED',
                      style: AppTheme.plusJakartaStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        color: AppColors.activeGreen,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),

          // Incident Type
          Text(
            (vm.tr(item.incidentType)).toUpperCase(),
            style: AppTheme.plusJakartaStyle(
              fontSize: 11,
              fontWeight: FontWeight.w900,
              color: const Color(0xFFFDA4AF),
            ),
          ),

          const SizedBox(height: 6),

          // Incident Location
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.pin_drop_rounded,
                  color: AppColors.emergencyRed, size: 14),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  item.incidentLocation,
                  style: AppTheme.plusJakartaStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 4),

          // Drop-off Hospital
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.apartment_rounded,
                  color: AppColors.trustBlue, size: 14),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  item.hospital,
                  style: AppTheme.plusJakartaStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSlate300,
                  ),
                ),
              ),
            ],
          ),

          // Hospital Changed Warning Badge
          if (item.hospitalChanged) ...[
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF451A03),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFB45309)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.warning_amber_rounded,
                          color: AppColors.amberWarning, size: 13),
                      const SizedBox(width: 4),
                      Text(
                        vm.tr('primary_hosp_rerouted'),
                        style: AppTheme.plusJakartaStyle(
                          fontSize: 9.5,
                          fontWeight: FontWeight.w800,
                          color: AppColors.amberWarning,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    item.rerouteReason ?? 'ICU availability changed',
                    style: AppTheme.plusJakartaStyle(
                      fontSize: 9.5,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSlate300,
                    ),
                  ),
                ],
              ),
            ),
          ],

          const Divider(height: 14, color: Color(0xFF334155)),

          // Time & Distance Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '🕒 ${item.date == 'Today' ? vm.tr('today') : item.date} • ${item.time}',
                style: AppTheme.monoStyle(
                  fontSize: 9.5,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSubtle,
                ),
              ),
              Text(
                '⏱ ${item.totalDistance} • ${item.totalDuration}',
                style: AppTheme.monoStyle(
                  fontSize: 9.5,
                  fontWeight: FontWeight.w800,
                  color: AppColors.activeGreen,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
