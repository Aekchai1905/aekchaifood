import 'package:aekfooddelivery/Screen/home.dart';
import 'package:aekfooddelivery/utility/my_style.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.green),
      title: MyStyle().applicationName,
      home: Home(),
    );
  }
}
