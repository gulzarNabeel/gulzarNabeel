import 'dart:async';
import 'package:diabetes/Models/UserLocal.dart';
import 'package:diabetes/Screens/TabBarVC.dart';
import 'package:diabetes/Screens/ProfileVC.dart';
import 'package:diabetes/Usables/AlertDialogLocal.dart';
import 'package:diabetes/Usables/Utility.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:country_calling_code_picker/picker.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Usables/AuthExceptionHandler.dart';
import '../Usables/CustomTextField.dart';

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
                  child: ElevatedButton(
                    onPressed: () {
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
    FirebaseAuth auth = FirebaseAuth.instance;
    auth.verifyPhoneNumber(phoneNumber: countryCodeIn+phoneNumber,verificationCompleted: (_){
      print("Done\n\n\n\nverificationCompleted");
    }, verificationFailed: (error){
      print("Done\n\n\n$error");
    }, codeSent: (String verificationId, int? token) async {
      final result = await showAlertDialog(con, countryCodeIn,phoneNumber, verificationId);
      setState() {
        print(result);
      }
    }, codeAutoRetrievalTimeout: (_){
      print("Done\n\n\n\ncodeAutoRetrievalTimeout");
    });
    // return result;
  }

  showAlertDialog(BuildContext cont,String countryCode, String phone,String idVerification) async {
    // set up the buttons
    AlertDialogLocal('OTP Verification', 'Please enter your OTP received in your phone', 'Login', 'Cancel', (String value) async {
      FirebaseAuth auth = FirebaseAuth.instance;
      final credentials = PhoneAuthProvider.credential(
          verificationId: idVerification,
          smsCode: value);
      try {
        await auth.signInWithCredential(credentials).then((authResult) {
          getFirestoreData(cont,countryCode,phone);
        });
      } catch (error) {
        AlertDialogLocal('Failed', AuthExceptionHandler.generateExceptionMessage(AuthExceptionHandler.handleException(error)), 'OK', '',(){},(){}, false, '', false).showAlert(cont);
      }
    }, (value){

    }, true, 'OTP', true).showAlert(cont);
  }

  getFirestoreData(BuildContext context, String countryCode, String phone){
    CollectionReference users = FirebaseFirestore.instance.collection('Users');
    FirebaseAuth auth = FirebaseAuth.instance;
    users.doc(auth.currentUser?.uid).get().then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
        Utility().saveUserData(data);
        if (data["name"].toString().length > 0) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => TabBarVC(onClose: (){
                  textFieldPhone.textFieldIn.controller?.text = '';
                  print('Reached here');
                }),
                fullscreenDialog: true),
          );
        }else{
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProfileVC(title: 'Flutter Profile Page', Signup: true, onClose: () {
                    textFieldPhone.textFieldIn.controller?.text = '';
                    print('Reached here');
                }),
                fullscreenDialog: true),
          );
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
            MaterialPageRoute(
                builder: (context) => ProfileVC(title: 'Flutter Profile Page', Signup: true, onClose: () {
                  textFieldPhone.textFieldIn.controller?.text = '';
                }),
                fullscreenDialog: true),
          );
        });
      }
    });
  }
}