import 'package:flutter/material.dart';
import 'package:frontend/features/FilterButton.dart';
import 'package:frontend/features/FoodIcon.dart';
import 'package:frontend/features/OmbreBackground.dart';
import 'package:frontend/Api_service.dart';
import 'package:frontend/view/Favorites.dart';
import 'package:frontend/view/Recipe.dart';
import 'package:frontend/view/Register.dart';
import 'package:frontend/view/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
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
    _fetchItems();
    _loadUsername();
    _searchController.addListener(_onSearchChanged);
  }

  Future<void> _fetchItems() async {
    try {
      final fetchedItems = await apiService.fetchItems();
      setState(() {
        items = fetchedItems.take(20).toList();
        filteredItems = items;
      });
    } catch (e) {
      print('Failed to load items: $e');
    }
  }

  Future<void> _loadUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username');
    });
  }

  void _onSearchChanged() {
    _applyFilters();
  }

  void _applyFilters() {
    setState(() {
      filteredItems = items.where((item) {
        final matchesSearch = item['name'].toLowerCase().contains(_searchController.text.toLowerCase());
        final matchesTime = timeFilter == null || (timeFilter! <= 60 ? item['time'] <= timeFilter! : item['time'] > 60);
        final matchesMeat = !meatFilter || item['meat'] == true;
        final matchesDairy = !dairyFilter || item['dairy'] == true;
        final matchesGluten = !glutenFilter || item['gluten'] == true;
        final matchesLowsugar = !lowsugarFilter || item['lowsugar'] == true;
        return matchesSearch && matchesTime && matchesMeat && matchesDairy && matchesGluten && matchesLowsugar;
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

  void _navigateBasedOnLoginStatus(Widget loggedInWidget, Widget loggedOutWidget) async {
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
      if (item['id'] % 2 == 0) {
        leftColumnItems.add(
          FoodIcon(
            title: item['name'],
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Recipe(id: item['id']),
                ),
              );
            },
            imagePath: item['image'],
          ),
        );
      } else {
        rightColumnItems.add(
          FoodIcon(
            title: item['name'],
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Recipe(id: item['id']),
                ),
              );
            },
            imagePath: item['image'],
          ),
        );
      }
    }

    return Scaffold(
      bottomNavigationBar: Container(
        height: 100,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromRGBO(89, 165, 216, 100).withOpacity(0.4),
              Color.fromRGBO(194, 248, 203, 100).withOpacity(0.4),
            ],
          ),
          color: Colors.white.withOpacity(0.8),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 5,
              blurRadius: 10,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.home,
                size: 40,
                color: Colors.black,
              ),
            ),
            IconButton(
              onPressed: () => _navigateBasedOnLoginStatus(Favorite(), Register()),
              icon: Icon(
                Icons.favorite,
                size: 40,
                color: Colors.black,
              ),
            ),

            IconButton(
              onPressed: () => _navigateBasedOnLoginStatus(Profile(), Register()),
              icon: Icon(
                Icons.person,
                size: 40,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
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
            ), // Logo
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
            ), //Greeting Text
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
            ), //Searchbar
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
            ), //Filter
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
