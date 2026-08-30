class HospitalModel {
  final String id;
  final String name;
  final String shortName;
  final double lat;
  final double lng;
  final String phone;
  final String erStatus;
  int icuBeds;
  final List<String> capabilities;
  final List<String> tags;
  double distanceKm;
  int etaMinutes;
  double computedScore;
  bool hasRequiredSpecialty;

  HospitalModel({
    required this.id,
    required this.name,
    required this.shortName,
    required this.lat,
    required this.lng,
    required this.phone,
    this.erStatus = 'OPEN',
    this.icuBeds = 4,
    this.capabilities = const [],
    this.tags = const [],
    this.distanceKm = 0.0,
    this.etaMinutes = 0,
    this.computedScore = 0.0,
    this.hasRequiredSpecialty = true,
  });

  HospitalModel copyWith({
    String? id,
    String? name,
    String? shortName,
    double? lat,
    double? lng,
    String? phone,
    String? erStatus,
    int? icuBeds,
    List<String>? capabilities,
    List<String>? tags,
    double? distanceKm,
    int? etaMinutes,
    double? computedScore,
    bool? hasRequiredSpecialty,
  }) {
    return HospitalModel(
      id: id ?? this.id,
      name: name ?? this.name,
      shortName: shortName ?? this.shortName,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      phone: phone ?? this.phone,
      erStatus: erStatus ?? this.erStatus,
      icuBeds: icuBeds ?? this.icuBeds,
      capabilities: capabilities ?? this.capabilities,
      tags: tags ?? this.tags,
      distanceKm: distanceKm ?? this.distanceKm,
      etaMinutes: etaMinutes ?? this.etaMinutes,
      computedScore: computedScore ?? this.computedScore,
      hasRequiredSpecialty: hasRequiredSpecialty ?? this.hasRequiredSpecialty,
    );
  }
}
