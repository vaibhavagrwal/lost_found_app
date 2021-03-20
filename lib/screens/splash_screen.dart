import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lost_found_app/util/screen_size.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

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
      Duration(milliseconds: 6000),
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

  ImageProvider logo = AssetImage("lib/assets/logo.png");

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white, //Color.fromRGBO(224, 227, 237, 1),
      resizeToAvoidBottomInset: false,
      body: Container(
        //height: size.height,
        //width: size.width,
        child: Column(children: [
          Image(
            image: logo,
            //width: 100 * ScreenSize.widthMultiplyingFactor,
            //height: 100 * ScreenSize.heightMultiplyingFactor,
            fit: BoxFit.cover,
          ),
          TypewriterAnimatedTextKit(
            textStyle: GoogleFonts.roboto(
              fontSize: 32.0,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
            speed: Duration(milliseconds: 500),
            text: [
              "MILA KYA",
            ],
            isRepeatingAnimation: true,
          ),
        ]),
      ),
    );
  }
}
