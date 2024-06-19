import 'package:flutter/material.dart';
import 'package:frontend/features/ombreBackground.dart';
import 'package:frontend/view/dashboard.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Recipe extends StatefulWidget {
  final int id;

  Recipe({required this.id});

  @override
  _RecipeState createState() => _RecipeState();
}

class _RecipeState extends State<Recipe> {
  Map<String, dynamic>? item;
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    _fetchItem();
  }

  Future<void> _fetchItem() async {
    final response = await http.get(Uri.parse('http://localhost:8000/api/items/${widget.id}/'));
    if (response.statusCode == 200) {
      setState(() {
        item = json.decode(response.body);
      });
      _checkIfFavorite();
    } else {
      throw Exception('Failed to load item');
    }
  }

  Future<void> _checkIfFavorite() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('http://localhost:8000/api/favorites/status/${widget.id}/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Token $token',
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        isFavorite = true;
      });
    } else if (response.statusCode == 404) {
      setState(() {
        isFavorite = false;
      });
    } else {
      print('Failed to check favorite status: ${response.body}');
    }
  }

  Future<void> _toggleFavorite() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (isFavorite) {
      final response = await http.delete(
        Uri.parse('http://localhost:8000/api/favorites/${widget.id}/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Token $token',
        },
      );

      if (response.statusCode == 204) {
        setState(() {
          isFavorite = false;
        });
      } else {
        print('Failed to remove item from favorites: ${response.body}');
      }
    } else {
      final response = await http.post(
        Uri.parse('http://localhost:8000/api/favorites/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Token $token',
        },
        body: jsonEncode({'item': widget.id}),
      );

      if (response.statusCode == 201) {
        setState(() {
          isFavorite = true;
        });
      } else {
        print('Failed to add item to favorites: ${response.body}');
      }
    }
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
      backgroundColor: Colors.white,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromRGBO(127, 109, 246, 100).withOpacity(0.4),
              Color.fromRGBO(70, 182, 198, 100).withOpacity(0.4),
            ],
          ),
        ),
        child: item == null
            ? Center(child: CircularProgressIndicator())
            : Stack(
          children: [
            Positioned(
              top: -350,
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 50),
                item!['image'] != null
                    ? Image.asset(item!['image'])
                    : Container(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    item!['name'],
                    style: TextStyle(
                        fontSize: 30,
                        letterSpacing: 3,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      '⏱️ ${item!['time']} min',
                      style: TextStyle(fontSize: 25),
                    ),
                    Text(
                      '${item!['meat'] ? "🍗" : "🌱"}',
                      style: TextStyle(fontSize: 30),
                    ),
                    Text(
                      '${item!['dairy'] ? "🧀" : ""}',
                      style: TextStyle(fontSize: 30),
                    ),
                    Text(
                      '${item!['gluten'] ? "🌾" : ""}',
                      style: TextStyle(fontSize: 30),
                    ),
                    Text(
                      '${item!['lowsugar'] ? "🤍" : ""}',
                      style: TextStyle(fontSize: 30),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    ' ${item!['ingredients']}',
                    style: TextStyle(fontSize: 20, letterSpacing: 2),
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    ' ${item!['description']}',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                SizedBox(height: 10),
                Center(
                  child: IconButton(
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.red : Colors.grey,
                    ),
                    onPressed: _toggleFavorite,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
