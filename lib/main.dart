import 'package:flutter/material.dart';
import 'package:nrs2023/screens/homeScreen.dart';
import 'package:nrs2023/screens/register.dart';
import 'package:nrs2023/screens/confirm_number.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}
