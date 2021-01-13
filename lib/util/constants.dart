import 'package:flutter/material.dart';

const primaryColour = Color.fromRGBO(19, 60, 109, 1);

Widget appBarOverall(
    {String heading, bool searchThere = true, Function() onPressed}) {
  return AppBar(
    backgroundColor: primaryColour,
    title: Text(
      "      " + heading,
      style: TextStyle(
        fontWeight: FontWeight.bold,
      ),
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        bottomRight: Radius.circular(20.0),
        bottomLeft: Radius.circular(20.0),
      ),
    ),
    actions: searchThere
        ? [
            IconButton(
              icon: Icon(
                Icons.search,
                color: Colors.white,
              ),
              onPressed: onPressed,
            )
          ]
        : [],
  );
}
