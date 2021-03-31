import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lost_found_app/screens/chat_rooms_screen.dart';
import 'package:lost_found_app/main.dart';
import 'package:lost_found_app/screens/drawer_screen.dart';
import 'package:lost_found_app/screens/found_items_screen.dart';
import 'package:lost_found_app/screens/lost_items_screen.dart';
import 'package:lost_found_app/util/constants.dart';
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
          toolbarHeight: 110 * ScreenSize.heightMultiplyingFactor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(30.0),
              bottomLeft: Radius.circular(30.0),
            ),
          ),
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(
            color: Color.fromRGBO(19, 60, 109, 1),
          ),
          // title: Text(
          //   " Mila Kya ? ",
          //   style: GoogleFonts.poppins(
          //       color: Color.fromRGBO(44, 62, 80, 1),
          //       fontSize: 25 * ScreenSize.heightMultiplyingFactor,
          //       fontWeight: FontWeight.w600),
          // ),
          title: SizedBox(
            width: 250.0,
            child: TyperAnimatedTextKit(
              onTap: () {},
              text: [
                "Mila Kya",
              ],
              displayFullTextOnTap: true,

              // totalRepeatCount: 2,
              repeatForever: true,
              curve: Curves.easeInCirc,
              speed: Duration(milliseconds: 200),
              pause: Duration(milliseconds: 6000),
              textStyle: GoogleFonts.poppins(
                color: primaryColour,
                fontSize: 28 * ScreenSize.heightMultiplyingFactor,
                fontWeight: FontWeight.bold,
                // letterSpacing: 2.0,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          bottom: TabBar(
            indicatorSize: TabBarIndicatorSize.values[1],
            indicatorPadding: EdgeInsets.only(
              bottom: 10.0 * ScreenSize.heightMultiplyingFactor,
              right: 10.0 * ScreenSize.widthMultiplyingFactor,
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
                  style: GoogleFonts.poppins(
                    fontSize: 18 * ScreenSize.heightMultiplyingFactor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Tab(
                child: Text(
                  'FOUND',
                  style: GoogleFonts.poppins(
                    fontSize: 18 * ScreenSize.heightMultiplyingFactor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              onPressed: () {
                navigatorKey.currentState
                    .push(MaterialPageRoute(builder: (context) => ChatRoom()));
              },
              icon: FaIcon(
                Icons.message_outlined,
                size: 24 * ScreenSize.heightMultiplyingFactor,
                color: Color.fromRGBO(19, 60, 109, 1),
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
