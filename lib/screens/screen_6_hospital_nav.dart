import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_theme.dart';
import '../viewmodels/app_view_model.dart';

class Screen6HospitalNav extends StatefulWidget {
  final AppViewModel viewModel;

  const Screen6HospitalNav({super.key, required this.viewModel});

  @override
  State<Screen6HospitalNav> createState() => _Screen6HospitalNavState();
}

class _Screen6HospitalNavState extends State<Screen6HospitalNav> {
  final MapController _mapController = MapController();

  void _recenterMap() {
    final c = widget.viewModel.activeCase;
    final hosp = c?.recommendedHospital;
    if (c == null || hosp == null) return;

    final start = LatLng(c.incidentLat, c.incidentLng);
    final dest = LatLng(hosp.lat, hosp.lng);

    final bounds = LatLngBounds.fromPoints([start, dest]);
    _mapController.fitCamera(
      CameraFit.bounds(
        bounds: bounds,
        padding: const EdgeInsets.all(50),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = widget.viewModel;
    final c = vm.activeCase;
    final hosp = c?.recommendedHospital;

    final startPoint =
        LatLng(c?.incidentLat ?? 13.0067, c?.incidentLng ?? 80.2025);
    final destPoint =
        LatLng(hosp?.lat ?? 13.0604, hosp?.lng ?? 80.2496);

    final routePoints = [
      startPoint,
      LatLng(startPoint.latitude + 0.015, startPoint.longitude + 0.010),
      LatLng(destPoint.latitude - 0.010, destPoint.longitude - 0.010),
      destPoint,
    ];

    return Container(
      color: AppColors.deepNavy,
      child: SafeArea(
        child: Column(
          children: [
            // Top Navigation Floating HUD Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.deepNavy,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.4),
                    blurRadius: 15,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFF064E3B).withValues(alpha: 0.9),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  color: AppColors.activeGreen.withValues(alpha: 0.5)),
                            ),
                            child: Text(
                              vm.tr('hosp_nav_badge'),
                              style: AppTheme.plusJakartaStyle(
                                fontSize: 9.5,
                                fontWeight: FontWeight.w900,
                                color: AppColors.activeGreen,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            c?.caseId ?? 'ER-2026-69655',
                            style: AppTheme.monoStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textSlate300,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      SizedBox(
                        width: 180,
                        child: Text(
                          hosp?.shortName ?? 'Apollo Hospitals',
                          style: AppTheme.plusJakartaStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),

                  // ETA & Distance meters
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        vm.tr('eta_label'),
                        style: AppTheme.plusJakartaStyle(
                          fontSize: 9.5,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textSubtle,
                          letterSpacing: 1.0,
                        ),
                      ),
                      Text(
                        '${hosp?.etaMinutes ?? 14} min',
                        style: AppTheme.monoStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          color: AppColors.activeGreen,
                        ),
                      ),
                      Text(
                        '${hosp?.distanceKm ?? 7.2} km ${vm.tr('remaining_text')}',
                        style: AppTheme.plusJakartaStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSlate300,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Dynamic Reroute Alert Banner (Slides down when ICU full)
            if (vm.showRerouteBanner)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFF78350F),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.amberWarning, width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.amberWarning.withValues(alpha: 0.3),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: AppColors.amberWarning.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: AppColors.amberWarning.withValues(alpha: 0.5)),
                      ),
                      child: const Icon(
                        Icons.warning_amber_rounded,
                        color: AppColors.amberWarning,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            vm.tr('dest_updated_title'),
                            style: AppTheme.plusJakartaStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w900,
                              color: const Color(0xFFFDE68A),
                            ),
                          ),
                          Text(
                            vm.currentLanguage == 'ta'
                                ? 'ICU பெட் இல்லை. மாற்றப்பட்ட ஆஸ்பத்திரி: ${hosp?.shortName} (${hosp?.distanceKm} கி.மீ)'
                                : 'ICU unavailable. Rerouted to: ${hosp?.shortName} (${hosp?.distanceKm} km)',
                            style: AppTheme.plusJakartaStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                            maxLines: 2,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: vm.acknowledgeReroute,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.amberWarning,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          vm.tr('ack_btn'),
                          style: AppTheme.plusJakartaStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w900,
                            color: const Color(0xFF0F172A),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            // Live Interactive Map View
            Expanded(
              child: Stack(
                children: [
                  FlutterMap(
                    mapController: _mapController,
                    options: MapOptions(
                      initialCenter: startPoint,
                      initialZoom: 13.0,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'com.medical.vit.app',
                      ),
                      PolylineLayer(
                        polylines: [
                          Polyline(
                            points: routePoints,
                            color: AppColors.trustBlue,
                            strokeWidth: 6.0,
                            strokeCap: StrokeCap.round,
                            strokeJoin: StrokeJoin.round,
                          ),
                        ],
                      ),
                      MarkerLayer(
                        markers: [
                          // Hospital Destination Marker
                          Marker(
                            point: destPoint,
                            width: 44,
                            height: 44,
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.trustBlue,
                                border: Border.all(color: Colors.white, width: 2.5),
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        AppColors.trustBlue.withValues(alpha: 0.6),
                                    blurRadius: 16,
                                    spreadRadius: 3,
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.local_hospital_rounded,
                                color: Colors.white,
                                size: 22,
                              ),
                            ),
                          ),
                          // Ambulance Marker
                          Marker(
                            point: startPoint,
                            width: 44,
                            height: 44,
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color(0xFF2563EB),
                                border: Border.all(color: Colors.white, width: 2.5),
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        const Color(0xFF2563EB).withValues(alpha: 0.6),
                                    blurRadius: 16,
                                    spreadRadius: 3,
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.navigation_rounded,
                                color: Colors.white,
                                size: 22,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  // Floating Map Action Buttons
                  Positioned(
                    right: 14,
                    bottom: 14,
                    child: Column(
                      children: [
                        _buildFloatingMapButton(
                          icon: Icons.volume_up_rounded,
                          onTap: () {},
                        ),
                        const SizedBox(height: 8),
                        // Simulate Dynamic ICU Full Reroute
                        _buildFloatingMapButton(
                          icon: Icons.alt_route_rounded,
                          iconColor: AppColors.amberWarning,
                          onTap: () => vm.triggerDynamicReroute(),
                        ),
                        const SizedBox(height: 8),
                        _buildFloatingMapButton(
                          icon: Icons.my_location_rounded,
                          onTap: _recenterMap,
                        ),
                        const SizedBox(height: 8),
                        _buildFloatingMapButton(
                          icon: Icons.fast_forward_rounded,
                          iconColor: AppColors.activeGreen,
                          onTap: vm.simulateHospitalNavProgress,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Navigation Bottom Sheet
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(26)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: 25,
                    offset: const Offset(0, -6),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Drag Handle
                  Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFFCBD5E1),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Hospital Destination Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              color: const Color(0xFFE0F2FE),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: const Color(0xFFBAE6FD)),
                            ),
                            child: const Icon(
                              Icons.apartment_rounded,
                              color: AppColors.trustBlue,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 10),
                          SizedBox(
                            width: 170,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  vm.tr('hosp_dest_lbl'),
                                  style: AppTheme.plusJakartaStyle(
                                    fontSize: 9.5,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.textMuted,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                Text(
                                  hosp?.name ?? 'Apollo Hospitals, Greams Rd',
                                  style: AppTheme.plusJakartaStyle(
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w900,
                                    color: AppColors.textNavy,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  vm.tr('er_open_icu_avail'),
                                  style: AppTheme.plusJakartaStyle(
                                    fontSize: 9.5,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.activeGreen,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      // Call Hospital Button
                      GestureDetector(
                        onTap: () =>
                            vm.makePhoneCall(hosp?.phone ?? '+914428290200'),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: AppColors.trustBlue, width: 1.5),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.phone,
                                  color: AppColors.trustBlue, size: 14),
                              const SizedBox(width: 6),
                              Text(
                                vm.tr('call_btn'),
                                style: AppTheme.plusJakartaStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.trustBlue,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  const Divider(height: 20, color: Color(0xFFF1F5F9)),

                  // 3-Column Metrics Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildMetricRow(
                        icon: Icons.location_on_rounded,
                        label: vm.tr('distance_label'),
                        value: '${hosp?.distanceKm ?? 7.2} km',
                      ),
                      Container(
                          width: 1, height: 28, color: const Color(0xFFF1F5F9)),
                      _buildMetricRow(
                        icon: Icons.access_time_rounded,
                        label: vm.tr('eta_label'),
                        value: '${hosp?.etaMinutes ?? 14} min',
                      ),
                      Container(
                          width: 1, height: 28, color: const Color(0xFFF1F5F9)),
                      _buildMetricRow(
                        icon: Icons.speed_rounded,
                        label: vm.tr('traffic_label'),
                        value: vm.tr('optimal_label'),
                        valueColor: AppColors.activeGreen,
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  // Primary CTA Button: Mark As Arrived at Hospital ER Bay
                  GestureDetector(
                    onTap: vm.markArrivedAtHospital,
                    child: Container(
                      width: double.infinity,
                      height: 52,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0F172A),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            blurRadius: 14,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: AppColors.trustBlue, width: 2),
                            ),
                            child: const Icon(
                              Icons.check_rounded,
                              color: AppColors.trustBlue,
                              size: 18,
                            ),
                          ),
                          Text(
                            vm.tr('arrived_hosp_er_bay'),
                            style: AppTheme.plusJakartaStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              letterSpacing: 0.5,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1E293B),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.keyboard_double_arrow_right_rounded,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingMapButton({
    required IconData icon,
    Color iconColor = const Color(0xFF334155),
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(icon, color: iconColor, size: 20),
      ),
    );
  }

  Widget _buildMetricRow({
    required IconData icon,
    required String label,
    required String value,
    Color valueColor = AppColors.textNavy,
  }) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF475569), size: 18),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: AppTheme.plusJakartaStyle(
                fontSize: 8.5,
                fontWeight: FontWeight.w800,
                color: AppColors.textMuted,
              ),
            ),
            Text(
              value,
              style: AppTheme.plusJakartaStyle(
                fontSize: 13,
                fontWeight: FontWeight.w900,
                color: valueColor,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
