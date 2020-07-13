import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:messaging/helperWidgets/styling.dart';
import 'package:messaging/services/auth.dart';
import 'package:messaging/services/database.dart';
import 'package:messaging/views/conversations.dart';
import 'package:messaging/views/search.dart';
import 'package:messaging/views/signIn.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class ChatRooms extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatRooms> {
  AuthMethods _authMethods = AuthMethods();
  String email = '';
  String userName;
  String recipient;
  Stream chatLists;
  Database database = new Database();

  //speech recognition variables
  bool _hasSpeech = false;
  double level = 0.0;
  double minSoundLevel = 50000;
  double maxSoundLevel = -50000;
  String lastWords = "";
  String lastError = "";
  String lastStatus = "";
  String _currentLocaleId = "";
  List<LocaleName> _localeNames = [];
  final SpeechToText speech = SpeechToText();

  @override
  void initState() {
    super.initState();
    getUserName();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          leading: Image.asset('images/lg.png', height: 50),
          automaticallyImplyLeading: false,
          centerTitle: true,
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.search),
                onPressed: () async {
                  showSearch(
                    context: context,
                    delegate: SearchUser(),
                  );
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  userName = prefs.getString('userName');
                  print(userName);
                }),
            IconButton(
                icon: Icon(Icons.settings_voice),
                onPressed: () {
                  initSpeechState().then((value) => _showDialog);
                }),
            IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setString('email', '');
                _authMethods
                    .signOut()
                    .then((_) => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => SignIn())));
              },
            )
          ],
        ),
        body: Container(
          child: StreamBuilder(
            stream: chatLists,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              return snapshot.hasData
                  ? ListView.builder(
                      itemCount: snapshot.data.documents.length,
                      itemBuilder: (BuildContext context, int index) {
                        DocumentSnapshot snap = snapshot.data.documents[index];
                        recipient = snap['chatId'].replaceAll(userName, '');
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 3.0),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 2.0, bottom: 1),
                            child: Material(
                              color: Colors.grey[700],
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                              child: ListTile(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => ChatScreen(
                                                chatId: snap['chatId'],
                                                recipent: recipient,
                                                sender: userName,
                                              )));
                                },
                                leading: CircleAvatar(
                                  backgroundColor: redColor,
                                  child: Text(
                                    recipient.substring(0, 1).toUpperCase(),
                                    style: TextStyle(color: greyColor),
                                  ),
                                ),
                                title: Text(recipient, style: TextStyle(color: Colors.white, letterSpacing: 1, fontSize: 20)),
                              ),
                            ),
                          ),
                        );
                      },
                    )
                  : Container();
            },
          ),
        ),
      ),
    );
  }

  void _showDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
            content: Container(
              height: 200,
              width: 340,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.mic, color: Colors.white),
                    onPressed: !_hasSpeech || speech.isListening ? null : startListening,
                  ),
                  IconButton(
                    icon: Icon(Icons.mic_off, color: Colors.white),
                    onPressed: speech.isListening ? stopListening : null,
                  ),
                  IconButton(
                    icon: Icon(Icons.cancel, color: Colors.white),
                    onPressed: speech.isListening ? cancelListening : null,
                  )
                ],
              ),
            ),
          );
        });
  }

  ///these are the methods for voice search i.e speech to text functionality
  Future<void> initSpeechState() async {
    bool hasSpeech = await speech.initialize(onError: errorListener, onStatus: statusListener);
    if (hasSpeech) {
      _localeNames = await speech.locales();

      var systemLocale = await speech.systemLocale();
      _currentLocaleId = systemLocale.localeId;
    }

    if (!mounted) return;

    setState(() {
      _hasSpeech = hasSpeech;
    });
  }

  void errorListener(SpeechRecognitionError error) {
    print("Received error status: $error, listening: ${speech.isListening}");
    setState(() {
      lastError = "${error.errorMsg} - ${error.permanent}";
    });
  }

  void statusListener(String status) {
    print("Received listener status: $status, listening: ${speech.isListening}");
    setState(() {
      lastStatus = "$status";
    });
  }

//the three widgets below will be used in the dialog
  void startListening() {
    lastWords = "";
    lastError = "";
    speech.listen(
        onResult: resultListener,
        listenFor: Duration(seconds: 20),
        localeId: 'English',
        onSoundLevelChange: soundLevelListener,
        cancelOnError: true,
        partialResults: true,
        onDevice: true,
        listenMode: ListenMode.confirmation);
    setState(() {});
  }

  void stopListening() {
    speech.stop();
    setState(() {
      level = 0.0;
    });
  }

  void cancelListening() {
    speech.cancel();
    setState(() {
      level = 0.0;
    });
  }

//the methods funciton to give the results of speech transcribed to text and volume control
  void resultListener(SpeechRecognitionResult result) {
    setState(() {
      lastWords = "${result.recognizedWords} - ${result.finalResult}";
    });
  }

  void soundLevelListener(double level) {
    minSoundLevel = min(minSoundLevel, level);
    maxSoundLevel = max(maxSoundLevel, level);
    // print("sound level $level: $minSoundLevel - $maxSoundLevel ");
    setState(() {
      this.level = level;
    });
  }

  getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userName = prefs.getString('userName');
    print(userName);
    chatLists = await database.getChatLists(userName);
  }
}
