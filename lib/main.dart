import 'package:flutter/material.dart';
import 'package:messaging/helperWidgets/styling.dart';
import 'package:messaging/views/signIn.dart';
import 'package:messaging/views/signUp.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        appBarTheme: AppBarTheme(color: Colors.grey[800]),
        scaffoldBackgroundColor: Colors.blueGrey[700],
        primarySwatch: Colors.blue,
      ),
      home: SignUp(),
    );
  }
}



// 139T3IXB