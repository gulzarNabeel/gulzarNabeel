import 'dart:async';

import 'package:diabetes/Models/Medicine.dart';
import 'package:diabetes/Screens/TabBar/Medicine/AddMedicineVC.dart';
import 'package:diabetes/Usables/Utility.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MedicineVC extends StatefulWidget {
  const MedicineVC({super.key});

  @override
  State<MedicineVC> createState() => _MedicineVCState();
}

class _MedicineVCState extends State<MedicineVC> {
  @override
  void initState() {
    Utility().fetchUserMedicineData();
    Timer.periodic(const Duration(seconds: 3), (timer) async {
      timer.cancel();
      setState(() {});
    });
  }

  Widget listItem(BuildContext context, int index) {
    int tempCount = index - 1;
    return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (context) => AddMedicineVC(
                    onClose: () {
                      initState();
                      print(' reload');
                    },
                    medicineIn: Utility().usersMedicines[tempCount])),
          );
        },
        child: Container(
            // height: 80,
            child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Row(
                      children: <Widget>[
                        Text('$index',
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.bold)),
                        SizedBox(width: 10),
                        Expanded(child: Text(
                            Utility().usersMedicines[tempCount].name +
                                ' (' +
                                Utility()
                                    .usersMedicines[tempCount]
                                    .dosageContent +
                                ')',
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),maxLines: 2))
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Text('     '),
                        Text('Dosage: ' +
                            Utility().usersMedicines[tempCount].unitMorning +
                            '-' +
                            Utility().usersMedicines[tempCount].unitAfterNoon +
                            '-' +
                            Utility().usersMedicines[tempCount].unitNight)
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Text('     '),
                        Text('Description: ' +
                            Utility().usersMedicines[tempCount].usedFor)
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Text('     '),
                        Text('Start Date: ' +
                            DateFormat('dd/MMM/yyyy').format(
                                Utility().usersMedicines[tempCount].startDate))
                      ],
                    )
                  ],
                ))));
  }

  Widget listAddItem(BuildContext context) {
    return Container(
        height: 60,
        child: Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
              height: 50,
              width: 100,
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(20)),
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (context) => AddMedicineVC(
                            onClose: () {
                              initState();
                              print(' reload');
                            },
                            medicineIn: Medicine(
                                '',
                                '',
                                '',
                                '',
                                '',
                                '',
                                '',
                                PeriodRepeat.None,
                                DateTime.now(),
                                DateTime.now(),
                                DateTime.now()))),
                  );
                },
                child: Text('Add',
                    style: TextStyle(color: Colors.white, fontSize: 20)),
              ),
            )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: null,
        body: ListView.builder(
            padding: EdgeInsets.all(0.0),
            shrinkWrap: false,
            itemCount: Utility().usersMedicines.length + 1,
            itemBuilder: (BuildContext context, int index) {
              if (index == 0) {
                return listAddItem(context);
              } else {
                return listItem(context, index);
              }
            }));
  }
}
