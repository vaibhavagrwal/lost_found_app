import 'package:flutter/material.dart';
import 'package:slider_button/slider_button.dart';

class ClaimButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliderButton(
      action: () {},
      label: Text(
        "Message",
        style: TextStyle(
            color: Colors.white, fontWeight: FontWeight.w500, fontSize: 25),
      ),
      vibrationFlag: false,
      icon: Center(
          child: Icon(
        Icons.message,
        color: Color.fromRGBO(19, 60, 109, 1),
        size: 40.0,
        semanticLabel: 'Text to announce in accessibility modes',
      )),
      width: 230,
      radius: 50,
      height: 60,
      buttonSize: 50,
      buttonColor: Colors.white,
      backgroundColor: Color.fromRGBO(19, 60, 109, 1),
      highlightedColor: Colors.white,
      baseColor: Colors.white,
    );
  }
}
