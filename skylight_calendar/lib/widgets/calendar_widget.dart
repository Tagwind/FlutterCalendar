import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import '../data/dummy_events.dart';

class CalendarWidget extends StatefulWidget {
  @override
  _CalendarWidgetState createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  List<CalendarEvent> _getEventsForDay(DateTime day) {
    final normalized = DateTime.utc(day.year, day.month, day.day);

    final events = dummyEvents.where((event) {
      final start = DateTime.utc(event.startDate.year, event.startDate.month, event.startDate.day);
      final end = DateTime.utc(event.effectiveEndDate.year, event.effectiveEndDate.month, event.effectiveEndDate.day);
      return normalized.isAtSameMomentAs(start) ||
          (normalized.isAfter(start) && normalized.isBefore(end)) ||
          normalized.isAtSameMomentAs(end);
    }).toList();

    print('Checking events for $normalized: ${events.length} found');
    return events;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Skylight Calendar'),
        backgroundColor: Colors.indigo,
      ),
      body: Column(
        children: [
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final rowHeight = constraints.maxHeight / 6;

                return SizedBox(
                  width: double.infinity,
                  child: TableCalendar<CalendarEvent>(
                    firstDay: DateTime.utc(2020, 1, 1),
                    lastDay: DateTime.utc(2030, 12, 31),
                    focusedDay: _focusedDay,
                    selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        _selectedDay = selectedDay;
                        _focusedDay = focusedDay;
                      });
                    },
                    calendarFormat: CalendarFormat.month,
                    rowHeight: rowHeight,
                    eventLoader: _getEventsForDay,
                    calendarStyle: CalendarStyle(
                      outsideDaysVisible: false,
                      isTodayHighlighted: false,
                      defaultTextStyle: TextStyle(fontSize: 12),
                      weekendTextStyle: TextStyle(color: Colors.redAccent),
                    ),
                    headerStyle: HeaderStyle(
                      formatButtonVisible: false,
                      titleCentered: true,
                      titleTextStyle: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    calendarBuilders: CalendarBuilders<CalendarEvent>(
                      defaultBuilder: (context, day, focusedDay) {
                        return _buildDayCell(day);
                      },
                      selectedBuilder: (context, day, focusedDay) {
                        return _buildDayCell(day, isSelected: true);
                      },
                      todayBuilder: (context, day, focusedDay) {
                        return _buildDayCell(day, isToday: true);
                      },
                      outsideBuilder: (context, day, focusedDay) {
                        return _buildDayCell(day, isOutside: true);
                      },
                      dowBuilder: (context, day) {
                        return Center(
                          child: Text(
                            DateFormat.E().format(day),
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        );
                      },
                      // 🚫 Disable the default marker (black dot)
                      markerBuilder: (context, day, events) {
                        return const SizedBox.shrink(); // disables marker
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDayCell(DateTime day,
      {bool isToday = false, bool isSelected = false, bool isOutside = false}) {
    final events = _getEventsForDay(day);
    final textColor = isOutside
        ? Colors.grey
        : isSelected
        ? Colors.white
        : Colors.black;

    return SizedBox.expand(  // This fills the whole table cell
      child: Container(
        margin: const EdgeInsets.all(1),
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.indigo
              : isToday
              ? Colors.indigo.withOpacity(0.1)
              : Colors.transparent,
          border: Border.all(color: Colors.grey.shade300, width: 0.5),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${day.day}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: textColor,
              ),
            ),
            const SizedBox(height: 2),
            ...events.take(3).map((e) => Text(
              '${DateFormat.Hm().format(e.startDate)} ${e.title}${!isSameDay(e.startDate, e.endDate) ? " ↔" : ""}',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 10,
                color: textColor.withOpacity(0.9),
              ),
            )),
            if (events.length > 3)
              Text(
                '+${events.length - 3} more',
                style: TextStyle(
                  fontSize: 9,
                  fontStyle: FontStyle.italic,
                  color: textColor.withOpacity(0.7),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
