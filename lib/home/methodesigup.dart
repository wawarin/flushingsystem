import 'package:app_new/home/authen.dart';
import 'package:app_new/home/regispage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

class MethodeSignup extends StatelessWidget {
  const MethodeSignup({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text("Sign Up"),
      // ),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              colors: [Colors.white, Colors.blue.shade100],
              radius: 1.0,
            ),
          ),
          child: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text("Sign Up",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                            fontFamily: 'Roboto')),
                  ),
                  Padding(
                      padding: EdgeInsets.all(10.0),
                      child: SignInButton(
                        Buttons.Email,
                        text: "Sign up with Email",
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Register()),
                          );
                        },
                      )),
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: SignInButton(
                      Buttons.Google,
                      text: 'Sign up with google',
                      onPressed: () {},
                    ),
                  ),
                  // Padding(
                  //     padding: EdgeInsets.all(10.0),
                  //     child: SignInButton(
                  //       Buttons.Twitter,
                  //       text: "Sign up with Twitter",
                  //       onPressed: () {},
                  //     )),
                  Padding(
                      padding: EdgeInsets.all(10.0),
                      child: GestureDetector(
                          child: Text("Log In Using Email",
                              style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  color: Colors.blue)),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Authen()),
                            );
                          }))
                ]),
          ),
        ),
      ),
    );
  }
}
