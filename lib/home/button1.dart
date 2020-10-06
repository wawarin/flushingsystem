import 'package:flutter/material.dart';

class FlushButton extends StatefulWidget {
  FlushButton({Key key}) : super(key: key);

  @override
  _FlushButtonState createState() => _FlushButtonState();
}

class _FlushButtonState extends State<FlushButton> {
  String msg = 'Press here to flushing';

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              msg,
              style: TextStyle(fontSize: 20, fontStyle: FontStyle.italic),
            ),
            // SizedBox(
            //   height: 30,
            //   // width: 100,
            // ),
            RaisedButton(
              onPressed: () {},
              // textColor: Colors.white,
              padding: EdgeInsets.all(0.0),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(colors: <Color>[
                      Color(0xFF0D47A1),
                      Color(0xFF1976D2),
                      Color(0xFF42A5F5),
                    ])),
                padding: EdgeInsets.fromLTRB(30, 15, 30, 15),
                child: Text('Flush!!!', style: TextStyle(fontSize: 20)),
              ),
            )
          ],
        ),
      ),
    );
  }

  _changeText() {
    setState(() {
      if (msg.startsWith('F')) {
        msg = 'Done!!!';
      } else {
        msg = 'Flush!!!';
      }
    });
  }
}
