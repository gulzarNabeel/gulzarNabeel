import 'dart:async';
import 'package:diabetes/Screens/ProfileVC.dart';
import 'package:diabetes/Usables/Utility.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:country_calling_code_picker/picker.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Usables/PhoneNumberTextField.dart';

class LoginVC extends StatefulWidget {
  const LoginVC({super.key, required this.title});
  final String title;
  @override
  State<LoginVC> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginVC> {
  Country? _selectedCountry;
  Text? _countryText = Text("", style: TextStyle(color: Colors.blue, fontSize: 25));
  PhoneNumberTextField textFieldPhone = PhoneNumberTextField();
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
      //   title: Text("Login Page"),
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
                      print(textFieldPhone.textFieldPhone.controller?.text ?? "");
                      FirebaseAuthentication().sendOTP(context,_selectedCountry?.callingCode ?? "", textFieldPhone.textFieldPhone.controller?.text ?? "");
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
}

class FirebaseAuthentication {
  String phoneNumber = "";
  String countryCodeIn = "";

  sendOTP(BuildContext con, String countryCode,String phoneNumber) async {
    this.phoneNumber = phoneNumber;
    this.countryCodeIn = countryCode;
    FirebaseAuth auth = FirebaseAuth.instance;
    auth.verifyPhoneNumber(phoneNumber: this.countryCodeIn+this.phoneNumber,verificationCompleted: (_){
      print("Done\n\n\n\nverificationCompleted");
    }, verificationFailed: (error){
      print("Done\n\n\n$error");
    }, codeSent: (String verificationId, int? token) async {
      final result = await showAlertDialog(con, countryCode,phoneNumber, verificationId);
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
    TextEditingController _editController = new TextEditingController();
    Widget cancelButton = ElevatedButton(
      child: Text("Cancel", style: TextStyle(color: Colors.red, fontSize: 25)),
      onPressed: () {
        Navigator.pop(cont);
      },
    );

    TextField textFieldin = TextField(
      controller: _editController,
      maxLines: 1,
      autofocus: true,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        hintText: 'Enter your code',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),
    );
    Widget continueButton = ElevatedButton(
      child: Text("Login", style: TextStyle(color: Colors.green, fontSize: 25)),
      onPressed: () async {
        FirebaseAuth auth = FirebaseAuth.instance;
        final credentials = PhoneAuthProvider.credential(
            verificationId: idVerification,
            smsCode: textFieldin.controller?.text ?? "");
        try {
          await auth.signInWithCredential(credentials).then((authResult) {
            getFirestoreData(cont,countryCode,phone);
            Navigator.pop(cont, textFieldin.controller?.text ?? "");
          });
        } catch (error) {
          print(error);
          Navigator.pop(cont);
        }
      },
    );
    Widget title = Text("Please enter your OTP received in your phone");

    List<Widget> actions = [cancelButton, continueButton];

    List<Widget> elements = [title, textFieldin];
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("OTP Verification"),
      content: SingleChildScrollView(
        child: ListBody(
          children: elements,
        ),
      ),
      actions: actions,
    );

    // show the dialog
    final result = await showDialog(
      context: cont,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  getFirestoreData(BuildContext context, String countryCode, String phone){
    CollectionReference users = FirebaseFirestore.instance.collection('Users');
    FirebaseAuth auth = FirebaseAuth.instance;
    users.doc(auth.currentUser?.uid).get().then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
        Utility().saveUserData(data);
        if (data["name"].toString().length > 0) {
          
        }else{
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProfileVC(title: 'Flutter Profile Page'),
                fullscreenDialog: true),
          );
        }
      }else{
        DateTime now = auth.currentUser?.metadata?.creationTime ?? DateTime.now();
        String formattedDate = DateFormat('yyyy-MM-dd – hh:mm:ss').format(now);
        users.doc(auth.currentUser?.uid).set({
          'name' : "",
          'email' : "",
          'countryCode' : countryCode,
          'phoneNumber' : phone,
          'profilePictureUrl' : "",
          'creationDate' : formattedDate
        }).then((_) {
          print("User Added Successfully");
          Map<String,dynamic> document = {
            'name' : "",
            'email' : "",
            'countryCode' : countryCode,
            'phoneNumber' : phone,
            'profilePictureUrl' : "",
            'creationDate' : formattedDate
          };
          Utility().saveUserData(document);
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProfileVC(title: 'Flutter Profile Page'),
                fullscreenDialog: true),
          );
        }).catchError((error) => print("Failed to add user: $error"));
      }
    });
  }
}