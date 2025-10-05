import 'package:reminders_app/features/reminders/domain/domain.dart';

abstract class RemoteReminderRepository {
  Future<List<Reminder>> loadAll();
  Future<void> add(Reminder reminder);
  Future<void> update(Reminder reminder);
  Future<void> delete(String id);
}