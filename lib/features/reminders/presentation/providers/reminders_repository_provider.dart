import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reminders_app/core/storage/local_storage.dart';
import '../../reminders.dart';

final localStorageProvider = Provider((ref) => LocalStorage());

final remindersRepositoryProvider = Provider((ref) {
  final storage = ref.read(localStorageProvider);
  
  final local = LocalReminderDatasourceImpl(storage);
  final firestore = ref.read(firestoreProvider);
  final remote = RemoteReminderDatasourceImpl(firestore);
  return ReminderRepositoryImpl(local,remote);
});
