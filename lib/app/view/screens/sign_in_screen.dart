// app/view/screens/sign_in_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:doctor_skin/app/view/widgets/text_style.dart';
import 'package:doctor_skin/app/view/widgets/custom_text_field.dart';
import 'package:doctor_skin/app/view/widgets/custom_button.dart';
import 'package:doctor_skin/app/view/widgets/birth_day_selector.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  String _selectedSex = 'Homme';
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _birthdayController = TextEditingController();
  List<DropdownMenuItem<String>> get genderItems {
    return <String>['Homme', 'Femme', 'Other']
        .map<DropdownMenuItem<String>>((String value) {
      return DropdownMenuItem<String>(
        value: value,
        child: Text(value),
      );
    }).toList();
  }

  Future<void> register() async {
    if (_passwordController.text != _confirmPasswordController.text) {
      _showErrorDialog("Passwords do not match");
      return;
    }

    try {
      var response = await http.post(
        Uri.parse('http://192.168.30.141:3000/users/register'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, String>{
          'sex': _selectedSex,
          'username': _nameController.text,
          'email': _emailController.text,
          'password': _passwordController.text,
          'dateDeNaissance': _birthdayController.text,
        }),
      );

      if (response.statusCode == 201) {
        var data = json.decode(response.body);
        // Save user data to local storage
        saveUserDetails(data['user']);
        Navigator.pushNamed(context, '/home'); // Redirect to home screen
      } else {
        _showErrorDialog(json.decode(response.body)['message'] ??
            "An unknown error occurred");
      }
    } catch (e) {
      _showErrorDialog("Failed to register: $e");
    }
  }

  Future<void> saveUserDetails(Map<String, dynamic> userData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', userData['_id']);
    await prefs.setString('username', userData['username']);
    await prefs.setString('email', userData['email']);
    // Store other required fields as needed
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Registration Error'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: const Text('Close'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bg2.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset("assets/images/logodr.png", height: 100),
                const SizedBox(height: 20.0),
                CustomTextFormField(
                  controller: _nameController,
                  label: "Nom & Prenom",
                ),
                const SizedBox(height: 20.0),
                CustomTextFormField(
                  controller: _emailController,
                  label: "Email ",
                ),
                const SizedBox(height: 20.0),
                CustomTextFormField(
                  controller: _passwordController,
                  label: "Mot De Passe",
                  isPasswordField: true,
                ),
                const SizedBox(height: 20.0),
                CustomTextFormField(
                  controller: _confirmPasswordController,
                  label: "Confirm Mot De Passe",
                  isPasswordField: true,
                ),
                const SizedBox(height: 20.0),
                BirthdayInputField(controller: _birthdayController),
                const SizedBox(height: 20.0),
                Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 253, 253, 253)
                        .withOpacity(0.5),
                    borderRadius: BorderRadius.circular(50.0),
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromARGB(253, 1, 51, 44)
                            .withOpacity(0.50),
                        spreadRadius: 0,
                        blurRadius: 4,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: DropdownButtonFormField<String>(
                    value: _selectedSex,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedSex = newValue!;
                      });
                    },
                    items: genderItems,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                CustomButton(
                  gradientColors: [Color(0xFF82b3c9), Color(0xFFb3e5fc)],
                  label: 'Rgester',
                  onPressed: register,
                ),
                const SizedBox(height: 20.0),
                const TextStyleAnimated(
                    label: 'Tu AS un Compte', nav: '/login'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
