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

class App extends StatelessWidget {
  void showBanner() {
    BannerAd(
      adUnitId: BannerAd.testAdUnitId,
      targetingInfo: MobileAdTargetingInfo(),
      size: AdSize.smartBanner,
    )
      ..load()
      ..show();
  }

  void showInterstitial() {
    InterstitialAd(
      adUnitId: InterstitialAd.testAdUnitId,
      targetingInfo: MobileAdTargetingInfo(),
    )
      ..load()
      ..show();
  }

  void showRewardVideo() {
    RewardedVideoAd.instance.listener =
        (RewardedVideoAdEvent event, {String rewardType, int rewardAmount}) {
      if (event == RewardedVideoAdEvent.loaded) {
        RewardedVideoAd.instance.show();
      }
    };
    RewardedVideoAd.instance
      .load(
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
              RaisedButton(child: Text("Show banner"), onPressed: showBanner),
              RaisedButton(
                  child: Text("Show interstitial"),
                  onPressed: showInterstitial),
              RaisedButton(
                  child: Text("Show reward video"), onPressed: showRewardVideo),
            ],
          ),
        ),
      ),
    );
  }
}
