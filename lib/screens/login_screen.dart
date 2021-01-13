import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lost_found_app/screens/root_screen.dart';
import 'package:lost_found_app/screens/signup_screen.dart';
import 'package:lost_found_app/widgets/custom_flat_button.dart';
import 'package:lost_found_app/widgets/round_button.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  FocusNode _passwordFocusNode;
  bool _obscureText = true;
  FocusNode _emailFocusNode;
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  Map<String, String> _authDataMap = {
    'email': '',
    'password': '',
  };

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  void initState() {
    _passwordFocusNode = FocusNode();
    _emailFocusNode = FocusNode();
    super.initState();
  }

  void _submit(BuildContext context) async {
    if (!_formKey.currentState.validate()) {
      //Invalid
      return;
    }
    _formKey.currentState.save();
    setState(() {
      isLoading = true;
    });
    Navigator.of(context, rootNavigator: true).pushReplacement(
      MaterialPageRoute(
        builder: (context) => RootScreen(),
      ),
    );

    // await FirebaseRepository().signIn(
    //     _authDataMap['email'], _authDataMap['password'], _scaffoldKey, context);

    setState(() {
      isLoading = false;
    });
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
                height: MediaQuery.of(context).size.height * 0.72,
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
                      child: Container(
                        height: 130,
                        // child: Image(
                        //   width: double.infinity,
                        //   height: 130,
                        //   image: AssetImage(
                        //     "assets/logo.png",
                        //   ),
                        // ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.fromLTRB(24, 8, 24, 14),
                            width: 328,
                            child: TextFormField(
                              focusNode: _emailFocusNode,
                              keyboardType: TextInputType.emailAddress,
                              onFieldSubmitted: (_) {
                                FocusScope.of(context)
                                    .requestFocus(_passwordFocusNode);
                              },
                              // validator: (val) {
                              //   return RegExp(
                              //               r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              //           .hasMatch(val)
                              //       ? null
                              //       : "Enter valid email address";
                              // },
                              onSaved: (val) {
                                _authDataMap['email'] = val.trim();
                              },
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
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
                                    vertical: 6.0, horizontal: 10.0),
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
                            padding: EdgeInsets.fromLTRB(24, 4, 24, 10),
                            width: 328,
                            child: Column(
                              children: [
                                TextFormField(
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  focusNode: _passwordFocusNode,
                                  onSaved: (val) {
                                    _authDataMap['password'] = val;
                                  },
                                  // validator: (val) {
                                  //   if (val.length < 3)
                                  //     return "Password too short";

                                  //   return null;
                                  // },
                                  obscureText: _obscureText,
                                  decoration: InputDecoration(
                                    fillColor: Color.fromRGBO(242, 245, 250, 1),
                                    filled: true,
                                    labelText: "Password",
                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        _toggle();
                                      },
                                      icon: Icon(
                                        _obscureText
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                        color: Color.fromRGBO(19, 60, 109, 1),
                                      ),
                                    ),
                                    labelStyle: GoogleFonts.roboto(
                                      fontWeight: FontWeight.normal,
                                      color: Color.fromRGBO(44, 62, 80, 1),
                                    ),
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 6.0, horizontal: 10.0),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                      borderSide: BorderSide(
                                        width: 0,
                                        style: BorderStyle.none,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Container(
                                  alignment: Alignment.bottomRight,
                                  child: Text('Forgot Password?',
                                      style: GoogleFonts.roboto(
                                        fontSize: 13,
                                        color: Color.fromRGBO(44, 62, 80, 1),
                                      )),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
                      child: isLoading
                          ? CircularProgressIndicator()
                          : CustomFlatButton(
                              title: "SIGN IN",
                              onPressed: () {
                                _submit(context);
                              },
                            ),
                    ),
                    Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            'DON\'T HAVE AN ACCOUNT?',
                            style: GoogleFonts.roboto(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SignUpScreen(),
                                  ));
                            },
                            child: Text(
                              'REGISTER HERE',
                              style: GoogleFonts.roboto(
                                fontSize: 14,
                                color: Color.fromRGBO(19, 60, 109, 1),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.20,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 13),
                      child: Text(
                        'LOGIN USING',
                        style: GoogleFonts.roboto(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(13),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          // RoundButton(
                          //   onPressed: () {},
                          //   image: Image.asset('assets/facebook.png'),
                          // ),
                          RoundButton(
                            onPressed: () {},
                            image: Image.asset(
                              'lib/assets/google.png',
                              width: 50,
                            ),
                          ),
                          // RoundButton(
                          //   onPressed: () {},
                          //   image: Image.asset('assets/twitter.png'),
                          // ),
                        ],
                      ),
                    )
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
