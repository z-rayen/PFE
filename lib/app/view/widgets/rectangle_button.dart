// app/view/widgets/rectangle_button.dart
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final double depth;
  final String imagePath; // Path to the image

  const CustomButton({
    Key? key,
    required this.label,
    required this.onPressed,
    this.depth = 8.0,
    required this.imagePath, // Added required imagePath parameter
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 150,
        width: 150,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromRGBO(38, 199, 220, 1),
              Color.fromRGBO(130, 179, 201, 1),
            ], // Apply gradient colors
          ),

          borderRadius: BorderRadius.circular(10.0), // Reduced border radius
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
          padding: EdgeInsets.symmetric(
              horizontal: 20, vertical: 10), // Adjusted padding
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                imagePath,
                width: 70, // Adjust image width as needed
                height: 70, // Adjust image height as needed
              ),
              SizedBox(height: 10), // Added spacing between image and text
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14, // Adjust font size as needed
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
