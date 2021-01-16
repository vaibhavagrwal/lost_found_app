import 'dart:io';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:lost_found_app/services/firebase_repository.dart';
import 'package:lost_found_app/util/constants.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CreateAdScreen extends StatefulWidget {
  @override
  _CreateAdScreenState createState() => _CreateAdScreenState();
}

class _CreateAdScreenState extends State<CreateAdScreen> {
  FirebaseRepository _repository = FirebaseRepository();
  TextEditingController headingController;
  TextEditingController descriptionController;
  TextEditingController categoryController;
  TextEditingController placeController;
  bool isLoading;
  clearImage() {
    setState(() {
      _image = null;
    });
  }

  _submit(BuildContext context) async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      setState(() {
        isLoading = true;
      });
      await _repository.createPost(_image, type, heading, category, description,
          where, selectedDate, context);
      setState(() {
        isLoading = false;
        _image = null;
        type = 0;
        headingController.text = "";
        descriptionController.text = "";
        categoryController.text = "";
        placeController.text = "";
        selectedDate = DateTime.now();
      });
    }
  }

  String heading, category, description, where;
  int type;
  DateTime selectedDate;
  File _image;
  final picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();

  var myFormat = DateFormat('d-MM-yyyy');

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2019),
        lastDate: DateTime.now());
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
    heading = "";
    category = "";
    description = "";
    where = "";
    headingController = TextEditingController();
    descriptionController = TextEditingController();
    categoryController = TextEditingController();
    placeController = TextEditingController();

    selectedDate = DateTime.now();
    type = 0;
    isLoading = false;
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
            onPressed: () async {
              await _submit(context);
            },
            child: isLoading
                ? Container()
                : Text(
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
      body: Stack(
        children: [
          Opacity(
            opacity: isLoading ? 0.3 : 1,
            child: AbsorbPointer(
              absorbing: isLoading,
              child: Form(
                key: _formKey,
                child: ListView(
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
                                    child: Center(
                                      child: Column(
                                        children: [
                                          Icon(
                                            Icons.touch_app,
                                            size: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.1,
                                            color: primaryColour,
                                          ),
                                          Text(
                                            'Select a photo',
                                            style: GoogleFonts.poppins(
                                              fontSize: 25,
                                              color: primaryColour,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white10,
                                      border: Border.all(
                                        color: primaryColour,
                                      ),
                                      borderRadius: BorderRadius.circular(
                                        20,
                                      ),
                                    ),
                                  )
                                : Stack(
                                    children: [
                                      Container(
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
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: 90.0, right: 100.0),
                                        child: GestureDetector(
                                          onTap: () {
                                            clearImage();
                                          },
                                          child: new CircleAvatar(
                                            backgroundColor: primaryColour,
                                            radius: 25.0,
                                            child: new Icon(
                                              Icons.delete,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10.0),
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.1,
                        ),
                        Radio(
                          activeColor: primaryColour,
                          value: 0,
                          groupValue: type,
                          onChanged: (val) {
                            setState(() {
                              type = val;
                            });
                          },
                        ),
                        Text(
                          'Lost',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.2,
                        ),
                        Radio(
                          activeColor: primaryColour,
                          value: 1,
                          groupValue: type,
                          onChanged: (val) {
                            setState(() {
                              type = val;
                            });
                          },
                        ),
                        Text(
                          'Found',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    Divider(),
                    ListTile(
                      leading: FaIcon(
                        FontAwesomeIcons.heading,
                        color: primaryColour,
                      ),
                      title: Container(
                        width: 250.0,
                        child: TextFormField(
                          controller: headingController,
                          decoration: InputDecoration(
                            hintText: "Write a heading...",
                            border: InputBorder.none,
                          ),
                          validator: (val) {
                            if (val.length == 0) {
                              return "Heading cannot be empty!";
                            }
                            return null;
                          },
                          onSaved: (val) {
                            heading = val;
                          },
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
                        child: TextFormField(
                          controller: categoryController,
                          decoration: InputDecoration(
                            hintText: "Write a category...",
                            border: InputBorder.none,
                          ),
                          validator: (val) {
                            if (val.length == 0) {
                              return "Category cannot be empty!";
                            }
                            return null;
                          },
                          onSaved: (val) {
                            category = val;
                          },
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
                        child: TextFormField(
                          controller: descriptionController,
                          minLines: 2,
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
                          validator: (val) {
                            if (val.length <= 4) {
                              return "Description too short!";
                            }
                            return null;
                          },
                          onSaved: (val) {
                            description = val;
                          },
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
                        child: TextFormField(
                          controller: placeController,
                          validator: (val) {
                            if (val.length == 0) {
                              return "Place cannot be empty!";
                            }
                            return null;
                          },
                          onSaved: (val) {
                            where = val;
                          },
                          decoration: InputDecoration(
                            hintText: "Where...",
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    Divider(),
                    ListTile(
                      leading: Icon(
                        Icons.calendar_today,
                        color: primaryColour,
                      ),
                      title: Container(
                        padding: EdgeInsets.only(
                          left: 20,
                        ),
                        width: 150,
                        height: 48,
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
                                decoration: InputDecoration(
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
                    ),
                  ],
                ),
              ),
            ),
          ),
          Opacity(
            opacity: isLoading ? 1.0 : 0,
            child: Center(
              child: SpinKitCircle(
                color: primaryColour,
                size: 80,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
