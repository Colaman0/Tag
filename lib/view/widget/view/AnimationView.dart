import 'package:flutter/material.dart';
import 'package:tag/view/widget/view/View.dart';

class AnimationView extends View {
  Widget child;

  AnimationView({Key key, this.child}) :super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(duration: Duration(milliseconds: 1000), curve: Curves.bounceInOut,
      child: super.build(context),);
  }
}
