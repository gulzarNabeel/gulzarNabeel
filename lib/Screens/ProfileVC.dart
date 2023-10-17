import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_calling_code_picker/picker.dart';
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
      appBar: AppBar(
        title: Text("Profile"),
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
                  updateProfile();
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

  updateProfile() {
    if ((textFieldName.textFieldIn.controller?.text ?? '').length <= 0 ||(textFieldEmail.textFieldIn.controller?.text ?? '').length <= 0) {
      return;
    }


    CollectionReference users = FirebaseFirestore.instance.collection('Users');
    FirebaseAuth auth = FirebaseAuth.instance;
    DateTime now = auth.currentUser?.metadata?.creationTime ?? DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd – hh:mm:ss').format(now);
    users.doc(auth.currentUser?.uid).set({
      'name': textFieldName.textFieldIn.controller?.text ?? '',
      'email': textFieldEmail.textFieldIn.controller?.text ?? '',
      'countryCode': _selectedCountry?.callingCode ?? '',
      'phoneNumber': textFieldPhone.textFieldIn.controller?.text ?? '',
      'profilePictureUrl': "",
      'creationDate': formattedDate
    }).then((_) {
      print("User Added Successfully");
      Map<String, dynamic> document = {
        'name': textFieldName.textFieldIn.controller?.text ?? '',
        'email': textFieldEmail.textFieldIn.controller?.text ?? '',
        'countryCode': _selectedCountry?.callingCode ?? '',
        'phoneNumber': textFieldPhone.textFieldIn.controller?.text ?? '',
        'profilePictureUrl': "",
        'creationDate': formattedDate
      };
      Utility().saveUserData(document);
      auth.currentUser?.updateEmail(textFieldEmail.textFieldIn.controller?.text ?? '');
      auth.currentUser?.updateDisplayName(textFieldName.textFieldIn.controller?.text ?? '');
    });
  }
}