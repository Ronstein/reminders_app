import '../entities/reminder.dart';

abstract class ReminderRepository {
  Future<List<Reminder>> loadAll();
  Future<void> add(Reminder reminder);
  Future<void> update(Reminder reminder);
  Future<void> delete(String id);
}
