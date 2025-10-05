import '../entities/reminder.dart';

abstract class ReminderDatasource {
  Future<List<Reminder>> loadAll();
  Future<void> saveAll(List<Reminder> reminders);
}
