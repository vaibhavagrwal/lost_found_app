import 'package:flutter/material.dart';

class RoundButton extends StatelessWidget {
  final Widget image;
  final VoidCallback onPressed;

  RoundButton({this.image, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 80,
        height: 65,
        child: Center(
          child: image,
        ),
        decoration: BoxDecoration(
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Color.fromRGBO(26, 80, 152, 0.1),
              offset: Offset(8.0, 8.0),
              blurRadius: 6.0,
            ),
          ],
          borderRadius: BorderRadius.circular(12),
          color: Color.fromRGBO(242, 245, 250, 1),
        ),
      ),
    );
  }
}
