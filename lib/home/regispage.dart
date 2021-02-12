import 'package:app_new/home/myservice.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Register extends StatefulWidget {
  Register({Key key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  // Variable
  final formKey = GlobalKey<FormState>();
  String nameString, lastnameString, emailString, passwordString;
  bool showpass = true;

  // Methode
  void _toggle() {
    setState(() {
      showpass = !showpass;
      print(showpass);
    });
  }

  Widget regisButton() {
    return IconButton(
        icon: Icon(Icons.cloud_upload),
        onPressed: () {
          print("You click upload");
          if (formKey.currentState.validate()) {
            formKey.currentState.save();
            print(
                'Name = $nameString, Lastname = $lastnameString, Email = $emailString, Password = $passwordString');
            registerThread();
          }
        });
  }

  Future<void> registerThread() async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    await firebaseAuth
        .createUserWithEmailAndPassword(
            email: emailString, password: passwordString)
        .then((response) {
      print('Register Success for Email = $emailString');
      setupDisplayName();
    }).catchError((response) {
      String title = response.code;
      String message = response.message;
      print('title = $title, message = $message');
      myAlert(title, message);
    });
  }

  Future<void> setupDisplayName() async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    var user = firebaseAuth.currentUser;
    if (user != null) {
      user.updateProfile(displayName: nameString);

      MaterialPageRoute materialPageRoute =
          MaterialPageRoute(builder: (BuildContext context) => MyService());
      Navigator.of(context).pushAndRemoveUntil(
          materialPageRoute, (Route<dynamic> route) => false);
    }
  }

  void myAlert(String title, String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: ListTile(
              leading: Icon(
                Icons.add_alert,
                color: Colors.red,
                size: 48.0,
              ),
              title: Text(
                title,
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
            content: Text(message),
            actions: <Widget>[
              FlatButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  Widget nameText() {
    return TextFormField(
      decoration: InputDecoration(
        icon: Icon(
          Icons.face,
          color: Colors.blue,
          size: 48.0,
        ),
        labelText: 'Name :',
        labelStyle: TextStyle(
          color: Colors.blue,
          fontWeight: FontWeight.bold,
        ),
        helperText: "Type your name for display",
        helperStyle: TextStyle(
          color: Colors.blue,
          fontStyle: FontStyle.italic,
        ),
      ),
      validator: (String value) {
        if (value.isEmpty) {
          return "Please Fill Your Name In The Blank";
        } else {
          return null;
        }
      },
      onSaved: (String val) {
        nameString = val.trim();
      },
    );
  }

  Widget lastNameText() {
    return TextFormField(
      decoration: InputDecoration(
        icon: Icon(
          Icons.face,
          color: Colors.amber.shade700,
          size: 48.0,
        ),
        labelText: 'Lastname :',
        labelStyle: TextStyle(
          color: Colors.amber.shade700,
          fontWeight: FontWeight.bold,
        ),
        helperText: "Type your lastname",
        helperStyle: TextStyle(
          color: Colors.amber.shade700,
          fontStyle: FontStyle.italic,
        ),
      ),
      validator: (String value) {
        if (value.isEmpty) {
          return "Please Fill Your Lastname In The Blank";
        } else {
          return null;
        }
      },
      onSaved: (String val) {
        lastnameString = val.trim();
      },
    );
  }

  Widget emailText() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        icon: Icon(
          Icons.mail_outline,
          color: Colors.purple.shade400,
          size: 48.0,
        ),
        labelText: 'Email :',
        labelStyle: TextStyle(
          color: Colors.purple.shade400,
          fontWeight: FontWeight.bold,
        ),
        helperText: "Type your Email",
        helperStyle: TextStyle(
          color: Colors.purple.shade400,
          fontStyle: FontStyle.italic,
        ),
      ),
      validator: (String value) {
        if (!((value.contains('@')) && (value.contains(".")))) {
          return "Please Type Email in Exp. you@email.com";
        } else {
          return null;
        }
      },
      onSaved: (String val) {
        emailString = val.trim();
      },
    );
  }

  Widget passwordText() {
    return Column(
      children: [
        TextFormField(
          decoration: InputDecoration(
            icon: Icon(
              Icons.lock_outline,
              color: Colors.green.shade600,
              size: 48.0,
            ),
            labelText: 'Password :',
            labelStyle: TextStyle(
              color: Colors.green.shade600,
              fontWeight: FontWeight.bold,
            ),
            helperText: "Type your Password more than 6 character",
            helperStyle: TextStyle(
              color: Colors.green.shade600,
              fontStyle: FontStyle.italic,
            ),
          ),
          validator: (String value) {
            if (value.length < 6) {
              return 'Password more 6 charactor';
            } else {
              return null;
            }
          },
          onSaved: (String val) {
            passwordString = val.trim();
          },
          obscureText: showpass,
        ),
        FlatButton(
          onPressed: _toggle,
          child: Text(
            showpass ? "Show password" : "Hide Password",
            style: TextStyle(
              color: Colors.grey.shade400,
            ),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
        actions: [regisButton()],
      ),
      body: Form(
        key: formKey,
        child: ListView(
          padding: EdgeInsets.all(30.0),
          children: [
            nameText(),
            lastNameText(),
            emailText(),
            passwordText(),
          ],
        ),
      ),
    );
  }
}
