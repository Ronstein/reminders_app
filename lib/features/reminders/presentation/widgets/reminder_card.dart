import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reminders_app/features/reminders/reminders.dart';


class ReminderCard extends ConsumerWidget {
  final Reminder reminder;
  const ReminderCard({super.key, required this.reminder});

  IconData _getStateIcon(ReminderState state) {
    switch (state) {
      case ReminderState.completed:
        return Icons.check_circle;
      case ReminderState.skipped: // <- nuevo estado omitido
      return Icons.remove_circle;
      case ReminderState.pending:
      default:
        return Icons.pending;
    }
  }

  Color _getStateColor(ReminderState state) {
  switch (state) {
    case ReminderState.completed:
      return Colors.green;
    case ReminderState.skipped: // omitido
      return Colors.orange;
    case ReminderState.pending:
    default:
      return Colors.blueGrey;
  }
}

  /// Calcula la próxima fecha según la frecuencia del recordatorio
  DateTime _getNextDate(DateTime current, Frequency freq) {
    switch (freq) {
      case Frequency.daily:
        return current.add(const Duration(days: 1));
      case Frequency.weekly:
        return current.add(const Duration(days: 7));
      case Frequency.once:
      default:
        return current; // No cambia, es único
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(
          _getStateIcon(reminder.state),
          color: _getStateColor(reminder.state),
          size: 32,
        ),
        title: Text(
          reminder.title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.indigo.shade800,
              ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
            reminder.description,
            maxLines: 1,
            overflow: TextOverflow.ellipsis, // ← agrega los "..."
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey.shade700,
                ),
          ),
            const SizedBox(height: 4),
            Text(
              'Fecha: ${reminder.dateTime}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 4),
            Text(
              'Frecuencia: ${reminder.frequency.label}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey.shade600,
                  ),
            ),
          ],
        ),
        isThreeLine: true,
        trailing: PopupMenuButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          onSelected: (v) async {
            final notifier = ref.read(remindersListProvider.notifier);

            if (v == 'edit') {
              context.push('/edit/${reminder.id}');
            } else if (v == 'complete') {
              // Calcular la próxima fecha si es recurrente
              final nextDate = _getNextDate(reminder.dateTime, reminder.frequency);

              final updated = reminder.copyWith(
                state: reminder.frequency == Frequency.once
                    ? ReminderState.completed // si es "una vez", queda completado
                    : ReminderState.pending,   // si es recurrente, vuelve a pendiente
                dateTime: reminder.frequency == Frequency.once
                    ? reminder.dateTime
                    : nextDate,
              );

              await notifier.updateReminder(updated);
            } else if (v == 'snooze') {
              final snoozed = reminder.copyWith(
                state: ReminderState.snoozed,
                dateTime: reminder.dateTime.add(const Duration(minutes: 2)),
              );
              await ref.read(remindersListProvider.notifier).updateReminder(snoozed);
            } else if (v == 'delete') {
              await ref.read(remindersListProvider.notifier).deleteReminder(reminder.id);
            }
          },
          itemBuilder: (_) => const [
            PopupMenuItem(value: 'edit', child: Text('Editar')),
            PopupMenuItem(value: 'complete', child: Text('Marcar completado')),
            PopupMenuItem(value: 'snooze', child: Text('Aplazar 2 min')),
            PopupMenuItem(value: 'delete', child: Text('Eliminar')),
          ],
        ),
      ),
    );
  }
}
