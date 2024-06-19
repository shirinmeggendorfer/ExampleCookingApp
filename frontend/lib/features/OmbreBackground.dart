import 'package:flutter/material.dart';

class OmbreBackground extends StatefulWidget {
  final Widget childWidget;
  final double? height;
  final double? width;

  const OmbreBackground({ required this.childWidget,
    this.height =double.infinity,
    this.width= double.infinity});

  @override
  State<OmbreBackground> createState() => _OmbreBackgroundState();
}

class _OmbreBackgroundState extends State<OmbreBackground> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      width: widget.width ,
      // constraints: BoxConstraints(
      // maxHeight: double.infinity,
      //),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.fromRGBO(127, 109, 246, 100),
            Color.fromRGBO(70, 182, 198, 100),
          ],
        ),
      ),
      child: widget.childWidget,
    );
  }
}
