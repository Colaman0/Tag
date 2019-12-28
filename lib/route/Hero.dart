import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tag/view/widget/view/View.dart';

class HeroWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return View(
      child: Hero(
        tag: "1",
        child: CachedNetworkImage(imageUrl: "https://wx3.sinaimg.cn/mw690/98f0f55fly1g9o3xdj8kxj20u011e7bi.jpg"),
      ),
    ).click(
      () {
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => HeroWidget2()));
      },
    );
  }
}

class HeroWidget2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: "1",
      child: Container(
        alignment: Alignment.topLeft,
        child: View(
          child: CachedNetworkImage(imageUrl: "https://wx3.sinaimg.cn/mw690/98f0f55fly1g9o3xdj8kxj20u011e7bi.jpg"),
        ).size(width: 50, height: 50).backgroundColor(Colors.black),
      ),
    );
  }
}
