import 'package:diabetes/Models/HealthProfile.dart';
import 'package:diabetes/Models/UserLocal.dart';
import 'package:diabetes/Usables/RemoteConfigFirebase.dart';
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
    if (document['glucoseUnit'] != null) {
      arrayString.add(document['glucoseUnit']);
    }else{
      arrayString.add('');
    }
    if (document['pressureUnit'] != null) {
      arrayString.add(document['pressureUnit']);
    }else{
      arrayString.add('');
    }
    if (document['foodUnit'] != null) {
      arrayString.add(document['foodUnit']);
    }else{
      arrayString.add('');
    }
    if (document['weightUnit'] != null) {
      arrayString.add(document['weightUnit']);
    }else{
      arrayString.add('');
    }
    if (document['heightUnit'] != null) {
      arrayString.add(document['heightUnit']);
    }else{
      arrayString.add('');
    }
    this.prefs?.setStringList("userData", arrayString).whenComplete((){});
  }
  UserLocal getUserData() {
    List<String>? data = this.prefs?.getStringList('userData') as List<String>?;
    UserLocal myData = UserLocal(data?[0] ?? '', data?[1] ?? '', data?[2] ?? '', data?[3] ?? '', data?[4] ?? '', ((data?[5] ?? '').length > 0 ? new DateFormat('yyyy-MM-dd – hh:mm:ss').parse(data?[5] ?? '') : DateTime.now()),((data?[6] ?? '').length > 0 ? new DateFormat('yyyy-MM-dd').parse(data?[6] ?? '') : null),(data?[7] ?? '').length > 0 ? Gender.values.firstWhere((element) => element.toString() == 'Gender.' + (data?[7] ?? '')) : null,Units({"unit" : (data?[8] ?? 'mg/dL').length > 0 ? (data?[8] ?? 'mg/dL') : 'mg/dL'}),Units({'unit' : (data?[9] ?? 'mmHg').length > 0 ? (data?[9] ?? 'mmHg') : 'mmHg'}),Units({'unit' : (data?[10] ?? 'grams').length > 0 ? (data?[10] ?? 'grams') :  'grams'}),Units({'unit' : (data?[11] ?? 'kg').length > 0 ? (data?[11] ?? 'kg') : 'kg'}),Units({'unit' : (data?[12] ?? 'cm').length > 0 ? (data?[12] ?? 'cm') : 'cm'}));
    return myData;
  }

  saveUserHealthData(Map<String,dynamic> document) {
    List<String> arrayString = [];
    if (document['type'] != null) {
      arrayString.add(document['type']);
    }else{
      arrayString.add('');
    }
    if (document['startedYearDiab'] != null) {
      arrayString.add(document['startedYearDiab']);
    }else{
      arrayString.add('');
    }
    if (document['hyperTension'] != null) {
      arrayString.add(document['hyperTension'].toString());
    }else{
      arrayString.add('false');
    }
    if (document['startedYearBP'] != null) {
      arrayString.add(document['startedYearBP']);
    }else{
      arrayString.add('');
    }
    if (document['nephroPathy'] != null) {
      arrayString.add(document['nephroPathy'].toString());
    }else{
      arrayString.add('false');
    }
    if (document['startedYearNephro'] != null) {
      arrayString.add(document['startedYearNephro']);
    }else{
      arrayString.add('');
    }
    if (document['retinopthy'] != null) {
      arrayString.add(document['retinopthy'].toString());
    }else{
      arrayString.add('false');
    }
    if (document['startedYearRetina'] != null) {
      arrayString.add(document['startedYearRetina']);
    }else{
      arrayString.add('');
    }
    if (document['cardioPathy'] != null) {
      arrayString.add(document['cardioPathy'].toString());
    }else{
      arrayString.add('false');
    }
    if (document['startedYearCardio'] != null) {
      arrayString.add(document['startedYearCardio']);
    }else{
      arrayString.add('');
    }
    if (document['neuropathy'] != null) {
      arrayString.add(document['neuropathy'].toString());
    }else{
      arrayString.add('false');
    }
    if (document['startedYearNeuro'] != null) {
      arrayString.add(document['startedYearNeuro']);
    }else{
      arrayString.add('');
    }
    this.prefs?.setStringList("userHealthData", arrayString).whenComplete((){});
  }
  HealthProfile getUserHealthData() {
    List<String>? data = this.prefs?.getStringList('userHealthData') as List<String>?;
    HealthProfile myData = HealthProfile(DiabetesType.values.firstWhere((element) => (data?[0] ?? "None") == element.name), ((data?[1] ?? '').isNotEmpty ? DateFormat('yyyy-MM-dd').parse(data?[1] ?? '') : null),
      (data?[2] ?? 'false').parseBool(), ((data?[3] ?? '').isNotEmpty ? DateFormat('yyyy-MM-dd').parse(data?[3] ?? '') : null),
      (data?[4] ?? 'false').parseBool(), ((data?[5] ?? '').isNotEmpty ? DateFormat('yyyy-MM-dd').parse(data?[5] ?? '') : null),
        (data?[6] ?? 'false').parseBool(), ((data?[7] ?? '').isNotEmpty ? DateFormat('yyyy-MM-dd').parse(data?[7] ?? '') : null),
      (data?[8] ?? 'false').parseBool(), ((data?[9] ?? '').isNotEmpty ? DateFormat('yyyy-MM-dd').parse(data?[9] ?? '') : null),
        (data?[10] ?? 'false').parseBool(), ((data?[11] ?? '').isNotEmpty ? DateFormat('yyyy-MM-dd').parse(data?[11] ?? '') : null)
    );
    return myData;
  }
}

extension BoolParsing on String {
  bool parseBool() {
    return this.toLowerCase() == 'true';
  }
}

extension StringParsing on bool {
  String parseToString() {
    return this == true ? 'true' : 'false';
  }
}