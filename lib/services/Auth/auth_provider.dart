import 'package:my_note_app/services/Auth/Auth_user.dart';

abstract class AuthProvider {
  Future<AuthUser> createUser({
    required final email,
    required final password,
  });
  Future<AuthUser> signIn({
    required final email,
    required final password,
  });
  Future<void> signOut();
  Future<void> sendEmailVerification();
  AuthUser? currentUser;
}
