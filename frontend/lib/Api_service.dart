import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:8000/api';

  Future<List<dynamic>> fetchItems() async {
    final response = await http.get(Uri.parse('$baseUrl/items/'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load items');
    }
  }

  Future<List<dynamic>> fetchFavoriteItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('$baseUrl/favorites/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Token $token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> favoriteItems = json.decode(response.body);
      List<dynamic> itemDetails = [];

      for (var favorite in favoriteItems) {
        int itemId = favorite['item'];
        var itemResponse = await http.get(
          Uri.parse('$baseUrl/items/$itemId/'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Token $token',
          },
        );

        if (itemResponse.statusCode == 200) {
          itemDetails.add(json.decode(itemResponse.body));
        }
      }

      return itemDetails;
    } else {
      throw Exception('Failed to load favorite items');
    }
  }
}
