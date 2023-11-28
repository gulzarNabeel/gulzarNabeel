import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diabetes/Usables/Utility.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

enum PeriodRepeat {
  None,Daily,Weekly,Monthly,Yearly
}

class Medicine {
  String id = '';
  String name = '';
  String dosageContent = '';
  String usedFor = '';
  String unitMorning = '';
  String unitAfterNoon = '';
  String unitNight = '';
  DateTime startDate = DateTime.now();
  DateTime createdDate = DateTime.now();
  DateTime updatedDate = DateTime.now();
  PeriodRepeat repeat = PeriodRepeat.None;



  Medicine(this.id,this.name,this.dosageContent,this.usedFor,this.unitMorning,this.unitAfterNoon,this.unitNight,this.repeat,this.startDate,this.createdDate,this.updatedDate);


  addData() async {
    CollectionReference users = FirebaseFirestore.instance.collection('UsersMedicine');
    FirebaseAuth auth = FirebaseAuth.instance;
    String formattedstartDate = DateFormat('yyyy-MM-dd').format(startDate!);
    String formattedcreatedDate = DateFormat('yyyy-MM-dd').format(createdDate!);
    String formatedUpdatedDate = DateFormat('yyyy-MM-dd').format(updatedDate!);

    users.add({
      'name': name,
      'dosageContent': dosageContent,
      'usedFor': usedFor,
      'unitMorning': unitMorning,
      'unitAfterNoon': unitAfterNoon,
      'unitNight': unitNight,
      'repeat' : repeat.name,
      'startDate' : formattedstartDate,
      'createdDate' : formattedcreatedDate,
      'updatedDate' : formatedUpdatedDate,
      'user' : auth.currentUser?.uid ?? ''
    }).then((_) {
      Utility().fetchUserMedicineData();
    });
  }

  updateData() async {
    CollectionReference users = FirebaseFirestore.instance.collection('UsersMedicine');
    FirebaseAuth auth = FirebaseAuth.instance;
    String formattedstartDate = DateFormat('yyyy-MM-dd').format(startDate!);
    String formattedcreatedDate = DateFormat('yyyy-MM-dd').format(createdDate!);
    String formatedUpdatedDate = DateFormat('yyyy-MM-dd').format(updatedDate!);

    users.doc(id).set({
      'name': name,
      'dosageContent': dosageContent,
      'usedFor': usedFor,
      'unitMorning': unitMorning,
      'unitAfterNoon': unitAfterNoon,
      'unitNight': unitNight,
      'repeat' : repeat.name,
      'startDate' : formattedstartDate,
      'createdDate' : formattedcreatedDate,
      'updatedDate' : formatedUpdatedDate,
      'user' : auth.currentUser?.uid ?? ''
    }).then((_) {
      Utility().fetchUserMedicineData();
    });
  }
}