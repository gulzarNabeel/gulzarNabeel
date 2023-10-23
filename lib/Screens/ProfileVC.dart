import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_calling_code_picker/picker.dart';
import 'package:diabetes/Models/User.dart';
import 'package:diabetes/Usables/AlertDialogLocal.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../Usables/CustomTextField.dart';
import '../Usables/Utility.dart';

class ProfileVC extends StatefulWidget {
  const ProfileVC({super.key, required this.title});
  final String title;
  @override
  State<ProfileVC> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfileVC> {
  Country? _selectedCountry;
  Text? _countryText = Text("", style: TextStyle(color: Colors.blue, fontSize: 25));
  CustomTextField textFieldPhone = CustomTextField('Phone Number', TextInputType.phone, false);
  CustomTextField textFieldName = CustomTextField('Name', TextInputType.name, true);
  CustomTextField textFieldEmail = CustomTextField('Email', TextInputType.emailAddress, true);
  @override
  void initState() {
    initCountry();
    super.initState();
  }
  void initCountry() async {
    var country = await getDefaultCountry(context);
    List<Country> countries = await getCountries(context);
    setState(() {
      List<Country> filter = countries.where((element) {
        return element.callingCode == Utility().getUserData().countryCode;
      }).toList();
      if (filter.length > 0) {
        country = filter[0];
      }
      _selectedCountry = country;
      if (Utility().getUserData().countryCode == _selectedCountry!.callingCode) {
        _countryText = Text(_selectedCountry?.callingCode ?? "", style: TextStyle(color: Colors.blue, fontSize: 25));
      }else{
        _countryText = Text(Utility().getUserData().countryCode, style: TextStyle(color: Colors.blue, fontSize: 25));
      }
      textFieldPhone.textFieldIn.controller?.text  = Utility().getUserData().phoneNumber;
      textFieldName.textFieldIn.controller?.text  = Utility().getUserData().name;
      textFieldEmail.textFieldIn.controller?.text  = Utility().getUserData().email;
      FirebaseAuth auth = FirebaseAuth.instance;
      print('Name: ' + (auth.currentUser?.displayName ?? '') + '\nMobile: ' + (auth.currentUser?.phoneNumber ?? '') + '\nUID: ' + (auth.currentUser?.uid ?? '') + '\nEmail: ' + (auth.currentUser?.email ?? ''));
    });
  }

  void _onPressedShowBottomSheet() async {
    return;
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
      appBar: AppBar(
        title: Text("Profile"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () async {
              await FirebaseAuth.instance.signOut().then((value) {

              });
            },
          ),],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: Center(
                child: Container(
                    width: 200,
                    height: 150,
                    child: Image.asset('Assets/appicon.png')),
              ),
            ),
            //Name Text Portion
            Padding(
              padding: EdgeInsets.only(left: 20, top: 0, right: 20, bottom: 20),
              child: Row(
                  children: <Widget>[
                    textFieldName,
                  ]
              ),
            ),
            //Phone Number portion
            Padding(
              padding: EdgeInsets.only(left: 20, top: 0, right: 20, bottom: 20),
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
            Padding(
                padding: EdgeInsets.only(left: 20, top: 0, right: 20, bottom: 20),
              child: Row(
                  children: <Widget>[
                    textFieldEmail,
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
                  updateProfile(context);
                },
                child: Text(
                  'Update',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  updateProfile(BuildContext context) async {
    if ((textFieldEmail.textFieldIn.controller?.text ?? '') == Utility().getUserData().email && (textFieldName.textFieldIn.controller?.text ?? '') == Utility().getUserData().name) {
      return;
    }
    if ((textFieldName.textFieldIn.controller?.text ?? '').length <= 0) {
      AlertDialogLocal(
          'Alert',
          'Please enter your name',
          'OK',
          '', () {print("OK");}, () {print("OK");},
          false,
          '',
          false).showAlert(context);
      return;
    }
    if ((textFieldEmail.textFieldIn.controller?.text ?? '').length <= 0) {
      AlertDialogLocal(
          'Alert',
          'Please enter your email address in correct format',
          'OK',
          '', () {}, () {},
          false,
          '',
          false).showAlert(context);
      return;
    }

    try {
      // Fetch sign-in methods for the email address
      List<String> list = [];
      if ((textFieldEmail.textFieldIn.controller?.text ?? '') != Utility().getUserData().email) {
        list = await FirebaseAuth.instance.fetchSignInMethodsForEmail(textFieldEmail.textFieldIn.controller?.text ?? '');
      }
      print('total login type list' + list.toString());
      if (list.isNotEmpty) {
        AlertDialogLocal('Alert', 'The email address is already in use by another account', 'OK', '', () {}, () {}, false, '', false).showAlert(context);
      } else {
        // Return false because email adress is not in use
        FirebaseAuth auth = FirebaseAuth.instance;
        auth.verifyPhoneNumber(phoneNumber: Utility().getUserData().countryCode+Utility().getUserData().phoneNumber,verificationCompleted: (_){
          print("Done\n\n\n\nverificationCompleted");
        }, verificationFailed: (error){
          print("Done\n\n\n$error");
        }, codeSent: (String verificationId, int? token) async {
          await showAlertDialog(context, verificationId);
        }, codeAutoRetrievalTimeout: (_){
          print("Done\n\n\n\ncodeAutoRetrievalTimeout");
        });
      }
    } catch (error) {
      AlertDialogLocal('Alert', error.toString(), 'OK', '', () {}, () {}, false, '', false).showAlert(context);
    }
  }

  showAlertDialog(BuildContext cont,String idVerification) async {
    // set up the buttons
    AlertDialogLocal('OTP Verification', 'Please enter your OTP received in your phone', 'Update', 'Cancel', (String value) async {
      FirebaseAuth auth = FirebaseAuth.instance;
      final credentials = PhoneAuthProvider.credential(
          verificationId: idVerification,
          smsCode: value);
      try {
        await auth.currentUser?.reauthenticateWithCredential(credentials).then((authResult) {
          var currentUser = Utility().getUserData();
          if (currentUser.name != (textFieldName.textFieldIn.controller?.text ?? '')) {
            auth.currentUser?.updateDisplayName(textFieldName.textFieldIn.controller?.text ?? '').then((value){
              currentUser.name = (textFieldName.textFieldIn.controller?.text ?? '');
              if (currentUser.email != (textFieldEmail.textFieldIn.controller?.text ?? '')) {
                auth.currentUser?.updateEmail(textFieldEmail.textFieldIn.controller?.text ?? '').then((value){
                  currentUser.email = (textFieldEmail.textFieldIn.controller?.text ?? '');
                  currentUser.updateData();
                });
              }
            });
          }else if (currentUser.email != (textFieldEmail.textFieldIn.controller?.text ?? '')) {
            auth.currentUser?.updateEmail(
                textFieldEmail.textFieldIn.controller?.text ?? '').then((
                value) {
              currentUser.email = (textFieldEmail.textFieldIn.controller?.text ?? '');
              currentUser.updateData();
            });
          }
        });
      } catch (error) {
        print(error);
        AlertDialogLocal('Failed', error.toString(), 'OK', '',(){},(){}, false, '', false).showAlert(cont);
      }
    }, (value){

    }, true, 'OTP', true).showAlert(cont);
  }
}