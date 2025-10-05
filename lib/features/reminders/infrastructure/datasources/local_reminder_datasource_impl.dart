import 'dart:convert';

import 'package:reminders_app/features/reminders/domain/domain.dart';

import '../../../../core/core.dart';

class LocalReminderDatasourceImpl extends ReminderDatasource {
  final LocalStorage storage;
  LocalReminderDatasourceImpl(this.storage);

  @override
  Future<List<Reminder>> loadAll() async {
    final raw = await storage.loadRaw();
    if (raw == null) return [];
    final decoded = (json.decode(raw) as List).cast<Map<String, dynamic>>();
    return decoded.map((m) => Reminder.fromMap(m)).toList();
  }

  @override
  Future<void> saveAll(List<Reminder> reminders) async {
    final raw = json.encode(reminders.map((r) => r.toMap()).toList());
    await storage.saveRaw(raw);
  }
}
