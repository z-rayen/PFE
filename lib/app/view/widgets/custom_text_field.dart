// app/view/widgets/custom_text_field.dart
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:doctor_skin/app/view/widgets/text_style.dart';

class CustomTextFormField extends StatefulWidget {
  final String label;
  final bool isPasswordField;
  final TextEditingController? controller; // Add this line

  const CustomTextFormField({
    super.key,
    required this.label,
    this.isPasswordField = false,
    this.controller, // Add this parameter
  });

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPasswordField;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 253, 253, 253).withOpacity(0.5),
        borderRadius: BorderRadius.circular(50.0),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(253, 1, 51, 44).withOpacity(0.50),
            spreadRadius: 0,
            blurRadius: 4,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: TextFormField(
        controller: widget.controller, // Use the passed controller here
        obscureText: _obscureText,
        decoration: InputDecoration(
          label: TextStyleAnimated(label: widget.label, totalRepeatCount: 1),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.transparent,
          suffixIcon: widget.isPasswordField
              ? IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility,
                    color: const Color.fromARGB(255, 3, 22, 82),
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                )
              : null,
        ),
      ),
    );
  }
}
