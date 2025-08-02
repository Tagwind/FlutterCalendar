class CalendarEvent {
  final String title;
  final DateTime startDate;
  final DateTime? endDate;
  final int userId;

  CalendarEvent({
    required this.title,
    required this.startDate,
    this.endDate,
    required this.userId,
  });

  /// Returns the effective endDate (same as startDate if not set)
  DateTime get effectiveEndDate => endDate ?? startDate;
}