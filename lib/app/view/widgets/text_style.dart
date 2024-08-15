import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class TextStyleAnimated extends StatelessWidget {
  final String label;
  final String? nav;
  final TextStyle? textStyle; // Custom text style
  final Duration speed; // Custom speed for the animation
  final int? totalRepeatCount; // Optional total repeat count

  const TextStyleAnimated({
    super.key,
    required this.label,
    this.nav,
    this.textStyle,
    this.speed =
        const Duration(milliseconds: 100), // Default speed if not provided
    this.totalRepeatCount, // Total repeat count can be null for infinite repetition
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: AnimatedTextKit(
        onTap: () {
          Navigator.pushNamed(context, nav!);
        },
        repeatForever: totalRepeatCount == null,
        totalRepeatCount: totalRepeatCount ?? 1,
        animatedTexts: [
          TypewriterAnimatedText(
            label,
            speed: speed,
            textStyle: textStyle ??
                const TextStyle(
                  color: Color.fromARGB(255, 8, 8, 8),
                  fontSize: 20.00,
                ), // Use default style if none provided
          ),
        ],
      ),
    );
  }
}
