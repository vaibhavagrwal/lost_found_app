import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lost_found_app/util/constants.dart';
import 'package:lost_found_app/util/screen_size.dart';

class AboutUs extends StatefulWidget {
  @override
  _AboutUsState createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          color: Colors.white,
          // height: 775 * ScreenSize.heightMultiplyingFactor,
          // width: 411 * ScreenSize.widthMultiplyingFactor,
          child: Stack(
            children: [
              aboutUsAppBar(),
              Positioned(
                top: 90.0 * ScreenSize.heightMultiplyingFactor,
                left: 1 * ScreenSize.widthMultiplyingFactor,
                right: 1 * ScreenSize.widthMultiplyingFactor,
                child: Column(
                  children: [
                    Container(
                      width: 335.0 * ScreenSize.widthMultiplyingFactor,
                      height: 220.0 * ScreenSize.heightMultiplyingFactor,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(25.0),
                          ),
                        ),
                        elevation: 3.0 * ScreenSize.heightMultiplyingFactor,
                        child: Image.asset(
                          "lib/assets/logo.png",
                          height: 248 * ScreenSize.heightMultiplyingFactor,
                          width: 206 * ScreenSize.widthMultiplyingFactor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 310.0 * ScreenSize.heightMultiplyingFactor,
                left: 1 * ScreenSize.widthMultiplyingFactor,
                right: 1 * ScreenSize.widthMultiplyingFactor,
                child: AboutUsData(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AboutUsData extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        height: (775 - 340) * ScreenSize.heightMultiplyingFactor,
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.fromLTRB(20.0 * ScreenSize.widthMultiplyingFactor,
              0.0, 20.0 * ScreenSize.widthMultiplyingFactor, 0.0),
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // SizedBox(
                //   height: 450 * ScreenSize.heightMultiplyingFactor,
                // ),
                Text(
                  "\nAbout the App: \n",
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16 * ScreenSize.heightMultiplyingFactor,
                  ),
                ),
                Text(
                  "Almost everyone of us had either lost or found any item in DTU but are unable to return it.This is app is the solution to all such problems.",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14 * ScreenSize.heightMultiplyingFactor,
                    fontFamily: 'Poppins-Light',
                  ),
                  textAlign: TextAlign.left,
                ),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "\nDevelopers of this Application:",
                        style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontSize: 16 * ScreenSize.heightMultiplyingFactor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                // ListView.builder(
                //   physics: NeverScrollableScrollPhysics(),
                //   shrinkWrap: true,
                //   itemCount: names.length,
                //   itemBuilder: (context, index) {
                //     return Text(
                //       names[index],
                //       style: TextStyle(
                //         color: Colors.black,
                //         fontSize: 14 * ScreenSize.heightMultiplyingFactor,
                //         fontFamily: 'Poppins-Regular',
                //       ),
                //     );
                //   },
                // ),
                Column(
                  children: [
                    ListTile(
                      leading: Container(
                        width: 60 * ScreenSize.widthMultiplyingFactor,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: CachedNetworkImage(
                            imageUrl:
                                "https://firebasestorage.googleapis.com/v0/b/lost-found-app-2408e.appspot.com/o/asset_images%2FWhatsApp%20Image%202021-03-16%20at%2022.35.01.jpeg?alt=media&token=55746560-3f15-413f-a13b-62d8d2bb9330",
                          ),
                        ),
                      ),
                      title: Text(
                        'Vaibhav Agarwal',
                        style: GoogleFonts.montserrat(
                          color: Colors.black,
                          fontSize: 16 * ScreenSize.heightMultiplyingFactor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'SE     | DTU \'23',
                            style: GoogleFonts.montserrat(
                              color: Colors.black,
                              fontSize: 14 * ScreenSize.heightMultiplyingFactor,
                            ),
                          ),
                          Text(
                            'vaibhavagarwal306@gmail.com',
                            style: GoogleFonts.montserrat(
                              color: Colors.black,
                              fontSize: 14 * ScreenSize.heightMultiplyingFactor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(),
                    ListTile(
                      leading: Container(
                        width: 60 * ScreenSize.widthMultiplyingFactor,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: CachedNetworkImage(
                            imageUrl:
                                "https://firebasestorage.googleapis.com/v0/b/lost-found-app-2408e.appspot.com/o/asset_images%2F102704231_2569955783257645_3095669080032974985_n.jpg?alt=media&token=c0507fba-a32f-4174-acaf-d4aab84ca824",
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      title: Text(
                        'Sameer Ahmed',
                        style: GoogleFonts.montserrat(
                          color: Colors.black,
                          fontSize: 16 * ScreenSize.heightMultiplyingFactor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'COE | DTU \'23',
                            style: GoogleFonts.montserrat(
                              color: Colors.black,
                              fontSize: 14 * ScreenSize.heightMultiplyingFactor,
                            ),
                          ),
                          Text(
                            'ahmedkhansameer50@gmail.com',
                            style: GoogleFonts.montserrat(
                              color: Colors.black,
                              fontSize: 14 * ScreenSize.heightMultiplyingFactor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 60.0 * ScreenSize.heightMultiplyingFactor,
                ),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "\nDeveloped with ❤ in Flutter",
                        style: GoogleFonts.montserrat(
                          color: Colors.black,
                          fontStyle: FontStyle.italic,
                          fontSize: 14 * ScreenSize.heightMultiplyingFactor,
                        ),
                      ),
                      FlutterLogo(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget aboutUsAppBar() {
  return Scaffold(
    appBar: PreferredSize(
      preferredSize:
          Size.fromHeight(221.0 * ScreenSize.heightMultiplyingFactor),
      child: appBarOverall(heading: 'About Us', searchThere: false),
    ),
  );
}
