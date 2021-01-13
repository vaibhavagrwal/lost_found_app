import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lost_found_app/screens/chat_rooms_screen.dart';
import 'package:lost_found_app/main.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
          " Home ",
          style: GoogleFonts.roboto(
              color: Color.fromRGBO(44, 62, 80, 1),
              fontSize: 20,
              fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            onPressed: () {
              navigatorKey.currentState.push(MaterialPageRoute(
                  builder: (context) => ChatRoomsListScreen()));
            },
            icon: FaIcon(
              FontAwesomeIcons.facebookMessenger,
              size: 20,
              color: Color.fromRGBO(44, 62, 80, 1),
            ),
          ),
        ],
      ),
      body: Center(
        child: Text('Home'),
      ),
    );
  }
}
