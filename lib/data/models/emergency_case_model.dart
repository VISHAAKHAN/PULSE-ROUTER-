import 'hospital_model.dart';

enum CaseStatus {
  ringing,
  navigatingToIncident,
  arrivedAtIncident,
  navigatingToHospital,
  completed,
}

class EmergencyCaseModel {
  final String caseId;
  final String callerName;
  final String callerPhone;
  final String address;
  final double incidentLat;
  final double incidentLng;
  final double startLat;
  final double startLng;
  final String complaint;
  int etaMinutes;
  double distanceKm;
  String incidentType;
  HospitalModel? recommendedHospital;
  HospitalModel? alternateHospital;
  String? primaryHospitalName;
  bool hospitalRerouted;
  String? rerouteReason;
  CaseStatus status;

  // Timestamps
  final String dispatchedTime;
  String? acceptedTime;
  String? incidentArrivalTime;
  String? hospitalArrivalTime;
  String? completedTime;

  EmergencyCaseModel({
    required this.caseId,
    required this.callerName,
    required this.callerPhone,
    required this.address,
    required this.incidentLat,
    required this.incidentLng,
    required this.startLat,
    required this.startLng,
    required this.complaint,
    this.etaMinutes = 12,
    this.distanceKm = 5.4,
    this.incidentType = 'CARDIAC_EMERGENCY',
    this.recommendedHospital,
    this.alternateHospital,
    this.primaryHospitalName,
    this.hospitalRerouted = false,
    this.rerouteReason,
    this.status = CaseStatus.ringing,
    required this.dispatchedTime,
    this.acceptedTime,
    this.incidentArrivalTime,
    this.hospitalArrivalTime,
    this.completedTime,
  });
}

class ShiftHistoryRecord {
  final String caseId;
  final String incidentType;
  final String incidentLocation;
  final String hospital;
  final String primaryHospital;
  final bool hospitalChanged;
  final String? rerouteReason;
  final String totalDistance;
  final String totalDuration;
  final String date;
  final String time;
  final String status;

  ShiftHistoryRecord({
    required this.caseId,
    required this.incidentType,
    required this.incidentLocation,
    required this.hospital,
    required this.primaryHospital,
    required this.hospitalChanged,
    this.rerouteReason,
    required this.totalDistance,
    required this.totalDuration,
    required this.date,
    required this.time,
    this.status = 'COMPLETED',
  });
}
