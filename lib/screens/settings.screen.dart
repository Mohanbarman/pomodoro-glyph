import 'package:flutter/material.dart';
import 'package:pomodoro_glyph/models/settings.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _formKey = GlobalKey<FormState>();
  final lapLengthController = TextEditingController();
  final shortBreakLengthController = TextEditingController();
  final longBreakLengthController = TextEditingController();
  final sessionsUntilLongBreakController = TextEditingController();

  @override
  void dispose() {
    lapLengthController.dispose();
    shortBreakLengthController.dispose();
    longBreakLengthController.dispose();
    sessionsUntilLongBreakController.dispose();
    super.dispose();
  }

  void handleSave(SettingsModel settings) async {
    settings.lapLength = int.parse(lapLengthController.text);
    settings.sessionUntilLongBreak =
        int.parse(sessionsUntilLongBreakController.text);
    settings.longBreakLength = int.parse(longBreakLengthController.text);
    settings.shortBreakLength = int.parse(shortBreakLengthController.text);
    await settings.saveToStorage();
  }

  @override
  Widget build(context) {
    return Consumer<SettingsModel>(
      builder: (context, settings, child) {
        lapLengthController.text = settings.lapLength.toString();
        shortBreakLengthController.text = settings.shortBreakLength.toString();
        longBreakLengthController.text = settings.longBreakLength.toString();
        sessionsUntilLongBreakController.text =
            settings.sessionUntilLongBreak.toString();
        return Scaffold(
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              handleSave(settings);
              Navigator.pop(context);
            },
            label: const Text('Save Changes'),
            icon: const Icon(Icons.save),
          ),
          appBar: AppBar(title: const Text('Settings')),
          body: Form(
            key: _formKey,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(height: 20),
                  TextFormField(
                    controller: lapLengthController,
                    decoration: const InputDecoration(
                      labelText: 'Lap Length',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  Container(height: 20),
                  TextFormField(
                    controller: shortBreakLengthController,
                    decoration: const InputDecoration(
                      labelText: 'Short Break Length',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  Container(height: 20),
                  TextFormField(
                    controller: longBreakLengthController,
                    decoration: const InputDecoration(
                      labelText: 'Long Break Length',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  Container(height: 20),
                  TextFormField(
                    controller: sessionsUntilLongBreakController,
                    decoration: const InputDecoration(
                      labelText: 'Sessions Until Long Break',
                      border: OutlineInputBorder(),
                      hintText: '40',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
