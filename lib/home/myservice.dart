import 'dart:async';

import 'package:app_new/home/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyService extends StatefulWidget {
  MyService({Key key}) : super(key: key);

  @override
  _MyServiceState createState() => _MyServiceState();
}

class _MyServiceState extends State<MyService> {
/* ////////////// Service page variable ////////////// */
  String login = '....';
  String onscreen = "Flush Automate";
  TextEditingController _textFieldController = TextEditingController();
  String codeDialog;
  String valueText;

  bool status = false;

  List<String> devicename = [];
  List<String> item = [];

/* //////////// Timer field variable /////////////////////// */
  final DatabaseReference databaseReference =
      FirebaseDatabase.instance.reference();
  int initHour = 12;
  int initMins = 0;
  int hour = 12;
  int mins = 0;
  String timerhour, timermins;
  bool isReset = true;
  bool reset = false;
  String displaytimer = "12:00";
  int collect_hours, collect_mins, submit_count = 0;

  // Methode
  @override
  void initState() {
    super.initState();
    findDisplayName();
    readDevice();
    refreshProcess();
  }

  Future<void> addChecker() async {
    var text = valueText;
    var alldevice = [];
    await databaseReference
        .child("device_id")
        .child('all')
        .once()
        .then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> data = snapshot.value;

      data.forEach((key, value) {
        alldevice.add(key);
      });

      if (alldevice.contains(text)) {
        databaseReference
            .child("device_id")
            .child('all')
            .child(text)
            .once()
            .then((DataSnapshot snapshot) {
          Map<dynamic, dynamic> val = snapshot.value;
          if (val['installation'] == 'no') {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text(
                    'Ops!!',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  content: Text("This device is already installed."),
                  actions: [
                    FlatButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Close'),
                    )
                  ],
                );
              },
            );
          } else {
            // databaseReference
            //     .child('device_id')
            //     .child('all')
            //     .child(text)
            //     .update({"installation": "yes"});
            print(text);
            // addedDevice(text);
            addDeviceTobase(text);
          }
        });
      } else {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(
                'Ops!!',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Text(
                  "The device you added could not be found in the database. Please check the device id again."),
              actions: [
                FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Close'),
                )
              ],
            );
          },
        );
      }
    });
  }

  Future<void> addDeviceTobase(String text) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    FirebaseAuth auth = FirebaseAuth.instance;
    var user = auth.currentUser;
    print(user.toString());

    Map<String, dynamic> map = Map();
    map['ID'] = text;

    await firestore
        .collection(user.displayName)
        .doc(text)
        .set(map)
        .then((value) {
      print('Upload Success');
    }).catchError((value) {
      print('fail');
    });
  }

  Future<dynamic> onlineStatusDevice(String device) async {
    databaseReference
        .child('device')
        .child(device)
        .once()
        .then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> data = snapshot.value;
      if (data['connection'] == 'ack') {
        databaseReference
            .child('device')
            .child(device)
            .update({'connection': 'syn'});
        status = true;
      } else {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(
                'Ops!!',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Text(
                "This device not online status. Please check device connection and reconnect device to the WiFi. But the toilet can still work through the sensor system.",
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              actions: [
                FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Close'),
                )
              ],
            );
          },
        );
        status = false;
      }
    });
  }

  Future<void> refreshProcess() async {
    List<String> onlinedevice = [];
    databaseReference.child('device').once().then((DataSnapshot value) {
      Map<dynamic, dynamic> data = value.value;
      data.forEach((key, value) {
        if (value['connection'] == 'ack') {
          print(key);
          onlinedevice.add(key);
        }
      });
      if (onlinedevice != null &&
          onlinedevice != [] &&
          onlinedevice.isNotEmpty) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(
                'Online status',
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Text("This is online devices $onlinedevice"),
              actions: [
                FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Close'),
                )
              ],
            );
          },
        );
      } else {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(
                'Connection devices status',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Text("There are no devices online at this time."),
              actions: [
                FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Close'),
                )
              ],
            );
          },
        );
      }
    });
  }

  Future<void> readDevice() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    FirebaseAuth auth = FirebaseAuth.instance;
    var user = auth.currentUser;
    CollectionReference collectionReference =
        firestore.collection(user.displayName);
    await collectionReference.snapshots().listen((event) {
      List<DocumentSnapshot> snapshots = event.docs;
      for (var device in snapshots) {
        print(device.id);
        print("HERE");
        print(devicename);
        // setState(() {
        //   devicename.add(device.id);
        //   devicename.toSet().toList();
        // });
        addedDevice(device.id);
      }
    });
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
                    addChecker();
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

