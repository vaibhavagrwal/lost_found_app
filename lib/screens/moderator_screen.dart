import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lost_found_app/screens/item_detail_screen.dart';
import 'package:lost_found_app/util/screen_size.dart';
import 'package:lost_found_app/widgets/item_tile.dart';
import 'package:lost_found_app/widgets/review_tile.dart';

import '../main.dart';

class ModeratorScreen extends StatefulWidget {
  @override
  _ModeratorScreenState createState() => _ModeratorScreenState();
}

class _ModeratorScreenState extends State<ModeratorScreen> {
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
          " Review Ads ",
          style: GoogleFonts.roboto(
              color: Color.fromRGBO(44, 62, 80, 1),
              fontSize: 20 * ScreenSize.heightMultiplyingFactor,
              fontWeight: FontWeight.w600),
        ),
      ),
      body: Column(
        children: [
          Expanded(child: LostReviewList()),
          Expanded(child: FoundReviewList()),
        ],
      ),
    );
  }
}

class FoundReviewList extends StatefulWidget {
  @override
  _FoundReviewListState createState() => _FoundReviewListState();
}

class _FoundReviewListState extends State<FoundReviewList> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("FoundItemsList")
            .where('isVerified', isEqualTo: false)
            .orderBy('date', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index) {
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
                      // if (snapshot.data.docs[index].get('status') == "Lost")
                      await FirebaseFirestore.instance
                          .collection("FoundItemsList")
                          .doc(snapshot.data.docs[index].get('postId'))
                          .delete();
                      // else if (snapshot.data.docs[index].get('status') ==
                      //     "Found")
                      //   await FirebaseFirestore.instance
                      //       .collection("FoundItemsList")
                      //       .doc(snapshot.data.docs[index].get('postId'))
                      //       .delete();
                      setState(() {
                        snapshot.data.docs.removeAt(index);
                      });
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("Item deleted successfully..!!")));
                    } catch (e) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text(e.toString())));
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
                  child: ReviewTile(
                    imageUrl: snapshot.data.docs[index].get('image_url'),
                    title: snapshot.data.docs[index].get('heading'),
                    status: "Found",
                    onPressed2: () {
                      String ownerId = snapshot.data.docs[index].get('ownerId');
                      String postId = snapshot.data.docs[index].get('postId');
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ItemDetailScreen(
                            ownerId: ownerId,
                            postId: postId,
                            type: "Found",
                          ),
                        ),
                      );
                    },
                    onPressed: () async {
                      try {
                        await FirebaseFirestore.instance
                            .collection("AllItems")
                            .doc(snapshot.data.docs[index].get('ownerId'))
                            .collection("myItems")
                            .doc(snapshot.data.docs[index].get('postId'))
                            .update({'isVerified': true});

                        await FirebaseFirestore.instance
                            .collection("FoundItemsList")
                            .doc(snapshot.data.docs[index].get('postId'))
                            .update({'isVerified': true});

                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Item Verified..!!")));
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(e.toString())));
                      }
                    },
                  ),
                );
              },
            );
          } else {
            return Container();
          }
        });
  }
}

class LostReviewList extends StatefulWidget {
  @override
  _LostReviewListState createState() => _LostReviewListState();
}

class _LostReviewListState extends State<LostReviewList> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("LostItemsList")
            .where('isVerified', isEqualTo: false)
            .orderBy('date', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index) {
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
                      // if (snapshot.data.docs[index].get('status') == "Lost")
                      await FirebaseFirestore.instance
                          .collection("LostItemsList")
                          .doc(snapshot.data.docs[index].get('postId'))
                          .delete();
                      // else if (snapshot.data.docs[index].get('status') ==
                      //     "Found")
                      //   await FirebaseFirestore.instance
                      //       .collection("FoundItemsList")
                      //       .doc(snapshot.data.docs[index].get('postId'))
                      //       .delete();
                      setState(() {
                        snapshot.data.docs.removeAt(index);
                      });
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("Item deleted successfully..!!")));
                    } catch (e) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text(e.toString())));
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
                  child: ReviewTile(
                    imageUrl: snapshot.data.docs[index].get('image_url'),
                    title: snapshot.data.docs[index].get('heading'),
                    status: "Lost",
                    onPressed2: () {
                      String ownerId = snapshot.data.docs[index].get('ownerId');
                      String postId = snapshot.data.docs[index].get('postId');
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ItemDetailScreen(
                            ownerId: ownerId,
                            postId: postId,
                            type: "Lost",
                          ),
                        ),
                      );
                    },
                    onPressed: () async {
                      try {
                        await FirebaseFirestore.instance
                            .collection("AllItems")
                            .doc(snapshot.data.docs[index].get('ownerId'))
                            .collection("myItems")
                            .doc(snapshot.data.docs[index].get('postId'))
                            .update({'isVerified': true});

                        await FirebaseFirestore.instance
                            .collection("LostItemsList")
                            .doc(snapshot.data.docs[index].get('postId'))
                            .update({'isVerified': true});

                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Item Verified..!!")));
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(e.toString())));
                      }
                    },
                  ),
                );
              },
            );
          } else {
            return Container();
          }
        });
  }
}
