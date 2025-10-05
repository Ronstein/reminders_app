import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:reminders_app/core/core.dart';
import 'package:reminders_app/features/reminders/domain/domain.dart';
import 'package:uuid/uuid.dart';

import '../providers/providers.dart';

class ReminderFormScreen extends ConsumerStatefulWidget {
  static const String name = 'reminderForm';
  final String? reminderId;

  const ReminderFormScreen({super.key, this.reminderId});

  @override
  ConsumerState<ReminderFormScreen> createState() =>
      _ReminderFormScreenState();
}

class _ReminderFormScreenState extends ConsumerState<ReminderFormScreen> {
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  DateTime? _dateTime;
  Frequency _freq = Frequency.once;
  String? _rrule;
  ReminderState _state = ReminderState.pending;

  @override
  void initState() {
    super.initState();

    if (widget.reminderId != null) {
      final reminder =
          ref.read(remindersListProvider.notifier).getById(widget.reminderId!);

      if (reminder != null) {
        _titleCtrl.text = reminder.title;
        _descCtrl.text = reminder.description;
        _dateTime = reminder.dateTime;
        _freq = reminder.frequency;
        _rrule = reminder.rrule;
        _state = reminder.state;
      }
    }
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.reminderId != null ? 'Editar Recordatorio' : 'Crear Recordatorio'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            // Título
            TextField(
              controller: _titleCtrl,
              decoration: const InputDecoration(labelText: 'Título'),
            ),
            const SizedBox(height: 12),
            // Descripción
            TextField(
  controller: _descCtrl,
  keyboardType: TextInputType.multiline,
  textInputAction: TextInputAction.newline,
  maxLines: null,
  minLines: 3, // altura inicial más cómoda
  decoration: InputDecoration(
    labelText: 'Descripción',
    alignLabelWithHint: true,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    hintText: 'Ejemplo: “Recuerda mantener la espalda recta y relajar los hombros.”',
  ),
),
            const SizedBox(height: 12),
            // Fecha/Hora
            ElevatedButton(
              onPressed: () async {
                final now = DateTime.now();
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _dateTime ?? now,
                  firstDate: now.subtract(const Duration(days: 365)),
                  lastDate: now.add(const Duration(days: 3650)),
                );
                if (picked != null) {
                  final time = await showTimePicker(
                      context: context, initialTime: TimeOfDay.now());
                  if (time != null) {
                    setState(() => _dateTime = DateTime(
                        picked.year, picked.month, picked.day, time.hour, time.minute));
                  }
                }
              },
              child: const Text('Seleccionar Fecha/Hora'),
            ),
            const SizedBox(height: 8),
            Text(_dateTime == null ? 'No seleccionado' : _dateTime.toString()),
            const SizedBox(height: 8),
            // Frecuencia
            DropdownButton<Frequency>(
              value: _freq,
              items: Frequency.values
                  .map((f) => DropdownMenuItem(value: f, child: Text(f.label)))
                  .toList(),
              onChanged: (v) {
                if (v != null) setState(() => _freq = v);
              },
            ),
            const SizedBox(height: 8),
            // Estado
            DropdownButton<ReminderState>(
              value: _state,
              items: ReminderState.values
                  .map((s) => DropdownMenuItem(value: s, child: Text(s.label)))
                  .toList(),
              onChanged: (v) {
                if (v != null) setState(() => _state = v);
              },
            ),
            const SizedBox(height: 20),
            // Guardar / Actualizar
            ElevatedButton(
              onPressed: () async {
                final notifier = ref.read(remindersListProvider.notifier);

                late Reminder reminderToNotify;

                if (widget.reminderId != null) {
                  // Actualizar
                  final updatedReminder = Reminder(
                    id: widget.reminderId!,
                    title: _titleCtrl.text,
                    description: _descCtrl.text,
                    dateTime: _dateTime ?? DateTime.now(),
                    frequency: _freq,
                    rrule: _rrule,
                    state: _state,
                  );

                  // Cancelar notificación anterior
                  await NotificationService()
                      .cancelNotification(updatedReminder.id.hashCode);

                  await notifier.updateReminder(updatedReminder);
                  reminderToNotify = updatedReminder;
                } else {
                  // Crear nuevo
                  final id = const Uuid().v4();
                  final newReminder = Reminder(
                    id: id,
                    title: _titleCtrl.text,
                    description: _descCtrl.text,
                    dateTime: _dateTime ?? DateTime.now(),
                    frequency: _freq,
                    rrule: _rrule,
                    state: _state,
                  );
                  await notifier.addReminder(newReminder);
                  reminderToNotify = newReminder;
                }

                // Programar notificación local
                await NotificationService().scheduleReminder(
                  id: reminderToNotify.id.hashCode,
                  title: reminderToNotify.title,
                  body: reminderToNotify.description,
                  scheduledDate: reminderToNotify.dateTime,
                  payload: reminderToNotify.id.toString(),
                );

                if (context.mounted) context.pop();
              },
              child: Text(widget.reminderId != null ? 'Actualizar' : 'Guardar'),
            )
          ],
        ),
      ),
    );
  }
}