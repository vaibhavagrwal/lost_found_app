import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lost_found_app/screens/login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  OnboardingScreen({Key key}) : super(key: key);

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final int _totalPages = 3;
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(
          children: [
            PageView(
              controller: _pageController,
              onPageChanged: (int page) {
                _currentPage = page;
                setState(() {});
              },
              children: <Widget>[
                _buildPageContent(
                    isShowImageOnTop: false,
                    image: 'lib/assets/lost.gif',
                    body:
                        'One-Stop Destination for all your Lost & Found items.',
                    color: Colors.white),
                _buildPageContent(
                    isShowImageOnTop: true,
                    image: 'lib/assets/chat.gif',
                    body: 'Maintain your privacy while helping out others.',
                    color: Colors.white),
                _buildPageContent(
                    isShowImageOnTop: false,
                    image: 'lib/assets/map.gif',
                    body:
                        'The new and updated version of the DTU map so that you can easily find your stuff.',
                    color: Colors.white)
              ],
            ),
            Positioned(
              bottom: 40,
              left: MediaQuery.of(context).size.width * .05,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width * .9,
                    child: Row(
                      children: [
                        Container(
                          child: Row(children: [
                            for (int i = 0; i < _totalPages; i++)
                              i == _currentPage
                                  ? _buildPageIndicator(true)
                                  : _buildPageIndicator(false)
                          ]),
                        ),
                        Spacer(),
                        if (_currentPage != 2)
                          InkWell(
                            onTap: () {
                              _pageController.animateToPage(2,
                                  duration: Duration(milliseconds: 400),
                                  curve: Curves.linear);
                              setState(() {});
                            },
                            child: Container(
                              // height: Platform.isIOS ? 70 : 60,
                              alignment: Alignment.center,
                              child: Text(
                                'Skip',
                                style: GoogleFonts.poppins(
                                    color: Color.fromRGBO(19, 60, 109, 1),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              ),
                            ),
                          ),
                        if (_currentPage == 2)
                          InkWell(
                            onTap: () => Navigator.pushReplacement(context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) {
                              return LoginScreen();
                            })),
                            child: Container(
                              //height: Platform.isIOS ? 70 : 60,
                              alignment: Alignment.center,
                              child: Text(
                                'Start',
                                style: GoogleFonts.poppins(
                                    color: Color.fromRGBO(19, 60, 109, 1),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildPageContent(
      {String image, String body, Color color, isShowImageOnTop}) {
    return Container(
      decoration: BoxDecoration(color: color),
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (!isShowImageOnTop)
            Column(
              children: [
                Center(
                  child: Image.asset(image),
                ),
                SizedBox(height: 50),
                Text(
                  body,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                      fontSize: 24,
                      height: 1.6,
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(19, 60, 109, 1)),
                ),
              ],
            ),
          if (isShowImageOnTop)
            Column(
              children: [
                Text(
                  body,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                      fontSize: 24,
                      height: 1.6,
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(19, 60, 109, 1)),
                ),
                SizedBox(height: 50),
                Center(
                  child: Image.asset(image),
                ),
              ],
            )
        ],
      ),
    );
  }

  Widget _buildPageIndicator(bool isCurrentPage) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 350),
      margin: EdgeInsets.symmetric(horizontal: 5.0),
      height: isCurrentPage ? 18.0 : 10.0,
      width: isCurrentPage ? 18.0 : 10.0,
      decoration: BoxDecoration(
        color: isCurrentPage
            ? Color.fromRGBO(19, 60, 109, 1)
            : Color.fromRGBO(19, 60, 109, 1),
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );
  }
}

//
/*
  Scaffold(
    appBar: AppBar(),
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'You have pushed the button this many times:',
          ),
        ],
      ),
    ),
  );*/
