import 'package:flutter/material.dart';
import 'package:tennis_booking/home.dart';

const Color backgroundColor = Color(0xFF0A0C0B);
const Color primaryColor = Color(0xFF16161A);
const Color secondaryColor = Color(0xFFC9C7C7);
const Color accentColor = Color(0xFFD3FF59);
const Color textColor = Color(0xFFFFFFFF);

void main() {
  runApp(const MyApp());
}

// Root Widget
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tennis Booking',
      theme: ThemeData(fontFamily: 'Raleway'),
      home: const MyHomePage(title: 'Home'),
    );
  }
}
