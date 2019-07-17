import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:firebase_admob/firebase_admob.dart';

const ANDROID_KEY = "ca-app-pub-4822657955324260~2836093970";
const IOS_KEY = "ca-app-pub-4822657955324260~1933149801";

// Replace these with keys from AdMob in order to start earning real cash
// Warning: Use the pattern: Platform.isAndroid ? "android-key" : "ios-key";
final String bannerId = Platform.isAndroid ? "ca-app-pub-4822657955324260/7680881068" : "ca-app-pub-4822657955324260/7680881068";
final String interstitialId = Platform.isAndroid ? "ca-app-pub-4822657955324260/3343439981" : "ca-app-pub-4822657955324260/3358492672";
final String rewardVideoId = Platform.isAndroid ? "ca-app-pub-4822657955324260/4639204197" : "ca-app-pub-4822657955324260/9540757641";

void main() {
  String appId = Platform.isAndroid ? ANDROID_KEY : IOS_KEY;
  FirebaseAdMob.instance.initialize(appId: appId);

  runApp(App());
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  InterstitialAd interstitial;
  List<Widget> boxes = [];
  int coins = 0;

  @override
  void initState() {
    boxes = getInitialBoxes();
    showBanner();
    loadInterstitial();
    loadRewardVideo();
    super.initState();
  }

  List<Widget> getInitialBoxes() {
    return [
      Container(width: 50, height: 50, color: Colors.green),
      Container(width: 50, height: 50, color: Colors.green),
      GestureDetector(
        child: Container(width: 50, height: 50, color: Colors.red),
        onTap: showInterstitial,
      ),
      Container(width: 50, height: 50, color: Colors.green),
      Container(width: 50, height: 50, color: Colors.green),
    ];
  }

  void loadInterstitial() {
    interstitial = InterstitialAd(
      adUnitId: interstitialId,
      targetingInfo: MobileAdTargetingInfo(),
    );
    interstitial.listener = (MobileAdEvent event) {
      if (event == MobileAdEvent.closed) {
        loadInterstitial();
      }
    };
    interstitial.load();
  }

  void showBanner() async {
    var banner = BannerAd(
      adUnitId: bannerId,
      targetingInfo: MobileAdTargetingInfo(),
      size: AdSize.smartBanner,
    );
    banner.listener = (MobileAdEvent event) {
      print("Banner event [$event]");
      if (event == MobileAdEvent.loaded) {
        banner.show();
      }
    };
    banner.load();
  }

  void showInterstitial() async {
    setState(() {
      coins++;
      boxes.shuffle();
    });
    interstitial.show();
  }

  void loadRewardVideo() {
    RewardedVideoAd.instance.listener =
        (RewardedVideoAdEvent event, {String rewardType, int rewardAmount}) {
      print("RewardVideo event [$event], [$rewardType], [$rewardAmount]");
      if (event == RewardedVideoAdEvent.closed) {
        loadRewardVideo();
      } else if (event == RewardedVideoAdEvent.completed) {
        setState(() {
          coins += 100;
        });
      }
    };
    RewardedVideoAd.instance.load(
      adUnitId: rewardVideoId,
      targetingInfo: MobileAdTargetingInfo(),
    );
  }

  void showRewardVideo() async {
    RewardedVideoAd.instance.show();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AdMob demo',
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Coins: $coins"),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: boxes,
              ),
              RaisedButton(
                child: Text("Get FREE coins"),
                onPressed: showRewardVideo,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
