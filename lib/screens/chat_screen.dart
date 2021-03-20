import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:lost_found_app/services/firebase_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lost_found_app/main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:emoji_picker/emoji_picker.dart';
import 'package:lost_found_app/util/screen_size.dart';
import 'chat_rooms_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Chat extends StatefulWidget {
  final String chatRoomId;
  final String username;
  final String personID;
  final String personName;
  final String img;

  Chat(
      {this.chatRoomId,
      this.username,
      this.personID,
      this.personName,
      this.img});

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  bool isShowSticker = true;
  Stream<QuerySnapshot> chats;
  TextEditingController messageEditingController = new TextEditingController();
  ScrollController _listScrollController = ScrollController();

  Future<bool> onBackPress() {
    if (isShowSticker) {
      setState(() {
        isShowSticker = false;
        //messageEditingController.selection = TextSelection.collapsed(offset: messageEditingController.text.length); //for pointer
      });
    } else {
      navigatorKey.currentState
          .pushReplacement(MaterialPageRoute(builder: (context) => ChatRoom()));
    }

    return Future.value(false);
  }

  Widget chatMessages() {
    return StreamBuilder(
      stream: chats,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                shrinkWrap: true,
                reverse: true,
                itemCount: snapshot.data.docs.length,
                controller: _listScrollController,
                itemBuilder: (context, index) {
                  print(index.toString());

                  FirebaseRepository()
                      .readUserMessages(widget.chatRoomId, widget.personID);
                  return MessageTile(
                    message: snapshot.data.docs[index].data()["message"],
                    sendByMe: user.userId ==
                        snapshot.data.docs[index].data()["sendBy"],
                    time: snapshot.data.docs[index].data()["time"],
                    index: snapshot.data.docs.length - index - 1,
                    personName: widget.personName,
                    read: snapshot.data.docs[index].data()["read"],
                    img: widget.img,
                  );
                })
            : Container();
      },
    );
  }

  addMessage() {
    if (_listScrollController.hasClients) {
      _listScrollController.animateTo(
          _listScrollController.position.minScrollExtent,
          duration: Duration(milliseconds: 250),
          curve: Curves.easeInOut);
    }

    DateTime timeStamp = DateTime.now();
    if (messageEditingController.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "sendBy": user.userId,
        "message": messageEditingController.text,
        'time': timeStamp,
        'read': 0,
        'MessageId': timeStamp.toString(),
      };

      FirebaseRepository().addMessage(widget.chatRoomId, chatMessageMap,
          widget.personID, widget.personName);
      FirebaseFirestore.instance
          .collection("UserChatPeople")
          .doc(user.userId)
          .collection(user.userId)
          .doc(widget.personID)
          .update({
        'read': 0,
      }).catchError((e) {
        print(e);
      });

      setState(() {
        messageEditingController.text = "";
      });
    }
  }

  @override
  void initState() {
    FirebaseRepository().readUserMessages(widget.chatRoomId, widget.personID);

    FirebaseRepository().getChats(widget.chatRoomId).then((val) {
      setState(() {
        chats = val;
      });
    });

    super.initState();
    isShowSticker = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.keyboard_backspace),
            onPressed: () {
              navigatorKey.currentState.pushReplacement(
                  MaterialPageRoute(builder: (context) => ChatRoom()));
            },
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          iconTheme: IconThemeData(
            color: Color.fromRGBO(44, 62, 80, 1),
          ),
          title: Row(children: [
            ClipOval(
              child: Image(
                image: CachedNetworkImageProvider(widget.img),
                width: 50 * ScreenSize.widthMultiplyingFactor,
                height: 50 * ScreenSize.heightMultiplyingFactor,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 20),
            Text(
              widget.personName.length > 16
                  ? widget.personName.substring(0, 13) + "..."
                  : widget.personName[0].toUpperCase() +
                      widget.personName.substring(1),
              style: GoogleFonts.roboto(
                  color: Color.fromRGBO(44, 62, 80, 1),
                  fontSize: 18 * ScreenSize.heightMultiplyingFactor,
                  fontWeight: FontWeight.bold),
            ),
          ])),
      body: Container(
          child: Stack(children: [
        Container(
          padding: isShowSticker
              ? EdgeInsetsDirectional.only(
                  bottom: MediaQuery.of(context).size.height / 12 +
                      MediaQuery.of(context).size.height / 3.5)
              : EdgeInsetsDirectional.only(
                  bottom: MediaQuery.of(context).size.height / 12),
          child: chatMessages(),
        ),
        WillPopScope(
          child: Container(
            //padding: EdgeInsetsDirectional.only(bottom: 200),
            alignment: Alignment.bottomCenter,
            padding: isShowSticker
                ? EdgeInsetsDirectional.only(
                    bottom: MediaQuery.of(context).size.height / 3.5)
                : EdgeInsetsDirectional.only(bottom: 0),
            width: MediaQuery.of(context).size.width,
            // height: MediaQuery.of(context).size.height/4,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              color: Colors.transparent,
              child: Neumorphic(
                  style: NeumorphicStyle(
                    shape: NeumorphicShape.concave,
                    boxShape:
                        NeumorphicBoxShape.roundRect(BorderRadius.circular(20)),
                    depth: 20,
                    lightSource: LightSource.topRight,
                  ),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 10 * ScreenSize.heightMultiplyingFactor,
                      horizontal: 15 * ScreenSize.widthMultiplyingFactor,
                    ),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.blueGrey.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              isShowSticker = !isShowSticker;
                              SystemChannels.textInput
                                  .invokeMethod('TextInput.hide');
                            });
                          },
                          child: Image.asset(
                            'lib/assets/emojiicon.gif',
                            width: 50,
                          ),
                        ),
                        SizedBox(
                          width: 10 * ScreenSize.widthMultiplyingFactor,
                        ),
                        Expanded(
                          child: TextField(
                            onTap: () {
                              setState(() {
                                isShowSticker = false;
                                //SystemChannels.textInput.invokeMethod('TextInput.show');
                              });
                            },
                            autofocus: true,
                            controller: messageEditingController,
                            style: GoogleFonts.poppins(
                              fontSize: 18 * ScreenSize.heightMultiplyingFactor,
                              color: Colors.white,
                            ),
                            decoration: InputDecoration.collapsed(
                              hintText: 'Type message..',
                              hintStyle: GoogleFonts.poppins(
                                fontSize:
                                    18 * ScreenSize.heightMultiplyingFactor,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        Neumorphic(
                          style: NeumorphicStyle(
                            shape: NeumorphicShape.flat,
                            boxShape: NeumorphicBoxShape.roundRect(
                                BorderRadius.circular(20)),
                            depth: 3,
                            lightSource: LightSource.topLeft,
                          ),
                          child: InkWell(
                            onTap: () {
                              addMessage();
                              print('tapped');
                            },
                            child: Image.asset(
                              'lib/assets/sendbtn.png',
                              width: 50 * ScreenSize.widthMultiplyingFactor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),

              // isShowSticker ?  buildSticker() : Container(),
            ),
          ),
          onWillPop: onBackPress,
        ),
        Positioned(
          bottom: 0,
          child: isShowSticker
              ? Container(
                  width: MediaQuery.of(context).size.height / 2,
                  padding: EdgeInsetsDirectional.only(
                      bottom: 10 * ScreenSize.heightMultiplyingFactor),
                  color: Colors.transparent,
                  child: Neumorphic(
                      style: NeumorphicStyle(
                        shape: NeumorphicShape.concave,
                        boxShape: NeumorphicBoxShape.roundRect(
                            BorderRadius.circular(20)),
                        depth: 20,
                        lightSource: LightSource.topRight,
                      ),
                      child: buildSticker()))
              : Container(),
        )
      ])),
    );
  }

  Widget buildSticker() {
    return EmojiPicker(
      rows: 3,
      columns: 7,
      buttonMode: ButtonMode.MATERIAL,
      recommendKeywords: ["racing", "horse"],
      numRecommended: 10,
      onEmojiSelected: (emoji, category) {
        {
          setState(() {
            messageEditingController.selection = TextSelection.collapsed(
                offset: messageEditingController.text.length);
          });

          messageEditingController.text =
              messageEditingController.text + emoji.emoji;
        }
      },
    );
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool sendByMe;
  final Timestamp time;
  final String personName;
  final int index;
  final Timestamp prevtime;
  final int read;
  final Timestamp curtime;
  final String img;

  MessageTile(
      {@required this.message,
      @required this.sendByMe,
      @required this.time,
      @required this.read,
      this.index,
      this.personName,
      this.prevtime,
      this.curtime,
      this.img});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      index == 0
          ? Padding(
              padding: EdgeInsetsDirectional.only(
                  bottom: 20 * ScreenSize.heightMultiplyingFactor),
              child: Container(
                color: Colors.redAccent.withOpacity(0.5),
                child: Text(
                  "NOTE : You are only allowed to send 50 messages to a particular user. Please switch to other platform for contact if you want to talk further.",
                  style: GoogleFonts.roboto(fontWeight: FontWeight.bold),
                ),
              ))
          : Container(),
      index == 0
          ? Center(
              child: ClipOval(
              child: Image(
                image: CachedNetworkImageProvider(img),
                width: 100 * ScreenSize.widthMultiplyingFactor,
                height: 100 * ScreenSize.heightMultiplyingFactor,
                fit: BoxFit.cover,
              ),
            ))
          : Container(),
      index == 0
          ? Padding(
              padding: EdgeInsetsDirectional.only(top: 10, bottom: 10),
              child: Text(
                personName.length > 16
                    ? personName.substring(0, 13) + "..."
                    : personName[0].toUpperCase() + personName.substring(1),
                style: GoogleFonts.poppins(
                    color: Color(0xff505C6B),
                    fontSize: 25 * ScreenSize.heightMultiplyingFactor,
                    fontWeight: FontWeight.bold),
                //textAlign: !sendByMe ? TextAlign.end : TextAlign.start,
              ))
          : Container(),
      Padding(
        padding:
            EdgeInsets.only(bottom: 30 * ScreenSize.heightMultiplyingFactor),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment:
              sendByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: <Widget>[
            !sendByMe
                ? SizedBox(
                    width: 6 * ScreenSize.widthMultiplyingFactor,
                  )
                : Container(),
            !sendByMe
                ? ClipOval(
                    child: Image(
                      image: CachedNetworkImageProvider(img),
                      width: 60 * ScreenSize.widthMultiplyingFactor,
                      height: 60 * ScreenSize.heightMultiplyingFactor,
                      fit: BoxFit.cover,
                    ),
                  )
                : Container(),
            !sendByMe
                ? SizedBox(
                    width: 12 * ScreenSize.widthMultiplyingFactor,
                  )
                : Container(),
            Flexible(
              child: Neumorphic(
                style: NeumorphicStyle(
                  shape: NeumorphicShape.concave,
                  boxShape:
                      NeumorphicBoxShape.roundRect(BorderRadius.circular(20)),
                  depth: 20,
                  lightSource:
                      !sendByMe ? LightSource.topLeft : LightSource.topRight,
                ),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: Color(0xffEBEFF3),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                      bottomLeft:
                          !sendByMe ? Radius.circular(0) : Radius.circular(20),
                      bottomRight:
                          !sendByMe ? Radius.circular(20) : Radius.circular(0),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: !sendByMe
                        ? CrossAxisAlignment.start
                        : CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                          constraints:
                              BoxConstraints(minWidth: 0, maxWidth: 220),
                          child: Text(
                            message,
                            style: GoogleFonts.poppins(
                                color: Color(0xff505C6B), fontSize: 20),
                            textAlign: TextAlign.start,
                          )),
                      Wrap(
                          //mainAxisAlignment: MainAxisAlignment.end,

                          children: [
                            sendByMe
                                ? read != 1
                                    ? Icon(
                                        Icons.check,
                                        size: 17.0 *
                                            ScreenSize.heightMultiplyingFactor,
                                        color: Colors.black,
                                      )
                                    : Icon(
                                        Icons.done_all,
                                        size: 17.0 *
                                            ScreenSize.heightMultiplyingFactor,
                                        color: Colors.green,
                                      )
                                : Container(
                                    width: 0,
                                  ),
                            sendByMe
                                ? SizedBox(
                                    width:
                                        8 * ScreenSize.widthMultiplyingFactor)
                                : Container(
                                    width: 0,
                                  ),
                            Text(
                              DateFormat('hh:mm a')
                                  .format(time.toDate())
                                  .toString(),
                              style: GoogleFonts.poppins(
                                color: Color(0xff808BA2),
                                fontWeight: FontWeight.w400,
                                fontSize:
                                    14 * ScreenSize.heightMultiplyingFactor,
                              ),
                            ),
                          ])
                    ],
                  ),
                ),
              ),
            ),
            !sendByMe
                ? Container()
                : SizedBox(
                    width: 12 * ScreenSize.widthMultiplyingFactor,
                  ),
            !sendByMe
                ? Container()
                : ClipOval(
                    child: Image.asset(
                      "lib/assets/face1.gif",
                      width: 60 * ScreenSize.widthMultiplyingFactor,
                      height: 60 * ScreenSize.heightMultiplyingFactor,
                      fit: BoxFit.fill,
                    ),
                  ),
            !sendByMe
                ? Container()
                : SizedBox(
                    width: 6 * ScreenSize.widthMultiplyingFactor,
                  ),
          ],
        ),
      )
    ]);
  }
}
