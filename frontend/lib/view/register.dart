import 'package:flutter/material.dart';
import 'package:frontend/features/ombreBackground.dart';
import 'package:frontend/view/Login.dart';
import 'package:frontend/view/dashboard.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      final response = await http.post(
        Uri.parse('http://localhost:8000/api/auth/registration/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'username': _usernameController.text,
          'password1': _passwordController.text,
          'password2': _confirmPasswordController.text,
        }),
      );

      if (response.statusCode == 201) {
        // Registrierung erfolgreich
        Navigator.pop(context);
      } else {
        // Registrierung fehlgeschlagen
        final Map<String, dynamic> responseData = json.decode(response.body);
        String errorMessage = 'An error occurred';
        if (responseData.containsKey('password1')) {
          errorMessage = responseData['password1'][0];
        } else if (responseData.containsKey('username')) {
          errorMessage = responseData['username'][0];
        } else if (responseData.containsKey('non_field_errors')) {
          errorMessage = responseData['non_field_errors'][0];
        }

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Registration Failed'),
              content: Text(errorMessage),
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
    }
  }

  void _navigateToLogin() {
    // Implementiere die Navigation zur Login-Seite hier
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Login()), // Beispiel-Login-Seite
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
      body: Stack(
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
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children:[
              SizedBox(height:70),
              Text("REGISTER NOW",
              style: TextStyle(
                fontSize: 30,
                letterSpacing: 3,
                color: Colors.white
              ),),
SizedBox(height: 50,),
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(
                  hintText: 'USERNAME',
                  labelStyle: TextStyle(color: Colors.black, letterSpacing: 3),
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a username';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10,),
              TextFormField(
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
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10,),
              TextFormField(
                controller: _confirmPasswordController,
                decoration: InputDecoration(
                  hintText: 'CONFIRM PASSWORD',
                  labelStyle: TextStyle(color: Colors.black, letterSpacing: 3),
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm your password';
                  }
                  if (value != _passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: _register,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),),
                  child: Text("LET'S GO"),
                ),
              ),
              TextButton(
                onPressed: _navigateToLogin,
                child: Text('Already have an account? Login'),
              ),
            ],
          ),
        ),
      ),
   ] ),
    );
  }
}


