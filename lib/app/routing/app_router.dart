// app/routing/app_router.dart
import 'package:flutter/material.dart';

import 'package:doctor_skin/app/view/screens/home_screen.dart';
import 'package:doctor_skin/app/view/screens/image_upload_screen.dart';
import 'package:doctor_skin/app/view/screens/analysis_screen.dart';
import 'package:doctor_skin/app/view/screens/results_screen.dart';
import 'package:doctor_skin/app/view/screens/history_screen.dart';
//import 'package:doctor_skin/app/view/screens/settings_screen.dart';
import 'package:doctor_skin/app/view/screens/profile_screen.dart';
import 'package:doctor_skin/app/view/screens/login_screen.dart';
import 'package:doctor_skin/app/view/screens/sign_in_screen.dart';
import 'package:doctor_skin/app/view/screens/help_screen.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case '/upload':
        return MaterialPageRoute(builder: (_) => const UploadScreen());
      case '/history':
        return MaterialPageRoute(builder: (_) => const HistoryScreen());
      case '/analyze':
        return MaterialPageRoute(builder: (_) => const AnalysisScreen());
      //case '/results':
      //return MaterialPageRoute(builder: (_) => const ResultsScreen());
      case '/help':
        return MaterialPageRoute(builder: (_) => const HelpScreen());
      //case '/settings':
      //return MaterialPageRoute(builder: (_) => const SettingsScreen());
      case '/profile':
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      case '/login':
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case '/signin':
        return MaterialPageRoute(builder: (_) => const SignInScreen());
      default:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
    }
  }
}
