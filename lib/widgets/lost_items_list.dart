import 'package:flutter/material.dart';
import 'package:lost_found_app/screens/lost_item_detail_screen.dart';

class LostItemsList extends StatefulWidget {
  @override
  _LostItemsListState createState() => _LostItemsListState();
}

class _LostItemsListState extends State<LostItemsList> {
  final List<String> _listItem = [
    'lib/assets/bag.jpg',
    'lib/assets/google.png',
    'lib/assets/bag.jpg',
    'lib/assets/google.png',
    'lib/assets/google.png',
    'lib/assets/google.png',
    'lib/assets/google.png',
    'lib/assets/google.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 10,
      mainAxisSpacing: 0,
      children: _listItem
          .map(
            (item) => GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LostItemDetailScreen(),
                    settings: RouteSettings(
                      arguments: item,
                    ),
                  ),
                );
              },
              child: Card(
                color: Colors.transparent,
                elevation: 0,
                child: Column(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                          color: Color.fromRGBO(19, 60, 109, 0.8),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20)),
                          image: DecorationImage(
                            image: AssetImage(item),
                          )),
                      child: Transform.translate(
                        offset: Offset(50, -50),
                        child: Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 65, vertical: 63),
                        ),
                      ),
                    ),
                    Container(
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20)),
                        color: Color.fromRGBO(19, 60, 109, 1),
                      ),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "Adidas Backpack",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                            ),
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: 15,
                              ),
                              Icon(
                                Icons.location_on_outlined,
                                color: Colors.white,
                                size: 18,
                              ),
                              Text(
                                "Mini OAT",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
          .toList(),
    ));
  }
}
