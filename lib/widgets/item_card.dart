import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ItemCard extends StatelessWidget {
  final String itemName;
  final String imageUrl;
  final String location;
  final VoidCallback onPressed;

  const ItemCard({
    @required this.itemName,
    this.imageUrl,
    @required this.location,
    @required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Card(
        color: Colors.transparent,
        elevation: 0,
        child: Column(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: Color.fromRGBO(19, 60, 109, 0.8),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)),
                image: DecorationImage(
                  image: CachedNetworkImageProvider(
                    imageUrl == ""
                        ? "https://axiomoptics.com/wp-content/uploads/2019/08/placeholder-images-image_large.png"
                        : imageUrl,
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              child: Transform.translate(
                offset: Offset(50, -50),
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 65, vertical: 63),
                ),
              ),
            ),
            Container(
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20)),
                color: Color.fromRGBO(19, 60, 109, 1),
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    itemName,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 15,
                      ),
                      Icon(
                        Icons.location_on_outlined,
                        color: Colors.white,
                        size: 18,
                      ),
                      Text(
                        location,
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
