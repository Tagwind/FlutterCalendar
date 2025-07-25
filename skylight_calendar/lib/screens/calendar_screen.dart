import 'package:flutter/material.dart';
import '../widgets/calendar_widget.dart';
import '../screens/settings_screen.dart';

class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  int selectedIndex = 0;

  final List<String> menuItems = ['Calendar', 'Photos', 'Settings'];
  final List<IconData> icons = [
    Icons.calendar_month_rounded,
    Icons.photo_library_rounded,
    Icons.settings_rounded,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Row(
        children: [
          // Sidebar (fixed width, icon + label vertically)
          Container(
            width: 80,
            color: Colors.white,
            child: Column(
              children: [
                SizedBox(height: 20),
                Text(
                  "S",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 40),

                // Nav items
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: List.generate(menuItems.length, (index) {
                      final isSelected = selectedIndex == index;
                      return InkWell(
                        onTap: () {
                          setState(() {
                            selectedIndex = index;
                          });
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          margin: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 12),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.indigo.withOpacity(0.1)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                icons[index],
                                size: 28,
                                color: isSelected
                                    ? Colors.indigo
                                    : Colors.grey[600],
                              ),
                              SizedBox(height: 6),
                              Text(
                                menuItems[index],
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  color: isSelected
                                      ? Colors.indigo
                                      : Colors.grey[800],
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),

          // Main Content
          Expanded(
            child: Container(

              child: getScreen(selectedIndex),
            ),
          ),
        ],
      ),
    );
  }

  Widget getScreen(int index) {
    switch (index) {
      case 0:
        return CalendarWidget();
      case 1:
        return Center(child: Text('Photos coming soon...'));
      case 2:
        return SettingsScreen();
      default:
        return CalendarWidget();
    }
  }
}
