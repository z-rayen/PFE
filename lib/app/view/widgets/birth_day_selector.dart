// app/view/widgets/birth_day_selector.dart
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import the intl package for date formatting
import 'package:doctor_skin/app/view/widgets/text_style.dart';

class BirthdayInputField extends StatefulWidget {
  final TextEditingController controller;
  const BirthdayInputField({super.key, required this.controller});

  @override
  _BirthdayInputFieldState createState() => _BirthdayInputFieldState();
}

class _BirthdayInputFieldState extends State<BirthdayInputField> {
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        widget.controller.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
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
        decoration: InputDecoration(
          label: const TextStyleAnimated(
              label: 'Date De Naissance', totalRepeatCount: 1),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
            borderSide: BorderSide.none,
          ),
          suffixIcon:
              const Icon(Icons.calendar_today), // Calendar icon for visual hint
        ),
        readOnly: true, // Make it read-only to prevent manual editing
        onTap: () => _selectDate(context), // Open date picker on tap
      ),
    );
  }
}
