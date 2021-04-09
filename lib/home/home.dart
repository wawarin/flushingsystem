import 'dart:async';
import 'package:connectivity/connectivity.dart';
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
  //  Variable
  bool network = true;
  // Medthod
  // @override
  // void initState() {
  //   super.initState();
  //   _checkInternet();
  // }

  _checkInternet() async {
    var result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.none) {
      return network = false;
    } else {
      return network = true;
    }
  }

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

  _showDialog() {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              "No internet connect",
              style: TextStyle(
                  color: Colors.red,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold),
            ),
            content: Text('Please connect the internet'),
            actions: [
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Ok'),
              )
            ],
          );
        });
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
                        _checkInternet();
                        if (network == false) {
                          _showDialog();
                        } else {
                          MaterialPageRoute materialPageRoute =
                              MaterialPageRoute(
                                  builder: (BuildContext context) => Authen());
                          Navigator.of(context).push(materialPageRoute);
                        }
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
                        _checkInternet();
                        if (network == false) {
                          _showDialog();
                        } else {
                          MaterialPageRoute materialPageRoute =
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      MethodeSignup());
                          Navigator.of(context).push(materialPageRoute);
                        }
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
