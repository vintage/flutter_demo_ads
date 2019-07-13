import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:firebase_admob/firebase_admob.dart';

const ANDROID_KEY = "ca-app-pub-4822657955324260~2836093970";
const IOS_KEY = "ca-app-pub-4822657955324260~1933149801";

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

  @override
  void initState() {
    showBanner();
    loadInterstitial();
    super.initState();
  }

  void loadInterstitial() {
    interstitial = InterstitialAd(
      adUnitId: InterstitialAd.testAdUnitId,
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
      adUnitId: BannerAd.testAdUnitId,
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
    if (await interstitial.isLoaded()) {
      interstitial.show();
    }
  }

  void showRewardVideo() {
    RewardedVideoAd.instance.listener =
        (RewardedVideoAdEvent event, {String rewardType, int rewardAmount}) {
      if (event == RewardedVideoAdEvent.loaded) {
        RewardedVideoAd.instance.show();
      }
    };
    RewardedVideoAd.instance.load(
      adUnitId: RewardedVideoAd.testAdUnitId,
      targetingInfo: MobileAdTargetingInfo(),
    );
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(width: 50, height: 50, color: Colors.green),
                  Container(width: 50, height: 50, color: Colors.green),
                  GestureDetector(
                    child: Container(width: 50, height: 50, color: Colors.red),
                    onTap: showInterstitial,
                  ),
                  Container(width: 50, height: 50, color: Colors.green),
                  Container(width: 50, height: 50, color: Colors.green),
                ],
              ),
              RaisedButton(
                child: Text("Show reward video"),
                onPressed: showRewardVideo,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
