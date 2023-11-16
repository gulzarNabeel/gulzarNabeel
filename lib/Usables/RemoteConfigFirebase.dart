import 'dart:convert';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';

class RemoteConfigFirebase {
  static RemoteConfigFirebase? _instance;
  FirebaseRemoteConfig? remoteConfig;

  RemoteConfigFirebase._();

  factory RemoteConfigFirebase() {
    if (_instance == null) {
      _instance = RemoteConfigFirebase._();
      _instance?.asyncFunc();
    }
    return _instance!;
  }
  asyncFunc() async {
    remoteConfig = FirebaseRemoteConfig.instance;
    await remoteConfig?.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(minutes: 1),
      minimumFetchInterval: const Duration(hours: 1),
    ));
  }

  static Map<String, dynamic> decodeJsonWithCompute(String rawJson) {
    return jsonDecode(rawJson);
  }

  Future<FullUnits> getUnits() async {
    try {
      await remoteConfig?.fetchAndActivate();
      var rs = remoteConfig?.getString('readingSettingsValues');
      try {
        return FullUnits(decodeJsonWithCompute(rs!));
      } catch (e, s) {
        print('error 3' + e.toString());
        return FullUnits({});
      }
    } catch (e) {
      print('error 4' + e.toString());
      return FullUnits({});
    }
  }
}

class FullUnits {
  List<Units> glucose = [];
  List<Units> pressure = [];
  List<Units> weight = [];
  List<Units> food = [];
  List<Units> height = [];

  FullUnits(Map<String, dynamic> data) {
    var dataIn = data['glucoseUnits'];
    glucose = [];
    if (dataIn != null) {
      for (var i = 0; i < (dataIn.length); i++) {
        print(dataIn[i]);
        glucose.add(Units(dataIn[i]));
      }
    }
    dataIn = data['pressureUnits'];
    pressure = [];
    if (dataIn != null) {
      for (var i = 0; i < (dataIn.length); i++) {
        pressure.add(Units(dataIn[i]));
      }
    }
    dataIn = data['food'];
    food = [];
    if (dataIn != null) {
      for (var i = 0; i < (dataIn.length); i++) {
        food.add(Units(dataIn[i]));
      }
    }
    dataIn = data['weight'];
    weight = [];
    if (dataIn != null) {
      for (var i = 0; i < (dataIn.length); i++) {
        weight.add(Units(dataIn[i]));
      }
    }
    dataIn = data['height'];
    height = [];
    if (dataIn != null) {
      for (var i = 0; i < (dataIn.length); i++) {
        height.add(Units(dataIn[i]));
      }
    }
  }
}
class Units {
  String unit = '';
  String description = '';
  Units(Map<String, dynamic> data) {
    this.unit = data['unit'] ?? '';
    this.description = data['description'] ?? '';
  }
}