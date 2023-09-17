import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:country_calling_code_picker/picker.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';

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


class _PhoneNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Format the phone number with spaces for better readability
    if (newValue.text.isNotEmpty) {
      final formattedText = newValue.text;
      return TextEditingValue(
        text: formattedText,
        selection: TextSelection.collapsed(offset: formattedText.length),
      );
    }
    return newValue;
  }
}

class PhoneNumberTextField extends StatelessWidget {
  TextField textFieldPhone = TextField(
    keyboardType: TextInputType.phone,
    inputFormatters: [
      FilteringTextInputFormatter.allow(RegExp("[0-9]")),
      LengthLimitingTextInputFormatter(10), // Limit to 10 digits
      _PhoneNumberFormatter(), // Custom formatter for phone numbers
    ],
    decoration: InputDecoration(
      labelText: 'Phone Number',
      hintText: 'Phone Number',
    ),
  );
  TextEditingController editController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    textFieldPhone = TextField(
      controller: editController,
      keyboardType: TextInputType.phone,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp("[0-9]")),
        LengthLimitingTextInputFormatter(10), // Limit to 10 digits
        _PhoneNumberFormatter(), // Custom formatter for phone numbers
      ],
      decoration: InputDecoration(
        labelText: 'Phone Number',
        hintText: 'Phone Number',
      ),
    );
    return Expanded(
        child: textFieldPhone,
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
            getFirestoreData(countryCode,phone);
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

  getFirestoreData(String countryCode, String phone){
    CollectionReference users = FirebaseFirestore.instance.collection('Users');
    FirebaseAuth auth = FirebaseAuth.instance;
    users.doc(auth.currentUser?.uid).get().then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
        print('Document exists on the database $data["name"]');
      }else{
        users.doc(auth.currentUser?.uid).set({
          'name' : "",
          'email' : "",
          'countryCode' : countryCode,
          'phoneNumber' : phone,
          'profilePictureUrl' : "",
          'creationDate' : auth.currentUser?.metadata?.creationTime
        }).then((value) => print("User Added")).catchError((error) => print("Failed to add user: $error"));
      }
    });



    if (users.doc(auth.currentUser?.uid).get() == null) {
      print("item not found");

    }else{
      print(users.id);
    }


    return FutureBuilder<DocumentSnapshot>(
        future: users.doc(auth.currentUser?.uid).get(),
        builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text("Something went wrong");
            }
            if (snapshot.hasData && !snapshot.data!.exists) {
              users.add({
                'name' : "",
                'email' : "",
                'countryCode' : "",
                'phoneNumber' : "",
                'profilePictureUrl' : "",
                'creationDate' : auth.currentUser?.metadata?.creationTime
              }).then((value) => print("User Added")).catchError((error) => print("Failed to add user: $error"));
            }

            if (snapshot.connectionState == ConnectionState.done) {
              Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
              return Text("name: ${data['name']}");
            }

            return Text("loading");
        },
    );
  }
}