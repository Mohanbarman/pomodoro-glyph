import 'package:flutter/material.dart';
import 'package:flutter_glyph_kit/flutter_glyph_kit.dart';

class GlyphModel {
  static const progressToLed = {
    0: Phone2Led.c1_1,
    1: Phone2Led.c1_2,
    2: Phone2Led.c1_3,
    3: Phone2Led.c1_4,
    4: Phone2Led.c1_5,
    5: Phone2Led.c1_6,
    6: Phone2Led.c1_7,
    7: Phone2Led.c1_8,
    8: Phone2Led.c1_9,
    9: Phone2Led.c1_10,
    10: Phone2Led.c1_11,
    11: Phone2Led.c1_11,
    12: Phone2Led.c1_12,
    13: Phone2Led.c1_13,
    14: Phone2Led.c1_14,
    15: Phone2Led.c1_15,
    16: Phone2Led.c1_16,
  };
  final _maxProgress = 16;
  bool isShortBreak = false;
  bool isLongBreak = false;
  bool isSupported = true;

  void setProgress(int currentProgress, int completeProgress) async {
    try {
      if (!isSupported) return;
      final glyph = Phone2Glyph();
      int progress =
          (currentProgress / completeProgress * _maxProgress).floor();
      debugPrint(
          'currentProgress = $currentProgress, maxProgress = $completeProgress');
      debugPrint('setting glyph progress $progress');
      List<Phone2Led> ledChannels = [];
      for (int i = 0; i <= progress; i++) {
        var led = progressToLed[i];
        if (led != null) ledChannels.add(led);
      }
      if (isShortBreak) {
        ledChannels.add(Phone2Led.c2);
      } else if (isLongBreak) {
        ledChannels.addAll([Phone2Led.c2, Phone2Led.c3]);
      }
      await glyph.toggle(channels: ledChannels);
    } catch (e) {
      debugPrint(e.toString());
      isSupported = false;
    }
  }

  Future<void> reset() async {
    if (!isSupported) return;
    try {
      final glyph = Phone2Glyph();
      isLongBreak = false;
      isShortBreak = false;
      await glyph.toggle(channels: []);
    } catch (e) {
      isSupported = false;
    }
  }
}
