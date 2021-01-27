import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  String postId;
  String postName;
  String postLocation;
  String postDescription;
  String postCategory;
  DateTime postDate;
  String imageUrl;
  String ownerId;

  PostModel({
    this.postId,
    this.postName,
    this.postLocation,
    this.postDescription,
    this.postCategory,
    this.postDate,
    this.imageUrl,
    this.ownerId,
  });

  PostModel.fromSnapshot(DocumentSnapshot snapshot) {
    this.postId = snapshot.data()['postId'];
    this.postName = snapshot.data()['heading'];
    this.postDescription = snapshot.data()['description'];
    this.postCategory = snapshot.data()['category'];
    this.postDate = snapshot.data()['timeStamp'];
    this.imageUrl = snapshot.data()['image_url'];
    this.ownerId = snapshot.data()['ownerId'];
  }
}
