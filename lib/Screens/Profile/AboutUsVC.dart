import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diabetes/Screens/Profile/ProfileVC.dart';
import 'package:diabetes/Usables/AlertDialogLocal.dart';
import 'package:diabetes/Usables/AuthHandler.dart';
import 'package:diabetes/Usables/Utility.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AboutUsVC extends StatefulWidget {
  const AboutUsVC({super.key});

  @override
  State<AboutUsVC> createState() => _AboutUsVCState();
}

class _AboutUsVCState extends State<AboutUsVC> {
  @override
  void initState() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text("About Diab-Gulzar")
        ),
        backgroundColor: Colors.white,
        body: Container());
  }
}
