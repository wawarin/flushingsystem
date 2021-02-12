import 'package:app_new/home/home.dart';
import 'package:app_new/home/myservice.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

FirebaseAuth _auth = FirebaseAuth.instance;
var user = _auth.currentUser;
_checstatus() {
  if (user != null) {
    return MyService();
  } else {
    return Home();
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: _checstatus(),
      theme: ThemeData(
          primarySwatch: Colors.indigo,
          scaffoldBackgroundColor: Colors.blue.shade50),
    );
  }
}
