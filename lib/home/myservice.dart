import 'package:app_new/home/home.dart';
import 'package:app_new/home/timerfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyService extends StatefulWidget {
  // final hours;
  // final minutes;

  MyService({Key key}) : super(key: key);

  @override
  _MyServiceState createState() => _MyServiceState();
}

class _MyServiceState extends State<MyService> {
  // Variable
  String login = '....';
  String onscreen = "Flush Automate";
  TextEditingController _textFieldController = TextEditingController();
  String codeDialog;
  String valueText;
  List<String> devicename = [];
  List<String> item = [];

  // Methode
  @override
  void initState() {
    super.initState();
    findDisplayName();
  }

  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Add Device'),
            content: TextField(
              onChanged: (value) {
                setState(() {
                  if (value != null) {
                    valueText = value;
                  } else {
                    valueText = null;
                  }
                });
              },
              controller: _textFieldController,
              decoration: InputDecoration(hintText: "Add your device UID"),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('CANCEL'),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
              ),
              FlatButton(
                child: Text('OK'),
                onPressed: () {
                  codeDialog = valueText;
                  if (valueText != null) {
                    addedDevice();
                  }
                  Navigator.pop(context);
                  valueText = null;
                  _textFieldController.clear();
                },
              ),
            ],
          );
        });
  }

  void addedDevice() {
    setState(() {
      print(valueText);
      item.add(valueText);
      print(item);
      devicename = item.toSet().toList();
      print(devicename);
    });
  }

  Widget listDevice() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: devicename.length,
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.all(2.0),
          // color: Colors.blue.shade200,
          child: Center(
              child: OutlineButton(
            onPressed: () {
              setState(() {
                Navigator.of(context).pop();
                onscreen = devicename[index];
                print(onscreen);
                // print(data.test);
              });
            },
            child: Text(
              '${devicename[index]}',
              style: TextStyle(
                fontSize: 16, color: Colors.indigo.shade400,
                // fontWeight: FontWeight.bold,
              ),
            ),
          )),
        );
      },
    );
  }

  Widget showListDevice() {
    return ExpansionTile(
      children: [
        listDevice(),
      ],
      leading: Icon(
        Icons.list,
        size: 36.0,
      ),
      subtitle: Text('Show All List Device'),
      title: Text('List Product'),
    );
  }

  Widget showAddlist() {
    return ListTile(
      leading: Icon(
        Icons.playlist_add,
        size: 36.0,
        color: Colors.greenAccent.shade700,
      ),
      subtitle: Text("Add New Device"),
      title: Text('Add device'),
      onTap: () {
        Navigator.of(context).pop();
        _displayTextInputDialog(context);
      },
    );
  }

  Future findDisplayName() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    var user = auth.currentUser;
    setState(() {
      login = user.displayName;
      print("log in : $login");
    });
  }

  Widget showAppname() {
    return Text(
      "Flush Automate",
      style: TextStyle(
        color: Colors.indigo.shade800,
        fontSize: 18.0,
        fontStyle: FontStyle.italic,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget showUserName() {
    return Text('Log in by : $login');
  }

  Widget showLogo() {
    return Container(
      width: 80.0,
      height: 80.0,
      child: Image.asset('images/logo.png'),
    );
  }

  Widget showDrawHead() {
    return DrawerHeader(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('images/wallpaper.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        children: [
          showLogo(),
          showAppname(),
          SizedBox(
            height: 6.0,
          ),
          showUserName(),
        ],
      ),
    );
  }

  Widget showDrawer() {
    return Drawer(
      child: ListView(
        children: [
          showDrawHead(),
          showListDevice(),
          showAddlist(),
        ],
      ),
    );
  }

  Widget logOutButton() {
    return IconButton(
      icon: Icon(Icons.logout),
      tooltip: "Sign Out",
      onPressed: () {
        signoutAlert();
      },
    );
  }

  void signoutAlert() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Are You Sure?"),
            content: Text("Do you want to sign out ?"),
            actions: [
              cancleButton(),
              okButton(),
            ],
          );
        });
  }

  Widget okButton() {
    return FlatButton(
      child: Text('Ok'),
      onPressed: () {
        Navigator.of(context).pop();
        processSignout();
      },
    );
  }

  Future<void> processSignout() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    await auth.signOut().then((response) {
      print('Sign out success');
      MaterialPageRoute materialPageRoute =
          MaterialPageRoute(builder: (context) => Home());
      Navigator.of(context)
          .pushAndRemoveUntil(materialPageRoute, (route) => false);
    });
  }

  Widget cancleButton() {
    return FlatButton(
      child: Text("Cancle"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(onscreen),
        centerTitle: true,
        actions: [logOutButton()],
      ),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
              gradient: RadialGradient(
            colors: [Colors.white, Colors.blue.shade100],
            radius: 1.0,
          )),
          child: Center(
            child: TimerInput(),
          ),
        ),
      ),
      drawer: showDrawer(),
    );
  }
}
