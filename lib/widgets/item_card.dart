import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:slimy_card/slimy_card.dart';

class ItemCard extends StatelessWidget {
  final String itemName;
  final String imageUrl;
  final String location;
  final String by;
  final VoidCallback onPressed;

  const ItemCard({
    @required this.itemName,
    this.imageUrl,
    @required this.location,
    @required this.by,
    @required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SlimyCard(
      //Curve: Curves.bounceOut,
      width: 190,
      color: Color(0xff295ba7), //Color.fromRGBO(19, 60, 130, 1),
      // elevation: 0,
      slimeEnabled: true,
      topCardHeight: 180,
      bottomCardHeight: 68,

      bottomCardWidget:
          Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: 15,
            ),
            Icon(
              Icons.location_on_outlined,
              color: Colors.white,
              size: 22,
            ),
            Text(
              location,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: 15,
            ),
            Icon(
              Icons.person,
              color: Colors.white,
              size: 22,
            ),
            Text(
              by,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ]),
      topCardWidget: Column(
        children: <Widget>[
          GestureDetector(
              onTap: onPressed,
              child: Container(
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                  image: DecorationImage(
                    image: imageUrl != ""
                        ? CachedNetworkImageProvider(imageUrl)
                        : ExactAssetImage("lib/assets/noimage.gif"),
                    fit: BoxFit.fill,
                  ),
                ),
                child: Transform.translate(
                  offset: Offset(50, -50),
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 65, vertical: 63),
                  ),
                ),
              )),
          Text(
            itemName[0].toUpperCase() + itemName.substring(1),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }
}
