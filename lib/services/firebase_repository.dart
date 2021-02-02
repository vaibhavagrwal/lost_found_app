import 'dart:convert';
import 'dart:io';
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
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(content: Text("Profile Updated")),
      );
      // Navigator.of(context, rootNavigator: true).pushReplacement(
      //   MaterialPageRoute(
      //     builder: (context) => ProfileScreen(),
      //   ),
      // );
      // Navigator.of(context).pop();
    } catch (e) {
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  Future<void> signout(BuildContext context) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.remove('userData');
    await _auth.signOut();

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
        _scaffoldKey.currentState.showSnackBar(
          SnackBar(
              content:
                  Text("Account is not verified! Please verify to login.")),
        );
      }
    } catch (e) {
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  Future<void> signUp(
      String name, String email, String password, _scaffoldKey) async {
    try {
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
          'image_url': "",
          'phone': "",
        });
        _scaffoldKey.currentState.showSnackBar(
          SnackBar(
            content: Text("Please verify your email and login!"),
          ),
        );
      } else {
        _scaffoldKey.currentState.showSnackBar(
          SnackBar(
            content: Text("Some error occurred, please try again!"),
          ),
        );
      }
    } catch (e) {
      print(e);
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
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
          await FirebaseFirestore.instance
              .collection('lostItems')
              .doc(user.userId)
              .collection('myLostItems')
              .doc(postId)
              .set({
            'heading': heading,
            'date': dateTime.toIso8601String(),
            'description': description,
            'image_url': url,
            'location': place,
            'ownerId': user.userId,
            'postId': postId,
            'timeStamp': timeStamp,
            'by':user.name,
          });

          await FirebaseFirestore.instance
              .collection('LostItemsList')
              .doc(postId)
              .set({
            'heading': heading,
            'image_url': url,
            'date': dateTime.toIso8601String(),
            'location': place,
            'ownerId': user.userId,
            'postId': postId,
            'by':user.name,
          });
        } else {
          await FirebaseFirestore.instance
              .collection('FoundItems')
              .doc(user.userId)
              .collection('myFoundItems')
              .doc(postId)
              .set({
            'heading': heading,
            'date': dateTime.toIso8601String(),
            'description': description,
            'image_url': url,
            'location': place,
            'ownerId': user.userId,
            'postId': postId,
            'timeStamp': timeStamp,
            'by':user.name,
          });

          await FirebaseFirestore.instance
              .collection('FoundItemsList')
              .doc(postId)
              .set({
            'heading': heading,
            'image_url': url,
            'date': dateTime.toIso8601String(),
            'location': place,
            'ownerId': user.userId,
            'postId': postId,
            'by':user.name,
          });
        }
      } else {
        if (type == 0) {
          await FirebaseFirestore.instance
              .collection('lostItems')
              .doc(user.userId)
              .collection('myLostItems')
              .doc(postId)
              .set({
            'heading': heading,
            'date': dateTime.toIso8601String(),
            'description': description,
            'image_url': "",
            'location': place,
            'ownerId': user.userId,
            'postId': postId,
            'timeStamp': timeStamp,
            'by':user.name,
          });
          await FirebaseFirestore.instance
              .collection('LostItemsList')
              .doc(postId)
              .set({
            'heading': heading,
            'image_url': "",
            'location': place,
            'date': dateTime.toIso8601String(),
            'ownerId': user.userId,
            'postId': postId,
            'by':user.name,
          });
        } else {
          await FirebaseFirestore.instance
              .collection('FoundItems')
              .doc(user.userId)
              .collection('myFoundItems')
              .doc(postId)
              .set({
            'heading': heading,
            'date': dateTime.toIso8601String(),
            'description': description,
            'image_url': "",
            'location': place,
            'ownerId': user.userId,
            'postId': postId,
            'timeStamp': timeStamp,
            'by':user.name,
          });
          await FirebaseFirestore.instance
              .collection('FoundItemsList')
              .doc(postId)
              .set({
            'heading': heading,
            'image_url': "",
            'date': dateTime.toIso8601String(),
            'location': place,
            'ownerId': user.userId,
            'postId': postId,
            'by':user.name,
          });
        }
      }
      return 0;
    } catch (e) {
      return 1;
    }
  }
}
