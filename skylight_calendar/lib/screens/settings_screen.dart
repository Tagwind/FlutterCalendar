import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String profileName = "Family Calendar";
  Color profileColor = Colors.indigo;
  bool isDarkMode = false;
  bool use24Hour = false;
  bool isSignedIn = false;

  void toggleSignIn() {
    setState(() {
      isSignedIn = !isSignedIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text(
          'Settings',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.indigo[800],
          ),
        ),
        const SizedBox(height: 24),

        // Profile Settings
        _sectionTitle('Profile'),
        TextField(
          decoration: InputDecoration(
            labelText: "Profile Name",
            border: OutlineInputBorder(),
          ),
          controller: TextEditingController(text: profileName),
          onChanged: (val) {
            setState(() {
              profileName = val;
            });
          },
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Text("Profile Color: "),
            const SizedBox(width: 12),
            GestureDetector(
              onTap: () {
                // Add color picker later
              },
              child: CircleAvatar(
                radius: 16,
                backgroundColor: profileColor,
              ),
            ),
          ],
        ),

        const SizedBox(height: 32),

        // Calendar Integration
        _sectionTitle('Google Calendar'),
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(isSignedIn
              ? 'Signed in with Google'
              : 'Not signed in to Google'),
          trailing: ElevatedButton(
            onPressed: toggleSignIn,
            child: Text(isSignedIn ? 'Sign out' : 'Sign in'),
          ),
        ),

        const SizedBox(height: 32),

        // General Settings
        _sectionTitle('General'),
        SwitchListTile(
          value: use24Hour,
          onChanged: (val) {
            setState(() {
              use24Hour = val;
            });
          },
          title: Text('Use 24-hour format'),
        ),
        SwitchListTile(
          value: isDarkMode,
          onChanged: (val) {
            setState(() {
              isDarkMode = val;
            });
          },
          title: Text('Dark Mode (coming soon)'),
        ),
      ],
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.indigo[700],
        ),
      ),
    );
  }
}
