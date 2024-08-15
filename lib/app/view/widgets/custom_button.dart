// app/view/widgets/custom_button.dart
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final double depth;
  final IconData? iconData; // Optional icon data
  final List<Color> gradientColors; // Colors for the gradient

  const CustomButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.depth = 8.0,
    this.iconData,
    required this.gradientColors, // Require gradient colors to be specified
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> rowChildren = [
      if (iconData != null) // Include an icon if it's provided
        Icon(iconData, color: Colors.white),
      if (iconData != null) // Add spacing only if icon is present
        SizedBox(width: 10),
      Text(
        label,
        style: TextStyle(color: Colors.white),
      ),
    ];

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: gradientColors, // Apply gradient colors
          ),
          borderRadius: BorderRadius.circular(50.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              offset: Offset(0, depth),
              blurRadius: depth,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          child: Row(
            mainAxisSize:
                MainAxisSize.min, // Ensure the row only takes needed space
            children: rowChildren,
          ),
        ),
      ),
    );
  }
}
