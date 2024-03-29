import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_calling_code_picker/picker.dart';
import 'package:diabetes/Models/HealthProfile.dart';
import 'package:diabetes/Models/Medicine.dart';
import 'package:diabetes/Models/UserLocal.dart';
import 'package:diabetes/Screens/TabBar/TabBarVC.dart';
import 'package:diabetes/Usables/AlertDialogLocal.dart';
import 'package:diabetes/Usables/CustomTextField.dart';
import 'package:diabetes/Usables/DisplayPictureScreen.dart';
import 'package:diabetes/Usables/ProgressIndicatorLocal.dart';
import 'package:diabetes/Usables/RemoteConfigFirebase.dart';
import 'package:diabetes/Usables/Utility.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'dart:io';

class AddMedicineVC extends StatefulWidget {
  final VoidCallback onClose;
  var medicineIn = Medicine('','', '', '', '', '', '', PeriodRepeat.None, DateTime.now(), DateTime.now(), DateTime.now());
  AddMedicineVC({super.key, required this.onClose, required this.medicineIn});

  @override
  State<AddMedicineVC> createState() => _AddMedicineVCState();
}

class _AddMedicineVCState extends State<AddMedicineVC> {
  CustomTextField textFieldName =
      CustomTextField('Medicine Name', TextInputType.name, true);
  TextField textFieldUsedFor = const TextField();
  TextField textFieldContent = const TextField();
  CustomTextField textFieldMorning = CustomTextField('Morning', TextInputType.number, true);
  CustomTextField textFieldAfterNoon = CustomTextField('After Noon', TextInputType.number, true);
  CustomTextField textFieldNight = CustomTextField('Night', TextInputType.number, true);
  TextEditingController dateController = TextEditingController();
  TextEditingController usedforController = TextEditingController();
  TextEditingController contentsController = TextEditingController();

