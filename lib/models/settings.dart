// ignore_for_file: constant_identifier_names
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const LAP_LENGTH = 'lapLength';
const SHORT_BREAK_LENGTH = 'shortBreakLength';
const LONG_BREAK_LENGTH = 'longBreakLength';
const SESSION_UNTIL_LONG_BREAK = 'sessionUntilLongBreak';
const INTRODUCTION_SEEN = 'introductionSeen';

class SettingsModel extends ChangeNotifier {
  int lapLength;
  int shortBreakLength;
  int longBreakLength;
  int sessionUntilLongBreak;
  bool introductionSeen;

  SettingsModel({
    this.lapLength = 40,
    this.shortBreakLength = 5,
    this.longBreakLength = 15,
    this.sessionUntilLongBreak = 4,
    this.introductionSeen = false,
  });

  Future<void> loadFromStorage() async {
    final perfs = await SharedPreferences.getInstance();
    int? lapLength = perfs.getInt(LAP_LENGTH);
    int? shortBreakLength = perfs.getInt(SHORT_BREAK_LENGTH);
    int? longBreakLength = perfs.getInt(LONG_BREAK_LENGTH);
    int? sessionUntilLongBreak = perfs.getInt(SESSION_UNTIL_LONG_BREAK);
    bool? introductionSeen = perfs.getBool(INTRODUCTION_SEEN);

    if (lapLength != null) {
      this.lapLength = lapLength;
    }
    if (shortBreakLength != null) {
      this.shortBreakLength = shortBreakLength;
    }
    if (longBreakLength != null) {
      this.longBreakLength = longBreakLength;
    }
    if (sessionUntilLongBreak != null) {
      this.sessionUntilLongBreak = sessionUntilLongBreak;
    }
    if (introductionSeen != null) {
      this.introductionSeen = introductionSeen;
    }
    notifyListeners();
  }

  Future<void> saveToStorage() async {
    notifyListeners();
    final perfs = await SharedPreferences.getInstance();
    perfs.setInt(LAP_LENGTH, lapLength);
    perfs.setInt(SHORT_BREAK_LENGTH, shortBreakLength);
    perfs.setInt(LONG_BREAK_LENGTH, longBreakLength);
    perfs.setInt(SESSION_UNTIL_LONG_BREAK, sessionUntilLongBreak);
    perfs.setBool(INTRODUCTION_SEEN, introductionSeen);
  }
}
