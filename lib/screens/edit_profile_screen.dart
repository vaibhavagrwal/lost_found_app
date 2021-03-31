import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:lost_found_app/services/firebase_repository.dart';
import 'package:lost_found_app/util/constants.dart';
import 'package:lost_found_app/main.dart';
import 'package:lost_found_app/util/screen_size.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String name;
  String email;
  String phone;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();

    super.dispose();
  }

  @override
  void didChangeDependencies() {
    isLoading = false;
    _nameController.text = user.name;
    _emailController.text = user.email;
    _phoneController.text = user.phone;
    name = _nameController.text;
    email = _emailController.text;
    phone = _phoneController.text;
    super.didChangeDependencies();
  }

  bool isLoading;
  File _image;
  final picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();
  Future<void> _pickImage() async {
    final pickedImage = await picker.getImage(
        source: ImageSource.gallery, imageQuality: 50, maxWidth: 200);
    setState(() {
      _image = File(pickedImage.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context, user);
            },
            icon: Icon(
              Icons.arrow_back,
            ),
          ),
          toolbarHeight: 80 * ScreenSize.heightMultiplyingFactor,
          backgroundColor: primaryColour,
          title: Text(
            "Edit Profile",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(20.0),
              bottomLeft: Radius.circular(20.0),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Container(
                  child: Padding(
                    padding: EdgeInsets.only(
                        top: 20.0 * ScreenSize.heightMultiplyingFactor),
                    child: new Stack(
                      fit: StackFit.loose,
                      children: <Widget>[
                        new Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            new Container(
                                width:
                                    180.0 * ScreenSize.widthMultiplyingFactor,
                                height:
                                    180.0 * ScreenSize.widthMultiplyingFactor,
                                decoration: new BoxDecoration(
                                  boxShadow: <BoxShadow>[
                                    BoxShadow(
                                      color: Color.fromRGBO(26, 80, 152, 0.1),
                                      offset: Offset(8.0, 8.0),
                                      blurRadius: 6.0,
                                    ),
                                  ],
                                  color: Color.fromRGBO(252, 255, 300, 1),
                                  shape: BoxShape.circle,
                                  image: new DecorationImage(
                                    image: AssetImage("lib/assets/face1.gif"),
                                    fit: BoxFit.cover,
                                  ),
                                )),
                          ],
                        ),
                        // Padding(
                        //   padding: EdgeInsets.only(top: 90.0, right: 100.0),
                        //   child: new Row(
                        //     mainAxisAlignment: MainAxisAlignment.center,
                        //     children: <Widget>[
                        //       new CircleAvatar(
                        //         backgroundColor: primaryColour,
                        //         radius: 25.0,
                        //         child: new Icon(
                        //           Icons.camera_alt,
                        //           color: Colors.white,
                        //         ),
                        //       )
                        //     ],
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 80.0 * ScreenSize.heightMultiplyingFactor,
                ),
                // Padding(
                //   padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
                //   child: new Row(
                //     mainAxisSize: MainAxisSize.max,
                //     children: <Widget>[
                //       new Column(
                //         mainAxisAlignment: MainAxisAlignment.start,
                //         mainAxisSize: MainAxisSize.min,
                //         children: <Widget>[
                //           new Text(
                //             'Name',
                //             style: TextStyle(
                //                 fontSize: 16.0, fontWeight: FontWeight.bold),
                //           ),
                //         ],
                //       ),
                //     ],
                //   ),
                // ),
                Padding(
                  padding: EdgeInsets.only(
                      left: 25.0 * ScreenSize.widthMultiplyingFactor,
                      right: 25.0 * ScreenSize.widthMultiplyingFactor,
                      top: 0.0),
                  child: new Row(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      new Flexible(
                        child: new TextFormField(
                          controller: _nameController,

                          decoration: InputDecoration(
                            fillColor: Color.fromRGBO(242, 245, 250, 1),
                            filled: true,
                            labelText: "Name",
                            enabled: true,
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: primaryColour,
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: primaryColour,
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            hintText: "Enter your name..",
                          ),

                          onSaved: (val) {
                            name = val.trim();
                          },
                          // enabled: !_status,
                          // autofocus: !_status,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20.0 * ScreenSize.heightMultiplyingFactor,
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: 25.0 * ScreenSize.widthMultiplyingFactor,
                      right: 25.0 * ScreenSize.widthMultiplyingFactor,
                      top: 0.0),
                  child: new Row(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      new Flexible(
                        child: new TextFormField(
                          controller: _emailController,
                          readOnly: true,
                          decoration: InputDecoration(
                            fillColor: Color.fromRGBO(242, 245, 250, 1),
                            filled: true,
                            labelText: "Email ID",
                            enabled: true,
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: primaryColour,
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: primaryColour,
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),

                          // enabled: !_status,
                          // autofocus: !_status,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20.0 * ScreenSize.heightMultiplyingFactor,
                ),
                _getActionButtons(_scaffoldKey),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _getActionButtons(_scaffoldKey) {
    return Padding(
      padding: EdgeInsets.only(
          left: 25.0 * ScreenSize.widthMultiplyingFactor,
          right: 25.0 * ScreenSize.widthMultiplyingFactor,
          top: 45.0 * ScreenSize.heightMultiplyingFactor),
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
                    fontSize: 18 * ScreenSize.heightMultiplyingFactor,
                  ),
                ),
                textColor: Colors.white,
                color: Colors.green,
                onPressed: () async {
                  if (phone != user.phone ||
                      _nameController.text != user.name ||
                      _image != null) {
                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();
                      setState(() {
                        isLoading = true;
                      });
                      await FirebaseRepository().updateUserInfo(
                        _image,
                        name,
                        phone,
                        _scaffoldKey,
                        context,
                      );
                      setState(() {
                        isLoading = false;
                      });
                    }
                  } else {
                    Flushbar(
                      title: "Nothing To Update!",
                      margin: EdgeInsets.all(8),
                      borderRadius: 8,
                      message: " ",
                      backgroundColor: Colors.green,
                      duration: Duration(seconds: 3),
                    )..show(context);
                  }

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
                    fontSize: 18 * ScreenSize.heightMultiplyingFactor,
                  ),
                ),
                textColor: Colors.white,
                color: Colors.red,
                onPressed: () {
                  setState(() {
                    Navigator.pop(context, user);
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
