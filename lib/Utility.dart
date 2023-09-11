import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Utility{

  static Utility? utility = null;
  TextField textFieldin = TextField();
  TextEditingController _editController = new TextEditingController();
  static Utility getInstance(){
    if(utility == null){
      utility = Utility();
    }
    return utility!;
  }

  showAlertDialog(BuildContext cont,String idVerification,String alertTitle, String alertMessage, String okButton, bool showCancel, bool textfieldShow){
    // set up the buttons
    Widget cancelButton = ElevatedButton(
      child: Text("Cancel",style: TextStyle(color: Colors.red, fontSize: 25)),
      onPressed:  () {
        Navigator.pop(cont);
      },
    );

    textFieldin = TextField(
      controller: _editController,
      maxLines: 1,
      autofocus: true,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: 'Enter your code',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),
    );
    Widget continueButton = ElevatedButton(
      child: Text(okButton,style: TextStyle(color: Colors.green, fontSize: 25)),
      onPressed:  () async{
        FirebaseAuth auth = FirebaseAuth.instance;
        print(idVerification);
        final credentials = PhoneAuthProvider.credential(verificationId: idVerification, smsCode: textFieldin.controller?.text ?? "");
        try {
          await auth.signInWithCredential(credentials);
          print("Signed iN");
          Navigator.pop(cont,textFieldin.controller?.text ?? "");
        }catch (error) {
          print(error);
          Navigator.pop(cont);
        }
      },
    );
    Widget title = Text(alertMessage);

    List<Widget> actions = [continueButton];
    if (showCancel == true) {
      actions = [cancelButton,continueButton];
    }

    List<Widget> elements = [title];
    if (textfieldShow == true) {
      elements = [title, textFieldin];
    }
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(alertTitle),
      content: SingleChildScrollView(
        child: ListBody(
          children: elements,
        ),
      ),
      actions: actions,
    );

    // show the dialog
    showDialog(
      context: cont,
      builder: (BuildContext context) {
        return alert;
      },
    );

  }
}