import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lost_found_app/screens/item_detail_screen.dart';
import 'package:lost_found_app/util/screen_size.dart';
import 'package:lost_found_app/widgets/item_card.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class LostItemsScreen extends StatefulWidget {
  @override
  _LostItemsScreenState createState() => _LostItemsScreenState();
}

class _LostItemsScreenState extends State<LostItemsScreen> {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: firebaseFirestore
          .collection("LostItemsList")
          .where("isVerified", isEqualTo: true)
          .orderBy('date', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          // snapshot.data.docs.forEach((item) {});
          return StaggeredGridView.countBuilder(
            physics: BouncingScrollPhysics(),
            //gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,

            itemCount: snapshot.data.docs.length,
            itemBuilder: (context, index) {
              return Padding(
                  padding: EdgeInsetsDirectional.only(
                      top: 10 * ScreenSize.heightMultiplyingFactor),
                  child: ItemCard(
                    itemName: snapshot.data.docs[index].get('heading'),
                    location: snapshot.data.docs[index].get('location'),
                    imageUrl: snapshot.data.docs[index].get('image_url'),
                    by: snapshot.data.docs[index].get('by'),
                    onPressed: () {
                      String ownerId = snapshot.data.docs[index].get('ownerId');
                      String postId = snapshot.data.docs[index].get('postId');
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LostItemDetailScreen(
                            ownerId: ownerId,
                            postId: postId,
                            type: "Lost",
                          ),
                        ),
                      );
                    },
                  ));
            },
            staggeredTileBuilder: (index) => StaggeredTile.fit(1),
            mainAxisSpacing: 0,
            crossAxisSpacing: 2,
          );
        }
        return Container();
      },
    );
  }
}
