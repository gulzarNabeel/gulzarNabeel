import 'package:country_calling_code_picker/picker.dart';
import 'package:flutter/material.dart';

import '../Usables/PhoneNumberTextField.dart';
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
  PhoneNumberTextField textFieldPhone = PhoneNumberTextField();
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
      textFieldPhone.textFieldPhone.controller?.text  = Utility().getUserData().phoneNumber;
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
                  // FirebaseAuthentication().sendOTP(context,_selectedCountry?.callingCode ?? "", textFieldPhone.textFieldPhone.controller?.text ?? "");
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