import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diabetes/Usables/Utility.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
enum Gender {
  Male,
  Female,
  Other
}

class UserLocal {
  String name;
  String email;
  String countryCode;
  String phoneNumber;
  String profilePictureUrl;
  DateTime creationDate;
  DateTime? dateOfBirth;
  Gender? gender;


  UserLocal(this.name,
      this.email,
      this.countryCode,
      this.phoneNumber,
      this.profilePictureUrl,
      this.creationDate,this.dateOfBirth,this.gender);


  updateData() async {
    CollectionReference users = FirebaseFirestore.instance.collection('Users');
    FirebaseAuth auth = FirebaseAuth.instance;
    DateTime now = auth.currentUser?.metadata?.creationTime ?? DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd – hh:mm:ss').format(now);
    String formattedDateDOB = dateOfBirth == null ? '' : DateFormat('yyyy-MM-dd – hh:mm:ss').format(dateOfBirth!);
    users.doc(auth.currentUser?.uid).set({
      'name': name,
      'email': email,
      'countryCode': countryCode,
      'phoneNumber': phoneNumber,
      'profilePictureUrl': profilePictureUrl,
      'creationDate': formattedDate,
      'dateOfBirth' : formattedDateDOB,
      'gender' : gender == null ? '' : gender!.name
    }).then((_) {
      Map<String, dynamic> document = {
        'name': name,
        'email': email,
        'countryCode': countryCode,
        'phoneNumber': phoneNumber,
        'profilePictureUrl': profilePictureUrl,
        'creationDate': formattedDate,
        'dateOfBirth' : formattedDateDOB,
        'gender' : gender == null ? '' : gender!.name
      };
      Utility().saveUserData(document);
    });
  }
}