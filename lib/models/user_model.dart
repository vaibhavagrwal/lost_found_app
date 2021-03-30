import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String userId;
  String name;
  String email;
  String imageUrl;
  String phone;
  bool isModerator;
  int not;

  DocumentReference reference;
  UserModel({
    this.userId,
    this.name,
    this.email,
    this.imageUrl,
    this.phone,
    this.isModerator,
    this.not,
  });
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        userId: json['id'],
        email: json['email'],
        name: json['name'],
        imageUrl: json['image_url'],
        phone: json['phone'],
        isModerator: json['isModerator'],
        not: json['not']);
  }

  UserModel.fromMap(Map<String, dynamic> map)
      : userId = map["id"],
        name = map["name"],
        imageUrl = map['image_url'],
        email = map['email'],
        phone = map['phone'],
        isModerator = map['isModerator'],
        not = map['not'];

  Map<String, dynamic> toJson() {
    return {
      "id": this.userId,
      "email": this.email,
      "name": this.name,
      "image_url": this.imageUrl,
      "phone": this.phone,
      "isModerator": this.isModerator,
      "not": this.not,
    };
  }
}
