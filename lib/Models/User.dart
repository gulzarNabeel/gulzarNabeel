import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diabetes/Usables/Utility.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import '../Models/User.dart';

class User {
  String name;
  String email;
  String countryCode;
  String phoneNumber;
  String profilePictureUrl;
  DateTime creationDate;

  User(this.name,
      this.email,
      this.countryCode,
      this.phoneNumber,
      this.profilePictureUrl,
      this.creationDate);


  updateData() async {
    CollectionReference users = FirebaseFirestore.instance.collection('Users');
    FirebaseAuth auth = FirebaseAuth.instance;
    DateTime now = auth.currentUser?.metadata?.creationTime ?? DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd – hh:mm:ss').format(now);
    users.doc(auth.currentUser?.uid).set({
      'name': name,
      'email': email,
      'countryCode': countryCode,
      'phoneNumber': phoneNumber,
      'profilePictureUrl': profilePictureUrl,
      'creationDate': formattedDate
    }).then((_) {
      print("User Updated Successfully");
      Map<String, dynamic> document = {
        'name': name,
        'email': email,
        'countryCode': countryCode,
        'phoneNumber': phoneNumber,
        'profilePictureUrl': profilePictureUrl,
        'creationDate': formattedDate
      };
      Utility().saveUserData(document);
    });
  }
}