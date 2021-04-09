import 'package:app_new/home/authen.dart';
import 'package:app_new/home/myservice.dart';
import 'package:app_new/home/regispage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_sign_in/google_sign_in.dart';

class MethodeSignup extends StatelessWidget {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var res;
  MethodeSignup({Key key}) : super(key: key);

  Future<dynamic> signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);
    var user = await _auth.signInWithCredential(credential);
    return res = user.user;
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
                      onPressed: () {
                        signInWithGoogle().then((value) {
                          if (res != null) {
                            MaterialPageRoute materialPageRoute =
                                MaterialPageRoute(
                                    builder: (context) => MyService());
                            Navigator.of(context).pushAndRemoveUntil(
                                materialPageRoute, (route) => false);
                          } else {
                            print('fail');
                          }
                        });
                      },
                    ),
                  ),
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
