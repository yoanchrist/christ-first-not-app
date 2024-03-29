import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_note_app/constants/routes.dart';
import 'package:my_note_app/firebase_options.dart';
import 'package:my_note_app/view/Verification_view.dart';
import 'package:my_note_app/view/login_view.dart';
import 'package:my_note_app/view/register_view.dart';
import 'dart:developer' as devtools show log;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    routes: {
      registerRoute: (context) => const RegisterView(),
      loginRoute: (context) => const LoginView(),
      notesRoute: (context) => const MyNoteView(),
      verifyEmail: (context) => const VerifyEmailView(),
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
                //return Scaffold(body: Text(user.toString()));
                if (user.emailVerified) {
                  return MyNoteView();
                } else {
                  return const VerifyEmailView();
                }
              } else {
                return const LoginView();
              }

            //return const LoginView();
            default:
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
          }
        }),
  ));
}

enum MenuOption { logout }

class MyNoteView extends StatefulWidget {
  const MyNoteView({Key? key}) : super(key: key);

  @override
  State<MyNoteView> createState() => _MyNoteViewState();
}

class _MyNoteViewState extends State<MyNoteView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Note"),
        actions: [
          PopupMenuButton<MenuOption>(
              onSelected: (value) async {
                switch (value) {
                  case MenuOption.logout:
                    final shouldLogOut = await showLogoutDialog(context);
                    if (shouldLogOut) {
                      await FirebaseAuth.instance.signOut();
                      Navigator.of(context)
                          .pushNamedAndRemoveUntil(loginRoute, (_) => false);
                    }
                    break;
                }
              },
              itemBuilder: (context) => [
                    const PopupMenuItem<MenuOption>(
                      child: Text("logout"),
                      value: MenuOption.logout,
                    )
                  ])
        ],
      ),
      body: Center(
        child: Text((FirebaseAuth.instance.currentUser?.email).toString()),
      ),
    );
  }
}

Future<bool> showLogoutDialog(BuildContext context) {
  return showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: const Text("LOGOUT"),
            content: const Text('do you realy want to log out?'),
            actions: [
              TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text("cancel")),
              TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text("logout"))
            ],
          )).then((value) => value ?? false);
}
