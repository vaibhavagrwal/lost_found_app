import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lost_found_app/models/post_model.dart';
import 'package:slider_button/slider_button.dart';

class PostDetailsScreen extends StatefulWidget {
  final String ownerId;
  final String postId;

  const PostDetailsScreen({Key key, this.ownerId, this.postId})
      : super(key: key);
  @override
  _PostDetailsScreenState createState() => _PostDetailsScreenState();
}

class _PostDetailsScreenState extends State<PostDetailsScreen> {
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
      print(currentPost.postDescription);
      print(currentPost.postName);
      print(currentPost.imageUrl);
       print(currentPost.ownerName);
       print(currentPost.postDate);
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    Widget _buildSwiper() {
      return Hero(
        tag: 'post-image-}',
        child: Container(
          margin: EdgeInsets.all(16.0 * height * 0.002),
          height: 300,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.0 * height * 0.002),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                offset: Offset(0, 10),
              )
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12.0 * height * 0.002),
            child: Swiper(
              itemCount: 1,
              itemBuilder: (_, index) {
                return InkWell(
                  onTap: () {
                    // if (currentPost.imageUrl != "" && currentPost.imageUrl!=null)
                    //   showDialogFunc(context, currentPost.imageUrl,
                    //       currentPost.postName, "LOST");
                  },
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
                );
              },
              loop: true,
              pagination: SwiperPagination(),
            ),
          ),
        ),
      );
    }

    Widget _buildContentContainer() {
      return Container(
        padding: EdgeInsets.fromLTRB(
          12.0 * width * 0.002,
          12.0 * height * 0.002,
          12.0 * width * 0.002,
          32.0 * height * 0.002,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 16.0 * width * 0.002),
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(
                    color: Color.fromRGBO(19, 60, 109, 0.8),
                    width: 3,
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.0 * width * 0.002,
                      vertical: 4.0 * height * 0.002,
                    ),
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(24.0 * height * 0.002),
                      color: Color.fromRGBO(19, 60, 109, 0.8),
                    ),
                    child: Text(
                      "LOST".toUpperCase(),
                      style: textTheme.overline.copyWith(color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 8.0 * height * 0.002),
                  Text(
                    currentPost.postName,
                    style: textTheme.headline,
                  ),
                  SizedBox(height: 8.0 * height * 0.002),
                  Text('Lost By : '+currentPost.ownerName),
                  Container(
                    margin:
                        EdgeInsets.symmetric(vertical: 12.0 * height * 0.002),
                    width: 50,
                    height: 2,
                    color: Color.fromRGBO(19, 60, 109, 0.8),
                  ),
                  SizedBox(height: 8.0 * height * 0.002),
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.location_on_outlined,
                        size: 18,
                      ),
                      SizedBox(width: 8.0 * height * 0.002),
                      Text(
                        "LOCATION",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.0 * height * 0.002),
                  Row(
                    children: <Widget>[
                      Text(currentPost.postLocation),
                    ],
                  ),
                  SizedBox(height: 18.0 * height * 0.002),
                  Row(
                    children: <Widget>[
                      Icon(
                        FontAwesomeIcons.mapPin,
                        size: 18,
                      ),
                      SizedBox(width: 8.0 * height * 0.002),
                      Text(
                        'TIME',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.0 * height * 0.002),
                  Row(
                    children: <Widget>[
                      Text(currentPost.postDate.toString()),
                    ],
                  ),
                  SizedBox(height: 24.0 * height * 0.002),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Additional Details'.toUpperCase(),
                        style: textTheme.overline,
                      ),
                      SizedBox(height: 8.0 * height * 0.002),
                      Text(
                        currentPost.postDescription,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.only(
                  start: width * 0.18, top: height * 0.05),
              child: ClaimButton(),
            )
          ],
        ),
      );
    }

    return Scaffold(
        appBar: AppBar(
          title: Text("Item Details"),
          automaticallyImplyLeading: true,
          backgroundColor: Color.fromRGBO(19, 60, 109, 0.8),
          iconTheme: IconThemeData.fallback(),
        ),
        body: isLoading
            ? CircularProgressIndicator()
            : ListView(
                children: <Widget>[
                  _buildSwiper(),
                  _buildContentContainer(),
                ],
              ));
  }
}

showDialogFunc(context, img, title, desc) {

  return showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: Material(
            type: MaterialType.transparency,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              padding: EdgeInsets.all(15),
              height: 320,
              width: MediaQuery.of(context).size.width * 0.7,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Container(
                      decoration: BoxDecoration(
                          image: DecorationImage(
                        image: CachedNetworkImageProvider(
                          img,
                        ),
                      )),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    // width: 200,
                    child: Align(
                      alignment: Alignment.center,
                      child: FlatButton(
                        onPressed: () {},
                        color: Color.fromRGBO(19, 60, 109, 1),
                        height: 15,
                        minWidth: 100,
                        child: Text("CLAIM",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                            )),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      });
}

Widget ClaimButton() {
  return SliderButton(
    action: () {},
    label: Text(
      "Message",
      style: TextStyle(
          color: Colors.white, fontWeight: FontWeight.w500, fontSize: 25),
    ),
    vibrationFlag: false,
    icon: Center(
        child: Icon(
      Icons.thumb_up_alt,
      color: Color.fromRGBO(19, 60, 109, 1),
      size: 40.0,
      semanticLabel: 'Text to announce in accessibility modes',
    )),
    width: 230,
    radius: 50,
    height: 60,
    buttonSize: 50,
    buttonColor: Colors.white,
    backgroundColor: Color.fromRGBO(19, 60, 109, 1),
    highlightedColor: Colors.white,
    baseColor: Colors.white,
  );
}
