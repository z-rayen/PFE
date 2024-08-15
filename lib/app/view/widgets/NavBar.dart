// app/view/widgets/NavBar.dart
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onChange;
  final List<String> imagePaths;
  final Color backgroundColor;
  final Color activeColor;
  final Color inactiveColor;
  final double iconSize;

  // Static list of routes corresponding to the index of the icons
  static const List<String> routeNames = [
    '/', // Home Screen
    '/history', // Upload Screen

    '/upload', // Analysis Screen
    '/help', // Results Screen
    // Settings Screen
    '/profile', // Profile Screen
    // Add more routes as needed
  ];

  const CustomBottomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onChange,
    required this.imagePaths,
    this.backgroundColor = Colors.white,
    this.activeColor = Colors.blueAccent,
    this.inactiveColor = Colors.grey,
    this.iconSize = 50.0,
  })  : assert(imagePaths.length == routeNames.length,
            'Image paths and route names must match in length.'),
        super(key: key);

  @override
  _CustomBottomNavBarState createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: widget.imagePaths.map((path) {
          int index = widget.imagePaths.indexOf(path);
          bool isActive = index == widget.currentIndex;

          return GestureDetector(
            onTap: () {
              widget.onChange(index);
              Navigator.pushNamed(
                  context, CustomBottomNavBar.routeNames[index]);
            },
            child: AnimatedContainer(
              duration: Duration(milliseconds: 300),
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isActive
                    ? widget.activeColor
                    : widget.inactiveColor.withOpacity(0.6),
                boxShadow: [
                  if (isActive)
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      spreadRadius: 2,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                ],
                gradient: LinearGradient(
                  colors: [widget.activeColor, widget.backgroundColor],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Image.asset(
                path,
                width: widget.iconSize,
                height: widget.iconSize,
                color: isActive ? Colors.white : null,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
