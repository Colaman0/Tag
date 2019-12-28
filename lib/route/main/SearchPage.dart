import 'package:flutter/material.dart';
import 'package:tag/view/widget/view/TextView.dart';

/// 首页homepage
class SearchPage extends StatefulWidget {
  @override
  SearchPageState createState() => SearchPageState();
}

class SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextView("my"),
    );
  }
}
