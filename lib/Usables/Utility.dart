import 'package:diabetes/Models/UserLocal.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';


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
    if (document['dateOfBirth'] != null) {
      arrayString.add(document['dateOfBirth']);
    }else{
      arrayString.add('');
    }
    if (document['gender'] != null) {
      arrayString.add(document['gender']);
    }else{
      arrayString.add('');
    }
    this.prefs?.setStringList("userData", arrayString).whenComplete((){});
  }

  UserLocal getUserData() {
    List<String>? data = this.prefs?.getStringList('userData') as List<String>?;
    UserLocal myData = UserLocal(data?[0] ?? '', data?[1] ?? '', data?[2] ?? '', data?[3] ?? '', data?[4] ?? '', ((data?[5] ?? '').length > 0 ? new DateFormat('yyyy-MM-dd – hh:mm:ss').parse(data?[5] ?? '') : DateTime.now()),((data?[6] ?? '').length > 0 ? new DateFormat('yyyy-MM-dd').parse(data?[6] ?? '') : null),(data?[7] ?? '').length > 0 ? Gender.values.firstWhere((element) => element.toString() == 'Gender.' + (data?[7] ?? '')) : null);
    return myData;
  }
}