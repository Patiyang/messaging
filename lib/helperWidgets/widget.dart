import 'package:flutter/material.dart';

Widget appBarMain(BuildContext context) {
  return AppBar(
    automaticallyImplyLeading: false,
    elevation: 0,
    title: Image.asset('images/lg.png', height: 50),
  );
}

class Loading extends StatelessWidget {
  final String text;
  final Color color;
  const Loading({Key key, this.text, this.color}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CircularProgressIndicator(),
        SizedBox(height: 10),
        Text(text, style: TextStyle(color: color ?? Colors.white))
      ],
    ));
  }
}

class CustomText extends StatelessWidget {
  final String text;
  final Color color;

  const CustomText({Key key, @required this.text, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(text, style: TextStyle(color: color ?? Colors.white));
  }
}
