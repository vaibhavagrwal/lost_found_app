import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:lost_found_app/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import '../screens/login_screen.dart';
import '../screens/root_screen.dart';

class FirebaseRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Future<void> updateUserInfo(File _image, String description, _scaffoldKey,
  //     BuildContext context) async {
  //   try {
  //     if (_image != null) {
  //       firebase_storage.FirebaseStorage storage =
  //           firebase_storage.FirebaseStorage.instance;

  //       firebase_storage.Reference ref = firebase_storage
  //           .FirebaseStorage.instance
  //           .ref()
  //           .child('user_images')
  //           .child(user.userId + '.jpg');
  //       await ref.putFile(
  //         _image,
  //       );

  //       String url = await ref.getDownloadURL();

  //       await FirebaseFirestore.instance
  //           .collection('users')
  //           .doc(user.userId)
  //           .update({
  //         'medical_description': description,
  //         'image_url': url,
  //       });

  //       user.imageUrl = url;
  //       user.medicalDescription = description;
  //     } else {
  //       await FirebaseFirestore.instance
  //           .collection('users')
  //           .doc(user.userId)
  //           .update({
  //         'medical_description': description,
  //       });
  //     }
  //     user.medicalDescription = description;
  //     _scaffoldKey.currentState.showSnackBar(
  //       SnackBar(content: Text("Profile Updated")),
  //     );
  //     Navigator.of(context, rootNavigator: true).pushReplacement(
  //       MaterialPageRoute(
  //         builder: (context) => RootScreen(),
  //       ),
  //     );
  //   } catch (e) {
  //     _scaffoldKey.currentState.showSnackBar(
  //       SnackBar(content: Text(e.toString())),
  //     );
  //   }
  // }

  Future<void> signout(BuildContext context) async {
    _auth.signOut();
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref = null;

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
}
