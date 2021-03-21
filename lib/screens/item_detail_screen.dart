import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:lost_found_app/models/post_model.dart';
import 'package:lost_found_app/util/constants.dart';
import 'package:lost_found_app/util/screen_size.dart';
import 'package:shimmer/shimmer.dart';
import 'package:lost_found_app/services/firebase_repository.dart';
import 'chat_screen.dart';
import 'package:lost_found_app/main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animated_button/animated_button.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'dart:typed_data';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:screenshot/screenshot.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../main.dart';

class ItemDetailScreen extends StatefulWidget {
  final String ownerId;
  final String postId;
  final String type;
  const ItemDetailScreen({
    Key key,
    this.ownerId,
    this.postId,
    this.type,
  }) : super(key: key);
  @override
  _ItemDetailScreenState createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends State<ItemDetailScreen> {
  var myFormat = DateFormat('yMMMd');
  PostModel currentPost;
  bool isLoading = true;

  File _imageFile;

  //Create an instance of ScreenshotController
  ScreenshotController screenshotController = ScreenshotController();

  FirebaseRepository databaseMethods = new FirebaseRepository(); //sameer
  sendMessage(String userName) async {
    List<String> users = [user.name, currentPost.ownerName];

    String chatRoomId = getChatRoomId(user.userId, currentPost.ownerId);

    Map<String, dynamic> chatRoom = {
      "users": users,
      "chatRoomId": chatRoomId,
    };

    databaseMethods.addChatRoom(chatRoom, chatRoomId);
    databaseMethods.addChatPeople(currentPost.ownerName, currentPost.ownerId);

    Future.delayed(Duration.zero, () {
      navigatorKey.currentState.push(MaterialPageRoute(
          builder: (context) => Chat(
                chatRoomId: chatRoomId,
                username: userName,
                personID: currentPost.ownerId,
                personName: currentPost.ownerName,
                img:
                    'https://firebasestorage.googleapis.com/v0/b/lost-found-app-2408e.appspot.com/o/asset_images%2F66377888_242269586730532_1532890469642947208_n.jpg?alt=media&token=2cfe880d-088b-48e0-a11b-53d88482546d',
              )));
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _asyncMethod();
    });

    super.initState();
  }

  _asyncMethod() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    currentPost = PostModel.fromSnapshot(await firebaseFirestore
        .collection("AllItems")
        .doc(widget.ownerId)
        .collection("myItems")
        .doc(widget.postId)
        .get());
    setState(() {
      // print(currentPost.postId);
      // print(currentPost.postLocation);
      // print(currentPost.postDescription);
      // print(currentPost.postName);
      // print(currentPost.imageUrl);
      // print(currentPost.ownerName);
      // print(currentPost.postDate);
      isLoading = false;
    });
    print(isLoading);
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
          height: 300 * ScreenSize.heightMultiplyingFactor,
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
                    // if (currentPost.imageUrl != "" &&
                    //     currentPost.imageUrl != null)
                    //   showDialogFunc(context, currentPost.imageUrl,
                    //       currentPost.postName, "LOST");
                  },
                  child: currentPost == null
                      ? Container()
                      : Neumorphic(
                          style: NeumorphicStyle(
                            shape: NeumorphicShape.convex,
                            boxShape: NeumorphicBoxShape.roundRect(
                                BorderRadius.circular(20)),
                            depth: 5,
                            lightSource: LightSource.bottomLeft,
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Color.fromRGBO(19, 60, 130, 1),
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: CachedNetworkImageProvider(
                                    currentPost.imageUrl == ""
                                        ? "https://i.postimg.cc/pdVFbHcJ/42752-404-error.gif "
                                        : currentPost.imageUrl,
                                  ),
                                )),
                          )),
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
          0 * 12.0 * height * 0.002,
          12.0 * width * 0.002,
          32.0 * height * 0.002,
        ),
        child: Stack(
          //crossAxisAlignment: CrossAxisAlignment.start,
          //mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Neumorphic(
              style: NeumorphicStyle(
                shape: NeumorphicShape.flat,
                boxShape:
                    NeumorphicBoxShape.roundRect(BorderRadius.circular(20)),
                depth: 5,
                lightSource: LightSource.bottomLeft,
              ),
              child: Container(
                padding: EdgeInsets.only(left: 16.0 * width * 0.002),
                decoration: BoxDecoration(
                  color: Color(0xffEBEFF3),
                  border: Border(
                    left: BorderSide(
                      color: Color.fromRGBO(19, 60, 130, 1),
                      width: 3 * ScreenSize.widthMultiplyingFactor,
                    ),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 8.0 * height * 0.002),
                    Text(
                      currentPost == null
                          ? ""
                          : currentPost.postName[0].toUpperCase() +
                              currentPost.postName.substring(1),
                      style: GoogleFonts.poppins(
                          fontSize: 35, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8.0 * height * 0.002),
                    Neumorphic(
                        style: NeumorphicStyle(
                          shape: NeumorphicShape.concave,
                          boxShape: NeumorphicBoxShape.roundRect(
                              BorderRadius.circular(10)),
                          depth: 5,
                          lightSource: LightSource.topRight,
                        ),
                        child: Container(
                            height: 30 * ScreenSize.heightMultiplyingFactor,
                            //width: width / 2,
                            child: Text(
                              widget.type == 'Lost'
                                  ? '    Lost By : ' +
                                      (currentPost == null
                                          ? ""
                                          : currentPost.ownerName + "   ")
                                  : '    Found By : ' +
                                      (currentPost == null
                                          ? ""
                                          : currentPost.ownerName + "   "),
                              textAlign: TextAlign.left,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.poppins(
                                  fontSize:
                                      15 * ScreenSize.heightMultiplyingFactor,
                                  fontWeight: FontWeight.bold),
                            ))),
                    Container(
                      margin:
                          EdgeInsets.symmetric(vertical: 12.0 * height * 0.002),
                      width: 50 * ScreenSize.widthMultiplyingFactor,
                      height: 2 * ScreenSize.heightMultiplyingFactor,
                      color: Color.fromRGBO(19, 60, 130, 1),
                    ),
                    SizedBox(height: 8.0 * height * 0.002),
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.location_on_outlined,
                          size: 18 * ScreenSize.heightMultiplyingFactor,
                        ),
                        SizedBox(width: 8.0 * height * 0.002),
                        Text(
                          "LOCATION",
                          style:
                              GoogleFonts.poppins(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(height: 12.0 * height * 0.001),
                    Column(
                      children: <Widget>[
                        Text(
                          currentPost == null ? "" : currentPost.postLocation,
                          //overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                              fontSize:
                                  20 * ScreenSize.heightMultiplyingFactor),
                        ),
                      ],
                    ),
                    SizedBox(height: 18.0 * height * 0.002),
                    Row(
                      children: <Widget>[
                        Icon(
                          FontAwesomeIcons.mapPin,
                          size: 18 * ScreenSize.heightMultiplyingFactor,
                        ),
                        SizedBox(width: 8.0 * height * 0.002),
                        Text(
                          'TIME',
                          style:
                              GoogleFonts.poppins(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(height: 12.0 * height * 0.001),
                    Row(
                      children: <Widget>[
                        // '${DateFormat.jm().format(homeworkData.items[index].dueDate)}',
                        // Text(currentPost==null?"":currentPost.postDate.toString(),),
                        Text(
                          currentPost == null
                              ? ""
                              : '${myFormat.format(currentPost.postDate)}',
                          style: GoogleFonts.poppins(
                              fontSize:
                                  20 * ScreenSize.heightMultiplyingFactor),
                        ),
                      ],
                    ),
                    SizedBox(height: 24.0 * height * 0.002),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('Additional Details'.toUpperCase(),
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold)),
                        SizedBox(height: 8.0 * height * 0.001),
                        Text(
                          currentPost == null
                              ? ""
                              : currentPost.postDescription + "\n\n",
                          style: GoogleFonts.poppins(
                              fontSize:
                                  20 * ScreenSize.heightMultiplyingFactor),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60 * ScreenSize.heightMultiplyingFactor,
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(30.0),
            bottomLeft: Radius.circular(30.0),
          ),
        ),
        backgroundColor: primaryColour,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        title: Text(
          " Item Details ",
          style: GoogleFonts.roboto(
              color: Colors.white,
              fontSize: 20 * ScreenSize.heightMultiplyingFactor,
              fontWeight: FontWeight.w600),
        ),
      ),
      body: isLoading
          ? Shimmer.fromColors(
              baseColor: Colors.grey[300],
              highlightColor: Colors.grey[100],
              enabled: true,
              child: ListView(
                children: <Widget>[
                  _buildSwiper(),
                  _buildContentContainer(),
                ],
              ),
            )
          : ListView(
              children: <Widget>[
                Screenshot(
                    controller: screenshotController,
                    child: ColoredBox(
                        color: Colors.white,
                        child: Column(children: [
                          _buildSwiper(),
                          _buildContentContainer(),
                        ]))),
                widget.ownerId == user.userId
                    ? Container()
                    : Padding(
                        padding: EdgeInsetsDirectional.only(
                            start: width * 0.25,
                            top: height * 0.02,
                            bottom: height * 0.02),
                        child: AnimatedButton(
                          child: Text(
                            'CLAIM',
                            style: GoogleFonts.poppins(
                              fontSize: 22,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          color: Color.fromRGBO(242, 245, 250, 1),
                          onPressed: () {
                            sendMessage(user.name);
                          },
                        )),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColour,
        splashColor: Colors.lightBlueAccent,
        onPressed: () async {
          _takeScreenshotandShare();
        },
        tooltip: 'Increment',
        child: Icon(Icons.share),
      ),
    );
  }

  _takeScreenshotandShare() async {
    _imageFile = null;
    screenshotController
        .capture(delay: Duration(milliseconds: 10), pixelRatio: 2.0)
        .then((File image) async {
      setState(() {
        _imageFile = image;
      });
      final directory = (await getApplicationDocumentsDirectory()).path;
      Uint8List pngBytes = _imageFile.readAsBytesSync();
      File imgFile = new File('$directory/screenshot.png');
      imgFile.writeAsBytes(pngBytes);
      print("File Saved to Gallery");
      await Share.file(
          currentPost.postName, 'screenshot.png', pngBytes, 'image/png');
    }).catchError((onError) {
      print(onError);
    });
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

getChatRoomId(String a, String b) {
  if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
    return "$b\_$a";
  } else {
    return "$a\_$b";
  }
}
