import 'package:flutter/material.dart';

Widget appBarMain(BuildContext context) {
  return AppBar(
    automaticallyImplyLeading: false,
    elevation: 0,
    title: Image.asset('images/lg.png', height: 50),
  );
}

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: CircularProgressIndicator());
  }
}


