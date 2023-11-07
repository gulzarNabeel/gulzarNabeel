import 'package:diabetes/Screens/ProfileVC.dart';
import 'package:diabetes/Usables/AlertDialogLocal.dart';
import 'package:diabetes/Usables/Utility.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AccountVC extends StatefulWidget {
  const AccountVC({super.key, required this.onClose});

  final VoidCallback onClose;

  @override
  State<AccountVC> createState() => _AccountVCState();
}

enum OptionAccount {
  PersonalDetails,
  ReadingSettings,
  Reminders,
  Help,
  AboutUs,
  Logout,
  DeleteAccount
}

class PairTab<Text, Icon, OptionAccount> {
  final Text title;
  final Icon obj;
  final OptionAccount option;

  PairTab(this.title, this.obj, this.option);
}


class _AccountVCState extends State<AccountVC> {
  List<PairTab> arrayOptions = [PairTab(const Text('Personal Details',style: TextStyle(color: Colors.black87)),const  Icon(Icons.person_add_alt_1,color: Colors.black87), OptionAccount.PersonalDetails),
                                PairTab(const Text('Reading Settings',style: TextStyle(color: Colors.black87)),const Icon(Icons.settings,color: Colors.black87), OptionAccount.ReadingSettings),
                                PairTab(const Text('Reminders',style: TextStyle(color: Colors.black87)),const Icon(Icons.alarm_add,color: Colors.black87), OptionAccount.Reminders),
                                PairTab(const Text('Help',style: TextStyle(color: Colors.black87)),const Icon(Icons.help,color: Colors.black87), OptionAccount.Help),
                                PairTab(const Text('About Diab-Gulzar',style: TextStyle(color: Colors.black87)),const Icon(Icons.home_work,color: Colors.black87), OptionAccount.AboutUs),
                                PairTab(const Text('Logout',style: TextStyle(color: Colors.grey)), const Icon(Icons.logout,color: Colors.grey), OptionAccount.Logout),
                                PairTab(Text('Delete Account',style: TextStyle(color: Colors.red[300])), Icon(Icons.delete,color: Colors.red[300]), OptionAccount.DeleteAccount)];
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
    return GestureDetector(
        onTap: () {
          switch(arrayOptions[index - 1].option) {
            case OptionAccount.Logout:
              AlertDialogLocal("Logout", 'Are you sure to logout from account?', 'Yes', 'No', () async {
                await FirebaseAuth.instance.signOut().then((value) {
                  widget.onClose();
                });
              }, (){}, false, '', true).showAlert(context);
              break;
          }
        },
        child: Container(
          height: 80,
          child: Row(
            children: <Widget>[
              Container(margin: EdgeInsets.all(10), child: arrayOptions[index - 1].obj),
              Container(margin: EdgeInsets.all(10), child: arrayOptions[index - 1].title)
            ],
          ),
        )
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
