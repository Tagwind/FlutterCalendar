import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import '../data/dummy_events.dart';
import '../models/event.dart';
import 'app_header_widget.dart';

class CalendarWidget extends StatefulWidget {
  @override
  State<CalendarWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  DateTime _focusedDay = DateTime.utc(2025, 7, 21);
  DateTime? _selectedDay;
  String _viewType = "month";

  List<CalendarEvent> _getEventsForDay(DateTime day) {
    final normalizedDay = DateTime.utc(day.year, day.month, day.day);
    return dummyEvents.where((event) {
      final start = DateTime.utc(
        event.startDate.year,
        event.startDate.month,
        event.startDate.day,
      );
      final end = DateTime.utc(
        event.effectiveEndDate.year,
        event.effectiveEndDate.month,
        event.effectiveEndDate.day,
      );
      return !normalizedDay.isBefore(start) && !normalizedDay.isAfter(end);
    }).toList();
  }

  String formatEventTime(CalendarEvent event) {
    final dt = event.startDate;
    if (dt.hour == 0 && dt.minute == 0) {
      return 'All Day'; // No time set, omit it
    } else {
      final time = TimeOfDay.fromDateTime(dt);
      final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
      final suffix = time.period == DayPeriod.am ? 'am' : 'pm';
      final minutes = time.minute.toString().padLeft(2, '0');
      return '$hour:$minutes$suffix';
    }
  }

  Widget _buildDayCell(
      DateTime day, {
        bool isToday = false,
        bool isOutside = false,
        int weekday = 1,
      }) {
    final events = _getEventsForDay(day);
    final hasEvents = events.isNotEmpty;
    final borderColor = Colors.grey.shade400;
    final burntOrange = Color(0xFFCC5500);

    return Container(
      decoration: BoxDecoration(
        color: isOutside ? Colors.white.withOpacity(0.4) : Colors.white,
        border: Border(
          top: BorderSide(color: borderColor, width: 0.5),
          bottom: BorderSide(color: borderColor, width: 0.5),
          left: weekday == DateTime.sunday
              ? BorderSide.none
              : BorderSide(color: borderColor, width: 0.5),
          right: weekday == DateTime.saturday
              ? BorderSide.none
              : BorderSide(color: borderColor, width: 0.5),
        ),
      ),
      padding: const EdgeInsets.only(right: 4.0, top: 4.0),
      alignment: Alignment.topRight,
      child: LayoutBuilder(
        builder: (context, constraints) {
          const double dayNumberHeight = 30.0;
          const double spacing = 4.0;
          const double eventLineHeight = 26.0;

          final availableHeight = constraints.maxHeight - dayNumberHeight - spacing;
          final maxEventLines = (availableHeight / eventLineHeight).floor();

          final visibleCount = maxEventLines < events.length ? maxEventLines - 1 : events.length;
          final hiddenCount = events.length - visibleCount;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                width: 30,
                height: dayNumberHeight,
                alignment: Alignment.center,
                decoration: isToday
                    ? BoxDecoration(
                  color: burntOrange,
                  shape: BoxShape.circle,
                )
                    : null,
                child: Text(
                  '${day.day}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: isToday
                        ? Colors.white
                        : isOutside
                        ? Colors.black.withOpacity(0.4)
                        : Colors.black,
                  ),
                ),
              ),
              if (hasEvents)
                Padding(
                  padding: const EdgeInsets.only(top: spacing),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      for (int i = 0; i < visibleCount; i++)
                        SizedBox(
                          height: eventLineHeight,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
                            margin: const EdgeInsets.only(bottom: 2.0),
                            decoration: BoxDecoration(
                              color: _getEventColor(events[i]), // pastel background
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Text(
                              _formatEventText(events[i]),
                              style: TextStyle(
                                height: 1.3,
                                fontSize: 13,
                                color: Colors.black87,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ),
                      if (hiddenCount > 0)
                        SizedBox(
                          height: eventLineHeight,
                          child: Text(
                            '$hiddenCount More...',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  String _formatEventText(CalendarEvent e) {
    final timeText = formatEventTime(e);
    return timeText.isNotEmpty ? '$timeText ${e.title}' : e.title;
  }

  Color _getEventColor(CalendarEvent event) {
    const pastelColors = [
      Color(0xFFCCE5FF), // Light Blue
      Color(0xFFD5F5E3), // Light Green
      Color(0xFFFFF3CD), // Light Yellow
      Color(0xFFFFD6D6), // Light Pink
      Color(0xFFE0D7FF), // Light Purple
    ];

    return pastelColors[event.userId % pastelColors.length];
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final headerHeight = screenHeight / 6 / 2;
    final dayRowHeight = (screenHeight - headerHeight) / 5;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(115),
        child: AppHeader(
          title: "Highlight Calendar",
          monthLabel: DateFormat.yMMMM().format(_focusedDay),
          currentViewType: _viewType,
          onViewTypeChanged: (view) {
            setState(() {
              _viewType = view;
            });
          },
          onPrevMonth: () {
            setState(() {
              _focusedDay = DateTime(_focusedDay.year, _focusedDay.month - 1);
            });
          },
          onNextMonth: () {
            setState(() {
              _focusedDay = DateTime(_focusedDay.year, _focusedDay.month + 1);
            });
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: TableCalendar<CalendarEvent>(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2099, 12, 31),
              focusedDay: _focusedDay,
              selectedDayPredicate: (_) => false,
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
              calendarFormat: CalendarFormat.month,
              startingDayOfWeek: StartingDayOfWeek.sunday,
              rowHeight: dayRowHeight,
              daysOfWeekHeight: headerHeight,
              eventLoader: _getEventsForDay,
              calendarStyle: CalendarStyle(
                outsideDaysVisible: true,
                isTodayHighlighted: true,
                defaultTextStyle: TextStyle(fontSize: 12),
                weekendTextStyle: TextStyle(color: Colors.redAccent),
              ),
              headerVisible: false,
              calendarBuilders: CalendarBuilders<CalendarEvent>(
                defaultBuilder: (context, day, focusedDay) =>
                    _buildDayCell(day, weekday: day.weekday),
                selectedBuilder: (context, day, focusedDay) =>
                    _buildDayCell(day, weekday: day.weekday),
                todayBuilder: (context, day, focusedDay) =>
                    _buildDayCell(day, isToday: true, weekday: day.weekday),
                outsideBuilder: (context, day, focusedDay) =>
                    _buildDayCell(day, isOutside: true, weekday: day.weekday),
                markerBuilder: (context, day, events) =>
                    const SizedBox.shrink(), // No black dots
                dowBuilder: (context, day) {
                  return Container(
                    decoration: BoxDecoration(
                      border: Border(
                        right: day.weekday == DateTime.saturday
                            ? BorderSide.none
                            : BorderSide(
                                color: Colors.grey.shade400,
                                width: 0.5,
                              ),
                        bottom: BorderSide(
                          color: Colors.grey.shade400,
                          width: 0.5,
                        ),
                      ),
                    ),
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: Text(
                      DateFormat.E().format(day),
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
