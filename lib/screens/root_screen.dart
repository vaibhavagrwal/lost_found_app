import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:lost_found_app/screens/tab_navigator.dart';
import 'package:provider/provider.dart';

class RootScreen extends StatefulWidget {
  @override
  _RootScreenState createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  int _selectedIndex = 0;
  String _currentPage = "Home";

  List<String> pageKeys = ["Home", "CreateAd", "MyAd", "Profile"];

  Map<String, GlobalKey<NavigatorState>> _navigatorKeys = {
    "Home": GlobalKey<NavigatorState>(),
    "CreateAd": GlobalKey<NavigatorState>(),
    "MyAd": GlobalKey<NavigatorState>(),
    "Profile": GlobalKey<NavigatorState>(),
  };

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _asyncMethod();
    });

    super.initState();
  }

  _asyncMethod() async {}

  void _onItemTapped(String tabItem, int index) {
    if (tabItem == _currentPage) {
      _navigatorKeys[tabItem].currentState.popUntil((route) => route.isFirst);
    } else {
      setState(() {
        _currentPage = pageKeys[index];
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final isFirstRouteInCurrentTab =
            !await _navigatorKeys[_currentPage].currentState.maybePop();
        if (isFirstRouteInCurrentTab) {
          if (_currentPage != "Home") {
            _onItemTapped("Home", 0);

            return false;
          }
        }

        return isFirstRouteInCurrentTab;
      },
      child: SafeArea(
        child: Scaffold(
          body: Stack(children: <Widget>[
            _buildOffstageNavigator("Home"),
            _buildOffstageNavigator("CreateAd"),
            _buildOffstageNavigator("MyAd"),
            _buildOffstageNavigator("Profile"),
          ]),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(37), topLeft: Radius.circular(37)),
              boxShadow: [
                BoxShadow(
                    color: Color.fromRGBO(136, 136, 136, 0.2),
                    spreadRadius: 6,
                    blurRadius: 12),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(34.0),
                topRight: Radius.circular(34.0),
              ),
              child: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                items: <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Center(
                      child: FaIcon(
                        FontAwesomeIcons.home,
                      ),
                    ),
                    label: '',
                    activeIcon: Container(
                      width: 85,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(19, 60, 109, 1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: FaIcon(
                          FontAwesomeIcons.home,
                        ),
                      ),
                    ),
                  ),
                  BottomNavigationBarItem(
                    icon: Center(
                      child: FaIcon(
                        FontAwesomeIcons.plusCircle,
                      ),
                    ),
                    label: '',
                    activeIcon: Container(
                      width: 85,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(19, 60, 109, 1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: FaIcon(
                          FontAwesomeIcons.plusCircle,
                        ),
                      ),
                    ),
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.receipt,
                    ),
                    label: '',
                    activeIcon: Container(
                      width: 85,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(19, 60, 109, 1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.receipt,
                      ),
                    ),
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.person,
                    ),
                    label: '',
                    activeIcon: Container(
                      width: 85,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(19, 60, 109, 1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.person,
                      ),
                    ),
                  ),
                ],
                currentIndex: _selectedIndex,
                selectedItemColor: Colors.white,
                selectedLabelStyle: TextStyle(fontSize: 0.1),
                unselectedLabelStyle: TextStyle(fontSize: 0.1),
                iconSize: 24,
                showSelectedLabels: true,
                unselectedItemColor: Color.fromRGBO(44, 62, 80, 1),
                onTap: (int index) {
                  _onItemTapped(pageKeys[index], index);
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOffstageNavigator(String tabItem) {
    return Offstage(
      offstage: _currentPage != tabItem,
      child: TabNavigator(
        navigatorKey: _navigatorKeys[tabItem],
        tabItem: tabItem,
      ),
    );
  }
}
