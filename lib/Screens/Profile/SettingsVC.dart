import 'dart:async';

import 'package:diabetes/Models/UserLocal.dart';
import 'package:diabetes/Usables/RemoteConfigFirebase.dart';
import 'package:diabetes/Usables/Utility.dart';
import 'package:flutter/material.dart';


class SettingsVC extends StatefulWidget {
  const SettingsVC({super.key});
  @override
  State<SettingsVC> createState() => _SettingsVCState();
}

class _SettingsVCState extends State<SettingsVC> {
  late FullUnits totalUnits;
  @override
  void initState() {
    RemoteConfigFirebase().getUnits().then((value){
      totalUnits = value;
      setState(() {

      });
    });
  }


  @override
  Widget build(BuildContext context) {
    print(Utility().getUserData().pressureUnit.unit);
    print(totalUnits.pressure.map((Units dropdownvalue) {
      return dropdownvalue.unit;
    }).toList());
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text("Reading Settings")
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              //Gender Portion
              Padding(
                  padding: const EdgeInsets.only(
                      top: 0, bottom: 0, right: 20, left: 20),
                  child: SizedBox(
                    height: 80,
                    child: Row(children: [
                      Padding(
                          padding: const EdgeInsets.only(left: 0, right: 30),
                          child: Text('Glucose Unit: ',
                              style:
                              TextStyle(fontSize: 16, color: Colors.blue))),
                      Expanded(
                          child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.black38,
                                  ),
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                              child: Padding(
                                padding:
                                const EdgeInsets.only(left: 10, right: 10),
                                child: DropdownButton(
                                  value: Utility().getUserData().glucoseUnit.unit,
                                  icon: const Icon(Icons.keyboard_arrow_down),
                                  isExpanded: true,
                                  items:
                                  totalUnits.glucose.map((Units dropdownvalue) {
                                    return DropdownMenuItem(
                                      value: dropdownvalue.unit,
                                      child: Text(dropdownvalue.unit),
                                    );
                                  }).toList(),
                                  hint: Text('Glucose Unit'),
                                  onChanged: (value) {
                                    UserLocal currentUser = Utility().getUserData();
                                    currentUser.glucoseUnit = totalUnits.glucose.firstWhere((element) => element.unit == value);
                                    currentUser.updateData();
                                    Timer.periodic(const Duration(seconds: 1),
                                        (timer) async {
                                          timer.cancel();
                                          setState(() {
                                            initState();
                                          });
                                        });
                                  },
                                ),
                              )))
                    ]),
                  )),
              Padding(
                  padding: const EdgeInsets.only(
                      top: 0, bottom: 0, right: 20, left: 20),
                  child: SizedBox(
                    height: 80,
                    child: Row(children: [
                      Padding(
                          padding: const EdgeInsets.only(left: 0, right: 30),
                          child: Text('Pressure Unit: ',
                              style:
                              TextStyle(fontSize: 16, color: Colors.blue))),
                      Expanded(
                          child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.black38,
                                  ),
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                              child: Padding(
                                padding:
                                const EdgeInsets.only(left: 10, right: 10),
                                child: DropdownButton(
                                  value: Utility().getUserData().pressureUnit.unit,
                                  icon: const Icon(Icons.keyboard_arrow_down),
                                  isExpanded: true,
                                  items:
                                  totalUnits.pressure.map((Units dropdownvalue) {
                                    return DropdownMenuItem(
                                      value: dropdownvalue.unit,
                                      child: Text(dropdownvalue.unit),
                                    );
                                  }).toList(),
                                  hint: Text('Pressure Unit'),
                                  onChanged: (value) {
                                    UserLocal currentUser = Utility().getUserData();
                                    currentUser.pressureUnit = totalUnits.pressure.firstWhere((element) => element.unit == value);
                                    currentUser.updateData();
                                    Timer.periodic(const Duration(seconds: 1),
                                            (timer) async {
                                              timer.cancel();
                                          setState(() {
                                            initState();
                                          });
                                        });
                                  },
                                ),
                              )))
                    ]),
                  )),
              Padding(
                  padding: const EdgeInsets.only(
                      top: 0, bottom: 0, right: 20, left: 20),
                  child: SizedBox(
                    height: 80,
                    child: Row(children: [
                      Padding(
                          padding: const EdgeInsets.only(left: 0, right: 30),
                          child: Text('Food Unit: ',
                              style:
                              TextStyle(fontSize: 16, color: Colors.blue))),
                      Expanded(
                          child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.black38,
                                  ),
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                              child: Padding(
                                padding:
                                const EdgeInsets.only(left: 10, right: 10),
                                child: DropdownButton(
                                  value: Utility().getUserData().foodUnit.unit,
                                  icon: const Icon(Icons.keyboard_arrow_down),
                                  isExpanded: true,
                                  items:
                                  totalUnits.food.map((Units dropdownvalue) {
                                    return DropdownMenuItem(
                                      value: dropdownvalue.unit,
                                      child: Text(dropdownvalue.unit),
                                    );
                                  }).toList(),
                                  hint: Text('Glucose Unit'),
                                  onChanged: (value) {
                                    UserLocal currentUser = Utility().getUserData();
                                    currentUser.foodUnit = totalUnits.food.firstWhere((element) => element.unit == value);
                                    currentUser.updateData();
                                    Timer.periodic(const Duration(seconds: 1),
                                            (timer) async {
                                              timer.cancel();
                                      setState(() {
                                            initState();
                                          });
                                        });
                                  },
                                ),
                              )))
                    ]),
                  )),
              Padding(
                  padding: const EdgeInsets.only(
                      top: 0, bottom: 0, right: 20, left: 20),
                  child: SizedBox(
                    height: 80,
                    child: Row(children: [
                      Padding(
                          padding: const EdgeInsets.only(left: 0, right: 30),
                          child: Text('Weight Unit: ',
                              style:
                              TextStyle(fontSize: 16, color: Colors.blue))),
                      Expanded(
                          child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.black38,
                                  ),
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                              child: Padding(
                                padding:
                                const EdgeInsets.only(left: 10, right: 10),
                                child: DropdownButton(
                                  value: Utility().getUserData().weightUnit.unit,
                                  icon: const Icon(Icons.keyboard_arrow_down),
                                  isExpanded: true,
                                  items:
                                  totalUnits.weight.map((Units dropdownvalue) {
                                    return DropdownMenuItem(
                                      value: dropdownvalue.unit,
                                      child: Text(dropdownvalue.unit),
                                    );
                                  }).toList(),
                                  hint: Text('Weight Unit'),
                                  onChanged: (value) {
                                    UserLocal currentUser = Utility().getUserData();
                                    currentUser.weightUnit = totalUnits.weight.firstWhere((element) => element.unit == value);
                                    currentUser.updateData();
                                    Timer.periodic(const Duration(seconds: 1),
                                            (timer) async {
                                              timer.cancel();
                                      setState(() {
                                            initState();
                                          });
                                        });
                                  },
                                ),
                              )))
                    ]),
                  )),
              Padding(
                  padding: const EdgeInsets.only(
                      top: 0, bottom: 0, right: 20, left: 20),
                  child: SizedBox(
                    height: 80,
                    child: Row(children: [
                      Padding(
                          padding: const EdgeInsets.only(left: 0, right: 30),
                          child: Text('Height Unit: ',
                              style:
                              TextStyle(fontSize: 16, color: Colors.blue))),
                      Expanded(
                          child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.black38,
                                  ),
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                              child: Padding(
                                padding:
                                const EdgeInsets.only(left: 10, right: 10),
                                child: DropdownButton(
                                  value: Utility().getUserData().heightUnit.unit,
                                  icon: const Icon(Icons.keyboard_arrow_down),
                                  isExpanded: true,
                                  items:
                                  totalUnits.height.map((Units dropdownvalue) {
                                    return DropdownMenuItem(
                                      value: dropdownvalue.unit,
                                      child: Text(dropdownvalue.unit),
                                    );
                                  }).toList(),
                                  hint: Text('Height Unit'),
                                  onChanged: (value) {
                                    UserLocal currentUser = Utility().getUserData();
                                    currentUser.heightUnit = totalUnits.height.firstWhere((element) => element.unit == value);
                                    currentUser.updateData();
                                    Timer.periodic(const Duration(seconds: 1),
                                            (timer) async {
                                              timer.cancel();
                                      setState(() {
                                            initState();
                                          });
                                        });
                                  },
                                ),
                              )))
                    ]),
                  ))
            ],
          ),
        )
    );
  }
}