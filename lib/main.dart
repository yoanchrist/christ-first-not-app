import 'package:flutter/material.dart';
import 'package:my_note_app/view/login_view.dart';
import 'package:my_note_app/view/register_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MaterialApp(
    title: "my note",
    home: LoginView(),
  ));
}
