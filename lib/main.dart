import 'package:flutter/material.dart';
import 'package:reminders_app/core/core.dart';
import 'package:reminders_app/features/reminders/domain/domain.dart';
import 'package:reminders_app/features/reminders/presentation/providers/providers.dart';
import 'config/config.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  

  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('America/Santiago')); // tu zona local

  await NotificationService().init();

  await FirebaseService.init(); // placeholder safe init
  
  runApp(const ProviderScope(child: MyApp()));
}

final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();



class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context,WidgetRef ref) {

   // Inyectar ref en NotificationService
    NotificationService().setRef(ref);

    DateTime getNextDate(DateTime current, Frequency freq) {
    switch (freq) {
      case Frequency.daily:
        return current.add(const Duration(days: 1));
      case Frequency.weekly:
        return current.add(const Duration(days: 7));
      case Frequency.once:
      default:
        return current;
    }
  }

  ref.listen<String?>(notificationTapProvider, (prev, payload) async {
  if (payload != null) {
    debugPrint('📩 Tap recibido: $payload');

    final notifier = ref.read(remindersListProvider.notifier);
    final reminder = notifier.getById(payload);

    if (reminder != null) {
      // ✅ Si es único y ya está completado, no hacer nada
      if (reminder.frequency == Frequency.once &&
          reminder.state == ReminderState.completed) {
          ref.read(notificationTapProvider.notifier).clear();
          return;
      }

      // Calcular nextDate solo si es recurrente
      final nextDate = reminder.frequency != Frequency.once
          ? getNextDate(reminder.dateTime, reminder.frequency)
          : reminder.dateTime;

      // Actualizar estado y fecha
      final updated = reminder.copyWith(
        state: reminder.frequency == Frequency.once
            ? ReminderState.completed
            : ReminderState.pending,
        dateTime: nextDate,
      );

      await notifier.updateReminder(updated);

      // Reprogramar solo si es recurrente
      if (reminder.frequency != Frequency.once) {
        await NotificationService().scheduleReminder(
          id: updated.id.hashCode,
          title: updated.title,
          body: updated.description,
          scheduledDate: updated.dateTime,
          payload: updated.id,
        );
      }

      // Mostrar notificación solo si NO es único completado
      rootScaffoldMessengerKey.currentState?.showSnackBar(
        SnackBar(
          content: Text(
            reminder.frequency == Frequency.once
                ? '✅ Recordatorio completado: ${reminder.title}'
                : '🔁 Próximo recordatorio reprogramado: ${reminder.title}',
          ),
        ),
      );
    }

    ref.read(notificationTapProvider.notifier).clear();
  }
});


    return MaterialApp.router(
      scaffoldMessengerKey: rootScaffoldMessengerKey,
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
      title: 'Recordatorios de Postura',
      theme: AppTheme.light(),
    );
    // return MaterialApp(
    //   title: 'Recordatorios',
    //   home: HomePage(),
    //   debugShowCheckedModeBanner: false,
    // );
  }
}

