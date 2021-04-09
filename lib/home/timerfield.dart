import 'package:app_new/home/myservice.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:firebase_database/firebase_database.dart';

class TimerInput extends StatefulWidget {
  void test() {
    print("COME ON");
  }

  TimerInput({Key key}) : super(key: key);
  @override
  _TimerInputState createState() => _TimerInputState();
}

class _TimerInputState extends State<TimerInput> {
  final DatabaseReference databaseReference =
      FirebaseDatabase.instance.reference();
  int initHour = 12;
  int initMins = 0;
  int hour = 12;
  int mins = 0;
  String timerhour, timermins;
  bool isReset = true;
  bool reset = false;
  String displaytimer = "12:00";
  int collect_hours, collect_mins, submit_count = 0;

  // Methode
  void resetProcess() {
    setState(() {
      isReset = !isReset;
      // hour = 12;
    });
  }

  Widget flushButton() {
    return Column(
      children: [
        RaisedButton(
          onPressed: () {},
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          color: Colors.blueAccent.shade400,
          child: Text(
            "Flushing",
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
        ),
        Text(
          "Tap to Flushing!!!",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black38,
          ),
        )
      ],
    );
  }

  Widget timerPicker() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [hourPicker(), minutesPicker()],
    );
  }

  Widget hourPicker() {
    if (!isReset) {
      print('Here');
      return Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: 5.0),
            child: Text(
              "HH",
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
          ),
          NumberPicker.integer(
              // initialValue: initHour,
              initialValue: initHour,
              minValue: 0,
              maxValue: 23,
              onChanged: (val) {
                setState(() {
                  // hour = val;
                  val = hour;
                });
              })
        ],
      );
    } else {
      return Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: 5.0),
            child: Text(
              "HH",
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
          ),
          NumberPicker.integer(
              // infiniteLoop: true,
              initialValue: hour,
              minValue: 0,
              maxValue: 23,
              onChanged: (val) {
                setState(() {
                  hour = val;
                });
              })
        ],
      );
    }
  }

  Widget minutesPicker() {
    return Column(
      // mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(bottom: 5.0),
          child: Text(
            "MM",
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
        ),
        NumberPicker.integer(
            // initialValue: initMins,
            initialValue: mins,
            minValue: 0,
            maxValue: 59,
            zeroPad: true,
            onChanged: (val) {
              setState(() {
                mins = val;
              });
            })
      ],
    );
  }

  Widget showTimer() {
    return Text(
      displaytimer,
      style: TextStyle(
        // color: Colors.red,
        fontSize: 30.0,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget showButton() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [resetButton(), submitButton()],
    );
  }

  Widget submitButton() {
    return RaisedButton(
      onPressed: submit,
      // padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
      color: Colors.green,
      child: Text(
        "submit",
        style: TextStyle(fontSize: 18, color: Colors.white),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
    );
  }

  Widget resetButton() {
    return RaisedButton(
      onPressed: () {
        // resetProcess();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MyService(),
          ),
        );
      },
      color: Colors.red,
      child: Text(
        "reset",
        style: TextStyle(fontSize: 18, color: Colors.white),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
    );
  }

  void submit() {
    setState(() {
      if (mins < 10) {
        displaytimer = "${hour.toString()}:0${mins.toString()}";
      } else {
        displaytimer = "${hour.toString()}:${mins.toString()}";
      }

      // print(myservice.devicename);
      collect_hours = hour;
      collect_mins = mins;
      submit_count = submit_count + 1;

      // databaseReference.child("timer").set({
      //   "hours": collect_hours,
      //   "minutes": collect_mins,
      //   "status": "active"
      // });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          flushButton(),
          timerPicker(),
          showTimer(),
          showButton(),
        ],
      ),
    );
  }
}
