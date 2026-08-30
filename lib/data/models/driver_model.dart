enum DriverStatus { onDuty, offDuty }

class DriverModel {
  final String name;
  final String id;
  final String ambulanceUnit;
  final String licenseNo;
  final String baseStation;
  DriverStatus status;

  DriverModel({
    this.name = 'ARUN KUMAR',
    this.id = 'AMB-1042',
    this.ambulanceUnit = 'TN 01 AB 4521',
    this.licenseNo = 'TN-01-2018004921',
    this.baseStation = 'Central Hub (Zone 1)',
    this.status = DriverStatus.offDuty,
  });

  bool get isOnDuty => status == DriverStatus.onDuty;
}
