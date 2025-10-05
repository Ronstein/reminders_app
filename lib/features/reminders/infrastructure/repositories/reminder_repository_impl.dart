import 'package:reminders_app/features/reminders/domain/domain.dart';
import 'package:reminders_app/features/reminders/infrastructure/infrastructure.dart';

class ReminderRepositoryImpl implements ReminderRepository {
  final LocalReminderDatasourceImpl local;
  final RemoteReminderDatasourceImpl remote;

  ReminderRepositoryImpl(this.local, this.remote);

  @override
  Future<List<Reminder>> loadAll() async {
    // 1️⃣ Cargar primero local (rápido)
    final localReminders = await local.loadAll();

    try {
      // 2️⃣ Intentar obtener remoto
      final remoteReminders = await remote.loadAll();

      // 3️⃣ Sincronizar local con Firestore
      await local.saveAll(remoteReminders);

      return remoteReminders;
    } catch (e) {
      // Si no hay conexión, devolver locales
      return localReminders;
    }
  }

  @override
  Future<void> add(Reminder reminder) async {
    final current = await local.loadAll();
    await local.saveAll([...current, reminder]);

    // Intentar sincronizar en background
    try {
      await remote.add(reminder);
    } catch (e) {
      // Podrías marcar este reminder como "pendiente de sync"
    }
  }

  @override
  Future<void> update(Reminder reminder) async {
    final current = await local.loadAll();
    final updated = current.map((r) => r.id == reminder.id ? reminder : r).toList();
    await local.saveAll(updated);

    try {
      await remote.update(reminder);
    } catch (_) {}
  }

  @override
  Future<void> delete(String id) async {
    final current = await local.loadAll();
    final updated = current.where((r) => r.id != id).toList();
    await local.saveAll(updated);

    try {
      await remote.delete(id);
    } catch (_) {}
  }
}
