import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lost_found_app/screens/chat_rooms_screen.dart';
import 'package:lost_found_app/main.dart';
import 'package:lost_found_app/screens/drawer_screen.dart';
import 'package:lost_found_app/screens/found_items_screen.dart';
import 'package:lost_found_app/screens/lost_items_screen.dart';
import 'package:lost_found_app/util/screen_size.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        drawer: DrawerScreen(),
        appBar: AppBar(
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(30.0),
              bottomLeft: Radius.circular(30.0),
            ),
          ),
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
          bottom: TabBar(
            indicatorSize: TabBarIndicatorSize.values[1],
            indicatorPadding: EdgeInsets.only(
              bottom: 10.0 * ScreenSize.heightMultiplyingFactor,
              right: 15.0 * ScreenSize.widthMultiplyingFactor,
            ),
            indicatorColor: Color.fromRGBO(19, 60, 109, 1),
            labelColor: Color.fromRGBO(19, 60, 109, 1),
            unselectedLabelColor: Color.fromRGBO(23, 23, 23, 1),
            tabs: [
              // Tab(
              //   child: Text(
              //     'ALL',
              //     style: GoogleFonts.roboto(
              //       fontSize: 18,
              //       fontWeight: FontWeight.w600,
              //     ),
              //   ),
              // ),
              Tab(
                child: Text(
                  'LOST',
                  style: GoogleFonts.roboto(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Tab(
                child: Text(
                  'FOUND',
                  style: GoogleFonts.roboto(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
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
        body: TabBarView(
          children: [
            // AllItemsScreen(),
            LostItemsScreen(),
            FoundItemsScreen(),
          ],
        ),
      ),
    );
  }
}