/* ///////////////////////////// My service page method ///////////////////// */

  void addedDevice(String str) {
    setState(() {
      print(str);
      item.add(str);
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
                onlineStatusDevice(onscreen);
                print(onscreen);
              });
              // onlineStatusDevice(onscreen);
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
        // refreshStatusdevice(),
        RefreshIndicator(
          child: listDevice(),
          onRefresh: refreshProcess,
        ),
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
    return Text(
      'Log in by : $login',
      style: TextStyle(fontSize: 18),
    );
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

/* //////////////////////// Timer field method //////////////////// */
  void resetProcess() {
    setState(() {
      isReset = !isReset;
      // hour = 12;
    });
  }

  Future<void> showWorkResult(String device) async {
    databaseReference
        .child('device')
        .child(device)
        .once()
        .then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> data = snapshot.value;
      if (data['working_state'] == 'flush completed') {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Row(
                children: [
                  Icon(
                    Icons.beenhere_sharp,
                    size: 48.0,
                    color: Colors.green,
                  ),
                  Text(
                    'Complete',
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              content: Text("Flusing is successfully."),
              actions: [
                FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Close'),
                )
              ],
            );
          },
        );
      } else if (data['working_state'] == 'failure') {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Row(
                children: [
                  Icon(
                    Icons.sms_failed_sharp,
                    size: 48.0,
                    color: Colors.red,
                  ),
                  Text(
                    'Failure',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              content: Text("Flushing has error."),
              actions: [
                FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Close'),
                )
              ],
            );
          },
        );
      }
    });
  }

  void flushProcess() {
    if (onscreen == "Flush Automate") {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(
                "Flush Error",
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Text("Please select a device before flushing"),
              actions: [
                FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Close'),
                )
              ],
            );
          });
    } else {
      onlineStatusDevice(onscreen);
      if (status == true) {
        databaseReference.child('device').child(onscreen).child('flush').set({
          'status': 'activate',
        });
        Timer(Duration(seconds: 4), () {
          showWorkResult(onscreen);
        });
        // showDialog(
        //   context: context,
        //   builder: (context) {
        //     return AlertDialog(
        //       title: Text(
        //         'Ops!!',
        //         style: TextStyle(
        //           color: Colors.red,
        //           fontSize: 24.0,
        //           fontWeight: FontWeight.bold,
        //         ),
        //       ),
        //       content: Text(
        //         "This device not online status. Please check device connection and reconnect device to the WiFi. But the toilet can still work through the sensor system.",
        //         style: TextStyle(
        //           fontSize: 16,
        //         ),
        //       ),
        //       actions: [
        //         FlatButton(
        //           onPressed: () {
        //             Navigator.of(context).pop();
        //           },
        //           child: Text('Close'),
        //         )
        //       ],
        //     );
        //   },
        // );
      }
    }
  }

  Widget flushButton() {
    return Column(
      children: [
        RaisedButton(
          onPressed: () {
            flushProcess();
          },
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          color: Colors.blueAccent.shade400,
          child: Text(
            "Flushing",
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
        ),
        Text(
          "Tap to Flushing!!!",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black38,
          ),
        )
      ],
    );
  }

  Widget timerPicker() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [hourPicker(), minutesPicker()],
    );
  }

  Widget hourPicker() {
    if (!isReset) {
      print('Here');
      return Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: 5.0),
            child: Text(
              "HH",
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
          ),
          NumberPicker.integer(
              // initialValue: initHour,
              initialValue: hour,
              minValue: 0,
              maxValue: 23,
              onChanged: (val) {
                setState(() {
                  // hour = val;
                  val = hour;
                });
              })
        ],
      );
    } else {
      return Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: 5.0),
            child: Text(
              "HH",
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
          ),
          NumberPicker.integer(
              // infiniteLoop: true,
              initialValue: hour,
              minValue: 0,
              maxValue: 23,
              onChanged: (val) {
                setState(() {
                  hour = val;
                });
              })
        ],
      );
    }
  }

  Widget minutesPicker() {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(bottom: 5.0),
          child: Text(
            "MM",
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
        ),
        NumberPicker.integer(
            // initialValue: initMins,
            initialValue: mins,
            minValue: 0,
            maxValue: 59,
            zeroPad: true,
            onChanged: (val) {
              setState(() {
                mins = val;
              });
            })
      ],
    );
  }

  Widget showTimer() {
    return Text(
      displaytimer,
      style: TextStyle(
        fontSize: 30.0,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget showButton() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [resetButton(), submitButton()],
    );
  }

  Widget submitButton() {
    return RaisedButton(
      onPressed: submit,
      // padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
      color: Colors.green,
      child: Text(
        "submit",
        style: TextStyle(fontSize: 18, color: Colors.white),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
    );
  }

  Widget resetButton() {
    return RaisedButton(
      onPressed: () {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => MyService(),
        //   ),
        // );
      },
      color: Colors.red,
      child: Text(
        "reset",
        style: TextStyle(fontSize: 18, color: Colors.white),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
    );
  }

  void submit() {
    setState(() {
      collect_hours = hour;
      collect_mins = mins;
      submit_count = submit_count + 1;

      if (onscreen.compareTo("Flush Automate") == 0) {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text(
                  "Ops!!",
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                content: Text("Please select device before submit timer"),
                actions: [
                  FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Close'),
                  )
                ],
              );
            });
      } else {
        onlineStatusDevice(onscreen);
        print(onscreen);
        if (mins < 10) {
          displaytimer = "${hour.toString()}:0${mins.toString()}";
        } else {
          displaytimer = "${hour.toString()}:${mins.toString()}";
        }
        databaseReference.child("device").child(onscreen).child("timer").set({
          "hours": collect_hours,
          "minutes": collect_mins,
          "status": "activate"
        });
      }
    });
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
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              flushButton(),
              timerPicker(),
              showTimer(),
              showButton(),
            ],
          ),
        ),
      ),
      drawer: showDrawer(),
    );
  }
}
