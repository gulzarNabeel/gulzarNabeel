import 'package:shared_preferences/shared_preferences.dart';

import 'User.dart';

class Utility {

  static Utility? _instance;
  SharedPreferences? prefs;
  Utility._();

  factory Utility() {
    if (_instance == null) {
      _instance = Utility._();
      _instance?.asyncFunc();
    }
    return _instance!;
  }

  asyncFunc() async {
    prefs = await SharedPreferences.getInstance();
  }

  saveUserData(Map<String,dynamic> document) {
    List<String> arrayString = [];
    if (document['name'] != null) {
      arrayString.add(document['name']);
    }else{
      arrayString.add('');
    }
    if (document['email'] != null) {
      arrayString.add(document['email']);
    }else{
      arrayString.add('');
    }
    if (document['countryCode'] != null) {
      arrayString.add(document['countryCode']);
    }else{
      arrayString.add('');
    }
    if (document['phoneNumber'] != null) {
      arrayString.add(document['phoneNumber']);
    }else{
      arrayString.add('');
    }
    if (document['profilePictureUrl'] != null) {
      arrayString.add(document['profilePictureUrl']);
    }else{
      arrayString.add('');
    }
    if (document['creationDate'] != null) {
      arrayString.add(document['creationDate']);
    }else{
      arrayString.add('');
    }
    this.prefs?.setStringList("userData", arrayString);
  }

  User getUserData() {
    List<String>? data = prefs?.get('userData') as List<String>?;
    Map<String,dynamic> document = {
      'name': data?[0] ?? '',
      'email': data?[1] ?? '',
      'countryCode': data?[2] ?? '',
      'phoneNumber': data?[3] ?? '',
      'profilePictureUrl': data?[4] ?? '',
      'creationDate': data?[5] ?? '',
    };
    return User.fromDocument(document);
  }
}