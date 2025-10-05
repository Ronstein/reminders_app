import 'package:go_router/go_router.dart';
import 'package:reminders_app/features/auth/presentation/screens/screens.dart';
import 'package:reminders_app/features/reminders/presentation/screens/screens.dart';


final appRouter = GoRouter(
  initialLocation: '/login', // Inicializamos en login
  routes: [
    // Rutas de autenticación
    GoRoute(
      path: '/login',
      name: 'Login',
      builder: (context, state) => const LoginScreen(),
    ),
    // Rutas de recordatorios
    GoRoute(
      path: '/',
      name: RemindersScreen.name,
      builder: (context, state) => const RemindersScreen(),
      routes: [
        GoRoute(
          path: 'new',
          name: 'Crear Recordatorio',
          builder: (context, state) => const ReminderFormScreen(),
        ),
        GoRoute(
          path: 'edit/:id',
          name: 'Editar Recordatorio',
          builder: (context, state) {
            final id = state.pathParameters['id']!;
            return ReminderFormScreen(reminderId: id);
          },
        ),
      ],
    ),
  ],
);