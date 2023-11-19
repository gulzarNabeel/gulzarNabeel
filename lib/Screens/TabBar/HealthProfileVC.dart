import 'dart:async';

import 'package:diabetes/Models/HealthProfile.dart';
import 'package:diabetes/Usables/Utility.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class HealthProfileVC extends StatefulWidget {
  const HealthProfileVC({super.key});
  @override
  State<HealthProfileVC> createState() => _HealthProfileVCState();
}

class _HealthProfileVCState extends State<HealthProfileVC> {
  TextEditingController diabController = TextEditingController();
  TextEditingController bpController = TextEditingController();
  TextEditingController nephroController = TextEditingController();
  TextEditingController retinoController = TextEditingController();
  TextEditingController cardioController = TextEditingController();
  TextEditingController neuroController = TextEditingController();
  @override
  void initState() {
    diabController.text = Utility().getUserHealthData().startedYearDiab != null ? DateFormat('dd-MMM-yyyy').format(Utility().getUserHealthData().startedYearDiab!) : '';
    bpController.text = Utility().getUserHealthData().startedYearBP != null ? DateFormat('dd-MMM-yyyy').format(Utility().getUserHealthData().startedYearBP!) : '';
    nephroController.text = Utility().getUserHealthData().startedYearNephro != null ? DateFormat('dd-MMM-yyyy').format(Utility().getUserHealthData().startedYearNephro!) : '';
    retinoController.text = Utility().getUserHealthData().startedYearRetina != null ? DateFormat('dd-MMM-yyyy').format(Utility().getUserHealthData().startedYearRetina!) : '';
    cardioController.text = Utility().getUserHealthData().startedYearCardio != null ? DateFormat('dd-MMM-yyyy').format(Utility().getUserHealthData().startedYearCardio!) : '';
    neuroController.text = Utility().getUserHealthData().startedYearNeuro != null ? DateFormat('dd-MMM-yyyy').format(Utility().getUserHealthData().startedYearNeuro!) : '';
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
      appBar: null,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            //Type of diabetes Portion
            Padding(
                padding: const EdgeInsets.only(
                    top: 0, bottom: 0, right: 20, left: 20),
                child: SizedBox(
                  height: 80,
                  child: Row(children: [
                    Padding(
                        padding: const EdgeInsets.only(left: 0, right: 30),
                        child: Text('Type of Diabetes: ',
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
                                value: Utility().getUserHealthData().type.name,
                                icon: const Icon(Icons.keyboard_arrow_down),
                                isExpanded: true,
                                items:
                                DiabetesType.values.map((DiabetesType dropdownvalue) {
                                  return DropdownMenuItem(
                                    value: dropdownvalue.name,
                                    child: Text(dropdownvalue.name),
                                  );
                                }).toList(),
                                hint: Text('Type of Diabetes'),
                                onChanged: (value) {
                                  HealthProfile currentUser = Utility().getUserHealthData();
                                  currentUser.type = DiabetesType.values.firstWhere((element) => element.name == value);
                                  if (currentUser.type == DiabetesType.None) {
                                    currentUser.startedYearDiab = null;
                                  }
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
            //Date of Sugar
            Padding(
              padding: const EdgeInsets.only(
                  left: 20, top: 0, right: 20, bottom: 20),
              child: Row(children: <Widget>[
                Expanded(
                    child: TextField(
                      controller: diabController,
                      readOnly: true,
                      enabled: Utility().getUserHealthData().type != DiabetesType.None ? true : false,
                      decoration: InputDecoration(labelText: 'Diabetes detected date'),
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: Utility().getUserHealthData().startedYearDiab != null ? Utility().getUserHealthData().startedYearDiab! : Utility().getUserData().dateOfBirth ?? DateTime.now(),
                            firstDate: Utility().getUserData().dateOfBirth ?? DateTime.now(),
                            lastDate: DateTime.now());

                        if (pickedDate != null) {
                          HealthProfile currentUser = Utility().getUserHealthData();
                          currentUser.startedYearDiab = pickedDate;
                          currentUser.updateData();
                          Timer.periodic(const Duration(seconds: 1),
                                  (timer) async {
                                timer.cancel();
                                setState(() {
                                  initState();
                                });
                              });
                        }
                      },
                    ))
              ]),
            ),
            //Hypertension Portion
            Padding(
                padding: const EdgeInsets.only(
                    top: 0, bottom: 0, right: 20, left: 20),
                child: SizedBox(
                  height: 80,
                  child: Row(children: [
                    Padding(
                        padding: const EdgeInsets.only(left: 0, right: 30),
                        child: Text('Hypertension: ',
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
                                value: Utility().getUserHealthData().hyperTension.toString(),
                                icon: const Icon(Icons.keyboard_arrow_down),
                                isExpanded: true,
                                items: [true,false].map((bool dropdownvalue) {
                                  return DropdownMenuItem(
                                    value: dropdownvalue.toString(),
                                    child: Text(dropdownvalue.toString()),
                                  );
                                }).toList(),
                                hint: Text('Hypertension'),
                                onChanged: (value) {
                                  String value2 = (value as String) ?? '';
                                  HealthProfile currentUser = Utility().getUserHealthData();
                                  currentUser.hyperTension = value2.parseBool();
                                  if (currentUser.hyperTension == false) {
                                    currentUser.startedYearBP = null;
                                  }
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
            //Date of Hypertension
            Padding(
              padding: const EdgeInsets.only(
                  left: 20, top: 0, right: 20, bottom: 20),
              child: Row(children: <Widget>[
                Expanded(
                    child: TextField(
                      controller: bpController,
                      readOnly: true,
                      enabled: Utility().getUserHealthData().hyperTension,
                      decoration: InputDecoration(labelText: 'Hypertension detected date'),
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: Utility().getUserHealthData().startedYearBP != null ? Utility().getUserHealthData().startedYearBP! : Utility().getUserData().dateOfBirth ?? DateTime.now(),
                            firstDate: Utility().getUserData().dateOfBirth ?? DateTime.now(),
                            lastDate: DateTime.now());

                        if (pickedDate != null) {
                          HealthProfile currentUser = Utility().getUserHealthData();
                          currentUser.startedYearBP = pickedDate;
                          currentUser.updateData();
                          Timer.periodic(const Duration(seconds: 1),
                                  (timer) async {
                                timer.cancel();
                                setState(() {
                                  initState();
                                });
                              });
                        }
                      },
                    ))
              ]),
            ),
            //Nephropathy Portion
            Padding(
                padding: const EdgeInsets.only(
                    top: 0, bottom: 0, right: 20, left: 20),
                child: SizedBox(
                  height: 80,
                  child: Row(children: [
                    Padding(
                        padding: const EdgeInsets.only(left: 0, right: 30),
                        child: Text('Nephropathy: ',
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
                                value: Utility().getUserHealthData().nephroPathy.toString(),
                                icon: const Icon(Icons.keyboard_arrow_down),
                                isExpanded: true,
                                items: [true,false].map((bool dropdownvalue) {
                                  return DropdownMenuItem(
                                    value: dropdownvalue.toString(),
                                    child: Text(dropdownvalue.toString()),
                                  );
                                }).toList(),
                                hint: Text('Nephropathy'),
                                onChanged: (value) {
                                  String value2 = (value as String) ?? '';
                                  HealthProfile currentUser = Utility().getUserHealthData();
                                  currentUser.nephroPathy = value2.parseBool();
                                  if (currentUser.nephroPathy == false) {
                                    currentUser.startedYearNephro = null;
                                  }
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
            //Date of Nephropathy detected
            Padding(
              padding: const EdgeInsets.only(
                  left: 20, top: 0, right: 20, bottom: 20),
              child: Row(children: <Widget>[
                Expanded(
                    child: TextField(
                      controller: nephroController,
                      readOnly: true,
                      enabled: Utility().getUserHealthData().nephroPathy,
                      decoration: InputDecoration(labelText: 'Nephropathy detected date'),
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: Utility().getUserHealthData().startedYearNephro != null ? Utility().getUserHealthData().startedYearNephro! : Utility().getUserData().dateOfBirth ?? DateTime.now(),
                            firstDate: Utility().getUserData().dateOfBirth ?? DateTime.now(),
                            lastDate: DateTime.now());

                        if (pickedDate != null) {
                          HealthProfile currentUser = Utility().getUserHealthData();
                          currentUser.startedYearNephro = pickedDate;
                          currentUser.updateData();
                          Timer.periodic(const Duration(seconds: 1),
                                  (timer) async {
                                timer.cancel();
                                setState(() {
                                  initState();
                                });
                              });
                        }
                      },
                    ))
              ]),
            ),
            //Retinopathy Portion
            Padding(
                padding: const EdgeInsets.only(
                    top: 0, bottom: 0, right: 20, left: 20),
                child: SizedBox(
                  height: 80,
                  child: Row(children: [
                    Padding(
                        padding: const EdgeInsets.only(left: 0, right: 30),
                        child: Text('Retinopathy: ',
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
                                value: Utility().getUserHealthData().retinopthy.toString(),
                                icon: const Icon(Icons.keyboard_arrow_down),
                                isExpanded: true,
                                items: [true,false].map((bool dropdownvalue) {
                                  return DropdownMenuItem(
                                    value: dropdownvalue.toString(),
                                    child: Text(dropdownvalue.toString()),
                                  );
                                }).toList(),
                                hint: Text('Retinopathy'),
                                onChanged: (value) {
                                  String value2 = (value as String) ?? '';
                                  HealthProfile currentUser = Utility().getUserHealthData();
                                  currentUser.retinopthy = value2.parseBool();
                                  if (currentUser.retinopthy == false) {
                                    currentUser.startedYearRetina = null;
                                  }
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
            //Date of Retinopathy detected
            Padding(
              padding: const EdgeInsets.only(
                  left: 20, top: 0, right: 20, bottom: 20),
              child: Row(children: <Widget>[
                Expanded(
                    child: TextField(
                      controller: retinoController,
                      readOnly: true,
                      enabled: Utility().getUserHealthData().retinopthy,
                      decoration: InputDecoration(labelText: 'Retinopathy detected date'),
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: Utility().getUserHealthData().startedYearRetina != null ? Utility().getUserHealthData().startedYearRetina! : Utility().getUserData().dateOfBirth ?? DateTime.now(),
                            firstDate: Utility().getUserData().dateOfBirth ?? DateTime.now(),
                            lastDate: DateTime.now());

                        if (pickedDate != null) {
                          HealthProfile currentUser = Utility().getUserHealthData();
                          currentUser.startedYearRetina = pickedDate;
                          currentUser.updateData();
                          Timer.periodic(const Duration(seconds: 1),
                                  (timer) async {
                                timer.cancel();
                                setState(() {
                                  initState();
                                });
                              });
                        }
                      },
                    ))
              ]),
            ),
            //Cardiopathy Portion
            Padding(
                padding: const EdgeInsets.only(
                    top: 0, bottom: 0, right: 20, left: 20),
                child: SizedBox(
                  height: 80,
                  child: Row(children: [
                    Padding(
                        padding: const EdgeInsets.only(left: 0, right: 30),
                        child: Text('Cardiopathy: ',
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
                                value: Utility().getUserHealthData().cardioPathy.toString(),
                                icon: const Icon(Icons.keyboard_arrow_down),
                                isExpanded: true,
                                items: [true,false].map((bool dropdownvalue) {
                                  return DropdownMenuItem(
                                    value: dropdownvalue.toString(),
                                    child: Text(dropdownvalue.toString()),
                                  );
                                }).toList(),
                                hint: Text('Cardiopathy'),
                                onChanged: (value) {
                                  String value2 = (value as String) ?? '';
                                  HealthProfile currentUser = Utility().getUserHealthData();
                                  currentUser.cardioPathy = value2.parseBool();
                                  if (currentUser.cardioPathy == false) {
                                    currentUser.startedYearCardio = null;
                                  }
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
            //Date of Cardiopathy detected
            Padding(
              padding: const EdgeInsets.only(
                  left: 20, top: 0, right: 20, bottom: 20),
              child: Row(children: <Widget>[
                Expanded(
                    child: TextField(
                      controller: cardioController,
                      readOnly: true,
                      enabled: Utility().getUserHealthData().cardioPathy,
                      decoration: InputDecoration(labelText: 'Cardiopathy detected date'),
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: Utility().getUserHealthData().startedYearCardio != null ? Utility().getUserHealthData().startedYearCardio! : Utility().getUserData().dateOfBirth ?? DateTime.now(),
                            firstDate: Utility().getUserData().dateOfBirth ?? DateTime.now(),
                            lastDate: DateTime.now());

                        if (pickedDate != null) {
                          HealthProfile currentUser = Utility().getUserHealthData();
                          currentUser.startedYearCardio = pickedDate;
                          currentUser.updateData();
                          Timer.periodic(const Duration(seconds: 1),
                                  (timer) async {
                                timer.cancel();
                                setState(() {
                                  initState();
                                });
                              });
                        }
                      },
                    ))
              ]),
            ),
            //Neuropathy Portion
            Padding(
                padding: const EdgeInsets.only(
                    top: 0, bottom: 0, right: 20, left: 20),
                child: SizedBox(
                  height: 80,
                  child: Row(children: [
                    Padding(
                        padding: const EdgeInsets.only(left: 0, right: 30),
                        child: Text('Neuropathy: ',
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
                                value: Utility().getUserHealthData().neuropathy.toString(),
                                icon: const Icon(Icons.keyboard_arrow_down),
                                isExpanded: true,
                                items: [true,false].map((bool dropdownvalue) {
                                  return DropdownMenuItem(
                                    value: dropdownvalue.toString(),
                                    child: Text(dropdownvalue.toString()),
                                  );
                                }).toList(),
                                hint: Text('Neuropathy'),
                                onChanged: (value) {
                                  String value2 = (value as String) ?? '';
                                  HealthProfile currentUser = Utility().getUserHealthData();
                                  currentUser.neuropathy = value2.parseBool();
                                  if (currentUser.neuropathy == false) {
                                    currentUser.startedYearNeuro = null;
                                  }
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
            //Date of Neuropathy detected
            Padding(
              padding: const EdgeInsets.only(
                  left: 20, top: 0, right: 20, bottom: 20),
              child: Row(children: <Widget>[
                Expanded(
                    child: TextField(
                      controller: neuroController,
                      readOnly: true,
                      enabled: Utility().getUserHealthData().neuropathy,
                      decoration: InputDecoration(labelText: 'Neuropathy detected date'),
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: Utility().getUserHealthData().startedYearNeuro != null ? Utility().getUserHealthData().startedYearNeuro! : Utility().getUserData().dateOfBirth ?? DateTime.now(),
                            firstDate: Utility().getUserData().dateOfBirth ?? DateTime.now(),
                            lastDate: DateTime.now());

                        if (pickedDate != null) {
                          HealthProfile currentUser = Utility().getUserHealthData();
                          currentUser.startedYearNeuro = pickedDate;
                          currentUser.updateData();
                          Timer.periodic(const Duration(seconds: 1),
                                  (timer) async {
                                timer.cancel();
                                setState(() {
                                  initState();
                                });
                              });
                        }
                      },
                    ))
              ]),
            ),
          ],
        ),
      ),
    );
  }
}