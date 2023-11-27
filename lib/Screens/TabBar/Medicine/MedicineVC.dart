import 'dart:async';

import 'package:diabetes/Usables/Utility.dart';
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
    if (Utility().usersMedicines.length <= 0) {
      Utility().fetchUserMedicineData();
      Timer.periodic(const Duration(seconds: 1), (timer) async {
        timer.cancel();
        setState(() {
          initState();
        });
      });
    }
  }

  Widget listItem(BuildContext context, int index) {
    return GestureDetector(
        onTap: () {

        },
        child: Container(
          height: 80,
          child: Column(
            children: [
              Row(
                children: <Widget>[
                  Text('$index'),
                  Text(Utility().usersMedicines[index].name)
                ],
              ),
              Row(
                children: <Widget>[
                  Text('    '),
                  Text('Dosage: ' + Utility().usersMedicines[index].unitMorning + '-' + Utility().usersMedicines[index].unitAfterNoon + '-' + Utility().usersMedicines[index].unitNight)
                ],
              ),
              Row(
                children: <Widget>[
                  Text('    '),
                  Text('Description: ' + Utility().usersMedicines[index].usedFor)
                ],
              ),
              Row(
                children: <Widget>[
                  Text('    '),
                  Text('Start Date: ' + DateFormat('dd/MMM/yyyy').format(Utility().usersMedicines[index].startDate))
                ],
              )
            ],
          )
        ));
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
              // Padding(
              //     padding: const EdgeInsets.only(
              //         top: 0, bottom: 0, right: 20, left: 20),
              //     child: SizedBox(
              //       height: 80,
              //       child: Row(children: [
              //         Padding(
              //             padding: const EdgeInsets.only(left: 0, right: 30),
              //             child: Text('Type of Diabetes: ',
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
              //                   child: DropdownButtonHideUnderline(child: DropdownButton(
              //                     value: Utility().getUserHealthData().type.name,
              //                     icon: const Icon(Icons.keyboard_arrow_down),
              //                     isExpanded: true,
              //                     items:
              //                     DiabetesType.values.map((DiabetesType dropdownvalue) {
              //                       return DropdownMenuItem(
              //                         value: dropdownvalue.name,
              //                         child: Text(dropdownvalue.name),
              //                       );
              //                     }).toList(),
              //                     hint: Text('Type of Diabetes'),
              //                     onChanged: (value) {
              //                       ProgressIndicatorLocal().showAlert(context);
              //                       HealthProfile currentUser = Utility().getUserHealthData();
              //                       currentUser.type = DiabetesType.values.firstWhere((element) => element.name == value);
              //                       if (currentUser.type == DiabetesType.None) {
              //                         currentUser.startedYearDiab = null;
              //                       }
              //                       currentUser.updateData();
              //                       Timer.periodic(const Duration(seconds: 1),
              //                               (timer) async {
              //                             timer.cancel();
              //                             ProgressIndicatorLocal().hideAlert(context);
              //                             setState(() {
              //                               initState();
              //                             });
              //                           });
              //                     },
              //                   )),
              //                 )))
              //       ]),
              //     )),
              //Date of Sugar
              // Padding(
              //   padding: const EdgeInsets.only(
              //       left: 20, top: 0, right: 20, bottom: 20),
              //   child: Row(children: <Widget>[
              //     Expanded(
              //         child: TextField(
              //           controller: diabController,
              //           readOnly: true,
              //           enabled: Utility().getUserHealthData().type != DiabetesType.None ? true : false,
              //           decoration: InputDecoration(labelText: 'Diabetes detected date',labelStyle: TextStyle(color: Utility().getUserHealthData().type != DiabetesType.None ? Colors.blue : Colors.grey)),
              //           onTap: () async {
              //             DateTime? pickedDate = await showDatePicker(
              //                 context: context,
              //                 initialDate: Utility().getUserHealthData().startedYearDiab != null ? Utility().getUserHealthData().startedYearDiab! : Utility().getUserData().dateOfBirth ?? DateTime.now(),
              //                 firstDate: Utility().getUserData().dateOfBirth ?? DateTime.now(),
              //                 lastDate: DateTime.now());
              //
              //             if (pickedDate != null) {
              //               HealthProfile currentUser = Utility().getUserHealthData();
              //               currentUser.startedYearDiab = pickedDate;
              //               currentUser.updateData();
              //               Timer.periodic(const Duration(seconds: 1),
              //                       (timer) async {
              //                     timer.cancel();
              //                     setState(() {
              //                       initState();
              //                     });
              //                   });
              //             }
              //           },
              //         ))
              //   ]),
              // ),
            ],

          ),
        )
    );
  }
}