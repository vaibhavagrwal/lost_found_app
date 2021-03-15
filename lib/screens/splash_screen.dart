import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lost_found_app/util/screen_size.dart';

class SplashScreen extends StatefulWidget {
  var screen;
  SplashScreen({this.screen});
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
      Duration(seconds: 3),
      () async {
        ScreenSize(MediaQuery.of(context).size.width,
            MediaQuery.of(context).size.height);
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => widget.screen,
          ),
        );
      },
    );
  }

  ImageProvider logo = AssetImage("lib/assets/google.png");

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        height: size.height,
        width: size.width,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: size.width,
              child: Image(
                image: logo,
                fit: BoxFit.fitWidth,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
