
import 'package:reminders_app/features/auth/domain/domain.dart';

import '../infrastructure.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthDatasource dataSource;

  AuthRepositoryImpl({AuthDatasource? dataSource})
      : dataSource = dataSource ?? AuthDataSourceImpl();

  @override
  Future<User?> signIn(String email, String password) {
    return dataSource.signIn(email, password);
  }

  @override
  Future<User?> register( String email, String password) {
    return dataSource.register( email, password);
  }

  @override
  Future<void> signOut() {
    return dataSource.signOut();
  }

  @override
  Stream<User?> authStateChanges() {
    return dataSource.authStateChanges();
  }
}