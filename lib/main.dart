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
        cursorColor: Colors.white,
        accentColor: greyColor,
        appBarTheme: AppBarTheme(color: Colors.grey[800]),
        scaffoldBackgroundColor: Colors.white54,
        // primarySwatch: Colors.grey,
      ),
      home: SignIn(),
    );
  }
}



// 139T3IXB