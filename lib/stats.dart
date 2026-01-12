import 'package:flutter/material.dart';

class StatsPage extends StatelessWidget {
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Statistics',
        style: TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontFamily: 'Raleway',
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
