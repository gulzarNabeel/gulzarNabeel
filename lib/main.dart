import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:diabetes/LoginVC.dart';
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer.periodic(const Duration(seconds: 5), (timer) {
      timer.cancel();
      print("Timer complted");
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginVC(title: 'Flutter Login Page'), fullscreenDialog: true),
      );
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