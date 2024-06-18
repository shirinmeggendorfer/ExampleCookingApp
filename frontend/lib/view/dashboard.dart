import 'package:flutter/material.dart';
import 'package:frontend/features/FilterButton.dart';
import 'package:frontend/features/FoodIcon.dart';
import 'package:frontend/features/ombreBackground.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                onPressed:  () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Dashboard()),),
                icon: Icon(
                  Icons.favorite,
                  size: 40,
                  color: Colors.black,
                ),
              ),
              IconButton(
                onPressed:  () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Dashboard()),),
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
            ),// Logo
            SizedBox(height: 50),
            Padding(
              padding: EdgeInsets.only(left: 25.0,right: 25),
              child: Text(
                "HI <NAME> 😇",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                  color: Colors.white,
                  letterSpacing: 3,
                ),
              ),
            ),//Greeting Text
            SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.only(left: 25.0,right: 25),
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
            SizedBox(height: 50,),
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
                    imagePath: 'assets/images/chicken-leg.png',
                  ),
                  FilterButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Dashboard()),
                    ),
                    imagePath: 'assets/images/dairy-products.png',
                  ),
                  FilterButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Dashboard()),
                    ),
                    imagePath: 'assets/images/wheat.png',
                  ),
                  FilterButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Dashboard()),
                    ),
                    imagePath: 'assets/images/sugar-cube.png',
                  ),
                ],
              ),
            ), //Filter
            SizedBox(height: 20,),
            Expanded(
              child: SingleChildScrollView(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        FoodIcon(title: 'Meal1', onPressed: (){}, imagePath: 'assets/images/exampleImage.png'),
                        FoodIcon(title: 'Meal2', onPressed: (){}, imagePath: 'assets/images/exampleImage.png')
                      ],
                    ),
                    Column(children: [
                      SizedBox(height: 100,),
                      FoodIcon(title: 'Meal1', onPressed: (){}, imagePath: 'assets/images/meal1.png'),
                      FoodIcon(title: 'Meal2', onPressed: (){}, imagePath: 'assets/images/meal1.png')
                    ],)
                  ],
                ),
              ),
            )

          ],
        ),
      ),
    );
  }
}
