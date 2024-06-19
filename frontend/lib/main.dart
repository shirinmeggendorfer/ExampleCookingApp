import 'package:flutter/material.dart';
import 'package:frontend/view/Dashboard.dart';
import 'package:frontend/view/login.dart';
import 'package:frontend/view/Register.dart';
import 'package:frontend/view/profile.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cooking App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Dashboard(), // Set the initial screen
      routes: {
        '/login': (context) => Login(),
        '/register': (context) => Register(),
        '/dashboard': (context) => Dashboard(),
        '/profile': (context) => Profile(),
      },
    );
  }
}
