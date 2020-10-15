import 'package:app_new/home/home.dart';
// import 'package:app_new/home/subbutton.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class TimerInput extends StatefulWidget {
  TimerInput({Key key}) : super(key: key);
  @override
  _TimerInputState createState() => _TimerInputState();
}

class _TimerInputState extends State<TimerInput> {
  final _hoursController = TextEditingController();
  final _minsController = TextEditingController();

  final DatabaseReference = FirebaseDatabase.instance.reference();

  int hour = 12;
  int mins = 0;
  String timerhour, timermins;
  String displaytimer = "12:00";
  int collect_hours, collect_mins, submit_count = 0;

  // Methode
  Widget hoursText() {
    return TextFormField(
      controller: _hoursController,
      decoration: InputDecoration(
          labelText: "Enter Hours",
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide(color: Colors.black26)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide(color: Colors.black26))),
      keyboardType: TextInputType.datetime,
      // validator: (value) {
      //   return value;
      // },
    );
  }

  Widget minsText() {
    return TextFormField(
      controller: _minsController,
      decoration: InputDecoration(
          labelText: "Enter Minutes",
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide(color: Colors.black26)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide(color: Colors.black26))),
      keyboardType: TextInputType.number,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: Text(
              "Set Timer",
              softWrap: true,
              style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(bottom: 5.0),
                    child: Text(
                      "HH",
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                  NumberPicker.integer(
                      initialValue: hour,
                      minValue: 0,
                      maxValue: 23,
                      // zeroPad: true,
                      // listViewWidth: 100,
                      onChanged: (val) {
                        setState(() {
                          hour = val;
                        });
                      })
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(bottom: 5.0),
                    child: Text(
                      "MM",
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                  NumberPicker.integer(
                      initialValue: mins,
                      minValue: 0,
                      maxValue: 59,
                      zeroPad: true,
                      // listViewWidth: 60.00,
                      onChanged: (val) {
                        setState(() {
                          mins = val;
                        });
                      })
                ],
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: Text(
              displaytimer,
              style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              RaisedButton(
                onPressed: () {
                  setState(() {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => Home()));
                  });
                },
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                color: Colors.red,
                child: Text(
                  "reset",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0)),
              ),
              RaisedButton(
                onPressed: submit,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                color: Colors.green,
                child: Text(
                  "submit",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void submit() {
    setState(() {
      if (mins < 10) {
        displaytimer = "${hour.toString()}:0${mins.toString()}";
      } else {
        displaytimer = "${hour.toString()}:${mins.toString()}";
      }
      // debugPrint("displaytimer  = ${displaytimer}");
      collect_hours = hour;
      collect_mins = mins;
      submit_count = submit_count + 1;
      // debugPrint(collect_hours.toString());
      // debugPrint(collect_mins.toString());
      // DatabaseReference.child("timer").set({
      //   "hours": collect_hours,
      //   "minutes": collect_mins,
      //   "couter": submit_count
      // });
      DatabaseReference.child("timer").set({
        "hours": collect_hours,
        "minutes": collect_mins,
        "status": "active"
      });
    });
  }
}