  @override
  void initState() {
    textFieldName.editController.text = widget.medicineIn.name;
    contentsController.text = widget.medicineIn.dosageContent;
    usedforController.text = widget.medicineIn.usedFor;
    textFieldMorning.editController.text = widget.medicineIn.unitMorning;
    textFieldAfterNoon.editController.text = widget.medicineIn.unitAfterNoon;
    textFieldNight.editController.text = widget.medicineIn.unitNight;
    dateController.text = DateFormat('dd-MMM-yyyy').format(widget.medicineIn.startDate);
    textFieldUsedFor = TextField(
      maxLines: null,
      maxLengthEnforcement: MaxLengthEnforcement.truncateAfterCompositionEnds,
      keyboardType: TextInputType.multiline,
      decoration: const InputDecoration(labelText: 'Used For',labelStyle: TextStyle(color: Colors.blue)),
      controller: usedforController
    );
    textFieldContent = TextField(
        maxLines: null,
        maxLengthEnforcement: MaxLengthEnforcement.truncateAfterCompositionEnds,
        keyboardType: TextInputType.multiline,
        decoration: const InputDecoration(labelText: 'Contents',labelStyle: TextStyle(color: Colors.blue)),
        controller: contentsController
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text("Add Your Medicine")),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            //Name Text Portion
            Padding(
              padding: const EdgeInsets.only(
                  left: 20, top: 0, right: 20, bottom: 20),
              child: Row(children: <Widget>[
                textFieldName,
              ]),
            ),
            //Content Text Portion
            Padding(
              padding: const EdgeInsets.only(
                  left: 20, top: 0, right: 20, bottom: 20),
              child: Row(children: <Widget>[
                Expanded(child: textFieldContent),
              ]),
            ),
            //Used For Text Portion
            Padding(
              padding: const EdgeInsets.only(
                  left: 20, top: 0, right: 20, bottom: 20),
              child: Row(children: <Widget>[
                Expanded(child: textFieldUsedFor),
              ]),
            ),
            //Date of Start
            Padding(
              padding: const EdgeInsets.only(
                  left: 20, top: 0, right: 20, bottom: 20),
              child: Row(children: <Widget>[
                Expanded(
                    child: TextField(
                  controller: dateController,
                  readOnly: true,
                  decoration: InputDecoration(labelText: 'Date of start',labelStyle: TextStyle(color: Colors.blue)),
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: widget.medicineIn.startDate ?? DateTime.now(),
                        firstDate: Utility().getUserData().dateOfBirth ??
                            DateTime(1970),
                        lastDate: DateTime.now());

                    if (pickedDate != null) {
                      widget.medicineIn.startDate = pickedDate;
                      dateController.text =
                          DateFormat('dd-MMM-yyyy').format(widget.medicineIn.startDate);
                    }
                  },
                ))
              ]),
            ),
            //Units for time Text Portion
            Padding(
              padding: const EdgeInsets.only(
                  left: 20, top: 0, right: 20, bottom: 20),
              child: Row(children: <Widget>[
                textFieldMorning,SizedBox(width: 20),textFieldAfterNoon,SizedBox(width: 20),textFieldNight
              ],
              ),
            ),
            //Repeat Portion
            Padding(
                padding: const EdgeInsets.only(
                    top: 0, bottom: 0, right: 20, left: 20),
                child: SizedBox(
                  height: 80,
                  child: Row(children: [
                    Padding(
                        padding: const EdgeInsets.only(left: 0, right: 30),
                        child: Text('Repeat: ',
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
                              child: DropdownButtonHideUnderline(
                                  child: DropdownButton(
                                value: widget.medicineIn.repeat.toString(),
                                icon: const Icon(Icons.keyboard_arrow_down),
                                isExpanded: true,
                                items:
                                PeriodRepeat.values.map((PeriodRepeat dropdownvalue) {
                                  return DropdownMenuItem(
                                    value: dropdownvalue.toString(),
                                    child: Text(dropdownvalue.name),
                                  );
                                }).toList(),
                                hint: Text('Repeat'),
                                onChanged: (value) {
                                  widget.medicineIn.repeat = PeriodRepeat.values.firstWhere(
                                      (element) => element.toString() == value);
                                  widget.medicineIn.name = textFieldName.editController.text;
                                  widget.medicineIn.usedFor = textFieldUsedFor.controller?.text ?? '';
                                  widget.medicineIn.dosageContent = textFieldContent.controller?.text ?? '';
                                  widget.medicineIn.unitMorning = textFieldMorning.editController.text;
                                  widget.medicineIn.unitAfterNoon = textFieldAfterNoon.editController.text;
                                  widget.medicineIn.unitNight = textFieldNight.editController.text;
                                  setState(() {
                                    initState();
                                  });
                                },
                              )),
                            )))
                  ]),
                )),
            //Add Button
            Padding(
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
                      updatedataIn();
                    },
                    child: Text(widget.medicineIn.id.length > 0 ? 'Update' : 'Add',
                        style: TextStyle(color: Colors.white, fontSize: 20)),
                  ),
                ))
          ],
        ),
      ),
    );
  }

  updatedataIn() {
    ProgressIndicatorLocal().showAlert(context);
    widget.medicineIn.name = textFieldName.editController.text;
    widget.medicineIn.usedFor = textFieldUsedFor.controller?.text ?? '';
    widget.medicineIn.dosageContent = textFieldContent.controller?.text ?? '';
    widget.medicineIn.unitMorning = textFieldMorning.editController.text;
    widget.medicineIn.unitAfterNoon = textFieldAfterNoon.editController.text;
    widget.medicineIn.unitNight = textFieldNight.editController.text;
    if (widget.medicineIn.id.length > 0) {
        widget.medicineIn.updatedDate = DateTime.now();
        widget.medicineIn.updateData();
    }else{
      widget.medicineIn.createdDate = DateTime.now();
      widget.medicineIn.addData();
    }
    Timer.periodic(const Duration(seconds: 3), (timer) async {
      timer.cancel();
        widget.onClose();
      ProgressIndicatorLocal().hideAlert(context);
        Navigator.pop(context);
      });
  }
}