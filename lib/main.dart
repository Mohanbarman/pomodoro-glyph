import 'package:flutter/material.dart';
import 'package:pomodoro_glyph/models/glyph.dart';
import 'package:pomodoro_glyph/models/settings.dart';
import 'package:pomodoro_glyph/models/timer.dart';
import 'package:pomodoro_glyph/screens/home.screen.dart';
import 'package:pomodoro_glyph/screens/introduction.screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var settings = SettingsModel();
  await settings.loadFromStorage();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => settings,
        ),
        ChangeNotifierProvider(
          create: (context) => TimerModel(
            settings: settings,
            glyph: GlyphModel(),
          ),
        ),
      ],
      child: MyApp(
        introductionSeen: settings.introductionSeen,
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.introductionSeen});
  final bool introductionSeen;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pomodoro Glyph',
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.redAccent),
        useMaterial3: true,
      ),
      home: introductionSeen ? const TimerPage() : const IntroductionPage(),
    );
  }
}
