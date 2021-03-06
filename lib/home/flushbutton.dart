import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class FlushButtonn extends StatefulWidget {
  FlushButtonn({Key key}) : super(key: key);

  @override
  _FlushButtonnState createState() => _FlushButtonnState();
}

class _FlushButtonnState extends State<FlushButtonn>
    with SingleTickerProviderStateMixin {
  final DatabaseReference = FirebaseDatabase.instance.reference();
  int flush_count = 0;
  double _scale;
  AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 200,
      ),
      lowerBound: 0.0,
      upperBound: 0.1,
    )..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _scale = 1 - _controller.value;
    return Container(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          'Tap to Flushing',
          style: TextStyle(color: Colors.grey[400], fontSize: 20.0),
        ),
        SizedBox(
          height: 20.0,
        ),
        Center(
          child: GestureDetector(
            onTapCancel: _todefult,
            onTap: _showresult,
            onTapDown: _onTapDown,
            onTapUp: _onTapUp,
            child: Transform.scale(
              scale: _scale,
              child: _animatedButtonUI,
            ),
          ),
        ),
      ],
    ));
  }

  Widget get _animatedButtonUI => Container(
        height: 50,
        width: 140,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100.0),
            boxShadow: [
              BoxShadow(
                color: Color(0x80000000),
                blurRadius: 30.0,
                offset: Offset(0.0, 5.0),
              ),
            ],
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF03A9F4),
                Color(0xFF039BE5),
              ],
            )),
        child: Center(
          child: Text(
            'Flush!!!',
            style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.white),
          ),
        ),
      );

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
    // DatabaseReference.child("flush").set(1);
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
    // DatabaseReference.child("flush").set(0);
  }

  void _showresult() {
    flush_count = flush_count + 1;
    // DatabaseReference.child("flush").set({"counter8": flush_count, "flush": 1});
    DatabaseReference.child("flush").set({"status": "active"});
  }

  void _todefult() {
    // DatabaseReference.child("flush").set(0);
  }
}
