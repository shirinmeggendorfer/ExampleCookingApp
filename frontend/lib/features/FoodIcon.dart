import 'package:flutter/material.dart';

class FoodIcon extends StatefulWidget {
  final Function onPressed;
  final String title;
  final String imagePath;
  const FoodIcon({
    Key? key,
    required this.title,
    required this.onPressed,
    required this.imagePath,
  }) : super(key: key);

  @override
  State<FoodIcon> createState() => _FoodIconState();
}

class _FoodIconState extends State<FoodIcon> {
  @override
  Widget build(BuildContext context) {
    return  Stack(
        children: [

          Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
            child:
            MaterialButton(
              onPressed: widget.onPressed as void Function()?,
              child:Column(
                children: [
                  Container(
                    color: Colors.transparent,
                    height: 80,
                    width: 150,)
                  , Container(
                    height: 150, // Höhe des Containers entsprechend der Bildgröße
                    width: 150,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color.fromRGBO(89, 165, 216, 100).withOpacity(0.4),
                          Color.fromRGBO(194, 248, 203, 100).withOpacity(0.4),
                        ],
                      ),
                      color: Colors.white.withOpacity(0.4),
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
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          SizedBox(height: 50,),
                          Text(
                            widget.title,
                            style: TextStyle(
                              letterSpacing: 4,
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                ],
              ),

            ),
          ),
          Positioned(
            top: 0, // Positionierung des Bildes über dem Container
            left: 0,
            right: 0,
            child: Container(
              child: Image(
                image: AssetImage(widget.imagePath),
                height: 150,
              ),
            ),
          ),
        ]
    );
  }
}
