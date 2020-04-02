import 'package:flutter/material.dart';
import 'package:helper/pages/main_page.dart';

void main() => runApp(HomePage());

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
      ),
      title: "Helper",
      home: MainPage(),
    );
  }
}
