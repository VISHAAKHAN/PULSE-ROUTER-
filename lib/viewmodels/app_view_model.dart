import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../core/localization/app_translations.dart';
import '../core/services/audio_haptic_service.dart';
import '../data/algorithms/hospital_ranking_engine.dart';
import '../data/models/driver_model.dart';
import '../data/models/emergency_case_model.dart';

enum AppScreen {
  login,
  waiting,
  incomingCall,
  navigation,
  arrivedIncident,
  hospitalNav,
  tripReport,
}

class AppViewModel extends ChangeNotifier {
  // Driver state
  final DriverModel driver = DriverModel();

  // Settings
  String _currentLanguage = 'en';
  String _sirenTone = 'yelp';
  bool rememberMe = true;

  // Active Screen
  AppScreen _currentScreen = AppScreen.login;

  // Active Emergency Case
  EmergencyCaseModel? _activeCase;

  // Shift History Records
  final List<ShiftHistoryRecord> _history = [
    ShiftHistoryRecord(
      caseId: 'ER-2026-08392',
      incidentType: 'CARDIAC_EMERGENCY',
      incidentLocation: 'T. Nagar, 3rd Street, Chennai',
      hospital: 'Apollo Hospitals, Greams Rd',
      primaryHospital: 'Apollo Hospitals, Greams Rd',
      hospitalChanged: false,
      rerouteReason: null,
      totalDistance: '11.8 km',
      totalDuration: '24 min',
      date: 'Today',
      time: '19:42',
      status: 'COMPLETED',
    ),
    ShiftHistoryRecord(
      caseId: 'ER-2026-08340',
      incidentType: 'TRAUMA_ACCIDENT',
      incidentLocation: 'Velachery Main Road, Chennai',
      hospital: 'MIOT International',
      primaryHospital: 'Apollo Hospitals',
      hospitalChanged: true,
      rerouteReason: 'ICU unavailable at primary hospital',
      totalDistance: '15.4 km',
      totalDuration: '31 min',
      date: 'Today',
      time: '17:15',
      status: 'COMPLETED',
    ),
    ShiftHistoryRecord(
      caseId: 'ER-2026-08291',
      incidentType: 'RESPIRATORY_DISTRESS',
      incidentLocation: 'Guindy Industrial Estate, Chennai',
      hospital: 'Apollo Hospitals, Greams Rd',
      primaryHospital: 'Apollo Hospitals, Greams Rd',
      hospitalChanged: false,
      rerouteReason: null,
      totalDistance: '9.6 km',
      totalDuration: '21 min',
      date: 'Today',
      time: '14:30',
      status: 'COMPLETED',
    ),
  ];

  // Pop-up Toast states
  bool _showDutyStartedPopup = false;
  bool _showCaseClosedPopup = false;
  String _lastClosedCaseId = '';
  Timer? _popupTimer;

  // Modals visibility
  bool showProfileModal = false;
  bool showHistoryModal = false;
  bool showActiveGuardModal = false;
  bool showSupportModal = false;

  // Dynamic Reroute Alert Banner
  bool showRerouteBanner = false;

  // Hardware clock string
  String liveClock = '';
  Timer? _clockTimer;

  // Test emergency scenario index
  int _scenarioIndex = 0;

  // Test Scenarios Pool
  static const List<Map<String, dynamic>> testScenarios = [
    {
      'address': 'GST Road, Guindy Junction, Chennai',
      'complaint': 'Acute Cardiac / Severe Chest Pain',
      'lat': 13.0067,
      'lng': 80.2025,
      'startLat': 13.0450,
      'startLng': 80.2000,
      'eta': 12,
      'dist': 5.4,
      'phone': '+91 94440 11223',
    },
    {
      'address': 'Anna Nagar, 2nd Avenue, Chennai',
      'complaint': 'Road Traffic Accident (Multiple Trauma)',
      'lat': 13.0850,
      'lng': 80.2101,
      'startLat': 13.0450,
      'startLng': 80.2000,
      'eta': 10,
      'dist': 4.8,
      'phone': '+91 98765 43210',
    },
    {
      'address': 'OMR Road, Thoraipakkam, Chennai',
      'complaint': 'Acute Stroke / Sudden Weakness',
      'lat': 12.9425,
      'lng': 80.2370,
      'startLat': 13.0450,
      'startLng': 80.2000,
      'eta': 14,
      'dist': 5.1,
      'phone': '+91 98401 23456',
    },
  ];

  AppViewModel() {
    _startClock();
  }

  // Getters
  String get currentLanguage => _currentLanguage;
  String get sirenTone => _sirenTone;
  AppScreen get currentScreen => _currentScreen;
  EmergencyCaseModel? get activeCase => _activeCase;
  List<ShiftHistoryRecord> get history => List.unmodifiable(_history);
  bool get isDutyStartedPopupVisible => _showDutyStartedPopup;
  bool get isCaseClosedPopupVisible => _showCaseClosedPopup;
  String get lastClosedCaseId => _lastClosedCaseId;

