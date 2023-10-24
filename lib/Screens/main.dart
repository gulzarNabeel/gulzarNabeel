import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diabetes/Screens/ProfileVC.dart';
import 'package:diabetes/Usables/Utility.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import '../firebase_options.dart';
import 'package:diabetes/Screens/LoginVC.dart';
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
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Home Page'),
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
  timerEvent();
  }

  timerEvent() {
    Timer.periodic(const Duration(seconds: 3), (timer) async {
      timer.cancel();
      print('timer finished');
      FirebaseAuth auth = FirebaseAuth.instance;
      if (auth.currentUser != null) {
        CollectionReference users = FirebaseFirestore.instance.collection('Users');
        users.doc(auth.currentUser?.uid).get().then((DocumentSnapshot documentSnapshot) {
          if (documentSnapshot.exists) {
            Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
            Utility().saveUserData(data);
            // if (data["name"].toString().length > 0) {
            //
            // }else{
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ProfileVC(title: 'Flutter Profile Page', onClose: () {
                    timerEvent();
                  }),
                  fullscreenDialog: true),
            );
            // }
          }else{
            auth.signOut();
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => LoginVC(title: 'Flutter Login Page'),
                  fullscreenDialog: true),
            );
          }
        });
      }else {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => LoginVC(title: 'Flutter Login Page'),
              fullscreenDialog: true),
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