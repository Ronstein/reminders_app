import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:reminders_app/features/auth/domain/domain.dart';

class AuthDataSourceImpl extends AuthDatasource {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Stream<User?> authStateChanges() {
    return _auth.authStateChanges().map((u) =>
        u == null ? null : User(uid: u.uid, email: u.email ?? ''));
  }

  @override
  Future<User?> register(String email, String password) async {
    final userCred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = userCred.user;
    return user != null ? User(uid: user.uid, email: user.email ?? '') : null;
  }

  @override
 Future<User?> signIn(String email, String password) async {
    final userCred = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = userCred.user;
    return user != null ? User(uid: user.uid, email: user.email ?? '') : null;
  }

  @override
  Future<void> signOut() async => await _auth.signOut();

}