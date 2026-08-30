import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_theme.dart';
import '../viewmodels/app_view_model.dart';

class Screen7TripReport extends StatelessWidget {
  final AppViewModel viewModel;

  const Screen7TripReport({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    final vm = viewModel;
    final c = vm.activeCase;
    final hosp = c?.recommendedHospital;
    final totalDist = ((c?.distanceKm ?? 5.4) + (hosp?.distanceKm ?? 7.2)).toStringAsFixed(1);
    final totalDur = '${(c?.etaMinutes ?? 12) + (hosp?.etaMinutes ?? 14) + 6} min';

    return Container(
      color: const Color(0xFF0F172A),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Top Title & Badge
              Column(
                children: [
                  Container(
                    width: 54,
                    height: 54,
                    decoration: BoxDecoration(
                      color: AppColors.activeGreen.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.activeGreen, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.activeGreen.withValues(alpha: 0.3),
                          blurRadius: 18,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.assignment_turned_in_rounded,
                      color: AppColors.activeGreen,
                      size: 30,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    vm.tr('trip_report_title'),
                    style: AppTheme.plusJakartaStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFF064E3B).withValues(alpha: 0.8),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.activeGreen.withValues(alpha: 0.6)),
                    ),
                    child: Text(
                      'CASE ID: ${c?.caseId ?? 'ER-2026-69655'}',
                      style: AppTheme.monoStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w900,
                        color: AppColors.activeGreen,
                      ),
                    ),
                  ),
                ],
              ),

              // Trip Summary Report Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B).withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: const Color(0xFF334155)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.4),
                      blurRadius: 25,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Medical Classification Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          vm.tr('med_class_lbl'),
                          style: AppTheme.monoStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textSubtle,
                          ),
                        ),
                        Text(
                          (vm.tr(c?.incidentType ?? 'CARDIAC_EMERGENCY')).toUpperCase(),
                          style: AppTheme.plusJakartaStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w900,
                            color: const Color(0xFFFDA4AF),
                          ),
                        ),
                      ],
                    ),

                    const Divider(height: 18, color: Color(0xFF334155)),

                    // Pickup Location
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.pin_drop_rounded,
                          color: AppColors.emergencyRed,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                vm.tr('pickup_loc_lbl'),
                                style: AppTheme.plusJakartaStyle(
                                  fontSize: 9.5,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.textSubtle,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                c?.address ?? 'GST Road, Guindy Junction, Chennai',
                                style: AppTheme.plusJakartaStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Drop-off Hospital
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.apartment_rounded,
                          color: AppColors.trustBlue,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                vm.tr('dropoff_hosp_lbl'),
                                style: AppTheme.plusJakartaStyle(
                                  fontSize: 9.5,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.textSubtle,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                hosp?.name ?? 'Apollo Hospitals, Greams Rd',
                                style: AppTheme.plusJakartaStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),

                    // 2-Column Metrics Grid
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              color: const Color(0xFF0F172A).withValues(alpha: 0.8),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: const Color(0xFF334155)),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  vm.tr('total_dist_lbl'),
                                  style: AppTheme.plusJakartaStyle(
                                    fontSize: 8.5,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.textSubtle,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '$totalDist km',
                                  style: AppTheme.monoStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              color: const Color(0xFF0F172A).withValues(alpha: 0.8),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: const Color(0xFF334155)),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  vm.tr('total_dur_lbl'),
                                  style: AppTheme.plusJakartaStyle(
                                    fontSize: 8.5,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.textSubtle,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  totalDur,
                                  style: AppTheme.monoStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w900,
                                    color: AppColors.activeGreen,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Handover Status Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          vm.tr('handover_status_lbl'),
                          style: AppTheme.plusJakartaStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSubtle,
                          ),
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.done_all_rounded,
                              color: AppColors.activeGreen,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              vm.tr('dropped_handed_over_val'),
                              style: AppTheme.plusJakartaStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w900,
                                color: AppColors.activeGreen,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Action Button: Back to Duty
              GestureDetector(
                onTap: vm.returnBackToDuty,
                child: Container(
                  width: double.infinity,
                  height: 54,
                  decoration: BoxDecoration(
                    color: AppColors.activeGreen,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.activeGreen.withValues(alpha: 0.4),
                        blurRadius: 20,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.refresh_rounded,
                          color: Colors.white, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        vm.tr('back_to_duty_btn'),
                        style: AppTheme.plusJakartaStyle(
                          fontSize: 13.5,
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
      ),
    );
  }
}
