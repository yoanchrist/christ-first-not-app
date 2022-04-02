import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_note_app/firebase_options.dart';
import 'package:my_note_app/view/Verification_view.dart';
import 'package:my_note_app/view/login_view.dart';
import 'package:my_note_app/view/register_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    routes: {
      "/Register/": (context) => const RegisterView(),
      "/Login/": (context) => const LoginView()
    },
    title: "my note",
    home: FutureBuilder(
        future: Firebase.initializeApp(
            options: DefaultFirebaseOptions.currentPlatform),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              final user = FirebaseAuth.instance.currentUser;
              if (user != null) {
                // return Text(user.emailVerified.toString());
                if (user.emailVerified) {
                  return const Text("Signed In");
                } else {
                  return const VerifyEmailView();
                }
              } else {
                return const LoginView();
              }

            default:
              return const Scaffold(
                body: CircularProgressIndicator(),
              );
          }
        }),
  ));
}
