import 'package:flutter/material.dart';
import 'package:frontend/view/Dashboard.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _login() async {
    final response = await http.post(
      Uri.parse('http://localhost:8000/api/auth/login/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': _usernameController.text,
        'password': _passwordController.text,
      }),
    );

    if (response.statusCode == 200) {
      // Login erfolgreich
      final Map<String, dynamic> responseData = json.decode(response.body);
      if (responseData.containsKey('key')) { // Überprüfen Sie, ob der Token vorhanden ist
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('username', _usernameController.text);
        await prefs.setString('token', responseData['key']); // Der Schlüssel kann je nach Ihrer Backend-Konfiguration variieren
        Navigator.pushReplacementNamed(context, '/dashboard');
      } else {
        // Token fehlt
        _showErrorDialog('Token is missing in the response');
      }
    } else {
      // Login fehlgeschlagen
      _showErrorDialog('Invalid username or password');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Login Failed'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Dashboard(),
            ),
          );
        },
        child: Icon(Icons.arrow_back_ios_new_outlined),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      body:
      Stack(
        children: [
        Positioned(
        top: -200,
        right: -175,
        child: Container(
          height: 800,
          width: 800  , // Set a width to make it visible
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(500),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromRGBO(127, 109, 246, 100),
                Color.fromRGBO(70, 182, 198, 100),
              ],
            ),
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height:70),
            Text("LOGIN",
              style: TextStyle(
                  fontSize: 30,
                  letterSpacing: 3,
                  color: Colors.white
              ),),
            SizedBox(height: 50,),
            TextField(
              controller: _usernameController,
              decoration:InputDecoration(
                hintText: 'USERNAME',
                labelStyle: TextStyle(color: Colors.black, letterSpacing: 3),
                fillColor: Colors.white,
                filled: true,
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            SizedBox(height: 10,),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                hintText: 'PASSWORD',
                labelStyle: TextStyle(color: Colors.black, letterSpacing: 3),
                fillColor: Colors.white,
                filled: true,
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),),
              child: Text("LET'S GO"),
            ),
          ],
        ),
      ),
    ]),);
  }
}
