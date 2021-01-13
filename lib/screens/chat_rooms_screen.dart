import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatRoomsListScreen extends StatefulWidget {
  @override
  _ChatRoomsListScreenState createState() => _ChatRoomsListScreenState();
}

class _ChatRoomsListScreenState extends State<ChatRoomsListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(
          color: Color.fromRGBO(44, 62, 80, 1),
        ),
        title: Text(
          "Messaging",
          style: GoogleFonts.roboto(
              color: Color.fromRGBO(44, 62, 80, 1),
              fontSize: 18,
              fontWeight: FontWeight.w600),
        ),
      ),
      body: Center(
        child: Text('Chat Room List'),
      ),
    );
  }
}
