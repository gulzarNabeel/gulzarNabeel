import 'package:shared_preferences/shared_preferences.dart';

class Utility {

  asyncFunc() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
  }
}