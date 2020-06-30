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
        primaryColor: Colors.white,
        cursorColor: Colors.white,
        accentColor: Colors.white,
        appBarTheme: AppBarTheme(textTheme: TextTheme(headline6: TextStyle(color: Colors.white) ),
          iconTheme: IconThemeData(color: Colors.white),
          color: greyColor,
        ),
        scaffoldBackgroundColor: Colors.grey[850],
      ),
      home: SignIn(),
    );
  }
}

// 139T3IXB
