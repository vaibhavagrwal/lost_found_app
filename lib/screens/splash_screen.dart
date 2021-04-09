import 'dart:async';

import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:lost_found_app/util/constants.dart';
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
      Duration(milliseconds: 2200),
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
        height: size.height,
        width: size.width,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
                top: size.height * 0.08,
                child: Container(
                  width: size.width,
                  child: Image(
                    image: logo,
                    fit: BoxFit.fitWidth,
                  ),
                )),
            Positioned(
              top: size.height * 0.68,
              child: TyperAnimatedTextKit(
                onTap: () {},
                text: [
                  "MILA KYA",
                ],
                displayFullTextOnTap: true,

                // totalRepeatCount: 2,
                repeatForever: false,
                curve: Curves.easeInCirc,
                speed: Duration(milliseconds: 100),
                isRepeatingAnimation: false,
                textStyle: GoogleFonts.poppins(
                  color: Color.fromRGBO(19, 60, 130, 1),
                  fontSize: 40 * ScreenSize.heightMultiplyingFactor,
                  fontWeight: FontWeight.bold,
                  // letterSpacing: 2.0,
                ),

                textAlign: TextAlign.center,
              ),
            )
            //  Positioned(
            //   top: size.height * 0.7,

            // child: Container(
            //   decoration: BoxDecoration(
            //     color: primaryColour,
            //     borderRadius: BorderRadius.only(
            //       topLeft: Radius.circular(
            //         100,
            //       ),
            //       topRight: Radius.circular(
            //         100,
            //       ),
            //     ),
            //   ),
            //   width: size.width,
            //   height: 0.3 * size.height,
            // ),
            // ),
            // Positioned(
            //   top: 100,
            //   child: ClipPath(
            //     clipper: OvalTopBorderClipper(),
            //     child: Container(
            //       height: size.height * 0.3,
            //       color: primaryColour,
            //     ),
            //   ),
            // ),

            // Positioned(
            //   top: size.height * 0.7,
            //   child: Container(
            //     decoration: BoxDecoration(
            //       color: primaryColour,
            //       borderRadius: BorderRadius.only(
            //         topLeft: Radius.circular(
            //           100,
            //         ),
            //         topRight: Radius.circular(
            //           100,
            //         ),
            //       ),
            //     ),
            //     width: size.width,
            //     height: 0.3 * size.height,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
