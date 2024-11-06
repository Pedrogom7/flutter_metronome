import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  final Function(bool) toggleTheme;
  final bool isDarkMode;

  SettingsScreen({required this.toggleTheme, required this.isDarkMode});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;

  late bool _darkMode; // Track the local dark mode state

  @override
  void initState() {
    super.initState();
    _darkMode =
        widget.isDarkMode; // Initialize with the current dark mode state
  }

  void _onDarkModeChanged(bool value) {
    setState(() {
      _darkMode = value;
      widget.toggleTheme(value); // Update the app-wide theme
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Settings',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          SwitchListTile(
            title: Text('Enable Notifications'),
            value: _notificationsEnabled,
            onChanged: (bool value) {
              setState(() {
                _notificationsEnabled = value;
              });
            },
          ),
          SwitchListTile(
            title: Text('Dark Mode'),
            value: _darkMode,
            onChanged: _onDarkModeChanged,
          ),
        ],
      ),
    );
  }
}
