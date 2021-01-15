import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lost_found_app/models/user_model.dart';
import 'package:lost_found_app/screens/edit_profile_screen.dart';
import 'package:lost_found_app/util/constants.dart';
import 'package:lost_found_app/util/screen_size.dart';

import '../main.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Stack(
          children: [
            profilePageAppBar(),
            profileDataList(
              userEmail: user.email,
              userName: user.name,
              userPhone: '',
            ),
          ],
        ),
      ),
    );
  }

  Widget profilePageAppBar() {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(221.0 * ScreenSize.heightMultiplyingFactor),
        child: appBarOverall(heading: 'Profile', searchThere: false),
      ),
    );
  }

  Widget profileDataList(
      {String userName, String userEmail, String userPhone}) {
    return Positioned(
      top: 135.0 * ScreenSize.heightMultiplyingFactor,
      left: 1,
      right: 1,
      child: Center(
        child: Column(
          children: [
            Container(
              width: 335.0 * ScreenSize.widthMultiplyingFactor,
              height: 262.0 * ScreenSize.heightMultiplyingFactor,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(25.0),
                  ),
                ),
                elevation: 3.0 * ScreenSize.heightMultiplyingFactor,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 50.0,
                      backgroundImage: CachedNetworkImageProvider(
                        user.imageUrl == ""
                            ? "https://i.pinimg.com/474x/67/c3/d6/67c3d63e215e034e01d45c8256d720d3.jpg"
                            : user.imageUrl,
                      ),
                    ),
                    SizedBox(
                      height: 11.0 * ScreenSize.heightMultiplyingFactor,
                    ),
                    Text(
                      userName,
                      style: TextStyle(
                        fontFamily: 'Poppins-Medium',
                        fontSize: 18.0 * ScreenSize.heightMultiplyingFactor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 36.0 * ScreenSize.heightMultiplyingFactor,
            ),
            smallBox(Icons.mail_outline, userEmail),
            SizedBox(
              height: 20.0 * ScreenSize.heightMultiplyingFactor,
            ),
            smallBox(
              Icons.phone,
              user.phone == ""
                  ? "Update Your Phone No."
                  : ("+91 - " + user.phone),
            ),
            SizedBox(
              height: 30.0 * ScreenSize.heightMultiplyingFactor,
            ),
            MaterialButton(
              onPressed: () async {
                UserModel user1 = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditProfileScreen(),
                    ));
                setState(() {
                  user.name = user1.name;
                  user.imageUrl = user1.imageUrl;
                  user.phone = user1.phone;
                });
              },
              child: Container(
                width: 150.0 * ScreenSize.widthMultiplyingFactor,
                padding: EdgeInsets.fromLTRB(
                  10.0 * ScreenSize.widthMultiplyingFactor,
                  5.0 * ScreenSize.heightMultiplyingFactor,
                  10.0 * ScreenSize.widthMultiplyingFactor,
                  5.0 * ScreenSize.heightMultiplyingFactor,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50.0),
                  border: Border.all(
                    color: Color(0xFFE9E9E9),
                    width: 1.0,
                  ),
                  color: Colors.white,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.edit_outlined,
                      color: Color.fromRGBO(19, 60, 109, 1),
                      size: 23.0 * ScreenSize.heightMultiplyingFactor,
                    ),
                    SizedBox(
                      width: 13.0 * ScreenSize.widthMultiplyingFactor,
                    ),
                    Text(
                      "Edit Profile",
                      style: TextStyle(
                        fontFamily: 'Poppins-Regular',
                        fontSize: 16.0 * ScreenSize.heightMultiplyingFactor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget smallBox(IconData iconDataPrefix, String title) {
    return Container(
      width: 335.0 * ScreenSize.widthMultiplyingFactor,
      padding: EdgeInsets.fromLTRB(
        22.0 * ScreenSize.widthMultiplyingFactor,
        15.0 * ScreenSize.heightMultiplyingFactor,
        22.0 * ScreenSize.widthMultiplyingFactor,
        15.0 * ScreenSize.heightMultiplyingFactor,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50.0),
        border: Border.all(
          color: Color(0xFFE9E9E9),
          width: 1.0,
        ),
        color: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            iconDataPrefix,
            color: Color.fromRGBO(19, 60, 109, 1),
            size: 23.0 * ScreenSize.heightMultiplyingFactor,
          ),
          SizedBox(
            width: 13.0 * ScreenSize.widthMultiplyingFactor,
          ),
          Text(
            title,
            style: TextStyle(
              fontFamily: 'Poppins-Regular',
              fontSize: 16.0 * ScreenSize.heightMultiplyingFactor,
            ),
          ),
        ],
      ),
    );
  }
}
