import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lost_found_app/widgets/item_tile.dart';
import 'dart:async';
import '../main.dart';
import 'package:async/async.dart';

class MyAdScreen extends StatefulWidget {
  @override
  _MyAdScreenState createState() => _MyAdScreenState();
}

class _MyAdScreenState extends State<MyAdScreen> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Color.fromRGBO(44, 62, 80, 1),
        ),
        title: Text(
          " My Ads ",
          style: GoogleFonts.roboto(
              color: Color.fromRGBO(44, 62, 80, 1),
              fontSize: 20,
              fontWeight: FontWeight.w600),
        ),
      ),
      body: MyList(),
    );
  }
}

class MyList extends StatefulWidget {
  @override
  _MyListState createState() => _MyListState();
}

class _MyListState extends State<MyList> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("AllItems")
            .doc(user.userId)
            .collection("myItems")
            .orderBy('date', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index) {
                if (snapshot.data.docs[index].get('isVerified') == true)
                  return Dismissible(
                    direction: DismissDirection.startToEnd,
                    resizeDuration: Duration(milliseconds: 200),
                    key: ObjectKey(snapshot.data.docs.elementAt(index)),
                    onDismissed: (direction) async {
                      try {
                        await FirebaseFirestore.instance
                            .collection("AllItems")
                            .doc(user.userId)
                            .collection("myItems")
                            .doc(snapshot.data.docs[index].get('postId'))
                            .delete();
                        if (snapshot.data.docs[index].get('status') == "Lost")
                          await FirebaseFirestore.instance
                              .collection("LostItemsList")
                              .doc(snapshot.data.docs[index].get('postId'))
                              .delete();
                        else if (snapshot.data.docs[index].get('status') ==
                            "Found")
                          await FirebaseFirestore.instance
                              .collection("FoundItemsList")
                              .doc(snapshot.data.docs[index].get('postId'))
                              .delete();
                        setState(() {
                          snapshot.data.docs.removeAt(index);
                        });
                        Flushbar(
                          title: "Success",
                          margin: EdgeInsets.all(8),
                          borderRadius: 8,
                          message: "Item Deleted Successfully!!",
                          backgroundColor: Colors.green,
                          icon: Icon(
                            Icons.check,
                            color: Colors.greenAccent,
                          ),
                          duration: Duration(seconds: 3),
                        )..show(context);
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(e.toString())));
                      }
                    },
                    background: Container(
                      padding: EdgeInsets.only(left: 28.0),
                      alignment: AlignmentDirectional.centerStart,
                      color: Colors.red,
                      child: Icon(
                        Icons.delete_forever,
                        color: Colors.white,
                      ),
                    ),
                    child: ItemTile(
                      imageUrl: snapshot.data.docs[index].get('image_url'),
                      title: snapshot.data.docs[index].get('heading'),
                      description: snapshot.data.docs[index].get('description'),
                      status: snapshot.data.docs[index].get('status'),
                    ),
                  );
                else
                  return Dismissible(
                    direction: DismissDirection.startToEnd,
                    resizeDuration: Duration(milliseconds: 200),
                    key: ObjectKey(snapshot.data.docs.elementAt(index)),
                    onDismissed: (direction) async {
                      try {
                        await FirebaseFirestore.instance
                            .collection("AllItems")
                            .doc(user.userId)
                            .collection("myItems")
                            .doc(snapshot.data.docs[index].get('postId'))
                            .delete();
                        if (snapshot.data.docs[index].get('status') == "Lost")
                          await FirebaseFirestore.instance
                              .collection("LostItemsList")
                              .doc(snapshot.data.docs[index].get('postId'))
                              .delete();
                        else if (snapshot.data.docs[index].get('status') ==
                            "Found")
                          await FirebaseFirestore.instance
                              .collection("FoundItemsList")
                              .doc(snapshot.data.docs[index].get('postId'))
                              .delete();
                        setState(() {
                          snapshot.data.docs.removeAt(index);
                        });
                        Flushbar(
                          title: "Success",
                          margin: EdgeInsets.all(8),
                          borderRadius: 8,
                          message: "Item Deleted Successfully!!",
                          backgroundColor: Colors.green,
                          icon: Icon(
                            Icons.check,
                            color: Colors.greenAccent,
                          ),
                          duration: Duration(seconds: 3),
                        )..show(context);
                      } catch (e) {
                        Flushbar(
                          title: "Error",
                          message: e.toString(),
                          margin: EdgeInsets.all(8),
                          borderRadius: 8,
                          icon: Icon(
                            Icons.error,
                            color: Colors.redAccent,
                          ),
                          backgroundColor: Colors.red,
                          duration: Duration(seconds: 3),
                        )..show(context);
                      }
                    },
                    background: Container(
                      padding: EdgeInsets.only(left: 28.0),
                      alignment: AlignmentDirectional.centerStart,
                      color: Colors.red,
                      child: Icon(
                        Icons.delete_forever,
                        color: Colors.white,
                      ),
                    ),
                    child: ItemTile(
                      imageUrl: snapshot.data.docs[index].get('image_url'),
                      title: snapshot.data.docs[index].get('heading'),
                      description: snapshot.data.docs[index].get('description'),
                      status: "Under Review",
                    ),
                  );
              },
            );
          } else {
            return CircularProgressIndicator();
          }
        });
  }
}
