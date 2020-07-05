import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:messaging/helperWidgets/styling.dart';
import 'package:messaging/services/database.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatScreen extends StatefulWidget {
  final String recipent;
  final String chatId;
  final String sender;
  const ChatScreen({Key key, this.recipent, this.chatId, this.sender}) : super(key: key);
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageController = new TextEditingController();
  Database _database = new Database();
  String sender;
  String date;
  Stream getChats;
  @override
  void initState() {
    super.initState();
    getUserName();
    getChats=_database.getConversations(widget.chatId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(widget.recipent),
      ),
      body: Column(
        children: <Widget>[
          StreamBuilder(
            stream:getChats,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              return snapshot.hasData
                  ? Expanded(
                      child: ListView.builder(
                        reverse: true,
                        physics: BouncingScrollPhysics(),
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (BuildContext context, int index) {
                          DocumentSnapshot snap = snapshot.data.documents[index];
                          String message = snap['message'];
                          print(sender);
                          return MessageTiles(message, snap['sender'] == sender);
                        },
                      ),
                    )
                  : Container();
            },
          ),
          // Spacer(),
          Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  height: 45,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    color: Colors.grey[700],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16.0, bottom: 3),
                    child: TextField(
                      maxLines: 4,
                      style: TextStyle(color: Colors.white),
                      controller: messageController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Message',
                        hintStyle: TextStyle(color: Colors.white70),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 2,
              ),
              MaterialButton(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                height: 45,
                color: redColor,
                onPressed: () async {
                  await sendMessage();
                  messageController.clear();
                },
                child: Text(
                  'Send',
                  style: TextStyle(color: Colors.white, fontSize: 19),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    sender = prefs.getString('userName');
  }

  sendMessage() async {
    date = DateTime.now().millisecondsSinceEpoch.toString();
    _database.addConversations(sender, widget.chatId, messageController.text, date);
  }
}

class MessageTiles extends StatelessWidget {
  final String message;
  final bool isMe;
  const MessageTiles(this.message, this.isMe);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: isMe
            ? EdgeInsets.only(right: 8, left: 50, top: 9, bottom: 2)
            : EdgeInsets.only(left: 8, right: 50, top: 9, bottom: 2),
        padding: EdgeInsets.symmetric(horizontal: 7, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: isMe ? Colors.red[600] : Colors.grey[350],
        ),
        child: Text(message, style: TextStyle(color: isMe ? Colors.white : Colors.black)),
      ),
    );
  }
}
