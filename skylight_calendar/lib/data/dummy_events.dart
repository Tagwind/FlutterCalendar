import '../models/event.dart';

class CalendarEvent {
  final String title;
  final DateTime startDate;
  final DateTime? endDate;

  CalendarEvent({
    required this.title,
    required this.startDate,
    this.endDate,
  });

  /// Returns the effective endDate (same as startDate if not set)
  DateTime get effectiveEndDate => endDate ?? startDate;
}


// Map<DateTime, List<CalendarEvent>> normalizeEvents(Map<DateTime, List<CalendarEvent>> input) {
//   return {
//     for (final entry in input.entries)
//       DateTime.utc(entry.key.year, entry.key.month, entry.key.day): entry.value
//   };
// }

final List<CalendarEvent> dummyEvents = [
  CalendarEvent(
    title: "Vacation",
    startDate: DateTime.utc(2025, 7, 21, 9, 30),
  ),
  CalendarEvent(
    title: "Doctor Appointment",
    startDate: DateTime.utc(2025, 7, 22),
    endDate: DateTime.utc(2025, 7, 22),
  ),
  CalendarEvent(
    title: "Doctor Appointment2",
    startDate: DateTime.utc(2025, 7, 22),
    endDate: DateTime.utc(2025, 7, 22),
  ),
  CalendarEvent(
    title: "Doctor Appointment3",
    startDate: DateTime.utc(2025, 7, 22),
    endDate: DateTime.utc(2025, 7, 22),
  ),
  CalendarEvent(
    title: "Doctor Appointment4",
    startDate: DateTime.utc(2025, 7, 22),
    endDate: DateTime.utc(2025, 7, 22),
  ),
  CalendarEvent(
    title: "Doctor Appointment5",
    startDate: DateTime.utc(2025, 7, 22),
    endDate: DateTime.utc(2025, 7, 22),
  ),
  CalendarEvent(
    title: "Conference",
    startDate: DateTime.utc(2025, 7, 25),
    endDate: DateTime.utc(2025, 7, 27),
  ),
];
