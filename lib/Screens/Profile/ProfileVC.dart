import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_calling_code_picker/picker.dart';
import 'package:diabetes/Models/UserLocal.dart';
import 'package:diabetes/Screens/TabBar/TabBarVC.dart';
import 'package:diabetes/Usables/AlertDialogLocal.dart';
import 'package:diabetes/Usables/DisplayPictureScreen.dart';
import 'package:diabetes/Usables/ProgressIndicatorLocal.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import '../../Usables/AuthHandler.dart';
import '../../Usables/CustomTextField.dart';
import '../../Usables/Utility.dart';

class ProfileVC extends StatefulWidget {
  final VoidCallback onClose;
  final bool Signup;

  const ProfileVC(
      {super.key,
      required this.title,
      required this.Signup,
      required this.onClose});

  final String title;

  @override
  State<ProfileVC> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfileVC> {
  Country? _selectedCountry;
  Text? _countryText =
      const Text("", style: TextStyle(color: Colors.blue, fontSize: 20));
  CustomTextField textFieldPhone =
      CustomTextField('Phone Number', TextInputType.phone, false);
  CustomTextField textFieldName =
      CustomTextField('Name', TextInputType.name, true);
  CustomTextField textFieldEmail =
      CustomTextField('Email', TextInputType.emailAddress, true);
  File? imageFile;
  late Gender CurrentUserGender = Utility().getUserData().gender ?? Gender.Male;
  DateTime? dob = Utility().getUserData().dateOfBirth;
  TextEditingController dobController = new TextEditingController();

  @override
  void initState() {
    if ((FirebaseAuth.instance.currentUser?.emailVerified ?? false) == false) {
      FirebaseAuth.instance.currentUser?.reload().then((value) {
        initState();
      });
    }
    if (_selectedCountry == null) {
      initCountry();
    }
    if (dob != null) {
      dobController.text = DateFormat('dd-MMM-yyyy').format(dob!);
    }
  }

  void initCountry() async {
    var country = await getDefaultCountry(context);
    List<Country> countries = await getCountries(context);
    setState(() {
      if (_selectedCountry == null) {
        List<Country> filter = countries.where((element) {
          return element.callingCode == Utility().getUserData().countryCode;
        }).toList();
        if (filter.length > 0) {
          country = filter[0];
        }
        _selectedCountry = country;
        if (Utility().getUserData().countryCode ==
            _selectedCountry!.callingCode) {
          _countryText = Text(_selectedCountry?.callingCode ?? "",
              style: const TextStyle(color: Colors.blue, fontSize: 20));
        } else {
          _countryText = Text(Utility().getUserData().countryCode,
              style: const TextStyle(color: Colors.blue, fontSize: 20));
        }
        var currentUser = Utility().getUserData();
        if (currentUser.email !=  (FirebaseAuth.instance.currentUser?.email ?? '')) {
          if ((FirebaseAuth.instance.currentUser?.email ?? '').length > 0) {
            currentUser.email = FirebaseAuth.instance.currentUser?.email ?? '';
          }
        }
        if (currentUser.name !=  (FirebaseAuth.instance.currentUser?.displayName ?? '')) {
          if ((FirebaseAuth.instance.currentUser?.displayName ?? '').length > 0) {
            currentUser.name = FirebaseAuth.instance.currentUser?.displayName ?? '';
          }
        }
        textFieldPhone.textFieldIn.controller?.text =
            currentUser.phoneNumber;
        textFieldName.textFieldIn.controller?.text =
            currentUser.name;
        textFieldEmail.textFieldIn.controller?.text =
            currentUser.email;
        currentUser.updateData();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Profile"),
        automaticallyImplyLeading: widget.Signup == true ? false : true,
        actions: widget.Signup == true
            ? [
                IconButton(
                  icon: const Icon(Icons.logout),
                  tooltip: 'Logout',
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut().then((value) {
                      widget.onClose();
                      Navigator.pop(context);
                    });
                  },
                ),
              ]
            : [],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            //Image Portion
            Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: Center(
                child: GestureDetector(
                    onTap: () {
                      AlertDialogLocal(
                              'Choose Image',
                              'Please select the source of image for your profile',
                              'Camara',
                              'Photo Library', () {
                        _getFromCamera();
                      }, () {
                        _getFromGallery();
                      }, false, '', true)
                          .showAlert(context);
                    },
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blue),
                        borderRadius: BorderRadius.all(Radius.circular(75)),
                      ),
                      child: ClipOval(
                        child: imageFile != null
                            ? Image.file(imageFile!)
                            : Utility().getUserData().profilePictureUrl.length >
                                    0
                                ? CachedNetworkImage(imageUrl: Utility().getUserData().profilePictureUrl,
                          placeholder:(context,url) => Image(image: AssetImage('Assets/appicon.png'),
                            // errorBuilder: (context,url,error),
                        ))
                                : Image(
                                    image: AssetImage('Assets/appicon.png')),
                      ),
                    )),
              ),
            ),
            //Name Text Portion
            Padding(
              padding: const EdgeInsets.only(
                  left: 20, top: 0, right: 20, bottom: 20),
              child: Row(children: <Widget>[
                textFieldName,
              ]),
            ),
            //Phone Number portion
            Padding(
              padding: const EdgeInsets.only(
                  left: 20, top: 0, right: 20, bottom: 20),
              child: Row(children: <Widget>[
                TextButton(
                  onPressed: () {},
                  child: Container(
                    color: Colors.white.withOpacity(0),
                    child: _countryText,
                  ),
                ),
                textFieldPhone,
              ]),
            ),
            //Email Portion
            Padding(
              padding: const EdgeInsets.only(
                  left: 20, top: 0, right: 20, bottom: 20),
              child: Row(
                children: [
                  textFieldEmail,
                  Visibility(
                      visible:
                          (FirebaseAuth.instance.currentUser?.emailVerified ??
                              false),
                      child: const Icon(
                        Icons.verified_user,
                        color: Colors.blue,
                      )),
                  Visibility(
                    visible:
                        !(FirebaseAuth.instance.currentUser?.emailVerified ??
                                false) &&
                            (FirebaseAuth.instance.currentUser!.email ==
                                textFieldEmail.editController.text),
                    child: GestureDetector(
                        onTap: () {
                          FirebaseAuth.instance.currentUser
                              ?.sendEmailVerification()
                              .then((value) {
                            AlertDialogLocal(
                                    'Success',
                                    'Verification link has been sent to your email',
                                    'OK',
                                    '',
                                    () {},
                                    () {},
                                    false,
                                    '',
                                    false)
                                .showAlert(context);
                          });
                        },
                        child: const Text('Verify',
                            style:
                                TextStyle(color: Colors.blue, fontSize: 15))),
                  )
                ],
              ),
            ),
            //Date of Birth
            Padding(
              padding: const EdgeInsets.only(
                  left: 20, top: 0, right: 20, bottom: 20),
              child: Row(children: <Widget>[
                Expanded(
                    child: TextField(
                  controller: dobController,
                  readOnly: true,
                  decoration: InputDecoration(labelText: 'Date of birth'),
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: dob ?? DateTime(DateTime.now().year - 18),
                        firstDate: DateTime(1924),
                        lastDate: DateTime.now());

                    if (pickedDate != null) {
                      dob = pickedDate;
                      dobController.text =
                          DateFormat('dd-MMM-yyyy').format(dob!);
                    }
                  },
                ))
              ]),
            ),
            //Gender Portion
            Padding(
                padding: const EdgeInsets.only(
                    top: 0, bottom: 0, right: 20, left: 20),
                child: SizedBox(
                  height: 80,
                  child: Row(children: [
                    Padding(
                        padding: const EdgeInsets.only(left: 0, right: 30),
                        child: Text('Gender: ',
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
                              child: DropdownButtonHideUnderline(child: DropdownButton(
                                value: CurrentUserGender.toString(),
                                icon: const Icon(Icons.keyboard_arrow_down),
                                isExpanded: true,
                                items:
                                    Gender.values.map((Gender dropdownvalue) {
                                  return DropdownMenuItem(
                                    value: dropdownvalue.toString(),
                                    child: Text(dropdownvalue.name),
                                  );
                                }).toList(),
                                hint: Text('Gender'),
                                onChanged: (value) {
                                  CurrentUserGender = Gender.values.firstWhere(
                                      (element) => element.toString() == value);
                                  setState(() {
                                    initState();
                                  });
                                },
                              )),
                            )))
                  ]),
                )),
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
                      updateProfile();
                    },
                    child: const Text('Update',
                        style: TextStyle(color: Colors.white, fontSize: 20)),
                  ),
                ))
          ],
        ),
      ),
    );
  }

  updateProfile() async {
    if ((textFieldName.textFieldIn.controller?.text ?? '').isEmpty) {
      AlertDialogLocal('Alert', 'Please enter your name', 'OK', '', () {},
              () {}, false, '', false)
          .showAlert(context);
      return;
    }
    if ((textFieldEmail.textFieldIn.controller?.text ?? '').isEmpty) {
      AlertDialogLocal(
              'Alert',
              'Please enter your email address in correct format',
              'OK',
              '',
              () {},
              () {},
              false,
              '',
              false)
          .showAlert(context);
      return;
    }
    if (dob == null) {
      AlertDialogLocal('Alert', 'Please select your date of birth', 'OK', '', () {},
              () {}, false, '', false)
          .showAlert(context);
      return;
    }
    if ((textFieldEmail.textFieldIn.controller?.text ?? '') ==
        Utility().getUserData().email &&
        (textFieldName.textFieldIn.controller?.text ?? '') ==
            Utility().getUserData().name &&
        imageFile == null) {
      uploadFile();
      return;
    }
    try {
      // Fetch sign-in methods for the email address
      List<String> list = [];
      if ((textFieldEmail.textFieldIn.controller?.text ?? '') !=
          Utility().getUserData().email) {
        list = await FirebaseAuth.instance.fetchSignInMethodsForEmail(
            textFieldEmail.textFieldIn.controller?.text ?? '');
      }
      if (list.isNotEmpty) {
        AlertDialogLocal(
                'Alert',
                'The email address is already in use by another account',
                'OK',
                '',
                () {},
                () {},
                false,
                '',
                false)
            .showAlert(context);
      } else {
        ProgressIndicatorLocal().showAlert(context);
        AuthHandler().sendOTP(context, Utility().getUserData().countryCode,
            Utility().getUserData().phoneNumber, 'Update', 'Cancel', () {
          showAlertDialog();
        });
      }
    } catch (error) {
      AlertDialogLocal(
              'Alert',
              AuthHandler.generateExceptionMessage(
                  AuthHandler.handleException(error)),
              'OK',
              '',
              () {},
              () {},
              false,
              '',
              false)
          .showAlert(context);
    }
  }

  showAlertDialog() async {
    ProgressIndicatorLocal().showAlert(context);
    var currentUser = Utility().getUserData();
    FirebaseAuth auth = FirebaseAuth.instance;
    if (currentUser.name !=
        (textFieldName.textFieldIn.controller?.text ?? '')) {
      auth.currentUser
          ?.updateDisplayName(textFieldName.textFieldIn.controller?.text ?? '')
          .then((value) {
        currentUser.name = (textFieldName.textFieldIn.controller?.text ?? '');
        currentUser.updateData();
        if (currentUser.email !=
            (textFieldEmail.textFieldIn.controller?.text ?? '')) {
          auth.currentUser
              ?.updateEmail(textFieldEmail.textFieldIn.controller?.text ?? '')
              .then((value) {
            currentUser.email =
                (textFieldEmail.textFieldIn.controller?.text ?? '');
            currentUser.updateData();
            uploadFile();
          }).catchError((error) {
            textFieldEmail.textFieldIn.controller?.text = '';
            AlertDialogLocal(
                    "Failure",
                    AuthHandler.generateExceptionMessage(
                        AuthHandler.handleException(error)),
                    'OK',
                    '',
                    () {},
                    () {},
                    false,
                    '',
                    false)
                .showAlert(context);
          });
        } else {
          uploadFile();
        }
      });
    } else if (currentUser.email !=
        (textFieldEmail.textFieldIn.controller?.text ?? '')) {
      auth.currentUser
          ?.updateEmail(textFieldEmail.textFieldIn.controller?.text ?? '')
          .then((value) {
        currentUser.email = (textFieldEmail.textFieldIn.controller?.text ?? '');
        currentUser.updateData();
        uploadFile();
      }).catchError((error) {
        textFieldEmail.textFieldIn.controller?.text = '';
        AlertDialogLocal(
                "Failure",
                AuthHandler.generateExceptionMessage(
                    AuthHandler.handleException(error)),
                'OK',
                '',
                () {},
                () {},
                false,
                '',
                false)
            .showAlert(context);
      });
    } else {
      uploadFile();
    }
  }
  /// Get from gallery
  _getFromGallery() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      croppingImage(File(pickedFile.path));
    }
  }

  /// Get from Camera
  _getFromCamera() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      croppingImage(File(pickedFile.path));
    }
  }

  Future<Null> croppingImage(File imagePath) async {
    var croppedFile = (await ImageCropper().cropImage(
        sourcePath: imagePath.path,
        aspectRatioPresets: Platform.isIOS
            ? [CropAspectRatioPreset.square]
            : [CropAspectRatioPreset.square],
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1)));
    if (croppedFile != null) {
      setState(() {
        imageFile = File(croppedFile.path);
        initState();
      });
    }
  }

  Future uploadFile() async {
    ProgressIndicatorLocal().showAlert(context);
    var currentUser = Utility().getUserData();
    currentUser.dateOfBirth = dob;
    currentUser.gender = CurrentUserGender;
    currentUser.updateData();
    if (imageFile == null) {
      Timer.periodic(const Duration(seconds: 3), (timer) {
        if (widget.Signup == true) {
          timer.cancel();
          ProgressIndicatorLocal().hideAlert(context);
          Navigator.push(
              context,
              CupertinoPageRoute(
                  builder: (context) => TabBarVC(onClose: () {
                        if (FirebaseAuth.instance.currentUser == null) {
                          widget.onClose();
                          Navigator.pop(context);
                        }
                      })));
        } else {
          widget.onClose();
          Navigator.pop(context);
        }
      });
    } else {
      final destination =
          (FirebaseAuth.instance.currentUser?.uid ?? 'ProfilePicture');
      try {
        final ref = FirebaseStorage.instance
            .ref(destination)
            .child('ProfilePicture.${imageFile!.path.split('.').last}');
        await ref.putFile(imageFile!).then((p0) async {
          print('Print here');
          await ref.getDownloadURL().then((value) {
            FirebaseAuth auth = FirebaseAuth.instance;
            auth.currentUser?.updatePhotoURL(value).then((value2) {
              currentUser.profilePictureUrl = value;
              currentUser.updateData();
              Timer.periodic(const Duration(seconds: 3), (timer) {
                imageFile = null;
                timer.cancel();
                initState();
                ProgressIndicatorLocal().hideAlert(context);
                if (widget.Signup == true) {
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (context) => TabBarVC(onClose: () {
                                if (FirebaseAuth.instance.currentUser == null) {
                                  widget.onClose();
                                  Navigator.pop(context);
                                }
                              })));
                } else {
                  print('Returning In Result');
                  widget.onClose();
                  Navigator.pop(context);
                }
              });
            }).catchError((error) {
              AlertDialogLocal(
                      "Failure",
                      AuthHandler.generateExceptionMessage(
                          AuthHandler.handleException(error)),
                      'OK',
                      '',
                      () {},
                      () {},
                      false,
                      '',
                      false)
                  .showAlert(context);
            });
          });
        }).catchError((value) {
          print(value);
        });
      } catch (e) {
        print('error occurred');
      }
    }
  }
}
