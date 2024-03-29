import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diabetes/Models/HealthProfile.dart';
import 'package:diabetes/Models/UserLocal.dart';
import 'package:diabetes/Screens/Profile/DataContentVC.dart';
import 'package:diabetes/Screens/Profile/SettingsVC.dart';
import 'package:diabetes/Screens/Profile/ProfileVC.dart';
import 'package:diabetes/Usables/AlertDialogLocal.dart';
import 'package:diabetes/Usables/AuthHandler.dart';
import 'package:diabetes/Usables/ProgressIndicatorLocal.dart';
import 'package:diabetes/Usables/RemoteConfigFirebase.dart';
import 'package:diabetes/Usables/Utility.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AccountVC extends StatefulWidget {
  const AccountVC({super.key, required this.onClose});

  final VoidCallback onClose;

  @override
  State<AccountVC> createState() => _AccountVCState();
}

enum OptionAccount {
  PersonalDetails,
  ReadingSettings,
  Reminders,
  Help,
  AboutUs,
  Logout,
  DeleteAccount,
  PrivacyAndPolicy,
  TermsAndConditions
}

class PairTab<Text, Icon, OptionAccount> {
  final Text title;
  final Icon obj;
  final OptionAccount option;

  PairTab(this.title, this.obj, this.option);
}

class _AccountVCState extends State<AccountVC> {
  List<PairTab> arrayOptions = [
    PairTab(
        const Text('Reading Settings', style: TextStyle(color: Colors.black87)),
        const Icon(Icons.settings, color: Colors.black87),
        OptionAccount.ReadingSettings),
    PairTab(
        const Text('Reminders', style: TextStyle(color: Colors.black87)),
        const Icon(Icons.alarm_add, color: Colors.black87),
        OptionAccount.Reminders),
    PairTab(const Text('Help', style: TextStyle(color: Colors.black87)),
        const Icon(Icons.help, color: Colors.black87), OptionAccount.Help),
    PairTab(
        const Text('About Diab-Gulzar',
            style: TextStyle(color: Colors.black87)),
        const Icon(Icons.home_work, color: Colors.black87),
        OptionAccount.AboutUs),
    PairTab(
        const Text('Terms And Conditions',
            style: TextStyle(color: Colors.black87)),
        const Icon(Icons.rule, color: Colors.black87),
        OptionAccount.TermsAndConditions),
    PairTab(
        const Text('Privacy And Policy',
            style: TextStyle(color: Colors.black87)),
        const Icon(Icons.privacy_tip, color: Colors.black87),
        OptionAccount.PrivacyAndPolicy),
    PairTab(const Text('Logout', style: TextStyle(color: Colors.grey)),
        const Icon(Icons.logout, color: Colors.grey), OptionAccount.Logout),
    PairTab(Text('Delete Account', style: TextStyle(color: Colors.red[300])),
        Icon(Icons.delete, color: Colors.red[300]), OptionAccount.DeleteAccount)
  ];

  @override
  void initState() {}

