import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lost_found_app/models/post_model.dart';

class ItemDetailScreen extends StatefulWidget {
  final String ownerId;
  final String postId;

  const ItemDetailScreen({Key key, this.ownerId, this.postId})
      : super(key: key);
  @override
  _ItemDetailScreenState createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends State<ItemDetailScreen> {
  PostModel currentPost;
  bool isLoading = true;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _asyncMethod();
    });

    super.initState();
  }

  _asyncMethod() async {
    setState(() {
      isLoading = true;
    });
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    currentPost = PostModel.fromSnapshot(await firebaseFirestore
        .collection("lostItems")
        .doc(widget.ownerId)
        .collection("myLostItems")
        .doc(widget.postId)
        .get());
    setState(() {
      print(currentPost.postId);
      print(currentPost.postLocation);
      // print(currentPost.postName);
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60,
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(30.0),
            bottomLeft: Radius.circular(30.0),
          ),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Color.fromRGBO(44, 62, 80, 1),
        ),
        // title: Text(
        //   currentPost.postName ?? "",
        //   style: GoogleFonts.roboto(
        //       color: Color.fromRGBO(44, 62, 80, 1),
        //       fontSize: 20,
        //       fontWeight: FontWeight.w600),
        // ),
      ),
      body: isLoading
          ? CircularProgressIndicator()
          : SingleChildScrollView(
              child: Column(children: <Widget>[
                Container(
                  height: 300,
                  color: Color.fromRGBO(19, 60, 109, 0.8),
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Container(
                      decoration: BoxDecoration(
                          image: DecorationImage(
                        image: CachedNetworkImageProvider(
                          currentPost.imageUrl == ""
                              ? "https://axiomoptics.com/wp-content/uploads/2019/08/placeholder-images-image_large.png"
                              : currentPost.imageUrl,
                        ),
                      )),
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
                                      text: currentPost.postName ?? "",
                                      style: TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold,
                                        color: Color.fromRGBO(19, 60, 109, 1),
                                      ),
                                    ),
                                    TextSpan(
                                        text: "Lost",
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
                                        text: "Lost on",
                                        style: TextStyle(
                                          color: Color.fromRGBO(19, 60, 109, 1),
                                          fontSize: 15,
                                        ))),
                                Row(
                                  children: [
                                    Icon(Icons.date_range),
                                    Text(
                                        currentPost.postDate == null
                                            ? ""
                                            : currentPost.postDate
                                                .toIso8601String(),
                                        style: TextStyle(
                                            color:
                                                Color.fromRGBO(19, 60, 109, 1),
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
                                Text("Lost at",
                                    style: TextStyle(
                                      color: Color.fromRGBO(19, 60, 109, 1),
                                      fontSize: 15,
                                    )),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.place,
                                    ),
                                    Text(currentPost.postLocation ?? "",
                                        style: TextStyle(
                                            color:
                                                Color.fromRGBO(19, 60, 109, 1),
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
                                            color:
                                                Color.fromRGBO(19, 60, 109, 1),
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold)),
                                    TextSpan(
                                        text: currentPost.postDescription ?? "",
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
            ),
    );
  }
}
