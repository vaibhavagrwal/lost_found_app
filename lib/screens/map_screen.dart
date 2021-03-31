import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_google_maps/flutter_google_maps.dart';
import 'package:flutter/foundation.dart';
import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lost_found_app/main.dart';
import 'package:lost_found_app/util/screen_size.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geopoint_location/geopoint_location.dart';
import 'package:location/location.dart';
import 'package:lost_found_app/services/location_service.dart';
import 'package:flash/flash.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geocoder/geocoder.dart';

import 'package:outline_search_bar/outline_search_bar.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _key = GlobalKey<GoogleMapStateBase>();
  String _mapStyle;
  TextEditingController textController = TextEditingController();
  bool _isSearching = false;
  String _searchText = "";

  _searchListState() {
    textController.addListener(() {
      if (textController.text.isEmpty) {
        setState(() {
          _isSearching = false;
          _searchText = "";
        });
      } else {
        setState(() {
          _isSearching = true;
          _searchText = textController.text;
        });
      }
    });
  }

  var noti = 1;

  funcc() async {
    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection("users")
        .doc(user.userId)
        .get();

    print('noti : ' + snap['not'].toString());
    snap['not'] == 0
        ? Future.delayed(Duration.zero, () {
            _show(
                margin: const EdgeInsets.only(
                    left: 12.0, right: 12.0, bottom: 34.0),
                location:
                    "Swipe Up with two fingers to see the map in 3D view");
          })
        : () {};
  }

  @override
  void initState() {
    funcc();
    super.initState();
  }

  void _show(
      {bool persistent = true,
      EdgeInsets margin = EdgeInsets.zero,
      String location}) {
    showFlash(
      context: context,
      persistent: persistent,
      builder: (_, controller) {
        return Flash(
          controller: controller,
          margin: margin,
          borderRadius: BorderRadius.circular(8.0),
          borderColor: Colors.white,
          boxShadows: kElevationToShadow[8],
          backgroundColor: Color.fromRGBO(19, 60, 109, 1),
          onTap: () {
            controller.dismiss();
            FirebaseFirestore.instance
                .collection("users")
                .doc(user.userId)
                .update({
              'not': 1,
            }).catchError((e) {
              print(e);
            });
          },
          forwardAnimationCurve: Curves.easeInCirc,
          reverseAnimationCurve: Curves.bounceIn,
          child: DefaultTextStyle(
            style: GoogleFonts.poppins(color: Colors.white),
            child: FlashBar(
              title: Text(
                location,
                style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 20 * ScreenSize.heightMultiplyingFactor),
              ),
              message: Text(""),
              leftBarIndicatorColor: Colors.white,
              icon: Icon(
                Icons.info_outline,
                color: Colors.white,
              ),
              primaryAction: TextButton(
                onPressed: () {
                  controller.dismiss();
                  FirebaseFirestore.instance
                      .collection("users")
                      .doc(user.userId)
                      .update({
                    'not': 1,
                  }).catchError((e) {
                    print(e);
                  });
                },
                child: Container(),
              ),
            ),
          ),
        );
      },
    ).then((_) {
      if (_ != null) {
        if (!mounted) return;
        showFlash(
            context: context,
            duration: Duration(seconds: 3),
            builder: (_, controller) {
              return Flash(
                controller: controller,
                position: FlashPosition.top,
                style: FlashStyle.grounded,
                child: FlashBar(
                  icon: Icon(
                    Icons.face,
                    size: 36.0,
                    color: Colors.black,
                  ),
                  message: Text(_.toString()),
                ),
              );
            });
      }
    });
  }

  void _showBottomFlash(
      {bool persistent = true,
      EdgeInsets margin = EdgeInsets.zero,
      var location}) {
    showFlash(
      context: context,
      persistent: persistent,
      builder: (_, controller) {
        return Flash(
          controller: controller,
          margin: margin,
          borderRadius: BorderRadius.circular(8.0),
          borderColor: Colors.white,
          boxShadows: kElevationToShadow[8],
          backgroundColor: Color.fromRGBO(19, 60, 109, 1),
          onTap: () => controller.dismiss(),
          forwardAnimationCurve: Curves.easeInCirc,
          reverseAnimationCurve: Curves.bounceIn,
          child: DefaultTextStyle(
            style: GoogleFonts.poppins(color: Colors.white),
            child: FlashBar(
              title: Text(
                location.first.featureName,
                style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 20 * ScreenSize.heightMultiplyingFactor),
              ),
              message: Text(location.first.addressLine),
              leftBarIndicatorColor: Colors.white,
              icon: Icon(
                Icons.info_outline,
                color: Colors.white,
              ),
              primaryAction: TextButton(
                onPressed: () {
                  controller.dismiss();
                },
                child: Text('DISMISS',
                    style: GoogleFonts.poppins(
                        color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ),
        );
      },
    ).then((_) {
      if (_ != null) {
        if (!mounted) return;
        showFlash(
            context: context,
            duration: Duration(seconds: 3),
            builder: (_, controller) {
              return Flash(
                controller: controller,
                position: FlashPosition.top,
                style: FlashStyle.grounded,
                child: FlashBar(
                  icon: Icon(
                    Icons.face,
                    size: 36.0,
                    color: Colors.black,
                  ),
                  message: Text(_.toString()),
                ),
              );
            });
      }
    });
  }

  LocationData _userLoc;
  LocationService _locSer = LocationService();

  var namepoints = {
    "Ground": 28.753567,
    "Library": 28.750623,
    "Sports Complex": 28.752029,
    "Mic Mac": 28.751089,
    "Maggi Baba": 28.745266,
    "Post Office": 28.746555,
    "Gym": 28.747750,
    "SBI": 28.747421,
    "Mechanical Canteen": 28.749350,
    "Amul": 28.749455,
    "Juice Corner": 28.749488,
    "Nescafe": 28.749655,
    "Stationary": 28.749417,
    "Kissing Point": 28.751964,
    "Race Track": 28.753544,
    "Wind Point": 28.751037,
    "Science Block": 28.750764,
    "Library Registration": 28.750530,
    "Technology Incubator": 28.750506,
    "Joint Registrar": 28.749820,
    "Senate Hall ": 28.749926,
    "DTU Lake": 28.749668,
    "BR Ambedkar Audi": 28.750236,
    "Smart Classroom": 28.750256,
    "Computer Centre": 28.750119,
    "Physics Lab": 28.750979,
    "Chemistry Labs ": 28.751238,
    "SPS 1-8": 28.751288,
    "SPS 9-12": 28.749355,
    "Washroom 1": 28.749562,
    "Washroom 2": 28.751058,
    "Mechanical Workshop": 28.750973,
    "Admin Block": 28.749681,
    "Girl's Hostel": 28.747722,
    "Design Centre": 28.750922, //new places
    "New Hostel 1": 28.750385,
    "New Hostel 2": 28.748188,
    "Raj Soin Hall": 28.751110,
    "Software Department": 28.749949,
  };

  var latofpoint = {
    28.749949: 77.1125023,
    28.748188: 77.117073,
    28.751110: 77.114842,
    28.750385: 77.114891,
    28.753567: 77.115853,
    28.750623: 77.116647,
    28.752029: 77.116738,
    28.751089: 77.115643,
    28.745266: 77.117649,
    28.746555: 77.119205,
    28.747750: 77.119817,
    28.747421: 77.119624,
    28.749350: 77.118808,
    28.749455: 77.118445,
    28.749488: 77.118153,
    28.749655: 77.116702,
    28.749417: 77.118848,
    28.751964: 77.119599,
    28.753544: 77.114471,
    28.751037: 77.117561,
    28.750764: 77.117990,
    28.750530: 77.116589,
    28.750506: 77.116312,
    28.749820: 77.116203,
    28.749926: 77.116341,
    28.749668: 77.113001,
    28.750236: 77.116440,
    28.750256: 77.116451,
    28.750119: 77.117128,
    28.750979: 77.117627,
    28.751238: 77.117879,
    28.751288: 77.119004,
    28.749355: 77.119888,
    28.749562: 77.119942,
    28.751058: 77.118697,
    28.750973: 77.118628,
    28.749681: 77.116269,
    28.747722: 77.118213,
    28.750922: 77.115567,
  };
  List<String> placeNames = [];
  List<String> filteredNames = [];
  @override
  Widget build(BuildContext context) {
    placeNames = [
      "Ground",
      "Library",
      "Sports Complex",
      "Mic Mac",
      "Maggi Baba",
      "Post Office",
      "Gym",
      "SBI",
      "Mechanical Canteen",
      "Amul",
      "Juice Corner",
      "Nescafe",
      "Stationary",
      "Kissing Point",
      "Race Track",
      "Wind Point",
      "Science Block",
      "Library Registration",
      "Technology Incubator",
      "Joint Registrar",
      "Senate Hall ",
      "DTU Lake",
      "BR Ambedkar Audi",
      "Smart Classroom",
      "Computer Centre",
      "Physics Lab",
      "Chemistry Labs ",
      "SPS 1-8",
      "SPS 9-12",
      "Washroom 1",
      "Washroom 2",
      "Mechanical Workshop",
      "Admin Block",
      "Girl's Hostel",
      "Design Centre", //new places
      "New Hostel 1",
      "New Hostel 2",
      "Raj Soin Hall",
      "Software Department"
    ];
    _locSer.getLocation().then((value) => _userLoc = value);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        toolbarHeight: 60 * ScreenSize.heightMultiplyingFactor,
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(30.0),
            bottomLeft: Radius.circular(30.0),
          ),
        ),
        backgroundColor: Color.fromRGBO(19, 60, 109, 1),
        iconTheme: IconThemeData(
          color: Colors.transparent,
        ),
        title: Text(
          "    DTU Map ",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 20 * ScreenSize.heightMultiplyingFactor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Stack(
        children: <Widget>[
          Positioned.fill(
            child: GoogleMap(
              key: _key,

              initialZoom: 17,

              initialPosition: GeoCoord(28.7505, 77.1177), // DTU
              mapType: MapType.roadmap,
              mapStyle: _mapStyle,
              interactive: true,
              onTap: (coord) async {
                print(coord.latitude.toString());
                final coordinates =
                    new Coordinates(coord.latitude, coord.longitude);
                var addresses = await Geocoder.local
                    .findAddressesFromCoordinates(coordinates);
                var first = addresses.first;
                print("${first.featureName} : ${first.addressLine}");
                // List<Placemark> newPlace = await placemarkFromCoordinates(0, 0);
                _showBottomFlash(
                    margin: const EdgeInsets.only(
                        left: 12.0, right: 12.0, bottom: 34.0),
                    location: addresses);

                /*_scaffoldKey.currentState.showSnackBar(SnackBar(
                  content: Text(coord?.toString()),
                  duration: const Duration(seconds: 2),
                ));*/
              },
              mobilePreferences: const MobileMapPreferences(
                trafficEnabled: true,
                zoomControlsEnabled: true,
                tiltGesturesEnabled: true,
                mapToolbarEnabled: true,
                //myLocationButtonEnabled: true,
                //myLocationEnabled: true,
                indoorViewEnabled: true,
              ),
              webPreferences: WebMapPreferences(
                fullscreenControl: true,
                zoomControl: true,
              ),
            ),
          ),
          Positioned(
            bottom: 85 * ScreenSize.heightMultiplyingFactor,
            left: 16 * ScreenSize.widthMultiplyingFactor,
            child: FloatingActionButton(
              child: Image(
                image: AssetImage('lib/assets/dtu.png'),
              ),
              onPressed: () async {
                _userLoc = await _locSer.getLocation();
                final bounds = GeoCoordBounds(
                  northeast: GeoCoord(28.7505, 77.1177),
                  southwest: GeoCoord(28.7505, 77.1177),
                );
                GoogleMap.of(_key).moveCameraBounds(bounds);
                GoogleMap.of(_key).addMarkerRaw(
                  GeoCoord(
                    (bounds.northeast.latitude + bounds.southwest.latitude) / 2,
                    (bounds.northeast.longitude + bounds.southwest.longitude) /
                        2,
                  ),
                  onTap: (markerId) async {
                    await showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        content: Text("Welcome to DTU",
                            style: GoogleFonts.poppins(
                                fontSize: 24, fontWeight: FontWeight.bold)),
                        actions: <Widget>[
                          Image(image: AssetImage('lib/assets/dtu.png')),
                          FlatButton(
                            onPressed: Navigator.of(context).pop,
                            child: Text('CLOSE'),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Positioned(
            bottom: 16 * ScreenSize.heightMultiplyingFactor,
            left: 16 * ScreenSize.widthMultiplyingFactor,
            child: FloatingActionButton(
              backgroundColor: Color.fromRGBO(19, 60, 109, 1),
              child: Icon(Icons.person_pin_circle),
              onPressed: () async {
                _userLoc = await _locSer.getLocation();
                final bounds = GeoCoordBounds(
                  northeast: GeoCoord(_userLoc.latitude, _userLoc.longitude),
                  southwest: GeoCoord(_userLoc.latitude, _userLoc.longitude),
                );
                GoogleMap.of(_key).moveCameraBounds(bounds);
                GoogleMap.of(_key).addMarkerRaw(
                  GeoCoord(
                    (bounds.northeast.latitude + bounds.southwest.latitude) / 2,
                    (bounds.northeast.longitude + bounds.southwest.longitude) /
                        2,
                  ),
                  onTap: (markerId) async {
                    await showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        content: Text("This is Your Location",
                            style: GoogleFonts.poppins(
                                fontSize: 24, fontWeight: FontWeight.bold)),
                        actions: <Widget>[
                          FlatButton(
                            onPressed: Navigator.of(context).pop,
                            child: Text('CLOSE'),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Positioned(
            top: 16 * ScreenSize.heightMultiplyingFactor,
            left: 16 * ScreenSize.widthMultiplyingFactor,
            // child: AnimSearchBar(
            //   width: 300,
            //   textController: textController,
            //   suffixIcon: Icon(
            //     Icons.search,
            //   ),
            //   onSuffixTap: () {
            //     final bounds = GeoCoordBounds(
            //       northeast: GeoCoord(namepoints[textController.text],
            //           latofpoint[namepoints[textController.text]]),
            //       southwest: GeoCoord(namepoints[textController.text],
            //           latofpoint[namepoints[textController.text]]),
            //     );
            //     GoogleMap.of(_key).moveCameraBounds(bounds);
            //     GoogleMap.of(_key).addMarkerRaw(
            //       GeoCoord(
            //         (bounds.northeast.latitude + bounds.southwest.latitude) / 2,
            //         (bounds.northeast.longitude + bounds.southwest.longitude) /
            //             2,
            //       ),
            //       onTap: (markerId) async {
            //         await showDialog(
            //           context: context,
            //           builder: (context) => AlertDialog(
            //             content: Text("Welcome to " + textController.text,
            //                 style: GoogleFonts.poppins(
            //                     fontSize: 24, fontWeight: FontWeight.bold)),
            //             actions: <Widget>[
            //               FlatButton(
            //                 onPressed: Navigator.of(context).pop,
            //                 child: Text('CLOSE'),
            //               ),
            //             ],
            //           ),
            //         );
            //       },
            //     );
            //   },
            // ),
            child: Container(
              width: 363 * ScreenSize.widthMultiplyingFactor,
              //height: ,
              child: Column(
                children: [
                  SizedBox(
                      width: 400 * ScreenSize.widthMultiplyingFactor,
                      height: 50 * ScreenSize.heightMultiplyingFactor,
                      child: OutlineSearchBar(
                        borderColor: Color.fromRGBO(19, 60, 109, 1),
                        searchButtonIconColor: Color.fromRGBO(19, 60, 109, 1),
                        textEditingController: textController,
                        cursorColor: Color.fromRGBO(19, 60, 109, 1),
                        textStyle: GoogleFonts.poppins(),
                        hintStyle: GoogleFonts.poppins(),
                        hintText: "Search...",
                        onKeywordChanged: (str) {
                          _searchListState();

                          setState(() {
                            filteredNames = placeNames
                                .where(
                                  (name) => (name.toLowerCase().contains(
                                        str.toLowerCase(),
                                      )),
                                )
                                .toList();
                            print(filteredNames.length);
                            print(_isSearching);
                          });
                        },
                      ) /*TextField(
                      controller: textController,
                      onChanged: (str) {
                        _searchListState();
                        setState(() {
                          filteredNames = placeNames
                              .where(
                                (name) => (name.toLowerCase().contains(
                                      str.toLowerCase(),
                                    )),
                              )
                              .toList();
                          print(filteredNames.length);
                          print(_isSearching);
                        });
                      },
                    ),*/
                      ),
                  !_isSearching
                      ? Container()
                      : SearchList(
                          filter: filteredNames,
                          latofpoints: latofpoint,
                          nameofpoints: namepoints,
                          keyy: _key,
                        ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SearchList extends StatefulWidget {
  final List filter;
  final Map<double, double> latofpoints;
  final Map<String, double> nameofpoints;
  final Key keyy;

  const SearchList(
      {Key key, this.filter, this.latofpoints, this.nameofpoints, this.keyy})
      : super(key: key);

  @override
  _SearchListState createState() => _SearchListState();
}

class _SearchListState extends State<SearchList> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 200 * ScreenSize.heightMultiplyingFactor,
        child: ListView.builder(
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Container(
              decoration: new BoxDecoration(
                  color: Colors.white,
                  border: new Border(
                      bottom: new BorderSide(
                          color: Color.fromRGBO(19, 60, 109, 1),
                          width: 0.5 * ScreenSize.widthMultiplyingFactor))),
              child: ListTile(
                onTap: () {
                  final bounds = GeoCoordBounds(
                    northeast: GeoCoord(
                        widget.nameofpoints[widget.filter[index]],
                        widget.latofpoints[
                            widget.nameofpoints[widget.filter[index]]]),
                    southwest: GeoCoord(
                        widget.nameofpoints[widget.filter[index]],
                        widget.latofpoints[
                            widget.nameofpoints[widget.filter[index]]]),
                  );
                  GoogleMap.of(widget.keyy).moveCameraBounds(bounds);
                  GoogleMap.of(widget.keyy).addMarkerRaw(
                    GeoCoord(
                      (bounds.northeast.latitude + bounds.southwest.latitude) /
                          2,
                      (bounds.northeast.longitude +
                              bounds.southwest.longitude) /
                          2,
                    ),
                    onTap: (markerId) async {
                      await showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          content: Text(widget.filter[index],
                              style: GoogleFonts.poppins(
                                  fontSize: 24, fontWeight: FontWeight.bold)),
                          actions: <Widget>[
                            FlatButton(
                              onPressed: Navigator.of(context).pop,
                              child: Text('CLOSE'),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
                title: Text(widget.filter[index],
                    style: GoogleFonts.poppins(fontSize: 18.0)),
              ),
            );
          },
          itemCount: widget.filter.length,
        ));
  }
}
