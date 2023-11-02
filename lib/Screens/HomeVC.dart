import 'dart:async';
import 'dart:ffi';
import 'package:diabetes/Screens/ProfileVC.dart';
import 'package:diabetes/Usables/Utility.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class HomeVC extends StatefulWidget {
  final VoidCallback onClose;

  const HomeVC({super.key, required this.onClose});

  @override
  _HomeVCState createState() => new _HomeVCState();
}

class Pair<String, Object> {
  final String title;
  final Object obj;

  Pair(this.title, this.obj);
}

class _HomeVCState extends State<HomeVC> with SingleTickerProviderStateMixin {
  String titleText = "My Sessions";
  List<Pair> itemsIn = [
    Pair("Home", ProfileVC(title: 'Home', Signup: false, onClose: () {})),
    Pair("Feeds", ProfileVC(title: 'Feeds', Signup: false, onClose: () {})),
    Pair("Add", ProfileVC(title: 'Add', Signup: false, onClose: () {})),
    Pair("Devices", ProfileVC(title: 'Devices', Signup: false, onClose: () {})),
    Pair("Profile", ProfileVC(title: 'Profile', Signup: false, onClose: () {}))
  ];

  int _routeTo = 0;
  List<Map<String, Object>>? _pages;

  @override
  void initState() {
    itemsIn = [
      Pair("Home", ProfileVC(title: 'Home', Signup: false, onClose: () {})),
      Pair("Feeds", ProfileVC(title: 'Feeds', Signup: false, onClose: () {})),
      Pair("Add", ProfileVC(title: 'Add', Signup: false, onClose: () {})),
      Pair("Devices", ProfileVC(title: 'Devices', Signup: false, onClose: () {})),
      Pair("Profile", ProfileVC(title: 'Profile', Signup: false, onClose: () {
        widget.onClose();
      }))
    ];
    if (_routeTo == 2) {
      // Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //         builder: (context) => retailer.ConnectRetailerScreen()));
    } else {
      routeToPage(_routeTo);
    }
  }

  void routeToPage(int pageTo) {
    _routeTo = pageTo;
    setState(() {
      switch (pageTo) {
        case 0:
          this.titleText = "My Home";
          break;
        case 1:
          this.titleText = "Feeds";
          break;
        case 2:
          this.titleText = "Add";
          break;
        case 3:
          this.titleText = "Devices";
          break;
        case 4:
          this.titleText = "Profile";
          break;
        default:
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          appBar: new AppBar(
            centerTitle: true,
            automaticallyImplyLeading: false,
            leading: Container(
              child: Container(
                padding: EdgeInsets.all(10),
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue),
                  borderRadius: BorderRadius.all(Radius.circular(13)),
                ),
                child: ClipOval(
                  child: Utility().getUserData().profilePictureUrl.length > 0
                      ? Image.network(Utility().getUserData().profilePictureUrl)
                      : Image(image: AssetImage('Assets/appicon.png')),
                ),
              ),
            ),
            title: Text(titleText, textAlign: TextAlign.center),
            actions: _routeTo == 4 ? [
            IconButton(
              icon: const Icon(Icons.logout),
              tooltip: 'Logout',
              onPressed: () async {
                await FirebaseAuth.instance.signOut().then((value) {
                  widget.onClose();
                  Navigator.pop(context);
                });
              },
            ),] : [
              IconButton(
                icon: const Icon(Icons.refresh),
                tooltip: 'Refresh',
                onPressed: () async {
                  await FirebaseAuth.instance.signOut().then((value) {
                    Navigator.pop(context);
                  });
                },
              ),
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            fixedColor: Colors.blue,
            onTap: routeToPage,
            currentIndex: _routeTo,
            items: [
              BottomNavigationBarItem(
                  icon: const Icon(Icons.home_rounded),
                  label: itemsIn[0].title,
                  activeIcon: const Icon(Icons.home_rounded, color: Colors.blue)),
              BottomNavigationBarItem(
                  icon: const Icon(Icons.feed),
                  label: itemsIn[1].title,
                  activeIcon: const Icon(Icons.feed, color: Colors.blue)),
              BottomNavigationBarItem(
                  icon: const Icon(Icons.add),
                  label: itemsIn[2].title,
                  activeIcon: const Icon(Icons.add, color: Colors.blue)),
              BottomNavigationBarItem(
                  icon: const Icon(Icons.gas_meter),
                  label: itemsIn[3].title,
                  activeIcon: const Icon(Icons.gas_meter, color: Colors.blue)),
              BottomNavigationBarItem(
                  icon: const Icon(Icons.person_2_rounded),
                  label: itemsIn[4].title,
                  activeIcon: const Icon(Icons.person_2_rounded, color: Colors.blue)),
            ],
          ),
          body: itemsIn[_routeTo].obj as Widget,
        ));
  }
}
