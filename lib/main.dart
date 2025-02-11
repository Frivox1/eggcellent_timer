import 'package:flutter/material.dart';
import 'screens/cooking_styles_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Eggcellent Timer',
      home: CookingStylesScreen(),
    );
  }
}
