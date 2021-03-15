import 'package:flutter/material.dart';
import 'package:lost_found_app/screens/create_ad_screen.dart';
import 'package:lost_found_app/screens/home_screen.dart';
import 'package:lost_found_app/screens/home_screen1.dart';
import 'package:lost_found_app/screens/my_ad_screen.dart';
import 'package:lost_found_app/screens/profile_screen.dart';

class TabNavigator extends StatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  final String tabItem;
  TabNavigator({this.navigatorKey, this.tabItem});

  @override
  _TabNavigatorState createState() => _TabNavigatorState();
}

class _TabNavigatorState extends State<TabNavigator> {
  @override
  Widget build(BuildContext context) {
    Widget child;

    if (widget.tabItem == "Home")
      child = HomeScreen1();
    else if (widget.tabItem == "CreateAd")
      child = CreateAdScreen();
    else if (widget.tabItem == "MyAd")
      child = MyAdScreen();
    else if (widget.tabItem == "Profile") child = ProfileScreen();

    return Navigator(
      key: widget.navigatorKey,
      onGenerateRoute: (routeSettings) {
        return MaterialPageRoute(
          builder: (context) => child,
        );
      },
    );
  }
}
