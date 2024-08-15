// app/view/screens/login_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:doctor_skin/app/view/widgets/custom_text_field.dart';
import 'package:doctor_skin/app/view/widgets/custom_button.dart';
import 'package:doctor_skin/app/view/widgets/text_style.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> login() async {
    var response = await http.post(
      Uri.parse('http://192.168.30.141:3000/users/login'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'email': _emailController.text,
        'password': _passwordController.text,
      }),
    );

    if (response.statusCode == 201) {
      var data = json.decode(response.body);
      await saveUserDetails(data['user']);
      Navigator.pushNamed(context, '/home');
    } else {
      String errorMessage = 'An unknown error occurred';
      try {
        errorMessage = json.decode(response.body)['message'];
      } catch (_) {
        if (response.body.isNotEmpty) {
          errorMessage = response.body;
        }
      }
      showErrorDialog(errorMessage);
    }
  }

  Future<void> saveUserDetails(Map<String, dynamic> userData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', userData['_id']);
    await prefs.setString('username', userData['username']);
    await prefs.setString('email', userData['email']);
    // Store other required fields as needed
  }

  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Login Error'),
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
                  controller: _emailController,
                  label: "Adresse e-mail",
                ),
                const SizedBox(height: 20.0),
                CustomTextFormField(
                  controller: _passwordController,
                  label: "Mot de passe",
                  isPasswordField: true,
                ),
                const SizedBox(height: 20.0),
                CustomButton(
                  gradientColors: [Color(0xFF82b3c9), Color(0xFFb3e5fc)],
                  label: 'Connexion',
                  onPressed: login,
                ),
                const SizedBox(height: 20.0),
                const TextStyleAnimated(
                    label: 'Vous n\'avez pas de compte ? Cliquez ici',
                    nav: '/signin'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
