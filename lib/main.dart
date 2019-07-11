import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:firebase_admob/firebase_admob.dart';

void main() {
  String appId = Platform.isAndroid ? "ss" : "yy";
  FirebaseAdMob.instance.initialize(appId: appId);

  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AdMob demo',
      home: Scaffold(
        body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RaisedButton(child: Text("Show banner"), onPressed: null),
                RaisedButton(child: Text("Show interstitial"), onPressed: null),
                RaisedButton(child: Text("Show reward video"), onPressed: null),
              ],
            ),
        ),
      ),
    );
  }
}
