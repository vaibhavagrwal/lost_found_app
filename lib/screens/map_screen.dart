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

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _key = GlobalKey<GoogleMapStateBase>();
  bool _darkMapStyle = false;
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
  };

  var latofpoint = {
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
              markers: {
                Marker(
                  GeoCoord(28.7505, 77.1177),
                ),
                Marker(
                  GeoCoord(28.7505, 77.1177),
                ),
              },
              initialZoom: 17,

              initialPosition: GeoCoord(28.7505, 77.1177), // DTU
              mapType: MapType.roadmap,
              mapStyle: _mapStyle,
              interactive: true,
              onTap: (coord) {
                print(coord.toString());
                _scaffoldKey.currentState.showSnackBar(SnackBar(
                  content: Text(coord?.toString()),
                  duration: const Duration(seconds: 2),
                ));
              },
              mobilePreferences: const MobileMapPreferences(
                trafficEnabled: true,
                zoomControlsEnabled: true,
                tiltGesturesEnabled: true,
                mapToolbarEnabled: true,
                myLocationButtonEnabled: true,
                myLocationEnabled: true,
              ),
              webPreferences: WebMapPreferences(
                fullscreenControl: true,
                zoomControl: true,
              ),
            ),
          ),
          Positioned(
            top: 16 * ScreenSize.heightMultiplyingFactor,
            left: 16 * ScreenSize.widthMultiplyingFactor,
            child: FloatingActionButton(
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
            top: 64 * ScreenSize.heightMultiplyingFactor,
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
              width: 200,
              height: double.infinity,
              child: Column(
                children: [
                  SizedBox(
                    width: 200,
                    height: 50,
                    child: TextField(
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
                    ),
                  ),
                  !_isSearching
                      ? Container()
                      : Expanded(
                          child: SearchList(
                            filter: filteredNames,
                          ),
                        ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 16,
            right: kIsWeb ? 60 : 16,
            child: FloatingActionButton(
              onPressed: () {
                if (_darkMapStyle) {
                  GoogleMap.of(_key).changeMapStyle(null);
                  _mapStyle = null;
                } else {
                  GoogleMap.of(_key).changeMapStyle(darkMapStyle);
                  _mapStyle = darkMapStyle;
                }

                setState(() => _darkMapStyle = !_darkMapStyle);
              },
              backgroundColor: _darkMapStyle ? Colors.black : Colors.white,
              child: Icon(
                _darkMapStyle ? Icons.wb_sunny : Icons.brightness_3,
                color: _darkMapStyle ? Colors.white : Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

const darkMapStyle = r'''
[
  {
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#212121"
      }
    ]
  },
  {
    "elementType": "labels.icon",
    "stylers": [
      {
        "visibility": "off"
      }
    ]
  },
  {
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#757575"
      }
    ]
  },
  {
    "elementType": "labels.text.stroke",
    "stylers": [
      {
        "color": "#212121"
      }
    ]
  },
  {
    "featureType": "administrative",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#757575"
      }
    ]
  },
  {
    "featureType": "administrative.country",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#9e9e9e"
      }
    ]
  },
  {
    "featureType": "administrative.land_parcel",
    "stylers": [
      {
        "visibility": "off"
      }
    ]
  },
  {
    "featureType": "administrative.locality",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#bdbdbd"
      }
    ]
  },
  {
    "featureType": "poi",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#757575"
      }
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#181818"
      }
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#616161"
      }
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "labels.text.stroke",
    "stylers": [
      {
        "color": "#1b1b1b"
      }
    ]
  },
  {
    "featureType": "road",
    "elementType": "geometry.fill",
    "stylers": [
      {
        "color": "#2c2c2c"
      }
    ]
  },
  {
    "featureType": "road",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#8a8a8a"
      }
    ]
  },
  {
    "featureType": "road.arterial",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#373737"
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#3c3c3c"
      }
    ]
  },
  {
    "featureType": "road.highway.controlled_access",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#4e4e4e"
      }
    ]
  },
  {
    "featureType": "road.local",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#616161"
      }
    ]
  },
  {
    "featureType": "transit",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#757575"
      }
    ]
  },
  {
    "featureType": "water",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#000000"
      }
    ]
  },
  {
    "featureType": "water",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#3d3d3d"
      }
    ]
  }
]
''';

const contentString = r'''
<div id="content">
  <div id="siteNotice"></div>
  <h1 id="firstHeading" class="firstHeading">Uluru</h1>
  <div id="bodyContent">
    <p>
      <b>Uluru</b>, also referred to as <b>Ayers Rock</b>, is a large 
      sandstone rock formation in the southern part of the 
      Northern Territory, central Australia. It lies 335&#160;km (208&#160;mi) 
      south west of the nearest large town, Alice Springs; 450&#160;km 
      (280&#160;mi) by road. Kata Tjuta and Uluru are the two major 
      features of the Uluru - Kata Tjuta National Park. Uluru is 
      sacred to the Pitjantjatjara and Yankunytjatjara, the 
      Aboriginal people of the area. It has many springs, waterholes, 
      rock caves and ancient paintings. Uluru is listed as a World 
      Heritage Site.
    </p>
    <p>
      Attribution: Uluru, 
      <a href="http://en.wikipedia.org/w/index.php?title=Uluru&oldid=297882194">
        http://en.wikipedia.org/w/index.php?title=Uluru
      </a>
      (last visited June 22, 2009).
    </p>
  </div>
</div>
''';

class SearchList extends StatefulWidget {
  final List filter;

  const SearchList({Key key, this.filter}) : super(key: key);

  @override
  _SearchListState createState() => _SearchListState();
}

class _SearchListState extends State<SearchList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return Container(
          decoration: new BoxDecoration(
              color: Colors.grey[100],
              border: new Border(
                  bottom: new BorderSide(color: Colors.grey, width: 0.5))),
          child: ListTile(
            onTap: () {},
            title: Text(widget.filter[index],
                style: new TextStyle(fontSize: 18.0)),
          ),
        );
      },
      itemCount: widget.filter.length,
    );
  }
}
