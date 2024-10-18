import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pomodoro_glyph/models/glyph.dart';
import 'package:pomodoro_glyph/models/settings.dart';

class TimerModel extends ChangeNotifier {
  int _lap = 1;
  int timerSec = 0;
  int maxTimerSec = 0;
  bool _breakStarted = false;
  bool _isLongBreak = false;
  Timer? _timer;
  bool _isFastForward = false;
  SettingsModel settings;
  GlyphModel glyph;

  TimerModel({
    required this.settings,
    required this.glyph,
  }) {
    timerSec = settings.lapLength * 60;
    maxTimerSec = timerSec;
  }

  bool get isRunning {
    if (_timer != null) return true;
    return false;
  }

  bool get isBreak {
    return _breakStarted;
  }

  bool get isLongBreak {
    return _breakStarted && _isLongBreak;
  }

  int get lap {
    return (_lap / 2).ceil();
  }

  void start() {
    if (_timer != null) return;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      timerSec--;
      if (timerSec < 0) timerSec = 0;
      glyph.setProgress(maxTimerSec - timerSec, maxTimerSec);
      if (timerSec > 0) {
        notifyListeners();
        return;
      }
      _lap++;

      // breaks on even lap
      if (_lap % 2 == 0) {
        _breakStarted = true;
        timerSec = _lap % settings.sessionUntilLongBreak == 0
            ? settings.longBreakLength * 60
            : settings.shortBreakLength * 60;
        maxTimerSec = timerSec;
        _isLongBreak = _lap % settings.sessionUntilLongBreak == 0;
        if (_isLongBreak) {
          glyph.isLongBreak = true;
        } else {
          glyph.isShortBreak = true;
        }
      }

      // if not then break has ended
      else {
        timerSec = settings.lapLength * 60;
        maxTimerSec = timerSec;
        _breakStarted = false;
        _isLongBreak = false;
        glyph.isShortBreak = false;
        glyph.isLongBreak = false;
      }

      if (_isFastForward) {
        stop();
        _isFastForward = false;
      } else {
        notifyListeners();
      }
    });
  }

  void fastForward() {
    _isFastForward = true;
    timerSec = 1;
    start();
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
    notifyListeners();
  }

  void toggle() {
    if (_timer != null) {
      stop();
    } else {
      start();
    }
    notifyListeners();
  }

  void reset() {
    if (_timer != null) {
      _timer?.cancel();
      _timer = null;
    }
    _lap = 1;
    timerSec = settings.lapLength * 60;
    maxTimerSec = timerSec;
    _isLongBreak = false;
    _breakStarted = false;
    _isFastForward = false;
    glyph.reset();
    notifyListeners();
  }

  String get formatDuration {
    if (timerSec <= 0) return '00:00';
    String seconds = '${timerSec % 60}';
    if (seconds.length <= 1) seconds = '0$seconds';
    return '${(timerSec / 60).floor()}:$seconds';
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
