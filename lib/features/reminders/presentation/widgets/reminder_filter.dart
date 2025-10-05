import 'package:flutter/material.dart';
import 'package:reminders_app/features/reminders/domain/domain.dart';

class RemindersFilter extends StatelessWidget {
  final ReminderFilter selected;
  final ValueChanged<ReminderFilter> onChanged;

  const RemindersFilter({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<ReminderFilter>(
      icon: const Icon(Icons.filter_list),
      initialValue: selected,
      onSelected: onChanged,
      itemBuilder: (context) => const [
        PopupMenuItem(
          value: ReminderFilter.all,
          child: Text('Todos'),
        ),
        PopupMenuItem(
          value: ReminderFilter.pending,
          child: Text('Pendientes'),
        ),
        PopupMenuItem(
          value: ReminderFilter.completed,
          child: Text('Completados'),
        ),
        PopupMenuItem(
          value: ReminderFilter.skipped,
          child: Text('Omitidos'),
        ),
      ],
    );
  }
}