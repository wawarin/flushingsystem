import 'package:app_new/home/methodesigup.dart';
import 'package:app_new/home/regispage.dart';
import 'package:flutter/material.dart';

class ConfigPage extends StatelessWidget {
  const ConfigPage({Key key}) : super(key: key);

  // Medthod
  _showlogo() {
    return Container(
      width: 120.0,
      height: 120.0,
      child: Image.asset('images/logo.png'),
    );
  }

  // Widget signInButton() {
  //   return RaisedButton(
  //     color: Colors.blueAccent[400],
  //     child: Text(
  //       'Sign In',
  //       style: TextStyle(fontSize: 18, color: Colors.white),
  //     ),
  //     onPressed: () {},
  //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
  //   );
  // }

  // Widget signUpButton() {
  //   return OutlineButton(
  //     child: Text("Sign Up"),
  //     onPressed: () {
  //       // Navigator.push(context,
  //       //     MaterialPageRoute(builder: (BuildContext context) => Register()));
  //     },
  //   );
  // }

  // Widget showButton() {
  //   return Row(
  //     mainAxisSize: MainAxisSize.min,
  //     children: <Widget>[
  //       signInButton(),
  //       SizedBox(
  //         width: 8.0,
  //       ),
  //       signUpButton(),
  //     ],
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _showlogo(),
          Text('APP NAME'),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              RaisedButton(
                color: Colors.blueAccent.shade400,
                child: Text(
                  'Sign In',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
                onPressed: () {},
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
                          builder: (BuildContext context) => MethodeSignup()));
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
