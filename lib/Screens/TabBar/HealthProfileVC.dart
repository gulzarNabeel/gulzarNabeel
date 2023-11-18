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
  TextEditingController diabController = new TextEditingController();
  @override
  void initState() {
    diabController.text = Utility().getUserHealthData().startedYearDiab != null ?DateFormat('dd-MMM-yyyy').format(Utility().getUserHealthData().startedYearDiab!) : '--';
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
                      decoration: InputDecoration(labelText: 'Diabetes detected date'),
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: Utility().getUserData().dateOfBirth ?? DateTime.now(),
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
            // //Gender Portion
            // Padding(
            //     padding: const EdgeInsets.only(
            //         top: 0, bottom: 0, right: 20, left: 20),
            //     child: SizedBox(
            //       height: 80,
            //       child: Row(children: [
            //         Padding(
            //             padding: const EdgeInsets.only(left: 0, right: 30),
            //             child: Text('Gender: ',
            //                 style:
            //                 TextStyle(fontSize: 16, color: Colors.blue))),
            //         Expanded(
            //             child: Container(
            //                 decoration: BoxDecoration(
            //                     border: Border.all(
            //                       color: Colors.black38,
            //                     ),
            //                     borderRadius:
            //                     BorderRadius.all(Radius.circular(10))),
            //                 child: Padding(
            //                   padding:
            //                   const EdgeInsets.only(left: 10, right: 10),
            //                   child: DropdownButton(
            //                     value: CurrentUserGender.toString(),
            //                     icon: const Icon(Icons.keyboard_arrow_down),
            //                     isExpanded: true,
            //                     items:
            //                     Gender.values.map((Gender dropdownvalue) {
            //                       return DropdownMenuItem(
            //                         value: dropdownvalue.toString(),
            //                         child: Text(dropdownvalue.name),
            //                       );
            //                     }).toList(),
            //                     hint: Text('Gender'),
            //                     onChanged: (value) {
            //                       CurrentUserGender = Gender.values.firstWhere(
            //                               (element) => element.toString() == value);
            //                       setState(() {
            //                         initState();
            //                       });
            //                     },
            //                   ),
            //                 )))
            //       ]),
            //     )),
          ],
        ),
      ),
    );
  }
}