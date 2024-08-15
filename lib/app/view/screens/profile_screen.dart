// app/view/screens/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'package:doctor_skin/app/view/widgets/NavBar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _currentIndex = 4;
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController =
      TextEditingController(); // For new password

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    String? userId = await getUserId();
    if (userId == null) {
      print("User ID is not available.");
      return;
    }
    var response = await http
        .get(Uri.parse('http://192.168.30.141:3000/users/user/$userId'));
    if (response.statusCode == 201) {
      var userData = json.decode(response.body);
      setState(() {
        usernameController.text = userData['username'];
        emailController.text = userData['email'];
      });
    } else {
      print('Failed to load user data: ${response.body}');
    }
  }

  Future<void> updateUserDetails() async {
    String? userId = await getUserId();
    if (userId == null) {
      print("User ID is not available.");
      return;
    }
    var response = await http.put(
      Uri.parse('http://192.168.30.141:3000/users/user/$userId'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'username': usernameController.text,
        'email': emailController.text,
        'password': passwordController.text, // Sending new password for update
      }),
    );

    if (response.statusCode == 201) {
      print('User updated successfully.');
    } else {
      print('Failed to update user: ${response.body}');
    }
  }

  Future<String?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId');
  }

  void _onItemTapped(int newIndex) {
    setState(() {
      _currentIndex = newIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/bg2.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('assets/images/profile.png'),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: usernameController,
                decoration: InputDecoration(
                  icon: Icon(Icons.person),
                  labelText: 'Nom d’utilisateur',
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  icon: Icon(Icons.email),
                  labelText: 'E-mail',
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  icon: Icon(Icons.lock),
                  labelText: 'Nouveau mot de passe',
                ),
                obscureText: true,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: updateUserDetails,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.blue,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                ),
                child: const Text('Enregistrer'),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 100,
              child: CustomBottomNavBar(
                currentIndex: _currentIndex,
                onChange: _onItemTapped,
                imagePaths: [
                  'assets/images/home_icon.png',
                  'assets/images/history_icon.png',
                  'assets/images/camera_icon.png',
                  'assets/images/help_icon.png',
                  'assets/images/profile_icon.png'
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