  Widget listHeader(BuildContext context, int index) {
    return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (context) => ProfileVC(
                    title: 'Profile',
                    onClose: () {
                      initState();
                      setState(() {
                        if (FirebaseAuth.instance.currentUser == null) {
                          widget.onClose();
                        }
                      });
                    },
                    Signup: false)),
          );
        },
        child: Container(
          color: Colors.blue,
          child: Row(
            children: [
              Container(
                margin: EdgeInsets.all(10),
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.all(Radius.circular(40)),
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
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                        padding: EdgeInsets.all(0),
                        child: Text('${Utility().getUserData().name}',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 20),maxLines: 3,)),
                    Text(Utility().getUserData().email,
                        style: const TextStyle(color: Colors.white)),
                    Text(
                        '${Utility().getUserData().countryCode} ${Utility().getUserData().phoneNumber}',
                        style: const TextStyle(color: Colors.white))
                  ],
                ),
              )
            ],
          ),
        ));
  }

  Widget listItem(BuildContext context, int index) {
    return GestureDetector(
        onTap: () {
          switch (arrayOptions[index - 1].option) {
            case OptionAccount.ReadingSettings:
              Navigator.push(context, CupertinoPageRoute(builder: (context) => SettingsVC()));
              break;
            case OptionAccount.Reminders:
              break;
            case OptionAccount.Help:
              Navigator.push(context, CupertinoPageRoute(builder: (context) => DataContentVC(title: 'Help', option: OptionAccount.Help)));
              break;
            case OptionAccount.AboutUs:
              Navigator.push(context, CupertinoPageRoute(builder: (context) => DataContentVC(title: 'About Diab-Gulzar', option: OptionAccount.AboutUs)));
              break;
            case OptionAccount.TermsAndConditions:
              Navigator.push(context, CupertinoPageRoute(builder: (context) => DataContentVC(title: 'Terms and Conditions', option: OptionAccount.TermsAndConditions)));
              break;
            case OptionAccount.PrivacyAndPolicy:
              Navigator.push(context, CupertinoPageRoute(builder: (context) => DataContentVC(title: 'Privacy and Policy', option: OptionAccount.PrivacyAndPolicy)));
              break;
            case OptionAccount.Logout:
              AlertDialogLocal("Logout", 'Are you sure to logout from account?',
                      'Yes', 'No', () async {
                    var user = UserLocal(
                    '',
                    '',
                    '',
                    '',
                    '',
                    DateTime.now(),
                    null,
                    null,
                    Units({}),
                    Units({}),
                    Units({}),
                    Units({}),
                    Units({}));
                user.updateData();
                var healthProfile = HealthProfile(
                    DiabetesType.None,
                    null,
                    false,
                    null,
                    false,
                    null,
                    false,
                    null,
                    false,
                    null,
                    false,
                    null);
                healthProfile.updateData();
                ProgressIndicatorLocal().showAlert(context);
                Timer.periodic(const Duration(seconds: 2), (timer) async {
                  timer.cancel();
                  await FirebaseAuth.instance.signOut().then((value) {
                    ProgressIndicatorLocal().hideAlert(context);
                    widget.onClose();
                  });
                });
              }, () {}, false, '', true)
                  .showAlert(context);
              break;
            case OptionAccount.DeleteAccount:
              AlertDialogLocal(
                      "Delete Account",
                      'Are you sure to Delete account?\n\n\nNote:Account can not be recovered once it is deleted',
                      'Yes',
                      'No', () async {
                ProgressIndicatorLocal().showAlert(context);
                AuthHandler().sendOTP(
                    context,
                    Utility().getUserData().countryCode,
                    Utility().getUserData().phoneNumber,
                    'Delete',
                    'Keep Account', () {
                  ProgressIndicatorLocal().showAlert(context);
                  CollectionReference users =
                      FirebaseFirestore.instance.collection('Users');
                  FirebaseAuth auth = FirebaseAuth.instance;
                  users.doc(auth.currentUser?.uid).delete().then((value) async {
                    CollectionReference users2 =
                    FirebaseFirestore.instance.collection('UsersHealth');
                    users2.doc(auth.currentUser?.uid).delete().then((value) async {
                      await FirebaseAuth.instance.currentUser
                          ?.delete()
                          .then((value) {
                        ProgressIndicatorLocal().hideAlert(context);
                        widget.onClose();
                      }).catchError((error) {
                        ProgressIndicatorLocal().hideAlert(context);
                        AuthHandler.generateExceptionMessage(
                            AuthHandler.handleException(error));
                      });
                    });
                  });
                });
              }, () {}, false, '', true)
                  .showAlert(context);
              break;
          }
        },
        child: Container(
          height: 80,
          child: Row(
            children: <Widget>[
              Container(
                  margin: EdgeInsets.all(10),
                  child: arrayOptions[index - 1].obj),
              SizedBox(
                  width: 300,
                  child: Container(
                      margin: EdgeInsets.all(10),
                      child: arrayOptions[index - 1].title))
            ],
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: null,
        body: ListView.builder(
            padding: EdgeInsets.all(0.0),
            shrinkWrap: false,
            itemCount: arrayOptions.length + 1,
            itemBuilder: (BuildContext context, int index) {
              if (index == 0) {
                return listHeader(context, index);
              } else {
                return listItem(context, index);
              }
            }));
  }
}
