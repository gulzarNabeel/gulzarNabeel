import 'dart:async';
import 'package:diabetes/Models/UserLocal.dart';
import 'package:diabetes/Screens/TabBar/TabBarVC.dart';
import 'package:diabetes/Screens/Profile/ProfileVC.dart';
import 'package:diabetes/Usables/AlertDialogLocal.dart';
import 'package:diabetes/Usables/ProgressIndicatorLocal.dart';
import 'package:diabetes/Usables/Utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:country_calling_code_picker/picker.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../Usables/AuthHandler.dart';
import '../../Usables/CustomTextField.dart';

class LoginVC extends StatefulWidget {
  const LoginVC({super.key, required this.title});
  final String title;
  @override
  State<LoginVC> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginVC> {
  Country? _selectedCountry;
  Text? _countryText = Text("", style: TextStyle(color: Colors.blue, fontSize: 25));
  CustomTextField textFieldPhone = CustomTextField('Phone Number', TextInputType.phone, true);
  @override
  void initState() {
    initCountry();
    super.initState();
  }
  void initCountry() async {
    final country = await getDefaultCountry(context);
    setState(() {
      _selectedCountry = country;
      _countryText = Text(_selectedCountry?.callingCode ?? "", style: TextStyle(color: Colors.blue, fontSize: 25));
    });
  }

  void _onPressedShowBottomSheet() async {
    final country = await showCountryPickerSheet(
      context,
    );
    if (country != null) {
      setState(() {
        _selectedCountry = country;
        _countryText = Text(_selectedCountry?.callingCode ?? "", style: TextStyle(color: Colors.blue, fontSize: 25));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   title: Text("Login"),
      // ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 60.0),
              child: Center(
                child: Container(
                    width: 200,
                    height: 150,
                    child: Image.asset('Assets/appicon.png')),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Row(
                children: <Widget>[
                  TextButton(
                    onPressed: () {
                      _onPressedShowBottomSheet();
                    },
                    child: Container(
                      color: Colors.white.withOpacity(0),
                      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      child: _countryText,
                    ),
                  ),
                  textFieldPhone,
                ]
              ),
            ),

            Container(
              height: 50,
              width: 250,
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(20)),
                  child: TextButton(
                    onPressed: () {
                      ProgressIndicatorLocal().showAlert(context);
                      sendOTP(context,_selectedCountry?.callingCode ?? "", textFieldPhone.textFieldIn.controller?.text ?? "");
                    },
                    child: Text(
                      'Login',
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    ),
                  ),
              ),
          ],
        ),
      ),
    );
  }

  sendOTP(BuildContext con, String countryCodeIn,String phoneNumber) async {
    AuthHandler().sendOTP(con, countryCodeIn, phoneNumber, 'Login', 'Cancel', (){
      getFirestoreData(con,countryCodeIn,phoneNumber);
    });
  }

  getFirestoreData(BuildContext context, String countryCode, String phone){
    ProgressIndicatorLocal().showAlert(context);
    CollectionReference users = FirebaseFirestore.instance.collection('Users');
    FirebaseAuth auth = FirebaseAuth.instance;
    users.doc(auth.currentUser?.uid).get().then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
        Utility().saveUserData(data);
        ProgressIndicatorLocal().hideAlert(context);
        if (data["name"].toString().length > 0) {
          Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (context) => TabBarVC(onClose: (){
                  textFieldPhone.textFieldIn.controller?.text = '';
                })),
          );
        }else{
          var userCurrent = Utility().getUserData();
          userCurrent.countryCode = countryCode;
          userCurrent.phoneNumber = phone;
          userCurrent.name = auth.currentUser?.displayName ?? '';
          userCurrent.profilePictureUrl = auth.currentUser?.photoURL ?? '';
          userCurrent.email = auth.currentUser?.email ?? '';
          userCurrent.creationDate = auth.currentUser?.metadata?.creationTime ?? DateTime.now();
          userCurrent.updateData().then((_) {
            print('No profile available' + countryCode + phone);
            print(Utility().getUserData().countryCode + Utility().getUserData().phoneNumber);
            Navigator.push(
              context,
              CupertinoPageRoute(
                  builder: (context) => ProfileVC(title: 'Flutter Profile Page', Signup: true, onClose: () {
                    textFieldPhone.textFieldIn.controller?.text = '';
                  })),
            );
          });
        }
      }else{
        var userCurrent = Utility().getUserData();
        userCurrent.countryCode = countryCode;
        userCurrent.phoneNumber = phone;
        userCurrent.name = '';
        userCurrent.profilePictureUrl = '';
        userCurrent.email = '';
        userCurrent.creationDate = auth.currentUser?.metadata?.creationTime ?? DateTime.now();
        userCurrent.updateData().then((_) {
          Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (context) => ProfileVC(title: 'Flutter Profile Page', Signup: true, onClose: () {
                  textFieldPhone.textFieldIn.controller?.text = '';
                })),
          );
        });
      }
    });
  }
}