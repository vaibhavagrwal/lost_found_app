import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lost_found_app/services/firebase_repository.dart';

import '../main.dart';

class DrawerScreen extends StatefulWidget {
  @override
  _DrawerScreenState createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      child: Drawer(
        child: ListView(
          children: [
            Container(
              height: 200,
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
                      fontSize: 18,
                      fontWeight: FontWeight.w600),
                ),
                accountEmail: Text(
                  user.email != null ? user.email : "",
                  style: GoogleFonts.roboto(
                      color: Color.fromRGBO(44, 62, 80, 1),
                      fontSize: 14,
                      fontWeight: FontWeight.w600),
                ),
                currentAccountPicture: Container(
                  child: CircleAvatar(
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
                  ),
                ),
              ),
            ),
            Container(
              height: 320,
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
                          fontSize: 17,
                          fontWeight: FontWeight.w600),
                    ),
                    onTap: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => EditProfileScreen(),
                      //   ),
                      // );
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.phone,
                      color: Color.fromRGBO(19, 60, 109, 1),
                    ),
                    title: Text(
                      "Contact Us",
                      style: GoogleFonts.roboto(
                          color: Colors.black,
                          fontSize: 17,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.logout,
                      color: Color.fromRGBO(19, 60, 109, 1),
                    ),
                    title: Text(
                      "Log Out",
                      style: GoogleFonts.roboto(
                        color: Colors.black,
                        fontSize: 17,
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
    );
  }
}
