import 'package:flutter/material.dart';
import 'package:lost_found_app/widgets/lost_Items_list.dart';

class LostItemsScreen extends StatefulWidget {
  @override
  _LostItemsScreenState createState() => _LostItemsScreenState();
}

class _LostItemsScreenState extends State<LostItemsScreen> {
  @override
  Widget build(BuildContext context) {
    return LostItemsList();
  }
}
