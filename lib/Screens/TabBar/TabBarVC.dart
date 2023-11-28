import 'dart:async';
import 'dart:ffi';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:diabetes/Models/Medicine.dart';
import 'package:diabetes/Screens/TabBar/DevicesVC.dart';
import 'package:diabetes/Screens/Profile/ProfileVC.dart';
import 'package:diabetes/Screens/TabBar/HealthProfileVC.dart';
import 'package:diabetes/Screens/TabBar/Medicine/AddMedicineVC.dart';
import 'package:diabetes/Screens/TabBar/Medicine/MedicineVC.dart';
import 'package:diabetes/Screens/TabBar/HomeVC.dart';
import 'package:diabetes/Screens/TabBar/AccountVC.dart';
import 'package:diabetes/Usables/Utility.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class TabBarVC extends StatefulWidget {
  final VoidCallback onClose;

  const TabBarVC({super.key, required this.onClose});

  @override
  _TabBarVCState createState() => new _TabBarVCState();
}

class Pair<String, Object> {
  final String title;
  final Object obj;

  Pair(this.title, this.obj);
}

class _TabBarVCState extends State<TabBarVC>
    with SingleTickerProviderStateMixin {
  String titleText = "My Sessions";
  List<Pair> itemsIn = [];

  int _routeTo = 0;
  List<Map<String, Object>>? _pages;

  @override
  void initState() {
    itemsIn = [
      Pair("", const HomeVC()),
      Pair("", const MedicineVC()),
      Pair("", const HealthProfileVC()),
      Pair("", const DevicesVC()),
      Pair("", AccountVC(onClose: (){
        if (FirebaseAuth.instance.currentUser == null) {
          widget.onClose();
          Navigator.pop(context);
        }}))
    ];
    routeToPage(_routeTo);
  }

  void routeToPage(int pageTo) {
    _routeTo = pageTo;
    setState(() {
      switch (pageTo) {
        case 0:
          this.titleText = "Home";
          break;
        case 1:
          this.titleText = "Medicines";
          break;
        case 2:
          this.titleText = "Health Profile";
          break;
        case 3:
          this.titleText = "Devices";
          break;
        case 4:
          this.titleText = "Account";
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
            elevation: _routeTo == 4 ? 0 : null,
            centerTitle: true,
            automaticallyImplyLeading: false,
            leading: _routeTo == 4 ? null : GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                      builder: (context) => ProfileVC(title: 'Profile', onClose: () {if (FirebaseAuth.instance.currentUser == null) {
                        widget.onClose();
                      }}, Signup: false)),
                );
              },
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
                      ? CachedNetworkImage(imageUrl: Utility().getUserData().profilePictureUrl,
                      placeholder:(context,url) => Image(image: AssetImage('Assets/appicon.png'),
                        // errorBuilder: (context,url,error),
                      ))
                      : Image(image: AssetImage('Assets/appicon.png')),
                ),
              ),
            ),
            title: Text(titleText, textAlign: TextAlign.center),
            actions: (_routeTo == 4 || _routeTo == 2 || _routeTo == 1)
                ? []
                : (_routeTo == 3)
                    ? [
                        IconButton(
                          icon: const Icon(Icons.add),
                          tooltip: 'Add',
                          onPressed: () async {
                              if (_routeTo == 1) {

                              }
                          },
                        )
                      ]
                    : [
                    IconButton(
                      icon: const Icon(Icons.refresh),
                      tooltip: 'Refresh',
                      onPressed: () async {

                      },
                    )
                  ],
          ),
          floatingActionButton: new FloatingActionButton(
            onPressed: (){},
            tooltip: 'Increment',
            child: new Icon(Icons.add,color: Colors.white),
            backgroundColor: Colors.blue,
            elevation: 10,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            fixedColor: Colors.blue,
            onTap: routeToPage,
            currentIndex: _routeTo,
            items: [
              BottomNavigationBarItem(
                  icon: const Icon(Icons.home_filled),
                  label: itemsIn[0].title,
                  activeIcon:
                      const Icon(Icons.home_filled, color: Colors.blue)),
              BottomNavigationBarItem(
                  icon: const Icon(Icons.medical_information_sharp),
                  label: itemsIn[1].title,
                  activeIcon: const Icon(Icons.medical_information_sharp, color: Colors.blue)),
              BottomNavigationBarItem(
                  icon: const Icon(Icons.health_and_safety),
                  label: itemsIn[2].title,
                  activeIcon: const Icon(Icons.health_and_safety, color: Colors.blue)),
              BottomNavigationBarItem(
                  icon: const Icon(Icons.gas_meter),
                  label: itemsIn[3].title,
                  activeIcon: const Icon(Icons.gas_meter, color: Colors.blue)),
              BottomNavigationBarItem(
                  icon: const Icon(Icons.account_circle),
                  label: itemsIn[4].title,
                  activeIcon:
                      const Icon(Icons.account_circle, color: Colors.blue)),
            ],
          ),
          body: itemsIn[_routeTo].obj as Widget,
        ));
  }
}
