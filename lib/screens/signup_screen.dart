import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lost_found_app/screens/login_screen.dart';
import 'package:lost_found_app/services/firebase_repository.dart';
import 'package:lost_found_app/util/constants.dart';
import 'package:lost_found_app/util/screen_size.dart';
import 'package:lost_found_app/widgets/custom_flat_button.dart';
import 'package:lost_found_app/widgets/round_button.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key key}) : super(key: key);
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  FocusNode _nameFocusNode;
  FocusNode _passwordFocusNode;
  FocusNode _emailFocusNode;
  FocusNode _confirmFocusNode;
  bool _googleLoading = false;

  bool _obscureText1 = true;
  bool _obscureText2 = true;
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  void _toggle1() {
    setState(() {
      _obscureText1 = !_obscureText1;
    });
  }

  void _toggle2() {
    setState(() {
      _obscureText2 = !_obscureText2;
    });
  }

  @override
  void initState() {
    _nameFocusNode = FocusNode();
    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();

    super.initState();
  }

  @override
  void dispose() {
    _nameFocusNode.dispose();
    _passwordFocusNode.dispose();
    _emailFocusNode.dispose();
    super.dispose();
  }

  Map<String, dynamic> _authDataMap = {
    'name': '',
    'email': '',
    'password': '',
    'confirm_password': '',
  };

  void _submit(BuildContext context) async {
    if (!_formKey.currentState.validate()) {
      //Invalid
      return;
    }

    _formKey.currentState.save();
    setState(() {
      isLoading = true;
    });

    FirebaseRepository _repository = FirebaseRepository();
    await _repository.signUp(_authDataMap['name'], _authDataMap['email'],
        _authDataMap['password'], _scaffoldKey, context);
    setState(() {
      isLoading = false;
    });

    _nameController.text = "";
    _emailController.text = "";
    _passwordController.text = "";
    _confirmPasswordController.text = "";
    FocusScope.of(context).requestFocus(_nameFocusNode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 576 * ScreenSize.heightMultiplyingFactor,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(36),
                    bottomLeft: Radius.circular(36),
                  ),
                  boxShadow: [
                    BoxShadow(
                        color: Color.fromRGBO(26, 80, 152, 0.1),
                        blurRadius: 20,
                        offset: Offset(0, 8),
                        spreadRadius: 6 // changes position of shadow
                        ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Center(
                      child: Image(
                        width: double.infinity,
                        height: 160 * ScreenSize.heightMultiplyingFactor,
                        image: AssetImage(
                          "lib/assets/logo.png",
                        ),
                      ),
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.fromLTRB(
                                24 * ScreenSize.heightMultiplyingFactor,
                                8 * ScreenSize.widthMultiplyingFactor,
                                24 * ScreenSize.heightMultiplyingFactor,
                                8 * ScreenSize.widthMultiplyingFactor),
                            width: 328 * ScreenSize.widthMultiplyingFactor,
                            child: TextFormField(
                              controller: _nameController,
                              focusNode: _nameFocusNode,
                              onFieldSubmitted: (_) {
                                FocusScope.of(context)
                                    .requestFocus(_emailFocusNode);
                              },
                              keyboardType: TextInputType.emailAddress,
                              onSaved: (val) {
                                _authDataMap['name'] = val.trim();
                              },
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                fillColor: Color.fromRGBO(242, 245, 250, 1),
                                filled: true,
                                labelText: "Name",
                                labelStyle: GoogleFonts.roboto(
                                  fontWeight: FontWeight.normal,
                                  color: Color.fromRGBO(44, 62, 80, 1),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  vertical:
                                      6.0 * ScreenSize.heightMultiplyingFactor,
                                  horizontal:
                                      10.0 * ScreenSize.widthMultiplyingFactor,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                  borderSide: BorderSide(
                                    width: 0,
                                    style: BorderStyle.none,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(
                                24 * ScreenSize.heightMultiplyingFactor,
                                8 * ScreenSize.widthMultiplyingFactor,
                                24 * ScreenSize.heightMultiplyingFactor,
                                8 * ScreenSize.widthMultiplyingFactor),
                            width: 328 * ScreenSize.widthMultiplyingFactor,
                            child: TextFormField(
                              controller: _emailController,
                              focusNode: _emailFocusNode,
                              onFieldSubmitted: (_) {
                                FocusScope.of(context)
                                    .requestFocus(_passwordFocusNode);
                              },
                              keyboardType: TextInputType.emailAddress,
                              onSaved: (val) {
                                _authDataMap['email'] = val.trim();
                              },
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                fillColor: Color.fromRGBO(242, 245, 250, 1),
                                filled: true,
                                labelText: "Email",
                                labelStyle: GoogleFonts.roboto(
                                  fontWeight: FontWeight.normal,
                                  color: Color.fromRGBO(44, 62, 80, 1),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 6.0 *
                                        ScreenSize.heightMultiplyingFactor,
                                    horizontal: 10.0 *
                                        ScreenSize.widthMultiplyingFactor),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                  borderSide: BorderSide(
                                    width: 0,
                                    style: BorderStyle.none,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(
                                24 * ScreenSize.heightMultiplyingFactor,
                                4 * ScreenSize.widthMultiplyingFactor,
                                24 * ScreenSize.heightMultiplyingFactor,
                                4 * ScreenSize.widthMultiplyingFactor),
                            width: 328 * ScreenSize.widthMultiplyingFactor,
                            child: TextFormField(
                              controller: _passwordController,

                              focusNode: _passwordFocusNode,

                              onFieldSubmitted: (_) {
                                FocusScope.of(context)
                                    .requestFocus(_confirmFocusNode);
                              },
                              obscureText: _obscureText1,

                              validator: (val) {
                                if (val.length < 6)
                                  return "Password must be of atleast 6 characters";

                                return null;
                              },
                              onSaved: (val) {
                                _authDataMap['password'] = val.trim();
                              },
                              // inputFormatters: [R
                              //   LengthLimitingTextInputFormatter(10),
                              // ],
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    _toggle1();
                                  },
                                  icon: Icon(
                                    _obscureText1
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Color.fromRGBO(19, 60, 109, 1),
                                  ),
                                ),
                                fillColor: Color.fromRGBO(242, 245, 250, 1),
                                filled: true,
                                labelText: "Password",
                                labelStyle: GoogleFonts.roboto(
                                  fontWeight: FontWeight.normal,
                                  color: Color.fromRGBO(44, 62, 80, 1),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 6.0 *
                                        ScreenSize.heightMultiplyingFactor,
                                    horizontal: 10.0 *
                                        ScreenSize.widthMultiplyingFactor),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                  borderSide: BorderSide(
                                    width: 0,
                                    style: BorderStyle.none,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(
                              24 * ScreenSize.heightMultiplyingFactor,
                              4 * ScreenSize.widthMultiplyingFactor,
                              24 * ScreenSize.heightMultiplyingFactor,
                              4 * ScreenSize.widthMultiplyingFactor,
                            ),
                            width: 328 * ScreenSize.widthMultiplyingFactor,
                            child: TextFormField(
                              focusNode: _confirmFocusNode,
                              controller: _confirmPasswordController,
                              validator: (val) {
                                if (val != _passwordController.text)
                                  return "Confirm password must be same as password";

                                return null;
                              },
                              obscureText: _obscureText2,
                              onFieldSubmitted: (_) {
                                FocusScope.of(context)
                                    .requestFocus(_nameFocusNode);
                              },
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    _toggle2();
                                  },
                                  icon: Icon(
                                    _obscureText2
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Color.fromRGBO(19, 60, 109, 1),
                                  ),
                                ),
                                fillColor: Color.fromRGBO(242, 245, 250, 1),
                                filled: true,
                                labelText: "Confirm Password",
                                labelStyle: GoogleFonts.roboto(
                                  fontWeight: FontWeight.normal,
                                  color: Color.fromRGBO(44, 62, 80, 1),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 6.0 *
                                        ScreenSize.heightMultiplyingFactor,
                                    horizontal: 10.0 *
                                        ScreenSize.widthMultiplyingFactor),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                  borderSide: BorderSide(
                                    width: 0,
                                    style: BorderStyle.none,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 15 * ScreenSize.heightMultiplyingFactor,
                    ),
                    isLoading
                        ? SpinKitWanderingCubes(
                            color: primaryColour,
                          )
                        : CustomFlatButton(
                            title: "SIGN UP",
                            onPressed: () {
                              _submit(context);
                            },
                          ),
                    SizedBox(
                      height: 5 * ScreenSize.heightMultiplyingFactor,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'ALREADY HAVE AN ACCOUNT?',
                          style: GoogleFonts.roboto(
                            fontSize: 14 * ScreenSize.heightMultiplyingFactor,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 8 * ScreenSize.heightMultiplyingFactor,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LoginScreen(),
                                ));
                          },
                          child: Text(
                            'Log In Here',
                            style: GoogleFonts.roboto(
                              fontSize: 14 * ScreenSize.heightMultiplyingFactor,
                              color: Color.fromRGBO(19, 60, 109, 1),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10 * ScreenSize.heightMultiplyingFactor,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                height: 152 * ScreenSize.heightMultiplyingFactor,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                          top: 13 * ScreenSize.heightMultiplyingFactor),
                      child: Text(
                        'SIGN UP USING ',
                        style: GoogleFonts.roboto(
                          fontSize: 14 * ScreenSize.heightMultiplyingFactor,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(
                          13 * ScreenSize.heightMultiplyingFactor),
                      child: _googleLoading
                          ? SpinKitWanderingCubes(
                              color: primaryColour,
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                RoundButton(
                                  onPressed: () async {
                                    setState(() {
                                      _googleLoading = true;
                                    });
                                    await FirebaseRepository()
                                        .signInGoogle(context, _scaffoldKey);
                                    setState(() {
                                      _googleLoading = false;
                                    });
                                  },
                                  image: Image.asset(
                                    'lib/assets/google.png',
                                    width:
                                        50 * ScreenSize.widthMultiplyingFactor,
                                  ),
                                ),
                              ],
                            ),
                    ),
                    GestureDetector(
                        onTap: () {
                          showDialogFunc(context);
                        },
                        child: Container(
                          padding: EdgeInsets.only(
                            bottom: 10 * ScreenSize.heightMultiplyingFactor,
                          ),
                          child: RichText(
                            text: TextSpan(
                              text: 'By Clicking Sign Up, You Agree To Our ',
                              style: GoogleFonts.roboto(
                                fontSize:
                                    11 * ScreenSize.heightMultiplyingFactor,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                              children: [
                                TextSpan(
                                  text: 'Term And Conditions',
                                  style: GoogleFonts.roboto(
                                    fontSize:
                                        11 * ScreenSize.heightMultiplyingFactor,
                                    fontWeight: FontWeight.w600,
                                    color: Color.fromRGBO(19, 60, 109, 1),
                                  ),
                                ),
                              ],
                            ),
                          ),
//                        text: Text(
//                            'By Clicking Sign Up, You Agree To Our Term And Conditions',
//                          style: GoogleFonts.roboto(
//                            fontSize: 12,
//                            fontWeight: FontWeight.w600,
//                            color: Colors.black,
//                          ),
//                        ),
//                      ),
                        )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

showDialogFunc(context) {
  return showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: Material(
            type: MaterialType.transparency,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              padding: EdgeInsets.all(15),
              height: 320,
              width: MediaQuery.of(context).size.width * 0.7,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    // width: 200,
                    child: Align(
                      alignment: Alignment.center,
                      child: FlatButton(
                        onPressed: () {},
                        color: Color.fromRGBO(19, 60, 109, 1),
                        height: 15,
                        minWidth: 100,
                        child: Text("ACCEPT",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                            )),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      });
}
