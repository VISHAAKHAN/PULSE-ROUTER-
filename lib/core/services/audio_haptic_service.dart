import 'dart:async';
import 'package:flutter/services.dart';

class AudioHapticService {
  static Timer? _sirenTimer;
  static bool _isPlayingSiren = false;

  static bool get isPlayingSiren => _isPlayingSiren;

  static void startEmergencySiren({String tone = 'yelp'}) {
    stopEmergencySiren();
    _isPlayingSiren = true;

    // Trigger initial system alert & heavy haptic pattern
    SystemSound.play(SystemSoundType.alert);
    HapticFeedback.heavyImpact();

    // Pulse haptic feedback in intervals matching ambulance siren rhythm
    final int intervalMs = tone == 'yelp' ? 240 : (tone == 'q2b' ? 800 : 400);

    _sirenTimer = Timer.periodic(Duration(milliseconds: intervalMs), (timer) {
      if (!_isPlayingSiren) {
        timer.cancel();
        return;
      }
      HapticFeedback.heavyImpact();
    });
  }

  static void stopEmergencySiren() {
    _isPlayingSiren = false;
    _sirenTimer?.cancel();
    _sirenTimer = null;
  }

  static void playAcknowledgeBeep() {
    SystemSound.play(SystemSoundType.click);
    HapticFeedback.mediumImpact();
  }

  static void playArrivalChime() {
    SystemSound.play(SystemSoundType.alert);
    HapticFeedback.vibrate();
  }

  static void playAlertChime() {
    SystemSound.play(SystemSoundType.alert);
    HapticFeedback.heavyImpact();
  }

  static void previewSirenTone(String tone) {
    startEmergencySiren(tone: tone);
    Timer(const Duration(milliseconds: 3200), () {
      stopEmergencySiren();
    });
  }
}
