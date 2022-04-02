import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_note_app/firebase_options.dart';

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
    return Column(
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

            final usercredential = await FirebaseAuth.instance
                .createUserWithEmailAndPassword(
                    email: email, password: password);
            print(usercredential);
          },
          child: Text("Register"),
        ),
        TextButton(
            onPressed: () {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil('/Login/', (route) => false);
            },
            child: const Text("you have an account? Login here"))
      ],
    );
  }
}
