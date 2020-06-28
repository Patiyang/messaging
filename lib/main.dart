import 'package:flutter/material.dart';

import 'helperWidgets/styling.dart';
import 'views/signIn.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        appBarTheme: AppBarTheme(color: Colors.grey[800]),
        scaffoldBackgroundColor: greyColor,
        primarySwatch: Colors.blue,
      ),
      home: SignIn(),
    );
  }
}



// 139T3IXB