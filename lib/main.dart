import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diabetes/Models/HealthProfile.dart';
import 'package:diabetes/Screens/TabBar/TabBarVC.dart';
import 'package:diabetes/Screens/Profile/ProfileVC.dart';
import 'package:diabetes/Usables/RemoteConfigFirebase.dart';
import 'package:diabetes/Usables/Utility.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'firebase_options.dart';
import 'package:diabetes/Screens/Authentication/LoginVC.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryIconTheme: IconThemeData(color: Colors.green),
        primaryColor: Colors.green,
        appBarTheme: AppBarTheme(
          color: Colors.blue,
        ),
      ),
      title: 'Flutter Demo',
      home: MyHomePage(title: 'Flutter Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void updateParentTxt() {
    initState();
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Utility();
    RemoteConfigFirebase();
  timerEvent();
  }

  timerEvent() {
    Timer.periodic(const Duration(seconds: 3), (timer) async {
      timer.cancel();
      FirebaseAuth auth = FirebaseAuth.instance;
      if (auth.currentUser != null) {
        CollectionReference users = FirebaseFirestore.instance.collection('Users');
        users.doc(auth.currentUser?.uid).get().then((DocumentSnapshot documentSnapshot) {
          if (documentSnapshot.exists) {
            Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
            Utility().saveUserData(data);
            if (data["name"].toString().length > 0) {
              Navigator.push(context, CupertinoPageRoute(builder: (context) => TabBarVC(onClose:(){timerEvent();})));
            }else{
            Navigator.push(
              context,
                CupertinoPageRoute(
                  builder: (context) => ProfileVC(title: 'Flutter Profile Page', onClose: () {timerEvent();}, Signup: true)));
            }
          }else{
            auth.signOut();
            Navigator.push(
              context,
              CupertinoPageRoute(
                  builder: (context) => LoginVC(title: 'Flutter Login Page')),
            );
          }
        });
        CollectionReference users2 = FirebaseFirestore.instance.collection('UsersHealth');
        users2.doc(auth.currentUser?.uid).get().then((DocumentSnapshot documentSnapshot) {
          if (documentSnapshot.exists) {
            Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
            Utility().saveUserHealthData(data);
          }else{
            HealthProfile profile = Utility().getUserHealthData();
            profile.updateData();
          }
        });
      }else {
        Navigator.push(
          context,
          CupertinoPageRoute(
              builder: (context) => LoginVC(title: 'Flutter Login Page')),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return  const Scaffold(
      body: Center(
        child: Image(image: AssetImage("Assets/appicon.png"),
        width: 200,
        height: 200,)
      ),
    );
  }
}