  String tr(String key) => AppTranslations.get(key, lang: _currentLanguage);

  void _startClock() {
    liveClock = DateFormat('HH:mm:ss').format(DateTime.now());
    _clockTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      liveClock = DateFormat('HH:mm:ss').format(DateTime.now());
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _clockTimer?.cancel();
    _popupTimer?.cancel();
    AudioHapticService.stopEmergencySiren();
    super.dispose();
  }

  // Language & Siren Controls
  void setLanguage(String lang) {
    _currentLanguage = lang;
    AudioHapticService.playAcknowledgeBeep();
    notifyListeners();
  }

  void setSirenTone(String tone) {
    _sirenTone = tone;
    AudioHapticService.playAcknowledgeBeep();
    notifyListeners();
  }

  // Navigation
  void navigateTo(AppScreen screen) {
    _currentScreen = screen;
    notifyListeners();
  }

  // Modals Controller
  void openProfileModal() {
    showProfileModal = true;
    notifyListeners();
  }

  void closeProfileModal() {
    showProfileModal = false;
    notifyListeners();
  }

  void openHistoryModal() {
    showHistoryModal = true;
    notifyListeners();
  }

  void closeHistoryModal() {
    showHistoryModal = false;
    notifyListeners();
  }

  void openSupportModal() {
    showSupportModal = true;
    notifyListeners();
  }

  void closeSupportModal() {
    showSupportModal = false;
    notifyListeners();
  }

  void openActiveGuardModal() {
    showActiveGuardModal = true;
    notifyListeners();
  }

  void closeActiveGuardModal() {
    showActiveGuardModal = false;
    notifyListeners();
  }

  // Duty Toggle
  void toggleDutyMode() {
    if (driver.status == DriverStatus.onDuty) {
      driver.status = DriverStatus.offDuty;
      AudioHapticService.playAcknowledgeBeep();
    } else {
      driver.status = DriverStatus.onDuty;
      AudioHapticService.playAcknowledgeBeep();
      triggerDutyStartedToast();
    }
    notifyListeners();
  }

  // Login Action
  void loginAndStartDuty({required String driverId, required String pin}) {
    driver.status = DriverStatus.onDuty;
    AudioHapticService.playAcknowledgeBeep();
    navigateTo(AppScreen.waiting);
    triggerDutyStartedToast();
  }

  void triggerDutyStartedToast() {
    _showDutyStartedPopup = true;
    _popupTimer?.cancel();
    _popupTimer = Timer(const Duration(seconds: 4), () {
      _showDutyStartedPopup = false;
      notifyListeners();
    });
    notifyListeners();
  }

  void dismissDutyStartedToast() {
    _showDutyStartedPopup = false;
    notifyListeners();
  }

  // Dispatch Test Emergency Call
  void triggerEmergencyAssignment() {
    if (driver.status == DriverStatus.offDuty) {
      driver.status = DriverStatus.onDuty;
    }

    final scenario = testScenarios[_scenarioIndex % testScenarios.length];
    _scenarioIndex++;

    final randomId = 'ER-2026-${10000 + Random().nextInt(90000)}';
    final currentTime = DateFormat('HH:mm:ss').format(DateTime.now());

    _activeCase = EmergencyCaseModel(
      caseId: randomId,
      callerName: 'Emergency Caller',
      callerPhone: scenario['phone'],
      address: scenario['address'],
      incidentLat: scenario['lat'],
      incidentLng: scenario['lng'],
      startLat: scenario['startLat'],
      startLng: scenario['startLng'],
      complaint: scenario['complaint'],
      etaMinutes: scenario['eta'],
      distanceKm: scenario['dist'],
      dispatchedTime: currentTime,
      status: CaseStatus.ringing,
    );

    showRerouteBanner = false;
    navigateTo(AppScreen.incomingCall);
    AudioHapticService.startEmergencySiren(tone: _sirenTone);
  }

  // Slide to Attend (Accept Call)
  void acceptEmergencyCall() {
    if (_activeCase == null) return;
    AudioHapticService.stopEmergencySiren();
    AudioHapticService.playAcknowledgeBeep();

    _activeCase!.status = CaseStatus.navigatingToIncident;
    _activeCase!.acceptedTime = DateFormat('HH:mm:ss').format(DateTime.now());

    navigateTo(AppScreen.navigation);
  }

  // Fast forward navigation simulator
  void simulateNavProgress() {
    if (_activeCase == null) return;
    if (_activeCase!.etaMinutes > 1) {
      _activeCase!.etaMinutes = max(1, _activeCase!.etaMinutes - 4);
      _activeCase!.distanceKm = max(0.4, double.parse((_activeCase!.distanceKm - 1.5).toStringAsFixed(1)));
      AudioHapticService.playAcknowledgeBeep();
      notifyListeners();
    }
  }

