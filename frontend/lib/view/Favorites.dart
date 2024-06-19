import 'package:flutter/material.dart';
import 'package:frontend/features/FilterButton.dart';
import 'package:frontend/features/FoodIcon.dart';
import 'package:frontend/features/ombreBackground.dart';
import 'package:frontend/api_service.dart';
import 'package:frontend/view/Dashboard.dart';
import 'package:frontend/view/recipe.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:frontend/view/register.dart';
import 'package:frontend/view/profile.dart';

class Favorite extends StatefulWidget {
  const Favorite({super.key});

  @override
  State<Favorite> createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {
  final TextEditingController _searchController = TextEditingController();
  final ApiService apiService = ApiService();
  List<dynamic> items = [];
  List<dynamic> filteredItems = [];
  String? username;

  bool meatFilter = false;
  bool dairyFilter = false;
  bool glutenFilter = false;
  bool lowsugarFilter = false;
  int? timeFilter;

  @override
  void initState() {
    super.initState();
    _fetchFavoriteItems();
    _loadUsername();
    _searchController.addListener(_onSearchChanged);
  }

  Future<void> _fetchFavoriteItems() async {
    try {
      final fetchedItems = await apiService.fetchFavoriteItems();
      setState(() {
        items = fetchedItems;
        filteredItems = items;
      });
      print('Fetched items: $fetchedItems');
    } catch (e) {
      print('Failed to load favorite items: $e');
    }
  }

  Future<void> _loadUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username');
    });
  }

  void _onSearchChanged() {
    setState(() {
      filteredItems = items
          .where((item) => (item['name'] ?? '')
              .toLowerCase()
              .contains(_searchController.text.toLowerCase()))
          .toList();
    });
  }

  void _applyFilters() {
    setState(() {
      filteredItems = items.where((item) {
        final matchesSearch = item['name']
            .toLowerCase()
            .contains(_searchController.text.toLowerCase());
        final matchesTime = timeFilter == null ||
            (timeFilter! <= 60
                ? item['time'] <= timeFilter!
                : item['time'] > 60);
        final matchesMeat = !meatFilter || item['meat'] == true;
        final matchesDairy = !dairyFilter || item['dairy'] == true;
        final matchesGluten = !glutenFilter || item['gluten'] == true;
        final matchesLowsugar = !lowsugarFilter || item['lowsugar'] == true;
        return matchesSearch &&
            matchesTime &&
            matchesMeat &&
            matchesDairy &&
            matchesGluten &&
            matchesLowsugar;
      }).toList();
    });
  }

  void _toggleFilter(String filter) {
    setState(() {
      switch (filter) {
        case 'meat':
          meatFilter = !meatFilter;
          break;
        case 'dairy':
          dairyFilter = !dairyFilter;
          break;
        case 'gluten':
          glutenFilter = !glutenFilter;
          break;
        case 'lowsugar':
          lowsugarFilter = !lowsugarFilter;
          break;
      }
      _applyFilters();
    });
  }

  void _filterItemsByTime(int maxTime) {
    setState(() {
      timeFilter = maxTime;
      _applyFilters();
    });
  }

  void _navigateBasedOnLoginStatus(
      Widget loggedInWidget, Widget loggedOutWidget) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => loggedInWidget,
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => loggedOutWidget,
        ),
      );
    }
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> leftColumnItems = [];
    List<Widget> rightColumnItems = [SizedBox(height: 100)];

    for (var item in filteredItems) {
      final imagePath = item['image'] ?? ''; // Check if image path is valid
      if (item['id'] % 2 == 0) {
        leftColumnItems.add(
          FoodIcon(
            title: item['name'] ?? 'Unknown',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Recipe(id: item['id']),
                ),
              );
            },
            imagePath: imagePath.isNotEmpty
                ? imagePath
                : 'assets/images/default_image.png',
          ),
        );
      } else {
        rightColumnItems.add(
          FoodIcon(
            title: item['name'] ?? 'Unknown',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Recipe(id: item['id']),
                ),
              );
            },
            imagePath: imagePath.isNotEmpty
                ? imagePath
                : 'assets/images/default_image.png',
          ),
        );
      }
    }

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
      body: OmbreBackground(
        childWidget: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
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
            ),
            SizedBox(height: 50),
            Padding(
              padding: EdgeInsets.only(left: 25.0, right: 25),
              child: Text(
                username != null ? "HI $username 😇" : "HI 😇",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                  color: Colors.white,
                  letterSpacing: 3,
                ),
              ),
            ),
            SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.only(left: 25.0, right: 25),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search',
                  labelStyle: TextStyle(color: Colors.black),
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
            SizedBox(height: 50),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  FilterButton(
                    onPressed: () async {
                      final result = await showDialog<int>(
                        context: context,
                        builder: (BuildContext context) {
                          return SimpleDialog(
                            title: Text('Select Time Filter'),
                            children: [
                              SimpleDialogOption(
                                onPressed: () {
                                  Navigator.pop(context, 15);
                                },
                                child: Text('<= 15 minutes'),
                              ),
                              SimpleDialogOption(
                                onPressed: () {
                                  Navigator.pop(context, 30);
                                },
                                child: Text('<= 30 minutes'),
                              ),
                            ],
                          );
                        },
                      );
                      if (result != null) {
                        _filterItemsByTime(result);
                      }
                    },
                    imagePath: 'assets/images/clock.png',
                  ),
                  FilterButton(
                    onPressed: () => _toggleFilter('meat'),
                    imagePath: 'assets/images/chicken-leg.png',
                    color: meatFilter ? Colors.blue : Colors.white,
                  ),
                  FilterButton(
                    onPressed: () => _toggleFilter('dairy'),
                    imagePath: 'assets/images/dairy-products.png',
                    color: dairyFilter ? Colors.blue : Colors.white,
                  ),
                  FilterButton(
                    onPressed: () => _toggleFilter('gluten'),
                    imagePath: 'assets/images/wheat.png',
                    color: glutenFilter ? Colors.blue : Colors.white,
                  ),
                  FilterButton(
                    onPressed: () => _toggleFilter('lowsugar'),
                    imagePath: 'assets/images/sugar-cube.png',
                    color: lowsugarFilter ? Colors.blue : Colors.white,
                  ),
                ],
              ),
            ), // Filter
            SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: leftColumnItems,
                    ),
                    Column(
                      children: rightColumnItems,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
