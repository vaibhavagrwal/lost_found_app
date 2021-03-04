import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lost_found_app/widgets/item_tile.dart';
import 'dart:async';
import '../main.dart';
import 'package:async/async.dart';

class MyAdScreen extends StatefulWidget {
  @override
  _MyAdScreenState createState() => _MyAdScreenState();
}

class _MyAdScreenState extends State<MyAdScreen> {
  StreamController streamController;
  Stream<List<QuerySnapshot>> getData() {
    Stream stream1 = FirebaseFirestore.instance
        .collection('lostItems')
        .doc(user.userId)
        .collection("myLostItems")
        .orderBy('timeStamp')
        .snapshots();
    Stream stream2 = FirebaseFirestore.instance
        .collection('FoundItems')
        .doc(user.userId)
        .collection("myFoundItems")
        .orderBy('timeStamp')
        .snapshots();
    return StreamZip(([stream1, stream2]));
  }

  @override
  void dispose() {
    super.dispose();
    streamController?.close();
    streamController = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Color.fromRGBO(44, 62, 80, 1),
        ),
        title: Text(
          " My Ads ",
          style: GoogleFonts.roboto(
              color: Color.fromRGBO(44, 62, 80, 1),
              fontSize: 20,
              fontWeight: FontWeight.w600),
        ),
      ),
      body: MyList(),
      // body: Column(
      //   children: [
      //     Container(
      //       height: MediaQuery.of(context).size.height * 0.4,
      //       child: MyLostList(),
      //     ),
      //     Expanded(
      //       child: MyFoundList(),
      //     ),
      //   ],
      // ),
      // body: StreamBuilder<QuerySnapshot>(
      //   stream: getData(),
      //   builder: (context, snapshot) {
      //     if (snapshot.hasData) {
      //       // snapshot.data.docs.forEach((item) {});
      //       return ListView.builder(
      //         itemCount: snapshot.data.docs.length,
      //         itemBuilder: (context, index) {
      //           return ItemTile(
      //             imageUrl: snapshot.data.docs[index].get('image_url'),
      //             title: snapshot.data.docs[index].get('heading'),
      //             description: snapshot.data.docs[index].get('description'),
      //             status: "Found",
      //           );
      //         },
      //       );
      //     }
      //   },
      // ),
      // body: StreamBuilder(
      //     stream: getData(),
      //     builder: (BuildContext context,
      //         AsyncSnapshot<List<QuerySnapshot>> snapshot1) {
      //       List<QuerySnapshot> querySnapshotData = snapshot1.data.toList();
      //       List dataList = [];

      //       //copy document snapshots from second stream to first so querySnapshotData[0].documents will have all documents from both query snapshots

      //       dataList.addAll(querySnapshotData[0].docs);
      //       dataList.addAll(querySnapshotData[1].docs);
      //       // querySnapshotData[0].docs.addAll(querySnapshotData[1].docs);
      //       print(dataList.length);
      //       if (dataList.isEmpty)
      //         return Column(
      //           mainAxisAlignment: MainAxisAlignment.center,
      //           children: <Widget>[
      //             Center(
      //               child: CircularProgressIndicator(),
      //             )
      //           ],
      //         );
      //       if (dataList.length == 0)
      //         return const Center(
      //           child: Text(
      //             "Not Available",
      //             style: TextStyle(fontSize: 30.0, color: Colors.grey),
      //           ),
      //         );

      //       // return new ListView(
      //       //     children:
      //       //         querySnapshotData[0].docs.map((DocumentSnapshot document) {
      //       //   // put your logic here. You will have access to document from both streams as "document" here
      //       //   return new ListCard(document);
      //       // }).toList());
      //       return ListView.builder(
      //         itemBuilder: (context, index) {
      //           return ItemTile(
      //             imageUrl: dataList[index].get("image_url"),
      //             title: dataList[index].get("heading"),
      //             description: dataList[index].get("description"),
      //             status: dataList[index].get("status"),
      //           );
      //         },
      //         itemCount: dataList.length,
      //       );
      //       // return new ListView(
      //       //     children:
      //       //         querySnapshotData[0].docs.map((DocumentSnapshot document) {
      //       //   return ItemTile(
      //       //     imageUrl: document.get("image_url"),
      //       //     title: document.get("heading"),
      //       //     description: document.get("description"),
      //       //   );
      //       // }).toList());
      //     }),
    );
  }
}

// class MyFoundList extends StatefulWidget {
//   @override
//   _MyFoundListState createState() => _MyFoundListState();
// }

// class _MyFoundListState extends State<MyFoundList> {
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<QuerySnapshot>(
//       stream: FirebaseFirestore.instance
//           .collection("FoundItems")
//           .doc(user.userId)
//           .collection("myFoundItems")
//           .orderBy('date', descending: true)
//           .snapshots(),
//       builder: (context, snapshot) {
//         if (snapshot.hasData) {
//           // snapshot.data.docs.forEach((item) {});
//           return ListView.builder(
//             itemCount: snapshot.data.docs.length,
//             itemBuilder: (context, index) {
//               return ItemTile(
//                 imageUrl: snapshot.data.docs[index].get('image_url'),
//                 title: snapshot.data.docs[index].get('heading'),
//                 description: snapshot.data.docs[index].get('description'),
//                 status: "Found",
//               );
//             },
//           );
//         }
//       },
//     );
//   }
// }

// class MyLostList extends StatefulWidget {
//   @override
//   _MyLostListState createState() => _MyLostListState();
// }

// class _MyLostListState extends State<MyLostList> {
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<QuerySnapshot>(
//       stream: FirebaseFirestore.instance
//           .collection("lostItems")
//           .doc(user.userId)
//           .collection("myLostItems")
//           .orderBy('date', descending: true)
//           .snapshots(),
//       builder: (context, snapshot) {
//         if (snapshot.hasData) {
//           // snapshot.data.docs.forEach((item) {});
//           return ListView.builder(
//             itemCount: snapshot.data.docs.length,
//             itemBuilder: (context, index) {
//               return ItemTile(
//                 imageUrl: snapshot.data.docs[index].get('image_url'),
//                 title: snapshot.data.docs[index].get('heading'),
//                 description: snapshot.data.docs[index].get('description'),
//                 status: "Lost",
//               );
//             },
//           );
//         }
//       },
//     );
//   }
// }
class MyList extends StatefulWidget {
  @override
  _MyListState createState() => _MyListState();
}

class _MyListState extends State<MyList> {
  @override
  Widget build(BuildContext context) {
    print("OKOKOKOKOKOKOK");
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("AllItems")
            .doc(user.userId)
            .collection("myItems")
            .orderBy('date', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index) {
                if (snapshot.data.docs[index].get('isVerified') == true)
                  return ItemTile(
                    imageUrl: snapshot.data.docs[index].get('image_url'),
                    title: snapshot.data.docs[index].get('heading'),
                    description: snapshot.data.docs[index].get('description'),
                    status: snapshot.data.docs[index].get('status'),
                  );
                else
                  return ItemTile(
                    imageUrl: snapshot.data.docs[index].get('image_url'),
                    title: snapshot.data.docs[index].get('heading'),
                    description: snapshot.data.docs[index].get('description'),
                    status: "Under Review",
                  );
              },
            );
          } else {
            return CircularProgressIndicator();
          }
        });
  }
}
