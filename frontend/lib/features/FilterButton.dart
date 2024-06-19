import 'package:flutter/material.dart';

class FilterButton extends StatefulWidget {
  final Function onPressed;
  final String imagePath;
  final Color color;

  const FilterButton({
    Key? key,
    required this.onPressed,
    required this.imagePath,
    this.color = Colors.white, // Default color is white
  }) : super(key: key);

  @override
  State<FilterButton> createState() => _FilterButtonState();
}

class _FilterButtonState extends State<FilterButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: MaterialButton(
        onPressed: widget.onPressed as void Function()?,
        child: Wrap(
          children: [
            Container(
              decoration: BoxDecoration(
                color: widget.color.withOpacity(0.9), // Use the color from widget property
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 9,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image(
                  image: AssetImage(widget.imagePath),
                  height: 30,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
