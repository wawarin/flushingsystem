import 'package:app_new/home/myservice.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Authen extends StatefulWidget {
  Authen({Key key}) : super(key: key);

  @override
  _AuthenState createState() => _AuthenState();
}

class _AuthenState extends State<Authen> {
  // Variable
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final formkey = GlobalKey<FormState>();
  String emailUser, passwordUser;

  // Methode

  Future<dynamic> signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);
    var user = await _auth.signInWithCredential(credential);
    print(user.user);
    if (user.user != null) {
      MaterialPageRoute materialPageRoute =
          MaterialPageRoute(builder: (context) => MyService());
      Navigator.of(context)
          .pushAndRemoveUntil(materialPageRoute, (route) => false);
    } else {
      print('Fail');
    }
  }

  Widget backButton() {
    return IconButton(
      icon: Icon(
        Icons.navigate_before,
        size: 38.0,
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
      color: Colors.blueAccent.shade700,
    );
  }

  Widget content() {
    return Center(
      child: Form(
        key: formkey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            showAppname(),
            emailText(),
            passwordText(),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: googleSiginButton(),
            )
          ],
        ),
      ),
    );
  }

  Widget showAppname() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        showLogo(),
        showText(),
      ],
    );
  }

  Widget showLogo() {
    return Container(
      width: 56.0,
      height: 56.0,
      child: Image.asset('images/logo.png'),
    );
  }

  Widget showText() {
    return Text(
      'Flush Aotumate',
      style: TextStyle(
        fontSize: 24.0,
        fontWeight: FontWeight.bold,
        // fontFamily:
        fontStyle: FontStyle.italic,
        color: Colors.blue.shade900,
      ),
    );
  }

  Widget emailText() {
    return Container(
      width: 250.0,
      child: TextFormField(
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          icon: Icon(
            Icons.email,
            size: 36.0,
            color: Colors.blue.shade700,
          ),
          labelText: 'Email : ',
          labelStyle: TextStyle(
            color: Colors.blue.shade700,
          ),
        ),
        onSaved: (val) => emailUser = val.trim(),
      ),
    );
  }

  Widget passwordText() {
    return Container(
      width: 250.0,
      child: TextFormField(
        obscureText: true,
        decoration: InputDecoration(
          icon: Icon(
            Icons.lock,
            size: 36.0,
            color: Colors.blue.shade700,
          ),
          labelText: 'Password : ',
          labelStyle: TextStyle(
            color: Colors.blue.shade700,
          ),
        ),
        onSaved: (val) => passwordUser = val.trim(),
      ),
    );
  }

  Future<void> checkMailAuthen() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    await auth
        .signInWithEmailAndPassword(email: emailUser, password: passwordUser)
        .then((res) {
      if (auth.currentUser.emailVerified) {
        print("Authen Success");
        MaterialPageRoute materialPageRoute =
            MaterialPageRoute(builder: (context) => MyService());
        Navigator.of(context)
            .pushAndRemoveUntil(materialPageRoute, (route) => false);
      } else if (!auth.currentUser.emailVerified) {
        print(auth.currentUser.emailVerified);
        myAlert("Login Error", 'Please verify email before login.');
      }
    }).catchError((res) {
      String title = res.code;
      String message = res.message;
      // String error = res;
      print(res);
      myAlert(title, message);
    });
  }

  Widget showTitleError(String title) {
    return ListTile(
      leading: Icon(
        Icons.add_alert,
        size: 48.0,
        color: Colors.red,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: Colors.red,
          fontSize: 28.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget okButton() {
    return FlatButton(
      onPressed: () {
        Navigator.of(context).pop();
      },
      child: Text("OK"),
    );
  }

  Widget googleSiginButton() {
    return SignInButton(
      Buttons.GoogleDark,
      onPressed: () {
        signInWithGoogle();
      },
    );
  }

  void myAlert(String title, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: showTitleError(title),
          content: Text(message),
          actions: [okButton()],
        );
      },
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
            ),
          ),
          child: Stack(
            children: [
              backButton(),
              content(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          formkey.currentState.save();
          print('Email: $emailUser, Password: $passwordUser');
          checkMailAuthen();
        },
        child: Icon(
          Icons.navigate_next,
          size: 36.0,
        ),
        backgroundColor: Colors.blueAccent.shade700,
      ),
    );
  }
}
