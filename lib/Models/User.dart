import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class User {
  final String name;
  final String email;
  final String countryCode;
  final String phoneNumber;
  final String profilePictureUrl;
  final DateTime creationDate;

  const User(this.name,
      this.email,
      this.countryCode,
      this.phoneNumber,
      this.profilePictureUrl,
      this.creationDate);

  factory User.fromDocument(Map<String,dynamic> document) {
    return User(
        document['name'],
        document['email'],
        document['countryCode'],
        document['phoneNumber'],
        document['profilePictureUrl'],
        document['creationDate'].length > 0 ? new DateFormat('yyyy-MM-dd – hh:mm:ss').parse(document['creationDate']) : DateTime.now()
    );
  }
}