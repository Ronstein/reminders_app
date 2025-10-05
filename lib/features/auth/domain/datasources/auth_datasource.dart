import '../domain.dart';

abstract class AuthDatasource {
  Future<User?> signIn(String email, String password);
  Future<User?> register(String email, String password);
  Future<void> signOut();
  Stream<User?> authStateChanges();
}