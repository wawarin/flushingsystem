import 'package:app_new/home/home.dart';
import 'package:app_new/home/myservice.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:connectivity/connectivity.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

bool network = true;

_checkInternet() async {
  var result = await Connectivity().checkConnectivity();
  if (result == ConnectivityResult.none) {
    return network = false;
  } else {
    return network = true;
  }
}

_checkstatus() {
  _checkInternet();
  FirebaseAuth _auth = FirebaseAuth.instance;
  var user = _auth.currentUser;
  if (network == true) {
    if (user != null) {
      return MyService();
    } else {
      print('Not login');
      return Home();
    }
  } else {
    print('No Internet');
    return Home();
  }
}

// _showDialog() {
//   return showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text(
//             "No internet connect",
//             style: TextStyle(
//                 color: Colors.red, fontSize: 18.0, fontWeight: FontWeight.bold),
//           ),
//           content: Text('Please connect the internet'),
//           actions: [
//             FlatButton(
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//                 child: Text('Ok'))
//           ],
//         );
//       });
// }

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: _checkstatus(),
      theme: ThemeData(
          primarySwatch: Colors.indigo,
          scaffoldBackgroundColor: Colors.blue.shade50),
    );
  }
}
