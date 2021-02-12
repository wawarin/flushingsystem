import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class Flush_Button extends StatefulWidget {
  Flush_Button({Key key}) : super(key: key);

  @override
  _Flush_ButtonState createState() => _Flush_ButtonState();
}

class _Flush_ButtonState extends State<Flush_Button> {
  final DatabaseReference = FirebaseDatabase.instance.reference();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: RaisedButton(
              onPressed: _flush,
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              color: Colors.blueAccent[400],
              child: Text(
                "Flushing",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0)),
            ),
          ),
          Text(
            "Tap to Flushing!!!",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black38),
          ),
        ],
      ),
    );
  }

  _flush() {
    DatabaseReference.child("flush").set({"status": "active"});
  }
}