  // Direct Phone Call Launcher
  Future<void> makePhoneCall(String phoneNumber) async {
    final cleanNumber = phoneNumber.replaceAll(RegExp(r'\s+'), '');
    final uri = Uri.parse('tel:$cleanNumber');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  // Arrive at Incident Location
  void markArrivedAtIncident() {
    if (_activeCase == null) return;

    _activeCase!.status = CaseStatus.arrivedAtIncident;
    _activeCase!.incidentArrivalTime = DateFormat('HH:mm:ss').format(DateTime.now());

    // Evaluate tertiary trauma centers
    final evalResult = HospitalRankingEngine.evaluate(
      incidentTypeKey: _activeCase!.incidentType,
      incidentLat: _activeCase!.incidentLat,
      incidentLng: _activeCase!.incidentLng,
    );

    _activeCase!.recommendedHospital = evalResult.primary;
    _activeCase!.alternateHospital = evalResult.alternate;

    AudioHapticService.playArrivalChime();
    navigateTo(AppScreen.arrivedIncident);
  }

  // Slide to Start Hospital Trip
  void startHospitalTrip() {
    if (_activeCase == null || _activeCase!.recommendedHospital == null) return;
    _activeCase!.status = CaseStatus.navigatingToHospital;
    AudioHapticService.playAcknowledgeBeep();
    navigateTo(AppScreen.hospitalNav);
  }

  // Fast forward hospital navigation simulator
  void simulateHospitalNavProgress() {
    if (_activeCase == null || _activeCase!.recommendedHospital == null) return;
    final hosp = _activeCase!.recommendedHospital!;
    if (hosp.etaMinutes > 1) {
      hosp.etaMinutes = max(1, hosp.etaMinutes - 4);
      hosp.distanceKm = max(0.4, double.parse((hosp.distanceKm - 1.8).toStringAsFixed(1)));
      AudioHapticService.playAcknowledgeBeep();
      notifyListeners();
    }
  }

  // Trigger Dynamic Reroute (ICU Full)
  void triggerDynamicReroute({String reason = 'ICU bed availability changed at primary hospital'}) {
    if (_activeCase == null || _activeCase!.alternateHospital == null) return;

    final prevHosp = _activeCase!.recommendedHospital!;
    final newHosp = _activeCase!.alternateHospital!;

    _activeCase!.hospitalRerouted = true;
    _activeCase!.primaryHospitalName = prevHosp.name;
    _activeCase!.recommendedHospital = newHosp;
    _activeCase!.rerouteReason = reason;

    showRerouteBanner = true;
    AudioHapticService.playAlertChime();
    notifyListeners();
  }

  void acknowledgeReroute() {
    showRerouteBanner = false;
    AudioHapticService.playAcknowledgeBeep();
    notifyListeners();
  }

  // Hospital Arrival & Trip Summary Report
  void markArrivedAtHospital() {
    if (_activeCase == null) return;

    final c = _activeCase!;
    final hosp = c.recommendedHospital ?? HospitalRankingEngine.chennaiHospitals.first;
    final currentTime = DateFormat('HH:mm:ss').format(DateTime.now());

    c.status = CaseStatus.completed;
    c.hospitalArrivalTime = currentTime;
    c.completedTime = currentTime;

    final totalDist = (c.distanceKm + hosp.distanceKm).toStringAsFixed(1);
    final totalDur = '${c.etaMinutes + hosp.etaMinutes + 6} min';

    // Archive into shift history
    _history.insert(
      0,
      ShiftHistoryRecord(
        caseId: c.caseId,
        incidentType: c.incidentType,
        incidentLocation: c.address,
        hospital: hosp.name,
        primaryHospital: c.primaryHospitalName ?? hosp.name,
        hospitalChanged: c.hospitalRerouted,
        rerouteReason: c.rerouteReason,
        totalDistance: '$totalDist km',
        totalDuration: totalDur,
        date: 'Today',
        time: c.dispatchedTime,
        status: 'COMPLETED',
      ),
    );

    AudioHapticService.playArrivalChime();
    navigateTo(AppScreen.tripReport);
  }

  // Close Case & Return to Waiting Queue
  void returnBackToDuty() {
    _lastClosedCaseId = _activeCase?.caseId ?? 'ER-2026-69655';
    _activeCase = null;
    driver.status = DriverStatus.onDuty;
    AudioHapticService.playAcknowledgeBeep();

    navigateTo(AppScreen.waiting);
    triggerCaseClosedToast();
  }

  void triggerCaseClosedToast() {
    _showCaseClosedPopup = true;
    _popupTimer?.cancel();
    _popupTimer = Timer(const Duration(seconds: 4), () {
      _showCaseClosedPopup = false;
      notifyListeners();
    });
    notifyListeners();
  }

  void dismissCaseClosedToast() {
    _showCaseClosedPopup = false;
    notifyListeners();
  }

  // End Duty / Logout
  void tryEndDuty(BuildContext context) {
    showProfileModal = false;

    if (_activeCase != null && _activeCase!.status != CaseStatus.completed) {
      showActiveGuardModal = true;
      notifyListeners();
      return;
    }

    driver.status = DriverStatus.offDuty;
    _activeCase = null;
    AudioHapticService.playAcknowledgeBeep();
    navigateTo(AppScreen.login);
  }
}
