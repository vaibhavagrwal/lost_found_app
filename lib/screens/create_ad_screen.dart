import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:lost_found_app/main.dart';
import 'package:lost_found_app/util/constants.dart';

class CreateAdScreen extends StatefulWidget {
  @override
  _CreateAdScreenState createState() => _CreateAdScreenState();
}

class _CreateAdScreenState extends State<CreateAdScreen> {
  clearImage() {
    setState(() {
      _image = null;
    });
  }

  DateTime selectedDate;
  TimeOfDay selectedTime;
  File _image;
  final picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();

  var myFormat = DateFormat('d-MM-yyyy');
  var timeFormat = DateFormat('h:mm a');

  Future<void> _selectTime(BuildContext context) async {
    TimeOfDay timePicked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    setState(() {
      selectedTime = timePicked ?? selectedTime;
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime.now(),
        lastDate: DateTime(2101));
    setState(() {
      selectedDate = picked ?? selectedDate;
    });
  }

  Future<void> _pickImage() async {
    final pickedImage = await picker.getImage(
        source: ImageSource.gallery, imageQuality: 50, maxWidth: 200);
    setState(() {
      _image = File(pickedImage.path);
    });
  }

  @override
  void didChangeDependencies() {
    selectedDate = DateTime.now();
    selectedTime = TimeOfDay.now();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60,
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
          " Create Post ",
          style: GoogleFonts.roboto(
              color: Color.fromRGBO(44, 62, 80, 1),
              fontSize: 20,
              fontWeight: FontWeight.w600),
        ),
        actions: [
          FlatButton(
            onPressed: () => print('pressed'),
            child: Text(
              "Post",
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(
              top: 20,
            ),
            height: 150.0,
            width: MediaQuery.of(context).size.width * 0.6,
            child: Center(
              child: GestureDetector(
                onTap: () {
                  _pickImage();
                },
                child: AspectRatio(
                  aspectRatio: 12 / 7,
                  child: _image == null
                      ? Container(
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(
                              20,
                            ),
                          ),
                        )
                      : Container(
                          decoration: BoxDecoration(
                            color: Colors.white10,
                            borderRadius: BorderRadius.circular(
                              20,
                            ),
                            image: DecorationImage(
                              // fit: BoxFit.cover,
                              image: FileImage(
                                _image,
                              ),
                            ),
                          ),
                        ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10.0),
          ),
          ListTile(
            leading: FaIcon(
              FontAwesomeIcons.heading,
              color: primaryColour,
            ),
            title: Container(
              width: 250.0,
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Write a heading...",
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Divider(),
          ListTile(
            leading: FaIcon(
              FontAwesomeIcons.listAlt,
              color: primaryColour,
            ),
            title: Container(
              width: 250.0,
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Write a category...",
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Divider(),
          ListTile(
            leading: FaIcon(
              FontAwesomeIcons.fileAlt,
              color: primaryColour,
              size: 35.0,
            ),
            title: Container(
              width: 250.0,
              child: TextField(
                minLines: 3,
                maxLines: 30,
                decoration: InputDecoration(
                  hintText: "Description",
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      16,
                    ),
                    borderSide: BorderSide(
                      color: primaryColour,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      16,
                    ),
                    borderSide: BorderSide(
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Divider(),
          ListTile(
            leading: FaIcon(
              FontAwesomeIcons.mapPin,
              color: primaryColour,
            ),
            title: Container(
              width: 250.0,
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Where...",
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Divider(),
          ListTile(
            title: Row(
              children: [
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: 150,
                        height: 60,
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
                        child: Center(
                          child: InkWell(
                            onTap: () => _selectDate(context),
                            child: IgnorePointer(
                              child: TextFormField(
                                // controller: _datecontroller,

                                decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.calendar_today_rounded,
                                    color: primaryColour,
                                  ),
                                  border: InputBorder.none,
                                  hintText:
                                      ('${myFormat.format(selectedDate)}'),
                                  hintStyle: GoogleFonts.roboto(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 5),
                  width: 150,
                  height: 60,
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
                  child: Center(
                    child: InkWell(
                      onTap: () => _selectTime(context),
                      child: IgnorePointer(
                        child: TextFormField(
                          // controller: _timeController,

                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              FontAwesomeIcons.clock,
                              color: primaryColour,
                            ),
                            border: InputBorder.none,
                            hintText: ('${selectedTime.format(context)}'),
                            hintStyle: GoogleFonts.roboto(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Container(
          //   width: 200.0,
          //   height: 100.0,
          //   alignment: Alignment.center,
          //   child: RaisedButton.icon(
          //     label: Text(
          //       "Use Current Location",
          //       style: TextStyle(color: Colors.white),
          //     ),
          //     shape: RoundedRectangleBorder(
          //       borderRadius: BorderRadius.circular(30.0),
          //     ),
          //     color: Colors.blue,
          //     onPressed: () => print('get user location'),
          //     icon: Icon(
          //       Icons.my_location,
          //       color: Colors.white,
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
