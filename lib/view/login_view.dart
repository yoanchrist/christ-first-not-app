import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_note_app/utilities/show-error-dialog.dart';
import 'dart:developer' as devtools show log;

import '../constants/routes.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Column(
        children: [
          TextField(
            controller: _email,
            decoration: InputDecoration(hintText: 'Email.....'),
            enableSuggestions: true,
          ),
          TextField(
            controller: _password,
            decoration: InputDecoration(hintText: 'Password....'),
            enableSuggestions: false,
            autocorrect: false,
            obscureText: true,
          ),
          TextButton(
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;

              try {
                final usercredential = await FirebaseAuth.instance
                    .signInWithEmailAndPassword(
                        email: email, password: password);
                devtools.log(usercredential.toString());
                if (FirebaseAuth.instance.currentUser?.emailVerified ?? false) {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    notesRoute,
                    (route) => false,
                  );
                } else {
                  Navigator.of(context).pushNamed(
                    verifyEmail,
                  );
                }
              } on FirebaseAuthException catch (e) {
                if (e.code == "user-not-found") {
                  await showErrorDialog(
                    context,
                    "user not found",
                  );
                } else if (e.code == "wrong-password") {
                  await showErrorDialog(
                    context,
                    "wrong password",
                  );
                }
              } catch (e) {
                await showErrorDialog(
                  context,
                  e.toString(),
                );
              }
            },
            child: const Text("Login"),
          ),
          TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(registerRoute, (route) => false);
              },
              child: const Text("you don't have an account yet? SIGNUP here"))
        ],
      ),
    );
  }
}
