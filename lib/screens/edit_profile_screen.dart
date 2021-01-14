import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lost_found_app/services/firebase_repository.dart';
import 'package:lost_found_app/util/constants.dart';
import 'package:lost_found_app/main.dart';
import 'package:lost_found_app/util/screen_size.dart';
import 'package:image_picker/image_picker.dart';

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
          toolbarHeight: 80,
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
                InkWell(
                  onTap: () {
                    _pickImage();
                  },
                  child: Padding(
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
                                  image: _image == null
                                      ? CachedNetworkImageProvider(
                                          user.imageUrl == ""
                                              ? "https://i.pinimg.com/474x/67/c3/d6/67c3d63e215e034e01d45c8256d720d3.jpg"
                                              : user.imageUrl,
                                        )
                                      : FileImage(_image),
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
                ),
                SizedBox(
                  height: 30.0 * ScreenSize.heightMultiplyingFactor,
                ),
                Padding(
                    padding:
                        EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
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
                        child: new TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            hintText: "Enter Your Name",
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
                  height: 10.0 * ScreenSize.heightMultiplyingFactor,
                ),
                Padding(
                    padding:
                        EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
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
                        child: new Text(
                          user.email,
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                    padding:
                        EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
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
                        child: _phoneController.text == ""
                            ? TextFormField(
                                validator: (val) {
                                  if (val.trim().length != 10) {
                                    return "Invalid!";
                                  }
                                  return null;
                                },
                                onChanged: (val) {
                                  phone = val.trim();
                                },
                                onSaved: (val) {
                                  phone = val.trim();
                                },
                                keyboardType: TextInputType.phone,
                                decoration: InputDecoration(
                                    hintText: "Enter Mobile Number"),
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(10),
                                ],
                              )
                            : TextFormField(
                                controller: _phoneController,
                                validator: (val) {
                                  if (val.trim().length != 10) {
                                    return "Invalid!";
                                  }
                                  return null;
                                },
                                onChanged: (val) {
                                  phone = val.trim();
                                },
                                onSaved: (val) {
                                  phone = val.trim();
                                },
                                keyboardType: TextInputType.phone,
                                decoration: InputDecoration(
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
                    _scaffoldKey.currentState.showSnackBar(
                      SnackBar(content: Text("Nothing To Update!")),
                    );
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
