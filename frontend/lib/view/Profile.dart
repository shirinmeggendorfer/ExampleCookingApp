import 'package:flutter/material.dart';
import 'package:frontend/view/dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  String? username;

  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  Future<void> _loadUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username');
      _usernameController.text = username ?? '';
    });
  }

  Future<void> _updateUsername() async {
    if (_usernameController.text.isNotEmpty) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      final response = await http.put(
        Uri.parse('http://localhost:8000/api/auth/update-username/'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Token $token',
        },
        body: jsonEncode({
          'username': _usernameController.text,
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          username = _usernameController.text;
          prefs.setString('username', username!);
        });
        _showDialog('Success', 'Username updated successfully');
      } else {
        _showDialog('Error', 'Failed to update username');
      }
    }
  }

  Future<void> _updatePassword() async {
    if (_passwordController.text.isNotEmpty) {
      // Show confirmation dialog
      _showConfirmationDialog();
    }
  }

  Future<void> _confirmPasswordUpdate(String confirmedPassword) async {
    if (_passwordController.text == confirmedPassword) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      final response = await http.put(
        Uri.parse('http://localhost:8000/api/auth/update-password/'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Token $token',
        },
        body: jsonEncode({
          'password': _passwordController.text,
        }),
      );

      if (response.statusCode == 200) {
        _showDialog('Success', 'Password updated successfully');
      } else {
        _showDialog('Error', 'Failed to update password');
      }
    } else {
      _showDialog('Error', 'Passwords do not match');
    }
  }

  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('username');
    Navigator.pushReplacementNamed(context, '/login');
  }

  void _showDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
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

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Password'),
          content: TextField(
            controller: _confirmPasswordController,
            decoration: InputDecoration(
              hintText: 'Confirm Password',
              labelStyle: TextStyle(color: Colors.black),
              fillColor: Colors.white,
              filled: true,
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(8.0),
              ),
              contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 16), // Add padding
            ),
            obscureText: true,
          ),
          actions: <Widget>[
            TextButton(
              child: Text('CANCEL'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('CONFIRM'),
              onPressed: () {
                _confirmPasswordUpdate(_confirmPasswordController.text);
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
      body: Stack(
        children: [
          Positioned(
            top: -200,
            right: -175,
            child: Container(
              height: 800,
              width: 800, // Set a width to make it visible
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
              children: [
                SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'PROFILE',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                          color: Colors.white,
                          letterSpacing: 3,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Image(
                        image: AssetImage('assets/images/cooking.png'),
                        height: 60,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 10),
                  ],
                ), // Logo
                SizedBox(height: 50),
                Text(
                  'CHANGE YOUR CREDENTIALS HERE',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Colors.white,
                    letterSpacing: 3,
                  ),
                ),
                SizedBox(height: 20,),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                          hintText: 'Username',
                          labelStyle: TextStyle(color: Colors.black),
                          fillColor: Colors.white,
                          filled: true,
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 16), // Add padding
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      flex: 1,
                      child: ElevatedButton(
                        onPressed: _updateUsername,
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          minimumSize: Size(0, 48), // Set the height here
                        ),
                        child: Text('UPDATE'),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          hintText: 'NEW PASSWORD',
                          labelStyle: TextStyle(color: Colors.black),
                          fillColor: Colors.white,
                          filled: true,
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 16), // Add padding
                        ),
                        obscureText: true,
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      flex: 1,
                      child: ElevatedButton(
                        onPressed: _updatePassword,
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          minimumSize: Size(0, 48), // Set the height here
                        ),
                        child: Text('UPDATE'),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _logout,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    minimumSize: Size(double.infinity, 48), // Set the height and width here
                  ),
                  child: Text('LOGOUT'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
