import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class FoundItemDetailScreen extends StatefulWidget {
  @override
  _FoundItemDetailScreenState createState() => _FoundItemDetailScreenState();
}

class _FoundItemDetailScreenState extends State<FoundItemDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: <Widget>[
        Container(
          height: 300,
          color: Color.fromRGBO(19, 60, 109, 0.8),
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Image(
              image: AssetImage('lib/assets/bag.jpg'),
            ),
          ),
        ),
        Container(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    children: [
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Adidas Backpack\n',
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Color.fromRGBO(19, 60, 109, 1),
                              ),
                            ),
                            TextSpan(
                                text: "Found",
                                style: TextStyle(
                                  color: Color.fromRGBO(19, 60, 109, 1),
                                  fontSize: 20,
                                ))
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                Row(
                  children: [
                    Column(
                      children: [
                        RichText(
                            text: TextSpan(
                                text: "Found on",
                                style: TextStyle(
                                  color: Color.fromRGBO(19, 60, 109, 1),
                                  fontSize: 15,
                                ))),
                        Row(
                          children: [
                            Icon(Icons.date_range),
                            Text("23-02-20",
                                style: TextStyle(
                                    color: Color.fromRGBO(19, 60, 109, 1),
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold))
                          ],
                        )
                      ],
                    ),
                    SizedBox(
                      width: 120,
                    ),
                    Column(
                      children: [
                        Text("Found at",
                            style: TextStyle(
                              color: Color.fromRGBO(19, 60, 109, 1),
                              fontSize: 15,
                            )),
                        Row(
                          children: [
                            Icon(Icons.place),
                            Text("OAT",
                                style: TextStyle(
                                    color: Color.fromRGBO(19, 60, 109, 1),
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold))
                          ],
                        )
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: 25,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    children: [
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                                text: "Description\n",
                                style: TextStyle(
                                    color: Color.fromRGBO(19, 60, 109, 1),
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold)),
                            TextSpan(
                                text:
                                    'bhot saara description\nbhot saara description\nbhot saara description\nbhot saara description\nbhot saara description\n',
                                style: TextStyle(
                                  color: Color.fromRGBO(19, 60, 109, 1),
                                  fontSize: 20,
                                ))
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                FlatButton(
                  onPressed: () {},
                  color: Color.fromRGBO(19, 60, 109, 1),
                  height: 45,
                  minWidth: 300,
                  child: Text("CLAIM",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      )),
                )
              ],
            ))
      ]),
    );
  }
}
