import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lost_found_app/util/constants.dart';

class ReviewTile extends StatefulWidget {
  final String title;
  final String imageUrl;
  final String status;
  final VoidCallback onPressed;
  const ReviewTile({
    Key key,
    this.title,
    this.imageUrl,
    this.status,
    this.onPressed,
  }) : super(key: key);

  @override
  _ReviewTileState createState() => _ReviewTileState();
}

class _ReviewTileState extends State<ReviewTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
        child: Container(
          height: 100,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(15),
              bottomLeft: Radius.circular(15),
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
          child: Center(
            child: ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(7),
                child: Container(
                  width: 70,
                  height: 80,
                  child: widget.imageUrl != ""
                      ? CachedNetworkImage(
                          imageUrl: widget.imageUrl,
                          fit: BoxFit.fill,
                        )
                      : Image.asset(
                          "lib/assets/noimage.gif",
                          fit: BoxFit.fill,
                        ),
                ),
              ),
              title: Text(
                widget.title,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.normal,
                  color: Color.fromRGBO(44, 62, 80, 1),
                ),
              ),
              subtitle: Text(
                widget.status,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.normal,
                ),
              ),
              trailing: MaterialButton(
                onPressed: widget.onPressed,
                color: primaryColour,
                child: Text('Accept',
                    style: TextStyle(
                      color: Colors.white,
                    )),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
