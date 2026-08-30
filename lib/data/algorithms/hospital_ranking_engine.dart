import 'dart:math';
import '../models/hospital_model.dart';

class MedicalIncidentCategory {
  final String key;
  final String label;
  final String sublabel;
  final String requiredDept;

  const MedicalIncidentCategory({
    required this.key,
    required this.label,
    required this.sublabel,
    required this.requiredDept,
  });
}

class HospitalRankingEngine {
  static const Map<String, MedicalIncidentCategory> medicalIncidentTypes = {
    'CARDIAC_EMERGENCY': MedicalIncidentCategory(
      key: 'CARDIAC_EMERGENCY',
      label: 'Cardiac Emergency',
      sublabel: 'Acute Chest Pain / MI',
      requiredDept: 'CARDIAC',
    ),
    'TRAUMA_ACCIDENT': MedicalIncidentCategory(
      key: 'TRAUMA_ACCIDENT',
      label: 'Trauma / Accident',
      sublabel: 'High-Speed Multi-Injury',
      requiredDept: 'TRAUMA',
    ),
    'STROKE_NEURO': MedicalIncidentCategory(
      key: 'STROKE_NEURO',
      label: 'Acute Stroke',
      sublabel: 'CVA / Hemiplegia',
      requiredDept: 'NEURO',
    ),
    'RESPIRATORY_DISTRESS': MedicalIncidentCategory(
      key: 'RESPIRATORY_DISTRESS',
      label: 'Respiratory Distress',
      sublabel: 'Severe Acute Hypoxia',
      requiredDept: 'RESPIRATORY',
    ),
    'SEVERE_BURN': MedicalIncidentCategory(
      key: 'SEVERE_BURN',
      label: 'Severe Burns',
      sublabel: 'Critical Thermal Trauma',
      requiredDept: 'BURNS',
    ),
    'PEDIATRIC_EMERGENCY': MedicalIncidentCategory(
      key: 'PEDIATRIC_EMERGENCY',
      label: 'Pediatric Code',
      sublabel: 'Infant / Child Critical Care',
      requiredDept: 'PEDIATRIC',
    ),
  };

  static List<HospitalModel> get chennaiHospitals => [
    HospitalModel(
      id: 'hosp-apollo',
      name: 'Apollo Hospitals, Greams Rd',
      shortName: 'Apollo Hospitals',
      lat: 13.0604,
      lng: 80.2496,
      phone: '+91 44 2829 0200',
      erStatus: 'OPEN',
      icuBeds: 4,
      capabilities: ['CARDIAC', 'TRAUMA', 'NEURO', 'RESPIRATORY'],
      tags: ['Emergency Dept. Open', 'ICU Available (4 beds)', 'Cardiac Cath Lab'],
    ),
    HospitalModel(
      id: 'hosp-miot',
      name: 'MIOT International, Manapakkam',
      shortName: 'MIOT International',
      lat: 13.0182,
      lng: 80.1772,
      phone: '+91 44 4200 2288',
      erStatus: 'OPEN',
      icuBeds: 6,
      capabilities: ['TRAUMA', 'CARDIAC', 'NEURO', 'RESPIRATORY', 'BURNS'],
      tags: ['Level 1 Trauma Care', 'ICU Available (6 beds)', 'Emergency Surgery'],
    ),
    HospitalModel(
      id: 'hosp-fortis',
      name: 'Fortis Malar Hospital, Adyar',
      shortName: 'Fortis Malar',
      lat: 13.0068,
      lng: 80.2573,
      phone: '+91 44 4289 2222',
      erStatus: 'OPEN',
      icuBeds: 2,
      capabilities: ['CARDIAC', 'NEURO', 'RESPIRATORY'],
      tags: ['Cardiac Care Unit', 'ICU Available (2 beds)', 'Neurology ICU'],
    ),
    HospitalModel(
      id: 'hosp-gleneagles',
      name: 'Gleneagles Global Health City, Perumbakkam',
      shortName: 'Gleneagles Global',
      lat: 12.9056,
      lng: 80.1983,
      phone: '+91 44 4477 7000',
      erStatus: 'OPEN',
      icuBeds: 5,
      capabilities: ['TRAUMA', 'CARDIAC', 'PEDIATRIC', 'RESPIRATORY'],
      tags: ['Emergency Trauma OR', 'ICU Available (5 beds)', 'Pediatric Critical Care'],
    ),
    HospitalModel(
      id: 'hosp-kauvery',
      name: 'Kauvery Hospital, Alwarpet',
      shortName: 'Kauvery Hospital',
      lat: 13.0336,
      lng: 80.2505,
      phone: '+91 44 4000 6000',
      erStatus: 'OPEN',
      icuBeds: 3,
      capabilities: ['NEURO', 'CARDIAC', 'RESPIRATORY', 'PEDIATRIC'],
      tags: ['Stroke Care Unit', 'ICU Available (3 beds)', 'Cath Lab Active'],
    ),
    HospitalModel(
      id: 'hosp-rgggh',
      name: 'Govt. General Trauma Hospital, Park Town',
      shortName: 'Govt. General Hospital',
      lat: 13.0827,
      lng: 80.2707,
      phone: '+91 44 2530 5000',
      erStatus: 'OPEN',
      icuBeds: 8,
      capabilities: ['TRAUMA', 'BURNS', 'CARDIAC', 'RESPIRATORY'],
      tags: ['Govt. Trauma Base', 'ICU Available (8 beds)', '24/7 Blood Bank'],
    ),
  ];

  static double calculateDistanceKm(double lat1, double lon1, double lat2, double lon2) {
    const double r = 6371; // Earth radius in km
    final double dLat = (lat2 - lat1) * pi / 180;
    final double dLon = (lon2 - lon1) * pi / 180;
    final double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1 * pi / 180) * cos(lat2 * pi / 180) * sin(dLon / 2) * sin(dLon / 2);
    final double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return double.parse((r * c).toStringAsFixed(1));
  }

  static ({HospitalModel primary, HospitalModel alternate, List<HospitalModel> allRanked}) evaluate({
    required String incidentTypeKey,
    required double incidentLat,
    required double incidentLng,
  }) {
    final typeConfig = medicalIncidentTypes[incidentTypeKey] ??
        medicalIncidentTypes['CARDIAC_EMERGENCY']!;
    final reqDept = typeConfig.requiredDept;

    final scored = chennaiHospitals.map((hosp) {
      final dist = calculateDistanceKm(incidentLat, incidentLng, hosp.lat, hosp.lng);
      final eta = max(6, (dist * 2.2 + 2).round());

      double score = 100;

      // Capability Match (40 pts)
      final hasSpecialty = hosp.capabilities.contains(reqDept);
      score += hasSpecialty ? 40 : -40;

      // ICU Availability (30 pts)
      score += hosp.icuBeds * 5;

      // ER Status (20 pts)
      score += hosp.erStatus == 'OPEN' ? 20 : -100;

      // Distance Suitability
      score -= dist * 2;

      return hosp.copyWith(
        distanceKm: dist,
        etaMinutes: eta,
        computedScore: score,
        hasRequiredSpecialty: hasSpecialty,
      );
    }).toList();

    scored.sort((a, b) => b.computedScore.compareTo(a.computedScore));

    return (
      primary: scored.first,
      alternate: scored.length > 1 ? scored[1] : scored.first,
      allRanked: scored,
    );
  }
}
