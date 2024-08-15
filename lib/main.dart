// main.dart
import 'package:flutter/material.dart';

import '/app/routing/app_router.dart';

void main() {
  runApp(const DoctorSkinApp());
}

class DoctorSkinApp extends StatelessWidget {
  const DoctorSkinApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Doctor Skin',
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      onGenerateRoute: AppRouter.generateRoute,
      initialRoute: '/login',
    );
  }
}
