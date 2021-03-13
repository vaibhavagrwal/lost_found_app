import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ItemTile extends StatefulWidget {
  final String title;
  final String description;
  final String status;
  final String imageUrl;

  const ItemTile({
    Key key,
    this.title,
    this.description,
    this.status = "Lost",
    this.imageUrl,
  }) : super(key: key);

  @override
  _ItemTileState createState() => _ItemTileState();
}

class _ItemTileState extends State<ItemTile> {
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
                widget.description,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.normal,
                ),
              ),
              trailing: Text(
                widget.status,
                style: GoogleFonts.montserrat(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
