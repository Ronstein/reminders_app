import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reminders_app/features/reminders/infrastructure/infrastructure.dart';
import 'package:reminders_app/features/reminders/presentation/providers/providers.dart';

final remoteReminderProvider = Provider<RemoteReminderDatasourceImpl>((ref) {
  final firestore = ref.read(firestoreProvider);
  return RemoteReminderDatasourceImpl(firestore);
});