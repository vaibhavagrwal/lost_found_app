import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lost_found_app/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'screens/login_screen.dart';
import 'screens/root_screen.dart';

final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

UserModel user;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  SharedPreferences pref = await SharedPreferences.getInstance();
  if (pref.getString('userData') != null) {
    Map json = jsonDecode(pref.getString('userData'));
    print(json);
    user = UserModel.fromJson(json);
    print(user.name);
    print(user.userId);
  }

  runApp(MyApp(
    screen: pref.getString('userData') == null ? LoginScreen() : RootScreen(),
  ));
}

class MyApp extends StatelessWidget {
  final Widget screen;

  MyApp({this.screen});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: screen,
    );
  }
}
