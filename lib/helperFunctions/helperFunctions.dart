import 'package:shared_preferences/shared_preferences.dart';

class HelperFunctions {
  static String isLoggedIn = 'loggedIn';
  static String userName = 'userName';
  static String email = 'email';
//first we save the logged in user credentials to shared preferences
  static Future<void> saveUser(bool userLoggedIn) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setBool(isLoggedIn, userLoggedIn);
  }

  static Future<void> saveUserName(String loggedInUserName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(userName, loggedInUserName);
  }

  static Future<void> saveEmail(String loggedInEmail) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(email, loggedInEmail);
  }

//get the saved values from shared preferences using these functions
  static Future<void> getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(isLoggedIn);
  }

  static Future<void> getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userName);
  }

  static Future<void> getEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(email);
  }
}
