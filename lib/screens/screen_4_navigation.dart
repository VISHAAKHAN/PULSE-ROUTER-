import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_theme.dart';
import '../viewmodels/app_view_model.dart';

class Screen4Navigation extends StatefulWidget {
  final AppViewModel viewModel;

  const Screen4Navigation({super.key, required this.viewModel});

  @override
  State<Screen4Navigation> createState() => _Screen4NavigationState();
}

class _Screen4NavigationState extends State<Screen4Navigation> {
  final MapController _mapController = MapController();

  void _recenterMap() {
    final c = widget.viewModel.activeCase;
    if (c == null) return;

    final start = LatLng(c.startLat, c.startLng);
    final dest = LatLng(c.incidentLat, c.incidentLng);

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

    final startPoint = LatLng(c?.startLat ?? 13.0450, c?.startLng ?? 80.2000);
    final destPoint =
        LatLng(c?.incidentLat ?? 13.0067, c?.incidentLng ?? 80.2025);

    final routePoints = [
      startPoint,
      LatLng(startPoint.latitude + 0.015, startPoint.longitude + 0.005),
      LatLng(destPoint.latitude - 0.010, destPoint.longitude - 0.005),
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
                              vm.tr('nav_to_incident'),
                              style: AppTheme.plusJakartaStyle(
                                fontSize: 9.5,
                                fontWeight: FontWeight.w900,
                                color: AppColors.activeGreen,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            c?.caseId ?? 'ER-2026-85812',
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
                          c?.address.split(',').first ?? 'OMR Road',
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
                        '${c?.etaMinutes ?? 12} min',
                        style: AppTheme.monoStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          color: AppColors.activeGreen,
                        ),
                      ),
                      Text(
                        '${c?.distanceKm ?? 5.1} km ${vm.tr('remaining_text')}',
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
                            color: const Color(0xFF2563EB),
                            strokeWidth: 6.0,
                            strokeCap: StrokeCap.round,
                            strokeJoin: StrokeJoin.round,
                          ),
                        ],
                      ),
                      MarkerLayer(
                        markers: [
                          // Destination Marker
                          Marker(
                            point: destPoint,
                            width: 44,
                            height: 44,
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.emergencyRed,
                                border: Border.all(color: Colors.white, width: 2.5),
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        AppColors.emergencyRed.withValues(alpha: 0.6),
                                    blurRadius: 16,
                                    spreadRadius: 3,
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.location_on_rounded,
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
                        _buildFloatingMapButton(
                          icon: Icons.my_location_rounded,
                          onTap: _recenterMap,
                        ),
                        const SizedBox(height: 8),
                        _buildFloatingMapButton(
                          icon: Icons.fast_forward_rounded,
                          iconColor: AppColors.activeGreen,
                          onTap: vm.simulateNavProgress,
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

                  // Emergency Caller Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              color: const Color(0xFFECFDF5),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: const Color(0xFFA7F3D0)),
                            ),
                            child: const Icon(
                              Icons.phone_rounded,
                              color: AppColors.activeGreen,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                vm.tr('caller_title'),
                                style: AppTheme.plusJakartaStyle(
                                  fontSize: 9.5,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.textMuted,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              Text(
                                c?.callerPhone ?? '+91 94440 11223',
                                style: AppTheme.plusJakartaStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.textNavy,
                                ),
                              ),
                              Text(
                                vm.tr('caller_sub'),
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

                      // Call Button
                      GestureDetector(
                        onTap: () =>
                            vm.makePhoneCall(c?.callerPhone ?? '+919444011223'),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: AppColors.activeGreen, width: 1.5),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.phone,
                                  color: AppColors.activeGreen, size: 14),
                              const SizedBox(width: 6),
                              Text(
                                vm.tr('call_btn'),
                                style: AppTheme.plusJakartaStyle(
                                  fontSize: 11,
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

                  const Divider(height: 20, color: Color(0xFFF1F5F9)),

                  // 3-Column Metrics Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildMetricRow(
                        icon: Icons.location_on_rounded,
                        label: vm.tr('distance_label'),
                        value: '${c?.distanceKm ?? 5.1} km',
                      ),
                      Container(
                          width: 1, height: 28, color: const Color(0xFFF1F5F9)),
                      _buildMetricRow(
                        icon: Icons.access_time_rounded,
                        label: vm.tr('eta_label'),
                        value: '${c?.etaMinutes ?? 12} min',
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

                  // Primary CTA Button: Mark As Arrived
                  GestureDetector(
                    onTap: vm.markArrivedAtIncident,
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
                                  color: AppColors.activeGreen, width: 2),
                            ),
                            child: const Icon(
                              Icons.check_rounded,
                              color: AppColors.activeGreen,
                              size: 18,
                            ),
                          ),
                          Text(
                            vm.tr('mark_arrived_location'),
                            style: AppTheme.plusJakartaStyle(
                              fontSize: 12,
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
