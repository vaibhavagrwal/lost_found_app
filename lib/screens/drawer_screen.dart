import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lost_found_app/models/user_model.dart';
import 'package:lost_found_app/screens/about_us.dart';
import 'package:lost_found_app/screens/chat_rooms_screen.dart';
import 'package:lost_found_app/screens/edit_profile_screen.dart';
import 'package:lost_found_app/screens/moderator_screen.dart';
import 'package:lost_found_app/screens/my_ad_screen.dart';
import 'package:lost_found_app/services/firebase_repository.dart';
import 'package:lost_found_app/util/screen_size.dart';
import '../main.dart';
import './root_screen.dart';

class DrawerScreen extends StatefulWidget {
  @override
  _DrawerScreenState createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  @override
  Widget build(BuildContext context) {
    return Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Color.fromRGBO(
              19, 60, 130, 1), //This will change the drawer background to blue.
          //other styles
        ),
        child: Drawer(
            child: Column(children: [
          Container(
            child: Padding(
              padding: EdgeInsets.only(
                  top: 30.0 * ScreenSize.heightMultiplyingFactor),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 50.0,
                    backgroundImage: AssetImage(
                      "lib/assets/face1.gif",
                    ),
                  ),
                  SizedBox(
                    height: 5.0 * ScreenSize.heightMultiplyingFactor,
                  ),
                  Text(
                    user.name != null ? "Hello " + user.name : "",
                    style: GoogleFonts.poppins(
                      fontSize: 25,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    height: 5.0 * ScreenSize.heightMultiplyingFactor,
                  ),
                  Text(
                    user.email != null ? user.email : "",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 20.0 * ScreenSize.heightMultiplyingFactor,
          ),
          //Now let's Add the button for the Menu
          //and let's copy that and modify it
          Column(
            children: [
              // Tile(
              //   "My Posts",
              //   () {
              //     // Navigator.push(
              //     //   context,
              //     //   MaterialPageRoute(
              //     //     builder: (context) => MyAdScreen(),
              //     //   ),
              //     // );

              //   },
              // ),
              SizedBox(height: 10 * ScreenSize.heightMultiplyingFactor),
              Tile(
                "My Chats",
                () {
                  navigatorKey.currentState.push(
                      MaterialPageRoute(builder: (context) => ChatRoom()));
                },
              ),
              SizedBox(height: 10 * ScreenSize.heightMultiplyingFactor),
              Tile(
                "Edit Profile",
                () async {
                  UserModel user1 = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditProfileScreen(),
                    ),
                  );

                  setState(() {
                    user.imageUrl = user1.imageUrl;
                    user.name = user1.name;
                    user.email = user1.email;
                  });
                },
              ),
              SizedBox(height: 10 * ScreenSize.heightMultiplyingFactor),
              user.isModerator == true
                  ? Tile(
                      "Review",
                      () async {
                        navigatorKey.currentState.push(MaterialPageRoute(
                            builder: (context) => ModeratorScreen()));
                      },
                    )
                  : Container(),
              user.isModerator == true
                  ? SizedBox(height: 10 * ScreenSize.heightMultiplyingFactor)
                  : Container(),
              Tile(
                "About Us",
                () {
                  navigatorKey.currentState
                      .push(MaterialPageRoute(builder: (context) => AboutUs()));
                },
              ),
              SizedBox(height: 10 * ScreenSize.heightMultiplyingFactor),
              Tile(
                "Logout",
                () async {
                  FirebaseRepository().signout(context);
                },
              ),
            ],
          )
        ])));
    /*Container(
      width: 250 * ScreenSize.widthMultiplyingFactor,
      child: Drawer(
        child: ListView(
          children: [
            Container(
              height: 200 * ScreenSize.heightMultiplyingFactor,
              child: UserAccountsDrawerHeader(
                decoration: BoxDecoration(
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Color.fromRGBO(26, 80, 152, 0.1),
                      offset: Offset(8.0, 8.0),
                      blurRadius: 6.0,
                    ),
                  ],
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                ),
                accountName: Text(
                  user.name != null ? user.name : "",
                  style: GoogleFonts.roboto(
                      color: Color.fromRGBO(44, 62, 80, 1),
                      fontSize: 18 * ScreenSize.heightMultiplyingFactor,
                      fontWeight: FontWeight.w600),
                ),
                accountEmail: Text(
                  user.email != null ? user.email : "",
                  style: GoogleFonts.roboto(
                      color: Color.fromRGBO(44, 62, 80, 1),
                      fontSize: 14 * ScreenSize.heightMultiplyingFactor,
                      fontWeight: FontWeight.w600),
                ),
                currentAccountPicture: Container(
                  width: 200 * ScreenSize.widthMultiplyingFactor,
                  height: 200 * ScreenSize.heightMultiplyingFactor,
                  child: ClipOval(
                    child: Image.asset(
                      "lib/assets/face1.gif",
                      fit: BoxFit.fill,
                    ),
                  ), /*CircleAvatar(
                    radius: 150,
                    backgroundImage: CachedNetworkImageProvider(
                      user.imageUrl == ""
                          ? "https://i.pinimg.com/474x/67/c3/d6/67c3d63e215e034e01d45c8256d720d3.jpg"
                          : user.imageUrl,
                    ),
                    // backgroundImage: AdvancedNetworkImage(
                    //   user.imageUrl == ""
                    //       ? "https://images.pexels.com/photos/771742/pexels-photo-771742.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500"
                    //       : user.imageUrl,
                    //   useDiskCache: true,
                    //   cacheRule: CacheRule(maxAge: const Duration(days: 2)),
                    // ),
                  ),*/
                ),
              ),
            ),
            Container(
              height: 320 * ScreenSize.heightMultiplyingFactor,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ListTile(
                    leading: Icon(
                      Icons.person,
                      color: Color.fromRGBO(19, 60, 109, 1),
                    ),
                    title: Text(
                      "Edit Profile",
                      style: GoogleFonts.roboto(
                          color: Colors.black,
                          fontSize: 17 * ScreenSize.heightMultiplyingFactor,
                          fontWeight: FontWeight.w600),
                    ),
                    onTap: () async {
                      UserModel user1 = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditProfileScreen(),
                        ),
                      );

                      setState(() {
                        user.imageUrl = user1.imageUrl;
                        user.name = user1.name;
                        user.email = user1.email;
                      });
                    },
                  ),
                  user.isModerator == true
                      ? ListTile(
                          leading: Icon(
                            Icons.person,
                            color: Color.fromRGBO(19, 60, 109, 1),
                          ),
                          title: Text(
                            "Review",
                            style: GoogleFonts.roboto(
                                color: Colors.black,
                                fontSize:
                                    17 * ScreenSize.heightMultiplyingFactor,
                                fontWeight: FontWeight.w600),
                          ),
                          onTap: () async {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ModeratorScreen(),
                              ),
                            );
                          },
                        )
                      : Container(),
                  ListTile(
                    leading: Icon(
                      Icons.phone,
                      color: Color.fromRGBO(19, 60, 109, 1),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AboutUs(),
                        ),
                      );
                    },
                    title: Text(
                      "About Us",
                      style: GoogleFonts.roboto(
                          color: Colors.black,
                          fontSize: 17 * ScreenSize.heightMultiplyingFactor,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  Container(),
                  ListTile(
                    leading: Icon(
                      Icons.logout,
                      color: Color.fromRGBO(19, 60, 109, 1),
                    ),
                    title: Text(
                      "Log Out",
                      style: GoogleFonts.roboto(
                        color: Colors.black,
                        fontSize: 17 * ScreenSize.heightMultiplyingFactor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onTap: () async {
                      FirebaseRepository().signout(context);
                    },
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );*/
  }
}

Widget Tile(String a, Function call) {
  return ListTile(
    leading: SizedBox(
      width: 15.0 * ScreenSize.widthMultiplyingFactor,
      height: 62.0 * ScreenSize.heightMultiplyingFactor,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Color.fromRGBO(19, 60, 130, 1),
        ),
      ),
    ),
    onTap: call,
    tileColor: Colors.white30,
    title: Text(
      a,
      style: GoogleFonts.poppins(
        fontSize: 20,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}
