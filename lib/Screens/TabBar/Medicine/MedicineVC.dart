import 'dart:async';

import 'package:diabetes/Models/Medicine.dart';
import 'package:diabetes/Screens/TabBar/Medicine/AddMedicineVC.dart';
import 'package:diabetes/Usables/Utility.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class MedicineVC extends StatefulWidget {
  MedicineVC({super.key});
  _MedicineVCState mobileGraph = _MedicineVCState();
  @override
  State<MedicineVC> createState() => mobileGraph;

  initIn() {
    mobileGraph.initState();
  }
}

class _MedicineVCState extends State<MedicineVC> {
  @override
  void initState() {
      Utility().fetchUserMedicineData();
      Timer.periodic(const Duration(seconds: 3), (timer) async {
        timer.cancel();
        setState(() {
        });
      });
  }

  Widget listItem(BuildContext context, int index) {
    int tempCount = index + 1;
    return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (context) => AddMedicineVC(
                    onClose: () {
                      initState();
                    },
                    medicineIn: Utility().usersMedicines[index])),
          );
        },
        child: Container(
          // height: 80,
          child: Padding(padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Row(
                children: <Widget>[
                  Text('$tempCount', style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold)),
                  SizedBox(width: 10),
            Expanded(child: Text(Utility().usersMedicines[index].name + ' (' + Utility().usersMedicines[index].dosageContent + ')', style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold)))
                ],
              ),
              Row(
                children: <Widget>[
                  Text('     '),
                  Text('Dosage: ' + Utility().usersMedicines[index].unitMorning + '-' + Utility().usersMedicines[index].unitAfterNoon + '-' + Utility().usersMedicines[index].unitNight)
                ],
              ),
              Row(
                children: <Widget>[
                  Text('     '),
                  Text('Description: ' + Utility().usersMedicines[index].usedFor)
                ],
              ),
              Row(
                children: <Widget>[
                  Text('     '),
                  Text('Start Date: ' + DateFormat('dd/MMM/yyyy').format(Utility().usersMedicines[index].startDate))
                ],
              )
            ],
          ))
        ));
  }

  Widget listAddItem(BuildContext context) {
    return Container(
      // height: 80,
        child: Padding(
            padding: const EdgeInsets.only(
                left: 20, top: 0, right: 20, bottom: 40),
            child: Container(
              height: 50,
              width: 250,
              decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(20)),
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
                            medicineIn: Medicine('','', '', '', '', '', '', PeriodRepeat.None, DateTime.now(), DateTime.now(), DateTime.now()))),
                  );
                },
                child: Text('Add',
                    style: TextStyle(color: Colors.white, fontSize: 20)),
              ),
            ))
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: null,
        body: ListView.builder(
            padding: EdgeInsets.all(0.0),
            shrinkWrap: false,
            itemCount: Utility().usersMedicines.length,
            itemBuilder: (BuildContext context, int index) {
              return listItem(context, index);
            })
    );
  }
}