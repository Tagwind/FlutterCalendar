import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skylight_calendar/constants/default_settings.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import '../forms/add_profile_form.dart';

// Import your database provider class
import '../data/app_database.dart';
import '../providers/database_provider.dart';
import '../data/tables/users.dart';
import '../providers/settings_provider.dart';
import '../widgets/settings_menu/timezone_dropdown_widget.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  //General
  String wiFiName = "Enter Wi-Fi";
  late TextEditingController timeZoneController;
  late TextEditingController displayNameController;
  late TextEditingController zipCodeController;
  late TextEditingController timeFormatController;
  late TextEditingController weatherUnitsController;

  String calendarDisplayName = "Highlight Calendar";
  String zipCode = "Enter a ZIP code to get weather data";
  String startWeekOn = "Sunday";
  String textSize = "Small";
  String displayDensity = "Compact";
  bool autoBrightness = true;
  String brightness = "100%";
  String volumeLevel = "100%";
  bool keyBoardClicks = true;
  String deviceName = "Test Name";
  String connectedServer = "Test Server";
  String softWareVer = "Version 0.1.0";
  String macAddress = "Test Mac Address";
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

  User? selectedUser;

  final List<String> _TimeFormatOptions = ['12', '24'];
  final List<String> _WeatherUnitOptions = ['F', 'C'];

  @override
  void initState() {
    super.initState();
    timeZoneController = TextEditingController();
    displayNameController = TextEditingController();
    zipCodeController = TextEditingController();
    timeFormatController = TextEditingController();
    weatherUnitsController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final provider = context.watch<SettingsProvider>();

    final newTimeZone = provider.get(SettingKey.timezone);
    if (timeZoneController.text != newTimeZone) {
      timeZoneController.text = newTimeZone;
    }

    final newDisplayName = provider.get(SettingKey.calendarDisplayName);
    if (displayNameController.text != newDisplayName) {
      displayNameController.text = newDisplayName;
    }

    final newZipCode = provider.get(SettingKey.zipCode);
    if (zipCodeController.text != newZipCode) {
      zipCodeController.text = newZipCode;
    }

    final newTimeFormat = provider.get(SettingKey.timeFormat);
    if (timeFormatController.text != newTimeFormat) {
      timeFormatController.text = newTimeFormat;
    }

    final newWeatherUnits = provider.get(SettingKey.weatherUnits);
    if (weatherUnitsController.text != newWeatherUnits) {
      weatherUnitsController.text = newWeatherUnits;
    }
  }

  @override
  void dispose() {
    timeZoneController.dispose();
    displayNameController.dispose();
    zipCodeController.dispose();
    super.dispose();
  }

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

  void _showAddProfileOverlay(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) =>
          Dialog(insetPadding: EdgeInsets.all(20), child: AddProfileForm()),
    );
  }

  void _saveSetting(
    SettingKey key,
    String value,
    String section,
    String type,
  ) async {
    final settingsProvider = context.read<SettingsProvider>();
    await settingsProvider.update(key, value);
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
    final myTextStyle = const TextStyle(fontSize: 16, color: Colors.black);

    switch (selectedSection) {
      case 'General':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle('Wi-Fi Name'),
            TextField(
              decoration: const InputDecoration(border: OutlineInputBorder()),
              controller: TextEditingController(text: wiFiName),
              onChanged: (val) => setState(() => wiFiName = val),
            ),
            const SizedBox(height: 16),
            _sectionTitle('Calendar Display Name'),
            TextField(
              decoration: const InputDecoration(border: OutlineInputBorder()),
              controller: displayNameController,
              onChanged: (String? newVal) {
                if (newVal != null) {
                  _saveSetting(
                    SettingKey.calendarDisplayName,
                    newVal,
                    'general',
                    'text',
                  );
                }
              },
            ),
            const SizedBox(height: 16),
            _sectionTitle('Time Zone'),
            TimezoneDropdown(
              timezones: tz.timeZoneDatabase.locations.keys.toList(),
              selectedTimezone: timeZoneController.text,
              onChanged: (String? newTz) {
                if (newTz != null) {
                  setState(() {
                    timeZoneController.text = newTz;
                  });
                  _saveSetting(SettingKey.timezone, newTz, 'general', 'text');
                }
              },
            ),
            const SizedBox(height: 16),
            _sectionTitle('Time Format'),
            DropdownButtonFormField<String>(
              value: timeFormatController.text,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                isDense: true, // Matches TextField spacing
                contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
              ),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.normal, // Adjust weight to match
              ),
              hint: Text('Changes Time Display To Be 12 or 24 Hour'), // Optional hint text
              items: _TimeFormatOptions.map((String option) {
                return DropdownMenuItem<String>(
                  value: option,
                  child: Text(option),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  timeFormatController.text = newValue ?? '12';
                });
                _saveSetting(SettingKey.timeFormat, newValue ?? '12', 'general', 'text');
              },
            ),
            const SizedBox(height: 16),
            _sectionTitle('Weather Zip Code'),
            TextField(
              decoration: const InputDecoration(border: OutlineInputBorder()),
              controller: zipCodeController,
              onChanged: (String? newVal) {
                if (newVal != null) {
                  _saveSetting(
                    SettingKey.zipCode,
                    newVal,
                    'general',
                    'text',
                  );
                }
              },
            ),
            const SizedBox(height: 16),
            _sectionTitle('Weather Units'),
            DropdownButtonFormField<String>(
              value: weatherUnitsController.text,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                isDense: true, // Matches TextField spacing
                contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
              ),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.normal, // Adjust weight to match
              ),
              hint: Text('Changes Time Display To Be 12 or 24 Hour'), // Optional hint text
              items: _WeatherUnitOptions.map((String option) {
                return DropdownMenuItem<String>(
                  value: option,
                  child: Text(option),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  weatherUnitsController.text = newValue ?? 'F';
                });
                _saveSetting(SettingKey.weatherUnits, newValue ?? 'F', 'general', 'text');
              },
            ),
            const SizedBox(height: 16),
            _sectionTitle('Start Week On'),
            TextField(
              decoration: const InputDecoration(border: OutlineInputBorder()),
              controller: TextEditingController(text: startWeekOn),
              onChanged: (val) => setState(() => startWeekOn = val),
            ),
            const SizedBox(height: 16),
            _sectionTitle('Text Size'),
            TextField(
              decoration: const InputDecoration(border: OutlineInputBorder()),
              controller: TextEditingController(text: textSize),
              onChanged: (val) => setState(() => textSize = val),
            ),
            const SizedBox(height: 16),
            _sectionTitle('Display Density'),
            TextField(
              decoration: const InputDecoration(border: OutlineInputBorder()),
              controller: TextEditingController(text: displayDensity),
              onChanged: (val) => setState(() => displayDensity = val),
            ),
            const SizedBox(height: 16),
            _sectionTitle('Display Brightness'),
            SwitchListTile(
              value: autoBrightness,
              onChanged: (val) => setState(() => autoBrightness = val),
              title: const Text('Auto Brightness'),
            ),

          ],
        );

      case 'Calendar':
        return FutureBuilder<List<User>>(
          future: context.read<DatabaseProvider>().db.usersDao.getAllUsers(),
          builder: (context, snapshot) {
            final profiles = snapshot.data ?? [];

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                _sectionTitle('Profiles'),
                DropdownButton<User?>(
                  isExpanded: true,
                  value: selectedUser,
                  hint: Text("Select Profile"),
                  items: [
                    DropdownMenuItem<User?>(
                      value: null,
                      child: Text("➕ Add Profile"),
                    ),
                    ...profiles.map(
                          (user) => DropdownMenuItem<User?>(
                        value: user,
                        child: Text(user.name),
                      ),
                    ),
                  ],
                  onChanged: (value) {
                    if (value == null) {
                      _showAddProfileOverlay(context);
                    } else {
                      setState(() {
                        selectedUser = value;
                      });
                    }
                  },
                ),
                SizedBox(height: 16),
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
          },
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
