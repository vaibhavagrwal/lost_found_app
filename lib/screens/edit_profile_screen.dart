import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lost_found_app/util/constants.dart';
import 'package:lost_found_app/main.dart';
import 'package:lost_found_app/util/screen_size.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(80),
          child: appBarOverall(
            heading: "Edit Profile",
            onPressed: () {},
            searchThere: false,
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 20.0),
                child: new Stack(fit: StackFit.loose, children: <Widget>[
                  new Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new Container(
                          width: 140.0,
                          height: 140.0,
                          decoration: new BoxDecoration(
                            shape: BoxShape.circle,
                            image: new DecorationImage(
                              image: CachedNetworkImageProvider(
                                user.imageUrl == ""
                                    ? "https://i.pinimg.com/474x/67/c3/d6/67c3d63e215e034e01d45c8256d720d3.jpg"
                                    : user.imageUrl,
                              ),
                              fit: BoxFit.cover,
                            ),
                          )),
                    ],
                  ),
                  Padding(
                      padding: EdgeInsets.only(top: 90.0, right: 100.0),
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          new CircleAvatar(
                            backgroundColor: primaryColour,
                            radius: 25.0,
                            child: new Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                            ),
                          )
                        ],
                      )),
                ]),
              ),
              SizedBox(
                height: 30.0 * ScreenSize.heightMultiplyingFactor,
              ),
              Padding(
                  padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
                  child: new Row(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      new Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          new Text(
                            'Name',
                            style: TextStyle(
                                fontSize: 16.0, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  )),
              Padding(
                padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 0.0),
                child: new Row(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    new Flexible(
                      child: new TextField(
                        decoration: const InputDecoration(
                          hintText: "Enter Your Name",
                        ),
                        // enabled: !_status,
                        // autofocus: !_status,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10.0 * ScreenSize.heightMultiplyingFactor,
              ),
              Padding(
                  padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
                  child: new Row(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      new Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          new Text(
                            'Email ID',
                            style: TextStyle(
                                fontSize: 16.0, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  )),
              Padding(
                padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 0.0),
                child: new Row(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    new Flexible(
                      child: new TextField(
                        decoration:
                            const InputDecoration(hintText: "Enter Email ID"),
                        // enabled: !_status,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                  padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
                  child: new Row(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      new Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          new Text(
                            'Mobile',
                            style: TextStyle(
                                fontSize: 16.0, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  )),
              Padding(
                padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 2.0),
                child: new Row(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Flexible(
                      child: Container(
                        color: Colors.white,
                        child: new Text(
                          "+91",
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                          ),
                          // enabled: !_status,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Flexible(
                      child: new TextField(
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                            hintText: "Enter Mobile Number"),
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(10),
                        ],
                        // enabled: !_status,
                      ),
                    ),
                  ],
                ),
              ),
              _getActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getActionButtons() {
    return Padding(
      padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 45.0),
      child: new Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: Container(
                  child: new RaisedButton(
                child: new Text(
                  "Save",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                  ),
                ),
                textColor: Colors.white,
                color: Colors.green,
                onPressed: () {
                  setState(() {
                    // _status = true;
                    FocusScope.of(context).requestFocus(new FocusNode());
                  });
                },
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(20.0)),
              )),
            ),
            flex: 2,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Container(
                  child: new RaisedButton(
                child: new Text(
                  "Cancel",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                  ),
                ),
                textColor: Colors.white,
                color: Colors.red,
                onPressed: () {
                  setState(() {
                    // _status = true;
                    FocusScope.of(context).requestFocus(new FocusNode());
                  });
                },
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(20.0)),
              )),
            ),
            flex: 2,
          ),
        ],
      ),
    );
  }
}
