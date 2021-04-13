import 'package:flutter/material.dart';
import '../util/screen_size.dart';

class RoundButton extends StatelessWidget {
  final Widget image;
  final VoidCallback onPressed;

  RoundButton({this.image, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 80 * ScreenSize.widthMultiplyingFactor,
        height: 65 * ScreenSize.heightMultiplyingFactor,
        child: Center(
          child: image,
        ),
        decoration: BoxDecoration(
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Color.fromRGBO(26, 80, 152, 0.1),
              offset: Offset(8.0 * ScreenSize.widthMultiplyingFactor,
                  8.0 * ScreenSize.heightMultiplyingFactor),
              blurRadius: 6.0 * ScreenSize.heightMultiplyingFactor,
            ),
          ],
          borderRadius:
              BorderRadius.circular(12 * ScreenSize.widthMultiplyingFactor),
          color: Color.fromRGBO(242, 245, 250, 1),
        ),
      ),
    );
  }
}
