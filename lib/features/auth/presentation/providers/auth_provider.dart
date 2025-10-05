// Provider del repositorio
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reminders_app/features/auth/domain/domain.dart';
import 'package:reminders_app/features/auth/infrastructure/infrastructure.dart';

final authRepositoryProvider = Provider<AuthRepositoryImpl>((ref) {
  final datasource = AuthDataSourceImpl();
  return AuthRepositoryImpl(dataSource: datasource);
});

// Estado de sesión
final authStateProvider = StreamProvider<User?>((ref) {
  final repo = ref.read(authRepositoryProvider);
  return repo.authStateChanges();
});

// Notifier para acciones como cerrar sesión
final authNotifierProvider = Provider<AuthNotifier>((ref) {
  final repo = ref.read(authRepositoryProvider);
  return AuthNotifier(repo);
});

class AuthNotifier {
  final AuthRepositoryImpl _repo;

  AuthNotifier(this._repo);

  Future<void> signOut() async {
    await _repo.signOut();
  }
}