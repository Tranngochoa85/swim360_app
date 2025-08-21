import 'package:flutter/material.dart';
import 'package:swim360_app/screens/login_screen.dart'; // Import màn hình mới

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Swim360',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // Đặt LoginScreen làm màn hình chính
      home: const LoginScreen(),
    );
  }
}