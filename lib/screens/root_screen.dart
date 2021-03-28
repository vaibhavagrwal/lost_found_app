import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:lost_found_app/screens/tab_navigator.dart';
import 'package:lost_found_app/util/screen_size.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class RootScreen extends StatefulWidget {
  @override
  _RootScreenState createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> with TickerProviderStateMixin {
  int _selectedIndex = 0;
  String _currentPage = "Home";
  final GlobalKey<ScaffoldState> _globalScaffoldkey =
      new GlobalKey<ScaffoldState>();

  @override
  void dispose() {
    super.dispose();
  }

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
        //_tabController.index = index;
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
          // key: _globalScaffoldkey,
          body: Stack(children: <Widget>[
            _buildOffstageNavigator("Home"),
            _buildOffstageNavigator("CreateAd"),
            _buildOffstageNavigator("MyAd"),
            _buildOffstageNavigator("Profile"),
          ]),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(color: Colors.white, boxShadow: [
              BoxShadow(blurRadius: 20, color: Colors.black.withOpacity(.1))
            ]),
            child: SafeArea(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
                child: GNav(
                  haptic: true, // haptic feedback
                  tabBorderRadius: 15,
                  //tabActiveBorder: Border.all(
                  //color: Colors.black, width: 1), // tab button border
                  //tabBorder: Border.all(color: Colors.grey, width: 1),
                  rippleColor: Color.fromRGBO(19, 60, 109, 1),
                  hoverColor: Color.fromRGBO(19, 60, 109, 0.5),
                  gap: 7,
                  activeColor: Colors.white,
                  iconSize: 26,
                  color: Color.fromRGBO(19, 60, 109, 1),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  duration: Duration(milliseconds: 400),
                  tabBackgroundColor: Color.fromRGBO(19, 60, 109, 1),
                  tabs: [
                    GButton(
                      icon: Icons.home,
                      text: 'Home',
                    ),
                    GButton(
                      icon: FontAwesomeIcons.plusCircle,
                      text: 'Create Post',
                    ),
                    GButton(
                      icon: Icons.receipt,
                      text: 'My Posts',
                    ),
                    GButton(
                      icon: Icons.person,
                      text: 'Profile',
                    ),
                  ],
                  selectedIndex: _selectedIndex,
                  onTabChange: (int index) {
                    _onItemTapped(pageKeys[index], index);
                  },
                ),
              ),
            ),
          ), /*MotionTabBar(
            labels: ["HOME", "CREATE AD", "MY ADS", "PROFILE"],
            initialSelectedTab: "HOME",
            tabIconColor: Color.fromRGBO(19, 60, 109, 1),
            tabSelectedColor: Color.fromRGBO(19, 60, 109, 1),
            onTabItemSelected: (int index) {
              _onItemTapped(pageKeys[index], index);
            },
            icons: [
              FontAwesomeIcons.home,
              FontAwesomeIcons.plusCircle,
              Icons.receipt,
              Icons.person
            ],
            textStyle: GoogleFonts.roboto(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),*/
          /*Container(
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
              /*borderRadius: BorderRadius.only(
                topLeft: Radius.circular(34.0),
                topRight: Radius.circular(34.0),
              ),*/
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
                      width: 85 * ScreenSize.widthMultiplyingFactor,
                      height: 40 * ScreenSize.heightMultiplyingFactor,
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
                      width: 85 * ScreenSize.widthMultiplyingFactor,
                      height: 40 * ScreenSize.heightMultiplyingFactor,
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
                      width: 85 * ScreenSize.widthMultiplyingFactor,
                      height: 40 * ScreenSize.heightMultiplyingFactor,
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
                      width: 85 * ScreenSize.widthMultiplyingFactor,
                      height: 40 * ScreenSize.heightMultiplyingFactor,
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
                selectedLabelStyle: TextStyle(
                    fontSize: 0.1 * ScreenSize.heightMultiplyingFactor),
                unselectedLabelStyle: TextStyle(
                    fontSize: 0.1 * ScreenSize.heightMultiplyingFactor),
                iconSize: 24 * ScreenSize.heightMultiplyingFactor,
                showSelectedLabels: true,
                unselectedItemColor: Color.fromRGBO(44, 62, 80, 1),
                onTap: (int index) {
                  _onItemTapped(pageKeys[index], index);
                },
              ),
            ),
          ),*/
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
