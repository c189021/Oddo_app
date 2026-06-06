import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/dummy/calendar_dummy.dart';

/// In-memory set of days that already have a diary record (date-only).
///
/// Seeded from the dummy recorded days, then grown at runtime when the user
/// completes a new diary. The home and both calendars watch this provider, so a
/// freshly written day immediately switches to the written state everywhere.
///
/// Prototype only — this is not persisted, so it resets every app launch (any
/// days the user wrote during a session disappear on restart, which is fine).
class RecordedDays extends Notifier<Set<DateTime>> {
  @override
  Set<DateTime> build() => {...CalendarDummy.recordedDays};

  static DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

  /// Marks [date] as recorded. Emits a new set so listeners rebuild.
  void markRecorded(DateTime date) {
    state = {...state, _dateOnly(date)};
  }

  bool isRecorded(DateTime date) => state.contains(_dateOnly(date));
}

final recordedDaysProvider =
    NotifierProvider<RecordedDays, Set<DateTime>>(RecordedDays.new);
