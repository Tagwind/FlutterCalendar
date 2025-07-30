import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  //General
  String wiFiName = "Enter Wi-Fi";
  String timeZone = "Central";
  String calendarDisplayName = "Highlight Calendar";
  String zipCode = "Enter a ZIP code to get weather data";
  String startWeekOn = "Sunday";
  String textSize = "Sunday";
  String displayDensity = "Sunday";
  String autoBrightness = "Sunday";
  String brightness = "Sunday";
  String volumeLevel = "Sunday";
  bool keyBoardClicks = true;
  String deviceName = "Sunday";
  String connectedServer = "Sunday";
  String softWareVer = "Sunday";
  String macAddress = "Sunday";
  Color profileColor = Colors.indigo;
  bool isDarkMode = false;
  bool use24Hour = false;
  bool isSignedIn = false;
  //Calendar
  String previewChores = "Sunday";
  String numDisplayDays = "Sunday";
  String startOnCurrDay = "Sunday";
  //Chores
  String selectProfileChores = "Sunday";
  String showLateChores = "Sunday";
  //Photos
  bool photoScreenSaverOn = true;
  String turnOnAfterMin = "Sunday";
  String photoOrder = "Sunday";
  String backgroundEffect = "Sunday";
  String showVerticalItems = "Sunday";
  String secondsPerPhoto = "Sunday";
  bool videoSoundOn = true;
  //Reminders
  String remindAtTime = "Sunday";
  String minsBefore = "Sunday";
  bool reminderSound = true;

  String selectedSection = 'General';

  void toggleSignIn() {
    setState(() {
      isSignedIn = !isSignedIn;
    });
  }

  void selectSection(String section) {
    setState(() {
      selectedSection = section;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Row(
        children: [
          // Left Panel: 1/5 of screen
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.grey.shade200,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Text(
                    'Settings',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo[800],
                    ),
                  ),
                  const SizedBox(height: 24),
                  _navItem('General', Icons.settings),
                  _navItem('Calendar', Icons.edit_calendar),
                  _navItem('Chores', Icons.list),
                  _navItem('Photos', Icons.photo),
                  _navItem('Reminders', Icons.doorbell),
                ],
              ),
            ),
          ),

          // Right Panel: 4/5 of screen
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: ListView(
                children: [
                  Text(
                    selectedSection,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo[800],
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildSettingsContent(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Left nav item
  Widget _navItem(String title, [IconData? icon]) {
    final isSelected = selectedSection == title;

    return ListTile(
      leading: icon != null ? Icon(icon) : null,
      selected: isSelected,
      selectedTileColor: Colors.indigo.shade100,
      title: Text(title),
      onTap: () => selectSection(title),
    );
  }


  // Right panel content
  Widget _buildSettingsContent() {
    switch (selectedSection) {
      case 'General':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle('Wi-Fi'),
            TextField(
              decoration: const InputDecoration(border: OutlineInputBorder()),
              controller: TextEditingController(text: wiFiName),
              onChanged: (val) => setState(() => wiFiName = val),
            ),
            const SizedBox(height: 16),
            _sectionTitle('Profile Color'),
            Row(
              children: [
                const Text("Choose color: "),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: () {
                    // Color picker dialog goes here
                  },
                  child: CircleAvatar(
                    radius: 16,
                    backgroundColor: profileColor,
                  ),
                ),
              ],
            ),
          ],
        );

      case 'Calendar':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle('Google Calendar Integration'),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                isSignedIn ? 'Signed in with Google' : 'Not signed in',
              ),
              trailing: ElevatedButton(
                onPressed: toggleSignIn,
                child: Text(isSignedIn ? 'Sign out' : 'Sign in'),
              ),
            ),
          ],
        );

      case 'Chores':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle('General'),
            SwitchListTile(
              value: use24Hour,
              onChanged: (val) => setState(() => use24Hour = val),
              title: const Text('Use 24-hour format'),
            ),
            SwitchListTile(
              value: isDarkMode,
              onChanged: (val) => setState(() => isDarkMode = val),
              title: const Text('Dark Mode (coming soon)'),
            ),
          ],
        );

      case 'Photos':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle('General'),
            SwitchListTile(
              value: use24Hour,
              onChanged: (val) => setState(() => use24Hour = val),
              title: const Text('Use 24-hour format'),
            ),
            SwitchListTile(
              value: isDarkMode,
              onChanged: (val) => setState(() => isDarkMode = val),
              title: const Text('Dark Mode (coming soon)'),
            ),
          ],
        );

      case 'Reminders':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle('General'),
            SwitchListTile(
              value: use24Hour,
              onChanged: (val) => setState(() => use24Hour = val),
              title: const Text('Use 24-hour format'),
            ),
            SwitchListTile(
              value: isDarkMode,
              onChanged: (val) => setState(() => isDarkMode = val),
              title: const Text('Dark Mode (coming soon)'),
            ),
          ],
        );

      default:
        return const Text("No settings available.");
    }
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
