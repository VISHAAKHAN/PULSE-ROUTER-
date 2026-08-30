import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/theme/app_colors.dart';
import 'core/theme/app_theme.dart';
import 'core/widgets/custom_popups.dart';
import 'screens/modals/active_guard_modal.dart';
import 'screens/modals/history_modal.dart';
import 'screens/modals/profile_modal.dart';
import 'screens/modals/support_modal.dart';
import 'screens/screen_1_login.dart';
import 'screens/screen_2_waiting.dart';
import 'screens/screen_3_incoming_call.dart';
import 'screens/screen_4_navigation.dart';
import 'screens/screen_5_arrived_incident.dart';
import 'screens/screen_6_hospital_nav.dart';
import 'screens/screen_7_trip_report.dart';
import 'viewmodels/app_view_model.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: AppColors.deepNavy,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const AmbulanceApp());
}

class AmbulanceApp extends StatelessWidget {
  const AmbulanceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ambulance Emergency Response',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme(context),
      home: const MainMobileFrame(),
    );
  }
}

class MainMobileFrame extends StatefulWidget {
  const MainMobileFrame({super.key});

  @override
  State<MainMobileFrame> createState() => _MainMobileFrameState();
}

class _MainMobileFrameState extends State<MainMobileFrame> {
  late final AppViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = AppViewModel();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, _) {
        final vm = _viewModel;

        return Scaffold(
          backgroundColor: AppColors.appBackground,
          body: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 450),
              color: AppColors.deepNavy,
              child: Stack(
                children: [
                  // Active Screen View
                  Column(
                    children: [
                      // Top Hardware Status Bar
                      _buildTopHardwareStatusBar(vm),

                      // Screen Content
                      Expanded(
                        child: _buildCurrentScreen(vm),
                      ),
                    ],
                  ),

                  // Duty Started Slide-down Notification Popup
                  CustomPopupNotification(
                    isVisible: vm.isDutyStartedPopupVisible,
                    icon: Icons.check_circle_rounded,
                    title: vm.tr('duty_started_title'),
                    badgeText: vm.tr('on_duty_badge'),
                    subtitle: vm.tr('duty_started_sub'),
                    onClose: vm.dismissDutyStartedToast,
                  ),

                  // Case Closed Slide-down Notification Popup
                  CustomPopupNotification(
                    isVisible: vm.isCaseClosedPopupVisible,
                    icon: Icons.military_tech_rounded,
                    title: vm.tr('case_closed_title'),
                    badgeText: vm.tr('case_closed_status'),
                    subtitle: vm.currentLanguage == 'ta'
                        ? 'கேஸ் ${vm.lastClosedCaseId} வெற்றிகரமாக முடிந்தது. அடுத்த எமர்ஜென்சிக்கு தயார்.'
                        : 'Case ${vm.lastClosedCaseId} closed successfully. Unit ready on duty.',
                    onClose: vm.dismissCaseClosedToast,
                  ),

                  // Modals Stack
                  if (vm.showProfileModal)
                    ProfileModal(viewModel: vm),
                  if (vm.showHistoryModal)
                    HistoryModal(viewModel: vm),
                  if (vm.showActiveGuardModal)
                    ActiveGuardModal(viewModel: vm),
                  if (vm.showSupportModal)
                    SupportModal(viewModel: vm),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTopHardwareStatusBar(AppViewModel vm) {
    return Container(
      width: double.infinity,
      height: 32,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      color: AppColors.deepNavy,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Live Clock
          Text(
            vm.liveClock,
            style: AppTheme.monoStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),

          // GPS & Connectivity Icons
          Row(
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.location_on_rounded,
                    color: AppColors.activeGreen,
                    size: 13,
                  ),
                  const SizedBox(width: 3),
                  Text(
                    vm.tr('gps_active'),
                    style: AppTheme.plusJakartaStyle(
                      fontSize: 9.5,
                      fontWeight: FontWeight.w800,
                      color: AppColors.activeGreen,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 8),
              Text(
                '|',
                style: TextStyle(
                  color: AppColors.textSubtle.withValues(alpha: 0.4),
                  fontSize: 11,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '4G LTE',
                style: AppTheme.plusJakartaStyle(
                  fontSize: 9.5,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textSlate200,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(
                Icons.signal_cellular_alt_rounded,
                color: Colors.white,
                size: 14,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentScreen(AppViewModel vm) {
    switch (vm.currentScreen) {
      case AppScreen.login:
        return Screen1Login(viewModel: vm);
      case AppScreen.waiting:
        return Screen2Waiting(viewModel: vm);
      case AppScreen.incomingCall:
        return Screen3IncomingCall(viewModel: vm);
      case AppScreen.navigation:
        return Screen4Navigation(viewModel: vm);
      case AppScreen.arrivedIncident:
        return Screen5ArrivedIncident(viewModel: vm);
      case AppScreen.hospitalNav:
        return Screen6HospitalNav(viewModel: vm);
      case AppScreen.tripReport:
        return Screen7TripReport(viewModel: vm);
    }
  }
}
