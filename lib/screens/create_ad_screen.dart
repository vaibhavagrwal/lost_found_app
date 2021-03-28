import 'dart:io';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:lost_found_app/services/firebase_repository.dart';
import 'package:lost_found_app/util/constants.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lost_found_app/util/screen_size.dart';
import 'drawer_screen.dart';

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

      int res = await _repository.createPost(_image, type, heading, category,
          description, where, selectedDate, context);
      setState(() {
        print("11111111");
        isLoading = false;
      });
      if (res == 0) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return StatefulBuilder(
              builder: (context, StateSetter _setState) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(32.0))),
                  title: Center(
                    child: FaIcon(
                      FontAwesomeIcons.checkCircle,
                      size: 80 * ScreenSize.heightMultiplyingFactor,
                      color: Colors.green,
                    ),
                  ),
                  content: Container(
                    height: 110 * ScreenSize.heightMultiplyingFactor,
                    width: MediaQuery.of(context).size.width * 0.3,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          'SUCCESS',
                          style: GoogleFonts.montserrat(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Center(
                          child: Text(
                            'Your Post has been created!',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.montserrat(
                              fontSize: 15 * ScreenSize.heightMultiplyingFactor,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10 * ScreenSize.heightMultiplyingFactor,
                        ),
                        RaisedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            'OK',
                            style: TextStyle(
                              fontSize: 15 * ScreenSize.heightMultiplyingFactor,
                            ),
                          ),
                          color: primaryColour,
                          textColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
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
      } else {
        setState(() {
          isLoading = false;
        });
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return StatefulBuilder(
              builder: (context, StateSetter _setState) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(32.0))),
                  title: Center(
                    child: FaIcon(
                      FontAwesomeIcons.exclamationCircle,
                      size: 80 * ScreenSize.heightMultiplyingFactor,
                      color: Colors.red,
                    ),
                  ),
                  content: Container(
                    height: 110 * ScreenSize.heightMultiplyingFactor,
                    width: MediaQuery.of(context).size.width * 0.3,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          'ERROR',
                          style: GoogleFonts.montserrat(
                            fontSize: 25 * ScreenSize.heightMultiplyingFactor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Center(
                          child: Text(
                            'Please try again!',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.montserrat(
                              fontSize: 15 * ScreenSize.heightMultiplyingFactor,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10 * ScreenSize.heightMultiplyingFactor,
                        ),
                        RaisedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              fontSize: 15 * ScreenSize.heightMultiplyingFactor,
                            ),
                          ),
                          color: primaryColour,
                          textColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
      }
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
      drawer: DrawerScreen(),
      appBar: AppBar(
        toolbarHeight: 60 * ScreenSize.heightMultiplyingFactor,
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(30.0),
            bottomLeft: Radius.circular(30.0),
          ),
        ),
        backgroundColor: primaryColour,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        title: Text(
          " Create Post ",
          style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 20 * ScreenSize.heightMultiplyingFactor,
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
                      color: Colors.lightGreenAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0 * ScreenSize.heightMultiplyingFactor,
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
                        top: 20 * ScreenSize.heightMultiplyingFactor,
                      ),
                      height: 150.0 * ScreenSize.heightMultiplyingFactor,
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
                                            Icons.camera_alt,
                                            size: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.1,
                                            color: primaryColour,
                                          ),
                                          SizedBox(
                                            height: 16 *
                                                ScreenSize
                                                    .heightMultiplyingFactor,
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
                      padding: EdgeInsets.only(
                          top: 10.0 * ScreenSize.heightMultiplyingFactor),
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
                            fontSize: 16 * ScreenSize.heightMultiplyingFactor,
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
                            fontSize: 16 * ScreenSize.heightMultiplyingFactor,
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
                        width: 250.0 * ScreenSize.widthMultiplyingFactor,
                        child: TextFormField(
                          controller: headingController,
                          decoration: InputDecoration(
                            hintStyle: GoogleFonts.poppins(),
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
                        width: 250.0 * ScreenSize.widthMultiplyingFactor,
                        child: TextFormField(
                          controller: categoryController,
                          decoration: InputDecoration(
                            hintText: "Write a category...",
                            hintStyle: GoogleFonts.poppins(),
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
                        size: 35.0 * ScreenSize.heightMultiplyingFactor,
                      ),
                      title: Container(
                        width: 250.0 * ScreenSize.widthMultiplyingFactor,
                        child: TextFormField(
                          controller: descriptionController,
                          minLines: 2,
                          maxLines: 30,
                          decoration: InputDecoration(
                            hintText: "Description",
                            hintStyle: GoogleFonts.poppins(),
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
                        width: 250.0 * ScreenSize.widthMultiplyingFactor,
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
                            hintStyle: GoogleFonts.poppins(),
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
                          left: 20 * ScreenSize.widthMultiplyingFactor,
                        ),
                        width: 150 * ScreenSize.widthMultiplyingFactor,
                        height: 48 * ScreenSize.heightMultiplyingFactor,
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
                                  hintStyle: GoogleFonts.poppins(
                                    fontSize:
                                        16 * ScreenSize.heightMultiplyingFactor,
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
                size: 80 * ScreenSize.widthMultiplyingFactor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
