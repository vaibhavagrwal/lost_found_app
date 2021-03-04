import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lost_found_app/screens/found_item_detail_screen.dart';
import 'package:lost_found_app/widgets/item_card.dart';

class FoundItemsScreen extends StatefulWidget {
  @override
  _FoundItemsScreenState createState() => _FoundItemsScreenState();
}

class _FoundItemsScreenState extends State<FoundItemsScreen> {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: firebaseFirestore
          .collection("FoundItemsList")
          .where("isVerified", isEqualTo: true)
          .orderBy('date', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          // snapshot.data.docs.forEach((item) {});
          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 5,
              mainAxisSpacing: 0,
            ),
            itemCount: snapshot.data.docs.length,
            itemBuilder: (context, index) {
              return ItemCard(
                itemName: snapshot.data.docs[index].get('heading'),
                location: snapshot.data.docs[index].get('location'),
                imageUrl: snapshot.data.docs[index].get('image_url'),
                onPressed: () {
                  String ownerId = snapshot.data.docs[index].get('ownerId');
                  String postId = snapshot.data.docs[index].get('postId');

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FoundItemDetailScreen(
                        ownerId: ownerId,
                        postId: postId,
                      ),
                    ),
                  );
                },
              );
            },
          );
        }
        return Container();
      },
    );
  }
}
