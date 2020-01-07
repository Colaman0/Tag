import 'package:flutter/cupertino.dart';

class FadeView extends StatefulWidget {
  final AnimationController controller;
  final Widget view;

  FadeView(
    this.view,
    this.controller,
  );

  @override
  _FadeViewState createState() => _FadeViewState(view);
}

class _FadeViewState extends State<FadeView>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  final Widget view;
  Animation _animation;

  _FadeViewState(this.view);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );

  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      child: view,
      opacity: _animation,
    );
  }

  
}
