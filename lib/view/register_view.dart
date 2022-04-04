import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:my_note_app/utilities/show-error-dialog.dart';
import 'dart:developer' as devtools show log;
import '../constants/routes.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
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
        appBar: AppBar(title: Text("Register")),
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
                      .createUserWithEmailAndPassword(
                          email: email, password: password);
                  Navigator.of(context).pushNamed(verifyEmail);
                  devtools.log(usercredential.toString());
                } on FirebaseAuthException catch (e) {
                  if (e.code == "weak-password") {
                    await showErrorDialog(context, "Weak password");
                  } else if (e.code == 'email-already-in-use') {
                    await showErrorDialog(context, "email is already in use");
                  } else if (e.code == 'invalid-email') {
                    await showErrorDialog(context, "invalid email");
                  }
                } catch (e) {
                  await showErrorDialog(context, e.toString());
                }
                final user = FirebaseAuth.instance.currentUser;
                if (user != null) {
                  user.sendEmailVerification();
                }
              },
              child: Text("Register"),
            ),
            TextButton(
                onPressed: () {
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil(loginRoute, (route) => false);
                },
                child: const Text("you have an account? Login here"))
          ],
        ));
  }
}
