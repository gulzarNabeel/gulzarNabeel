import 'package:diabetes/Usables/CustomTextField.dart';
import 'package:flutter/material.dart';

class AlertDialogLocal extends StatelessWidget {

  //When creating please recheck 'context' if there is an error!

  String title;
  String content;
  String yes;
  String no;
  Function yesOnPressed;
  Function noOnPressed;
  bool textNeeded;
  bool noNeeded;
  String titleForTF;

  AlertDialogLocal(this.title, this.content, this.yes, this.no, this.yesOnPressed, this.noOnPressed, this.textNeeded, this.titleForTF, this.noNeeded);

  @override
  Widget build(BuildContext context) {
    CustomTextField textFieldIn = CustomTextField('OTP', TextInputType.number, true);
    Widget noButton = ElevatedButton(
      child: Text(no, style: TextStyle(color: Colors.red, fontSize: 25)),
      style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
      onPressed: () {
        if (textNeeded == true) {
          noOnPressed(textFieldIn.textFieldIn.controller?.text ?? '');
        }else{
          noOnPressed;
        }
        Navigator.pop(context);
      },
    );
    Widget yesButton = ElevatedButton(
      child: Text(yes, style: TextStyle(color: Colors.green, fontSize: 25)),
      style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
      onPressed: () {
        if (textNeeded == true) {
          yesOnPressed(textFieldIn.textFieldIn.controller?.text ?? '');
        }else{
          yesOnPressed;
        }
        Navigator.pop(context);
      },
    );
    List<Widget> actions = [];
    if (noNeeded == true) {
      actions.add(noButton);
    }
    actions.add(yesButton);
    List<Widget> elements = [Text(this.content + "\n")];
    if (textNeeded == true) {
      elements.add(Row(children: [textFieldIn]));
    }

    return AlertDialog(
      title: Text(this.title),
      content: SingleChildScrollView(
        child: ListBody(
          children:
          elements,
        ),
      ),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(15)),
      actions: actions
    );
  }

  showAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return this;
      },
    );
  }
}