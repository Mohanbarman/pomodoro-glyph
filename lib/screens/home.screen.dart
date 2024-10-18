import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pomodoro_glyph/models/timer.dart';
import 'package:pomodoro_glyph/screens/settings.screen.dart';
import 'package:provider/provider.dart';

class TimerPage extends StatefulWidget {
  const TimerPage({super.key});

  @override
  State<TimerPage> createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  var _isGlpyhSupportChecked = false;

  Future<void> checkGlyphSupport(BuildContext context, TimerModel timer) async {
    if (_isGlpyhSupportChecked) return;
    if (timer.glyph.isSupported) {
      _isGlpyhSupportChecked = false;
      return;
    }
    if (!context.mounted) return;
    _isGlpyhSupportChecked = true;
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Glyph Not Supported'),
        content: const Text(
          'Progress Glyph is not supported on your device. If you have nothing phone 2 run "adb shell settings put global nt_glyph_interface_debug_enable 1" and reload the application',
        ),
        actions: [
          TextButton(
            onPressed: () async {
              await Clipboard.setData(
                const ClipboardData(
                  text:
                      "adb shell settings put global nt_glyph_interface_debug_enable 1",
                ),
              );
            },
            child: const Text('Copy Command'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context, 'OK');
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsPage(),
                ),
              );
            },
            icon: const Icon(Icons.settings),
          )
        ],
      ),
      body: Consumer<TimerModel>(
        builder: (context, timer, child) {
          checkGlyphSupport(context, timer);
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Lap ${timer.lap} ${timer.isBreak ? timer.isLongBreak ? ": Long break" : ": Short Break" : ""}',
                ),
                Text(
                  timer.formatDuration,
                  style: Theme.of(context).textTheme.displayLarge,
                ),
                Container(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    FloatingActionButton(
                      onPressed: () => timer.toggle(),
                      heroTag: 'btn1',
                      child: timer.isRunning
                          ? const Icon(Icons.pause)
                          : const Icon(Icons.play_arrow),
                    ),
                    Container(
                      width: 20,
                    ),
                    FloatingActionButton(
                      onPressed: () => timer.fastForward(),
                      heroTag: 'btn2',
                      child: const Icon(Icons.fast_forward),
                    ),
                    Container(
                      width: 20,
                    ),
                    FloatingActionButton(
                      onPressed: () => timer.reset(),
                      heroTag: 'btn3',
                      child: const Icon(Icons.restart_alt),
                    ),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
