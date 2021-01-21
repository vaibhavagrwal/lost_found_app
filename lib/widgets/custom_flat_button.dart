 import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomFlatButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String title;

  CustomFlatButton({this.title, this.onPressed});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: EdgeInsets.symmetric(
          vertical: 0.0,
          horizontal: 55,
        ),
        width: 350,
        height: 50,
        decoration: BoxDecoration(
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Color.fromRGBO(26, 80, 152, 0.1),
              offset: Offset(10.0, 10.0),
              blurRadius: 6.0,
            ),
          ],
          borderRadius: BorderRadius.circular(12),
          color: Color.fromRGBO(19, 60, 109, 1),
        ),
        child: Center(
          child: Text(
            title,
            style: GoogleFonts.roboto(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
