import 'package:app_new/home/button1.dart';
import 'package:app_new/home/flushbutton.dart';
import 'package:app_new/home/timerfield.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Widget testt() {
    return TextFormField();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fluh Ro Dah'),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // FlushButton(),
              Padding(
                padding: const EdgeInsets.only(top: 50),
                child: FlushButtonn(),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 30, 0, 10),
                child: TimerInput(),
              )
              // Container(
              //   decoration: BoxDecoration(
              //       border: Border.all(width: 4, color: Colors.black26),
              //       borderRadius:
              //           const BorderRadius.all(const Radius.circular(8))),
              //   child: testt(),
              // )
            ],
          ),
        ),
      ),
    );
  }
}
