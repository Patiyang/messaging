import 'package:cloud_firestore/cloud_firestore.dart';

class Database {
  Firestore _firestore = Firestore.instance;
  String users = 'users';
  String chatRoom = 'chatRoom';
  getUserByUserName(String userName) {
    _firestore.collection(users).where('userName', isEqualTo: userName).getDocuments();
  }

  getUserByEmail(String email) {
    return _firestore.collection(users).where('email', isEqualTo: email).getDocuments();
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

  createChatRoom(String chatId, List<String> users) {
    _firestore
        .collection(chatRoom)
        .document(chatId)
        .setData({'users': users, 'chatId': chatId}).catchError((e) => print(e.toString()));
  }
}
