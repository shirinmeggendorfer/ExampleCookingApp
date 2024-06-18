import 'package:flutter/material.dart';
import 'package:frontend/features/FilterButton.dart';
import 'package:frontend/features/FoodIcon.dart';
import 'package:frontend/features/ombreBackground.dart';
import 'package:frontend/api_service.dart';
import 'package:frontend/view/recipe.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final TextEditingController _searchController = TextEditingController();
  final ApiService apiService = ApiService();
  List<dynamic> items = [];

  @override
  void initState() {
    super.initState();
    _fetchItems();
  }

  Future<void> _fetchItems() async {
    try {
      final fetchedItems = await apiService.fetchItems();
      setState(() {
        items = fetchedItems.take(20).toList(); // Nimm die letzten 20 Items
      });
    } catch (e) {
      print('Failed to load items: $e');
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> leftColumnItems = [];
    List<Widget> rightColumnItems = [
      SizedBox(height: 100,),
    ];

    for (var item in items) {
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
        height: 100, // Höhe des Containers entsprechend der Bildgröße
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
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Dashboard()),
              ),
              icon: Icon(
                Icons.favorite,
                size: 40,
                color: Colors.black,
              ),
            ),
            IconButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Dashboard()),
              ),
              icon: Icon(
                Icons.explore,
                size: 40,
                color: Colors.black,
              ),
            ),
            IconButton(
              onPressed: () {},
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
                "HI <NAME> 😇",
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
                // onChanged: (query) => _filterItems(query),
              ),
            ), //Searchbar
            SizedBox(height: 50),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  FilterButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Dashboard()),
                    ),
                    imagePath: 'assets/images/clock.png',
                  ),
                  FilterButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Dashboard()),
                      ),
                      imagePath: 'assets/images/chicken-leg.png'),
                  FilterButton(
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Dashboard())),
                      imagePath: 'assets/images/dairy-products.png'),
                  FilterButton(
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Dashboard())),
                      imagePath: 'assets/images/wheat.png'),
                  FilterButton(
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Dashboard())),
                      imagePath: 'assets/images/sugar-cube.png'),
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
