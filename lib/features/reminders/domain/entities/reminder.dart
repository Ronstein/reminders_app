

import 'package:reminders_app/features/reminders/domain/domain.dart';

enum ReminderState { pending, completed, snoozed, skipped }

class Reminder {
  final String id;
  final String title;
  final String description;
  final DateTime dateTime;
  final Frequency frequency;
  final ReminderState state;
  final String? rrule; // optional recurrence rule string

  Reminder({
    required this.id,
    required this.title,
    required this.description,
    required this.dateTime,
    this.frequency = Frequency.once,
    this.state = ReminderState.pending,
    this.rrule,
  });

  Reminder copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? dateTime,
    Frequency? frequency,
    ReminderState? state,
    String? rrule,
  }) {
    return Reminder(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dateTime: dateTime ?? this.dateTime,
      frequency: frequency ?? this.frequency,
      state: state ?? this.state,
      rrule: rrule ?? this.rrule,
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'description': description,
    'dateTime': dateTime.toIso8601String(),
    'frequency': frequency.index,
    'state': state.index,
    'rrule': rrule,
  };

  factory Reminder.fromMap(Map<String, dynamic> m) => Reminder(
    id: m['id'] as String,
    title: m['title'] as String,
    description: m['description'] as String,
    dateTime: DateTime.parse(m['dateTime'] as String),
    frequency: Frequency.values[(m['frequency'] as int)],
    state: ReminderState.values[(m['state'] as int)],
    rrule: m['rrule'] as String?,
  );
}

extension ReminderStateX on ReminderState {
  /// Devuelve una descripción legible en español
  String get label {
    switch (this) {
      case ReminderState.pending:
        return 'Pendiente';
      case ReminderState.completed:
        return 'Completado';
      case ReminderState.snoozed:
        return 'Aplazado';
      case ReminderState.skipped:
        return 'Omitido';
    }
  }
}
