import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_theme.dart';
import '../core/widgets/swipe_action_button.dart';
import '../viewmodels/app_view_model.dart';

class Screen5ArrivedIncident extends StatelessWidget {
  final AppViewModel viewModel;

  const Screen5ArrivedIncident({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    final vm = viewModel;
    final c = vm.activeCase;
    final hosp = c?.recommendedHospital;

    return Container(
      color: const Color(0xFF0F172A),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Top Arrival & Status Header
              Column(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: AppColors.activeGreen.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.activeGreen, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.activeGreen.withValues(alpha: 0.3),
                          blurRadius: 16,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.pin_drop_rounded,
                      color: AppColors.activeGreen,
                      size: 28,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    vm.tr('arrived_incident_title'),
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
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.activeGreen,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          vm.tr('control_room_sync'),
                          style: AppTheme.plusJakartaStyle(
                            fontSize: 9.5,
                            fontWeight: FontWeight.w800,
                            color: AppColors.activeGreen,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 4),

              // Incident Location Info Card
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B).withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: const Color(0xFF334155)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          vm.tr('lbl_case_id'),
                          style: AppTheme.monoStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textSubtle,
                          ),
                        ),
                        Text(
                          c?.caseId ?? 'ER-2026-69655',
                          style: AppTheme.monoStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 14, color: Color(0xFF334155)),
                    Text(
                      vm.tr('lbl_incident_loc'),
                      style: AppTheme.monoStyle(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textSubtle,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      c?.address ?? 'GST Road, Guindy Junction, Chennai',
                      style: AppTheme.plusJakartaStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textSlate200,
                      ),
                    ),
                  ],
                ),
              ),

              // External Telemetry Medical Report Card
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFF334155)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.4),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.activeGreen,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              vm.tr('telemetry_report_header'),
                              style: AppTheme.monoStyle(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFF064E3B),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: const Color(0xFF047857)),
                          ),
                          child: Text(
                            vm.tr('data_received_badge'),
                            style: AppTheme.plusJakartaStyle(
                              fontSize: 8.5,
                              fontWeight: FontWeight.w800,
                              color: AppColors.activeGreen,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    // Medical Issue Classification
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0F172A),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFF334155)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                vm.tr('med_issue_class_lbl'),
                                style: AppTheme.plusJakartaStyle(
                                  fontSize: 8.5,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.textSubtle,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                (vm.tr(c?.incidentType ?? 'CARDIAC_EMERGENCY')).toUpperCase(),
                                style: AppTheme.plusJakartaStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w900,
                                  color: const Color(0xFFFDA4AF),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFF4C0519),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: const Color(0xFF9F1239)),
                            ),
                            child: Text(
                              vm.tr('high_severity'),
                              style: AppTheme.plusJakartaStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFFFDA4AF),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Assigned Destination Hospital
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0F172A),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFF334155)),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      vm.tr('assigned_hosp_lbl'),
                                      style: AppTheme.plusJakartaStyle(
                                        fontSize: 8.5,
                                        fontWeight: FontWeight.w800,
                                        color: AppColors.textSubtle,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      hosp?.name ?? 'Apollo Hospitals, Greams Rd',
                                      style: AppTheme.plusJakartaStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w900,
                                        color: Colors.white,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF064E3B),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(color: const Color(0xFF047857)),
                                ),
                                child: Text(
                                  vm.tr('icu_avail_badge'),
                                  style: AppTheme.plusJakartaStyle(
                                    fontSize: 8.5,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.activeGreen,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const Divider(height: 14, color: Color(0xFF1E293B)),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Distance: ${hosp?.distanceKm ?? 7.2} km',
                                style: AppTheme.monoStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textSlate300,
                                ),
                              ),
                              Text(
                                'ETA: ${hosp?.etaMinutes ?? 14} min',
                                style: AppTheme.monoStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.activeGreen,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 6),

              // Slide to Start Hospital Navigation Trip
              Column(
                children: [
                  SwipeActionButton(
                    text: vm.tr('slide_start_trip'),
                    icon: Icons.navigation_rounded,
                    onSwipeComplete: vm.startHospitalTrip,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    vm.tr('slide_start_trip_sub'),
                    style: AppTheme.plusJakartaStyle(
                      fontSize: 9,
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
}
