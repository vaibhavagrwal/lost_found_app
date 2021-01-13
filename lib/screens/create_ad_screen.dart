import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CreateAdScreen extends StatefulWidget {
  @override
  _CreateAdScreenState createState() => _CreateAdScreenState();
}

class _CreateAdScreenState extends State<CreateAdScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Color.fromRGBO(44, 62, 80, 1),
        ),
        title: Text(
          " Create Ad ",
          style: GoogleFonts.roboto(
              color: Color.fromRGBO(44, 62, 80, 1),
              fontSize: 20,
              fontWeight: FontWeight.w600),
        ),
      ),
      body: Center(
        child: Text('Create Ad'),
      ),
    );
  }
}
