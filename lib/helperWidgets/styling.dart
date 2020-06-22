import 'package:flutter/material.dart';

Color greyColor = new Color(0xff212121);
Color redColor = new Color(0xffef5350);
Color lightBlue = new Color(0xF88787A0);

TextStyle hint = new TextStyle(
  color: Colors.white54,
);

InputDecoration textFields(String hintText) {
  return InputDecoration(
      hintText: hintText,
      hintStyle: hint,
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
      ),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
      ));
}

TextStyle formTextStyle() {
  return TextStyle(color: Colors.white);
}

MaterialButton button(String text, Color color, BuildContext context,VoidCallback callback) {
  return MaterialButton(
    minWidth: MediaQuery.of(context).size.width *.6,
    color: color,
    child: Text(text),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    onPressed: callback,
  );
}
