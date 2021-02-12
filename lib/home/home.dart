import 'dart:async';

import 'package:app_new/home/authen.dart';
import 'package:app_new/home/methodesigup.dart';
import 'package:app_new/home/myservice.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // Medthod

  // @override
  // void initState() {
  //   super.initState();
  //   // setState(() {
  //   //   Future.delayed(Duration(milliseconds: 10)).then((value) {
  //   //     checkStatus();
  //   //   });
  //   // });
  //   // Timer.run(() {
  //   //   checkStatus();
  //   // });
  //   SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
  //     checkStatus();
  //   });
  // }

  Future<void> checkStatus() async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    var user = firebaseAuth.currentUser;

    if (user != null) {
      MaterialPageRoute materialPageRoute =
          MaterialPageRoute(builder: (BuildContext context) => MyService());
      Navigator.of(context)
          .pushAndRemoveUntil(materialPageRoute, (route) => false);
    }
  }

  _showlogo() {
    return Container(
      width: 120.0,
      height: 120.0,
      child: Image.asset('images/logo.png'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
              gradient: RadialGradient(
            colors: [Colors.white, Colors.blue.shade100],
            radius: 1.0,
          )),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _showlogo(),
                Text(
                  'Flash Automate',
                  style: TextStyle(
                    fontSize: 32.0,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    color: Colors.indigo.shade800,
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    RaisedButton(
                      color: Colors.blueAccent.shade400,
                      child: Text(
                        'Sign In',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                      onPressed: () {
                        MaterialPageRoute materialPageRoute = MaterialPageRoute(
                            builder: (BuildContext context) => Authen());
                        Navigator.of(context).push(materialPageRoute);
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0)),
                    ),
                    SizedBox(
                      width: 8.0,
                    ),
                    OutlineButton(
                      color: Colors.blueAccent,
                      child: Text("Sign Up"),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    MethodeSignup()));
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
