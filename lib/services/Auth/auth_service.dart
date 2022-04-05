import 'package:my_note_app/services/Auth/Auth_provider.dart';
import 'package:my_note_app/services/Auth/Auth_user.dart';

class Authservice extends AuthProvider {
  AuthProvider provider;
  Authservice(this.provider);
  @override
  Future<AuthUser> createUser({required email, required password}) =>
      provider.createUser(email: email, password: password);

  @override
  Future<void> sendEmailVerification() => provider.sendEmailVerification();

  @override
  Future<AuthUser> signIn({required email, required password}) =>
      provider.signIn(email: email, password: password);

  @override
  Future<void> signOut() => provider.signOut();
}
