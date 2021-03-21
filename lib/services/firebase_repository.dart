import 'dart:convert';
import 'dart:io';
import 'package:flushbar/flushbar.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lost_found_app/models/user_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image/image.dart' as Im;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import '../screens/login_screen.dart';
import '../screens/root_screen.dart';

class FirebaseRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> updateUserInfo(File _image, String name, String phone,
      _scaffoldKey, BuildContext context) async {
    try {
      if (_image != null) {
        firebase_storage.Reference ref = firebase_storage
            .FirebaseStorage.instance
            .ref()
            .child('user_images')
            .child(user.userId + '.jpg');
        await ref.putFile(
          _image,
        );

        String url = await ref.getDownloadURL();

        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.userId)
            .update({
          'name': name,
          'phone': phone,
          'image_url': url,
        });

        user.imageUrl = url;
        user.name = name;
        user.phone = phone;
        SharedPreferences pref = await SharedPreferences.getInstance();
        String user1 = jsonEncode(user);
        pref.setString('userData', user1);
      } else {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.userId)
            .update({
          'name': name,
          'phone': phone,
        });
      }
      user.name = name;
      user.phone = phone;
      SharedPreferences pref = await SharedPreferences.getInstance();
      String user1 = jsonEncode(user);
      pref.setString('userData', user1);
      showSuccessFlushbar("Success", "Profile Updated", context);

      // Navigator.of(context, rootNavigator: true).pushReplacement(
      //   MaterialPageRoute(
      //     builder: (context) => ProfileScreen(),
      //   ),
      // );
      // Navigator.of(context).pop();
    } catch (error) {
      String errorMessage;
      switch (error.message) {
        case "ERROR_INVALID_EMAIL":
          errorMessage = "Your email address appears to be malformed.";
          break;
        case 'The password is invalid or the user does not have a password.':
          errorMessage = "Your password is invalid.";
          break;
        case 'There is no user record corresponding to this identifier. The user may have been deleted.':
          errorMessage = "User with this email doesn't exist.";
          break;
        case "ERROR_USER_DISABLED":
          errorMessage = "User with this email has been disabled.";
          break;
        case "ERROR_TOO_MANY_REQUESTS":
          errorMessage = "Too many requests. Try again later.";
          break;
        case 'A network error (such as timeout, interrupted connection or unreachable host) has occurred.':
          errorMessage = "Network error..!!.";
          break;
        default:
          errorMessage = error.toString();
      }
      print(error);
      // _scaffoldKey.currentState.showSnackBar(
      //   SnackBar(content: Text(errorMessage)),
      // );
      showErrorFlushbar("Error", errorMessage, context);
    }
  }

  Future<void> signout(BuildContext context) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.remove('userData');
    await _auth.signOut();

    GoogleSignIn _googleSignIn = GoogleSignIn();
    _googleSignIn.disconnect();

    Navigator.of(context, rootNavigator: true).pushReplacement(
      MaterialPageRoute(
        builder: (context) => LoginScreen(),
      ),
    );
  }

  Future<void> signIn(
      String email, String password, _scaffoldKey, BuildContext context) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      print(userCredential.user.emailVerified);
      if (userCredential.user.emailVerified) {
        SharedPreferences pref = await SharedPreferences.getInstance();

        DocumentSnapshot snapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(_auth.currentUser.uid)
            .get();
        user = UserModel(
          userId: snapshot.data()['id'],
          name: snapshot.data()['name'],
          email: snapshot.data()['email'],
          imageUrl: snapshot.data()['image_url'],
          phone: snapshot.data()['phone'],
          isModerator: snapshot.data()['isModerator'],
        );

        String user1 = jsonEncode(user);
        pref.setString('userData', user1);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => RootScreen(),
          ),
        );
      } else {
        // _scaffoldKey.currentState.showSnackBar(
        //   SnackBar(
        //       content:
        //           Text("Account is not verified! Please verify to login.")),
        // );
        showErrorFlushbar("Error",
            "Account is not verified! Please verify to login.", context);
      }
    } catch (error) {
      String errorMessage;
      switch (error.message) {
        case "ERROR_INVALID_EMAIL":
          errorMessage = "Your email address appears to be malformed.";
          break;
        case 'The password is invalid or the user does not have a password.':
          errorMessage = "Your password is invalid.";
          break;
        case 'There is no user record corresponding to this identifier. The user may have been deleted.':
          errorMessage = "User with this email doesn't exist.";
          break;
        case "ERROR_USER_DISABLED":
          errorMessage = "User with this email has been disabled.";
          break;
        case "ERROR_TOO_MANY_REQUESTS":
          errorMessage = "Too many requests. Try again later.";
          break;
        case 'A network error (such as timeout, interrupted connection or unreachable host) has occurred.':
          errorMessage = "Network error..!!.";
          break;
        case 'com.google.firebase.FirebaseException: An internal error has occurred. [ Unable to resolve host "www.googleapis.com":No address associated with hostname ]':
          errorMessage = "Network Error!";
          break;

        default:
          errorMessage = "An undefined Error occured.";
      }
      print(error);
      // _scaffoldKey.currentState.showSnackBar(
      //   SnackBar(content: Text(errorMessage)),
      // );
      showErrorFlushbar("Error", errorMessage, context);
    }
  }

  Future<void> resetPassword(
      String email, _scaffoldKey, BuildContext context) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      // _scaffoldKey.currentState.showSnackBar(
      //   SnackBar(
      //       content: Text(
      //           "Password reset link sent on your email-id. Please check it.")),
      // );
      showSuccessFlushbar(
          "Success",
          "Password reset link sent on your email-id. Please check it.",
          context);
    } catch (error) {
      String errorMessage;
      switch (error.code) {
        case "ERROR_EMAIL_ALREADY_IN_USE":
        case "account-exists-with-different-credential":
        case "email-already-in-use":
          errorMessage = "Email already used. Go to login page.";
          break;
        case "ERROR_WRONG_PASSWORD":
        case "wrong-password":
          errorMessage = "Wrong email/password combination.";
          break;
        case "ERROR_USER_NOT_FOUND":
        case "user-not-found":
          errorMessage = "No user found with this email.";
          break;
        case "ERROR_USER_DISABLED":
        case "user-disabled":
          errorMessage = "User disabled.";
          break;
        case "ERROR_TOO_MANY_REQUESTS":
        case "operation-not-allowed":
          errorMessage = "Too many requests to log into this account.";
          break;
        case "ERROR_OPERATION_NOT_ALLOWED":
        case "operation-not-allowed":
          errorMessage = "Server error, please try again later.";
          break;
        case "ERROR_INVALID_EMAIL":
        case "invalid-email":
          errorMessage = "Email address is invalid.";
          break;
        case 'com.google.firebase.FirebaseException: An internal error has occurred. [ Unable to resolve host "www.googleapis.com":No address associated with hostname ]':
          errorMessage = "Network Error!";
          break;
        default:
          errorMessage = "Login failed. Please try again.";
          break;
      }
      print(error);
      showErrorFlushbar("Error", errorMessage, context);
      // _scaffoldKey.currentState.showSnackBar(
      //   SnackBar(content: Text(errorMessage)),
      // );
    }
  }

  showErrorFlushbar(String heading, String des, BuildContext context) {
    Flushbar(
      title: heading,
      message: des,
      margin: EdgeInsets.all(8),
      borderRadius: 8,
      icon: Icon(
        Icons.error,
        color: Colors.white,
      ),
      backgroundColor: Colors.red,
      duration: Duration(seconds: 3),
    )..show(context);
  }

  showSuccessFlushbar(String heading, String des, BuildContext context) {
    Flushbar(
      title: heading,
      margin: EdgeInsets.all(8),
      borderRadius: 8,
      message: des,
      backgroundColor: Colors.green,
      icon: Icon(
        Icons.check,
        color: Colors.greenAccent,
      ),
      duration: Duration(seconds: 3),
    )..show(context);
  }

  Future<void> signUp(String name, String email, String password, _scaffoldKey,
      BuildContext context) async {
    String uid, oldEmail, oldPass;
    try {
      await FirebaseFirestore.instance
          .collection("users")
          .where('email', isEqualTo: email)
          .get()
          .then((querySnapshot) => {
                querySnapshot.docs.forEach((docu) {
                  uid = docu.get('id');
                  oldEmail = docu.get('email');
                  oldPass = docu.get('password');
                })
              });
      if (uid != null) {
        UserCredential userCredential1 = await _auth.signInWithEmailAndPassword(
            email: email, password: oldPass);
        if (userCredential1.user.emailVerified == false) {
          await userCredential1.user.delete();
          await FirebaseFirestore.instance
              .collection('users')
              .doc(uid)
              .delete();
        }
      }

      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      if (userCredential != null) {
        userCredential.user.sendEmailVerification();

        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user.uid)
            .set({
          'id': userCredential.user.uid,
          'name': name,
          'email': email,
          'password': password,
          'image_url': "",
          'phone': "",
          'isModerator': false,
        });
        showSuccessFlushbar(
            "Success", "Please Verify your Email and Login..!.", context);
        // _scaffoldKey.currentState.showSnackBar(
        //   SnackBar(
        //     content: Text("Please verify your email and login!"),
        //   ),
        // );
      } else {
        showErrorFlushbar("Error", "Please Try Again...", context);
        // _scaffoldKey.currentState.showSnackBar(
        //   SnackBar(
        //     content: Text("Some error occurred, please try again!"),
        //   ),
        // );
      }
    } catch (error) {
      String errorMessage;
      switch (error.message) {
        case "ERROR_USER_NOT_FOUND":
        case "user-not-found":
          errorMessage = "No user found with this email.";
          break;
        case "ERROR_USER_DISABLED":
        case "user-disabled":
          errorMessage = "User disabled.";
          break;
        case "ERROR_TOO_MANY_REQUESTS":
        case "operation-not-allowed":
          errorMessage = "Too many requests to log into this account.";
          break;
        case "ERROR_OPERATION_NOT_ALLOWED":
        case "operation-not-allowed":
          errorMessage = "Server error, please try again later.";
          break;
        case "ERROR_INVALID_EMAIL":
        case "invalid-email":
          errorMessage = "Email address is invalid.";
          break;
        case 'com.google.firebase.FirebaseException: An internal error has occurred. [ Unable to resolve host "www.googleapis.com":No address associated with hostname ]':
          errorMessage = "Network Error!";
          break;
        case 'field does not exist within the DocumentSnapshotPlatform':
          errorMessage = "Email already SignedUp. Please SignIn.";
          break;
        default:
          errorMessage = error.message.toString();
          break;
      }
      print(errorMessage);

      showErrorFlushbar("Error", errorMessage, context);
    }
  }

  Future<int> createPost(
    File _image,
    int type,
    String heading,
    String category,
    String description,
    String place,
    DateTime dateTime,
    BuildContext context,
  ) async {
    assert(DateTime != null);
    DateTime timeStamp = DateTime.now();
    final String postId = timeStamp.microsecondsSinceEpoch.toString();
    try {
      if (_image != null) {
        final tempDir = await getTemporaryDirectory();
        final path = tempDir.path;
        Im.Image imageFile = Im.decodeImage(_image.readAsBytesSync());
        final compressedImageFile = File("$path/img_$postId.jpg")
          ..writeAsBytesSync(
            Im.encodeJpg(imageFile, quality: 60),
          );
        _image = compressedImageFile;

        firebase_storage.Reference ref = firebase_storage
            .FirebaseStorage.instance
            .ref()
            .child('post_images')
            .child(postId + '.jpg');
        await ref.putFile(
          _image,
        );

        String url = await ref.getDownloadURL();
        if (type == 0) {
          // await FirebaseFirestore.instance
          //     .collection('lostItems')
          //     .doc(user.userId)
          //     .collection('myLostItems')
          //     .doc(postId)
          //     .set({
          //   'heading': heading,
          //   'date': dateTime,
          //   'description': description,
          //   'image_url': url,
          //   'location': place,
          //   'ownerId': user.userId,
          //   'postId': postId,
          //   'timeStamp': timeStamp,
          //   'by': user.name,
          // });
          await FirebaseFirestore.instance
              .collection('AllItems')
              .doc(user.userId)
              .collection('myItems')
              .doc(postId)
              .set({
            'heading': heading,
            'date': dateTime,
            'description': description,
            'image_url': url,
            'location': place,
            'ownerId': user.userId,
            'postId': postId,
            'timeStamp': timeStamp,
            'by': user.name,
            'status': "Lost",
            'isVerified': false,
          });

          await FirebaseFirestore.instance
              .collection('LostItemsList')
              .doc(postId)
              .set({
            'heading': heading,
            'image_url': url,
            'date': dateTime,
            'location': place,
            'ownerId': user.userId,
            'postId': postId,
            'by': user.name,
            'isVerified': false,
          });
        } else {
          // await FirebaseFirestore.instance
          //     .collection('FoundItems')
          //     .doc(user.userId)
          //     .collection('myFoundItems')
          //     .doc(postId)
          //     .set({
          //   'heading': heading,
          //   'date': dateTime,
          //   'description': description,
          //   'image_url': url,
          //   'location': place,
          //   'ownerId': user.userId,
          //   'postId': postId,
          //   'timeStamp': timeStamp,
          //   'by': user.name,
          // });
          await FirebaseFirestore.instance
              .collection('AllItems')
              .doc(user.userId)
              .collection('myItems')
              .doc(postId)
              .set({
            'heading': heading,
            'date': dateTime,
            'description': description,
            'image_url': url,
            'location': place,
            'ownerId': user.userId,
            'postId': postId,
            'timeStamp': timeStamp,
            'by': user.name,
            'status': "Found",
            'isVerified': false,
          });

          await FirebaseFirestore.instance
              .collection('FoundItemsList')
              .doc(postId)
              .set({
            'heading': heading,
            'image_url': url,
            'date': dateTime,
            'location': place,
            'ownerId': user.userId,
            'postId': postId,
            'by': user.name,
            'isVerified': false,
          });
        }
      } else {
        if (type == 0) {
          await FirebaseFirestore.instance
              .collection('AllItems')
              .doc(user.userId)
              .collection('myItems')
              .doc(postId)
              .set({
            'heading': heading,
            'date': dateTime,
            'description': description,
            'image_url': "",
            'location': place,
            'ownerId': user.userId,
            'postId': postId,
            'timeStamp': timeStamp,
            'by': user.name,
            'status': "Lost",
            'isVerified': false,
          });

          // await FirebaseFirestore.instance
          //     .collection('lostItems')
          //     .doc(user.userId)
          //     .collection('myLostItems')
          //     .doc(postId)
          //     .set({
          //   'heading': heading,
          //   'date': dateTime,
          //   'description': description,
          //   'image_url': "",
          //   'location': place,
          //   'ownerId': user.userId,
          //   'postId': postId,
          //   'timeStamp': timeStamp,
          //   'by': user.name,
          // });
          await FirebaseFirestore.instance
              .collection('LostItemsList')
              .doc(postId)
              .set({
            'heading': heading,
            'image_url': "",
            'location': place,
            'date': dateTime,
            'ownerId': user.userId,
            'postId': postId,
            'by': user.name,
            'isVerified': false,
          });
        } else {
          await FirebaseFirestore.instance
              .collection('AllItems')
              .doc(user.userId)
              .collection('myItems')
              .doc(postId)
              .set({
            'heading': heading,
            'date': dateTime,
            'description': description,
            'image_url': "",
            'location': place,
            'ownerId': user.userId,
            'postId': postId,
            'timeStamp': timeStamp,
            'by': user.name,
            'status': "Found",
            'isVerified': false,
          });

          // await FirebaseFirestore.instance
          //     .collection('FoundItems')
          //     .doc(user.userId)
          //     .collection('myFoundItems')
          //     .doc(postId)
          //     .set({
          //   'heading': heading,
          //   'date': dateTime,
          //   'description': description,
          //   'image_url': "",
          //   'location': place,
          //   'ownerId': user.userId,
          //   'postId': postId,
          //   'timeStamp': timeStamp,
          //   'by': user.name,
          // });
          await FirebaseFirestore.instance
              .collection('FoundItemsList')
              .doc(postId)
              .set({
            'heading': heading,
            'image_url': "",
            'date': dateTime,
            'location': place,
            'ownerId': user.userId,
            'postId': postId,
            'by': user.name,
            'isVerified': false,
          });
        }
      }
      return 0;
    } catch (e) {
      print(e.toString());

      return 1;
    }
  }

  // chat work
  Future<bool> addChatRoom(chatRoom, chatRoomId) {
    FirebaseFirestore.instance
        .collection("ChatRoom")
        .doc(chatRoomId)
        .set(chatRoom, SetOptions(merge: true))
        .catchError((e) {
      print(e);
    });
  }

  // ignore: non_constant_identifier_names
  Future<bool> addChatPeople(UserName, UserID) {
    FirebaseFirestore.instance
        .collection("UserChatPeople")
        .doc(user.userId)
        .collection(user.userId)
        .doc(UserID)
        .set({
      'user_name': UserName,
      'user_ID': UserID,
    }, SetOptions(merge: true)).catchError((e) {
      print(e);
    });

    FirebaseFirestore.instance
        .collection("UserChatPeople")
        .doc(UserID)
        .collection(UserID)
        .doc(user.userId)
        .set({
      'user_name': user.name,
      'user_ID': user.userId,
    }, SetOptions(merge: true)).catchError((e) {
      print(e);
    });
    //for easiness otherwise we can remove this one
    FirebaseFirestore.instance
        .collection("UserChatPeople")
        .doc(user.userId)
        .set({
      'user_name': user.name,
      'user_ID': user.userId,
    }).catchError((e) {
      print(e);
    });
    FirebaseFirestore.instance.collection("UserChatPeople").doc(UserID).set({
      'user_name': UserName,
      'user_ID': UserID,
    }).catchError((e) {
      print(e);
    });
  }

  getChats(String chatRoomId) async {
    return FirebaseFirestore.instance
        .collection("ChatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .orderBy('time', descending: true)
        .snapshots();
  }

  Future<void> addMessage(
      String chatRoomId, chatMessageData, String personID, String personName) {
    FirebaseFirestore.instance
        .collection("ChatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .doc(chatMessageData['time'].toString())
        .set(chatMessageData)
        .catchError((e) {
      print(e.toString());
    });

    //last message
    //sender data base
    FirebaseFirestore.instance
        .collection("UserChatPeople")
        .doc(user.userId)
        .collection(user.userId)
        .doc(personID)
        .update({
      'user_name': personName,
      'user_ID': personID,
      'sender_name': user.name,
      'lastMessage': chatMessageData['message'],
      'lastMessage_sendBy': chatMessageData['sendBy'],
      'lastMessageTime': chatMessageData['time'],
      'read': 0,
    }).catchError((e) {
      print(e);
    });

    //otherperson data base

    FirebaseFirestore.instance
        .collection("UserChatPeople")
        .doc(personID)
        .collection(personID)
        .doc(user.userId)
        .update({
      //'user_name' : user_name,
      'user_name': user.name,
      'user_ID': user.userId,
      'sender_name': user.name,
      'lastMessage': chatMessageData['message'],
      'lastMessage_sendBy': chatMessageData['sendBy'],
      'lastMessageTime': chatMessageData['time'],
      //'read' : 0,
    }).catchError((e) {
      print(e);
    });
  }

  getUserChats(String itIsMyName) async {
    return await FirebaseFirestore.instance
        .collection("ChatRoom")
        .where('users', arrayContains: itIsMyName)
        .snapshots();
  }

  getUserPeople() async {
    return await FirebaseFirestore.instance
        .collection("UserChatPeople")
        .doc(user.userId)
        .collection(user.userId)
        .orderBy('lastMessageTime')
        .snapshots();
  }

  Future<void> readUserMessages(String chatRoomId, String userId) async {
    QuerySnapshot unreadDocs = await FirebaseFirestore.instance
        .collection("ChatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .where('sendBy', isEqualTo: userId)
        .where('read', isEqualTo: 0)
        .get()
        .catchError((e) {
      print(e.toString());
    });
    List unreadList = unreadDocs.docs;
    for (DocumentSnapshot i in unreadList) {
      FirebaseFirestore.instance
          .collection("ChatRoom")
          .doc(chatRoomId)
          .collection("chats")
          .doc(i['MessageId'].toString())
          .update(
        {'read': 1},
      ).catchError((e) {
        print(e.toString());
      });
      print(i['read'].toString());
    }

    FirebaseFirestore.instance
        .collection("UserChatPeople")
        .doc(userId)
        .collection(userId)
        .doc(user.userId)
        .update({
      'read': 1,
    }).catchError((e) {
      print(e);
    });
  }

  Future<void> signInGoogle(BuildContext context, _scaffoldKey) async {
    try {
      final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return;
      print("1111111111");
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final GoogleAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      print("122222222");
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      bool isNewUser = userCredential.additionalUserInfo.isNewUser;
      if (isNewUser) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user.uid)
            .set({
          'id': userCredential.user.uid,
          'name': userCredential.user.displayName,
          'email': userCredential.user.email,
          'image_url': userCredential.user.photoURL,
          'phone': userCredential.user.phoneNumber ?? "",
          'isModerator': false,
        });
      }
      print("3333333");

      SharedPreferences pref = await SharedPreferences.getInstance();

      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(_auth.currentUser.uid)
          .get();
      print("444444444");
      user = UserModel(
        userId: snapshot.data()['id'],
        name: snapshot.data()['name'],
        email: snapshot.data()['email'],
        imageUrl: snapshot.data()['image_url'],
        phone: snapshot.data()['phone'],
        isModerator: snapshot.data()['isModerator'],
      );
      print("5555555");

      String user1 = jsonEncode(user);
      pref.setString('userData', user1);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => RootScreen(),
        ),
      );
    } catch (error) {
      print(error);
      String errorMessage;

      String s = "";
      try {
        s = error.message;
        print(s);
        switch (s) {
          case "ERROR_INVALID_EMAIL":
            errorMessage = "Your email address appears to be malformed.";
            break;
          case 'The password is invalid or the user does not have a password.':
            errorMessage = "Your password is invalid.";
            break;
          case 'There is no user record corresponding to this identifier. The user may have been deleted.':
            errorMessage = "User with this email doesn't exist.";
            break;
          case "ERROR_USER_DISABLED":
            errorMessage = "User with this email has been disabled.";
            break;
          case "ERROR_TOO_MANY_REQUESTS":
            errorMessage = "Too many requests. Try again later.";
            break;
          case "com.google.android.gms.common.api.ApiException: 7:":
            errorMessage = "Network error..!!.";
            break;
          case 'com.google.firebase.FirebaseException: An internal error has occurred. [ Unable to resolve host "www.googleapis.com":No address associated with hostname ]':
            errorMessage = "Network Error!";
            break;
          default:
            errorMessage = "An undefined Error occured.";
        }

        print("Message " + error.message);
        // _scaffoldKey.currentState.showSnackBar(
        //   SnackBar(content: Text(errorMessage)),
        // );
        showErrorFlushbar("Error", errorMessage, context);
      } catch (e) {
        showErrorFlushbar("Error", "An undefined error occurred!!", context);
      }
    }
  }
}
