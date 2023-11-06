import 'package:diabetes/Screens/ProfileVC.dart';
import 'package:diabetes/Usables/Utility.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AccountVC extends StatefulWidget {
  const AccountVC({super.key, required this.onClose});

  final VoidCallback onClose;

  @override
  State<AccountVC> createState() => _AccountVCState();
}

class _AccountVCState extends State<AccountVC> {
  List<String> arrayOptions = ['Personal Details', 'Reading Settings', 'Reminders', 'Help', 'About Diab-Gulzar', 'Delete Account', 'Logout'];
  @override
  void initState() {}

  Widget listHeader(BuildContext context, int index) {
    return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProfileVC(
                    title: 'Profile',
                    onClose: () {
                      setState(() {
                        if (FirebaseAuth.instance.currentUser == null) {
                          widget.onClose();
                        }
                      });
                      initState();
                    },
                    Signup: false),
                fullscreenDialog: true),
          );
        },
        child: Container(
          color: Colors.blue,
          child: Row(
            children: [
              Container(
                margin: EdgeInsets.all(10),
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.all(Radius.circular(40)),
                ),
                child: ClipOval(
                  child: Utility().getUserData().profilePictureUrl.length > 0
                      ? Image.network(Utility().getUserData().profilePictureUrl)
                      : Image(image: AssetImage('Assets/appicon.png')),
                ),
              ),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 300,
                      child: Row(
                        children: [
                          Expanded(
                            child: Text('${Utility().getUserData().name}',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 22)), // default is 1
                          ),
                        ],
                      ),
                    ),
                    Text(Utility().getUserData().email,
                        style: const TextStyle(color: Colors.white)),
                    Text(
                        '${Utility().getUserData().countryCode} ${Utility().getUserData().phoneNumber}',
                        style: const TextStyle(color: Colors.white))
                  ],
                ),
              )
            ],
          ),
        ));
  }

  Widget listItem(BuildContext context, int index) {
    return Container(
      height: 80,
      child: Row(
        children: <Widget>[
          Container(margin: EdgeInsets.all(10), child: Text('${index}')),
          Container(
            height: 20,
            width: 1,
            color: Colors.blue,
          ),
          Container(margin: EdgeInsets.all(10), child: Text(arrayOptions[index - 1]))
        ],
      ),
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
            itemCount: arrayOptions.length + 1,
            itemBuilder: (BuildContext context, int index) {
              if (index == 0) {
                return listHeader(context, index);
              } else {
                return listItem(context, index);
              }
            }));
  }
}
