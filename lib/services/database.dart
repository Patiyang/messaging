import 'package:cloud_firestore/cloud_firestore.dart';

class Database {
  Firestore _firestore = Firestore.instance;
  String users = 'users';
  getUserByUserName(String userName) {
    _firestore.collection(users).where('name', isEqualTo: userName).getDocuments();
  }

  createUsers(String userName, String email, String password) {
      
    try {
      return _firestore.collection(users).document().setData({
        'userName': userName,
        'email': email,
        'password': password.hashCode,
      });
    } catch (e) {
      print(e.toString());
    }
  }
}
