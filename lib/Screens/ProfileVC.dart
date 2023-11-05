import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_calling_code_picker/picker.dart';
import 'package:diabetes/Models/UserLocal.dart';
import 'package:diabetes/Screens/TabBarVC.dart';
import 'package:diabetes/Usables/AlertDialogLocal.dart';
import 'package:diabetes/Usables/DisplayPictureScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import '../Usables/AuthExceptionHandler.dart';
import '../Usables/CustomTextField.dart';
import '../Usables/Utility.dart';

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
      const Text("", style: TextStyle(color: Colors.blue, fontSize: 25));
  CustomTextField textFieldPhone =
      CustomTextField('Phone Number', TextInputType.phone, false);
  CustomTextField textFieldName =
      CustomTextField('Name', TextInputType.name, true);
  CustomTextField textFieldEmail =
      CustomTextField('Email', TextInputType.emailAddress, true);
  File? imageFile;

  _ProfilePageState();

  @override
  void initState() {
    if ((FirebaseAuth.instance.currentUser?.emailVerified ?? false) == false) {
      FirebaseAuth.instance.currentUser?.reload().then((value) {
        initState();
      });
    }
    initCountry();
  }

  void initCountry() async {
    var country = await getDefaultCountry(context);
    List<Country> countries = await getCountries(context);
    setState(() {
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
            style: const TextStyle(color: Colors.blue, fontSize: 25));
      } else {
        _countryText = Text(Utility().getUserData().countryCode,
            style: const TextStyle(color: Colors.blue, fontSize: 25));
      }
      textFieldPhone.textFieldIn.controller?.text =
          Utility().getUserData().phoneNumber;
      textFieldName.textFieldIn.controller?.text = Utility().getUserData().name;
      textFieldEmail.textFieldIn.controller?.text =
          Utility().getUserData().email;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Profile"),
        automaticallyImplyLeading: widget.Signup == true ? false : true,
        actions: [
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
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
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
                                ? Image.network(
                                    Utility().getUserData().profilePictureUrl)
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
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    child: _countryText,
                  ),
                ),
                textFieldPhone,
              ]),
            ),
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
                            false),
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

            Container(
              height: 50,
              width: 250,
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(20)),
              child: ElevatedButton(
                onPressed: () {
                  updateProfile(context);
                },
                child: const Text('Update',
                    style: TextStyle(color: Colors.white, fontSize: 20)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  updateProfile(BuildContext context) async {
    if ((textFieldEmail.textFieldIn.controller?.text ?? '') ==
            Utility().getUserData().email &&
        (textFieldName.textFieldIn.controller?.text ?? '') ==
            Utility().getUserData().name &&
        imageFile == null) {
      return;
    }
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
        // Return false because email adress is not in use
        FirebaseAuth auth = FirebaseAuth.instance;
        auth.verifyPhoneNumber(
            phoneNumber: Utility().getUserData().countryCode +
                Utility().getUserData().phoneNumber,
            verificationCompleted: (_) {
              print("Done\n\n\n\nverificationCompleted");
            },
            verificationFailed: (error) {
              print("Done\n\n\n$error");
            },
            codeSent: (String verificationId, int? token) async {
              await showAlertDialog(context, verificationId);
            },
            codeAutoRetrievalTimeout: (_) {
              print("Done\n\n\n\ncodeAutoRetrievalTimeout");
            });
      }
    } catch (error) {
      AlertDialogLocal(
              'Alert',
              AuthExceptionHandler.generateExceptionMessage(
                  AuthExceptionHandler.handleException(error)),
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

  showAlertDialog(BuildContext cont, String idVerification) async {
    // set up the buttons
    AlertDialogLocal(
            'OTP Verification',
            'Please enter your OTP received in your phone',
            'Update',
            'Cancel', (String value) async {
      FirebaseAuth auth = FirebaseAuth.instance;
      final credentials = PhoneAuthProvider.credential(
          verificationId: idVerification, smsCode: value);
      try {
        await auth.currentUser
            ?.reauthenticateWithCredential(credentials)
            .then((authResult) {
          var currentUser = Utility().getUserData();
          if (currentUser.name !=
              (textFieldName.textFieldIn.controller?.text ?? '')) {
            auth.currentUser
                ?.updateDisplayName(
                    textFieldName.textFieldIn.controller?.text ?? '')
                .then((value) {
              currentUser.name =
                  (textFieldName.textFieldIn.controller?.text ?? '');
              currentUser.updateData();
              if (currentUser.email !=
                  (textFieldEmail.textFieldIn.controller?.text ?? '')) {
                auth.currentUser
                    ?.updateEmail(
                        textFieldEmail.textFieldIn.controller?.text ?? '')
                    .then((value) {
                  currentUser.email =
                      (textFieldEmail.textFieldIn.controller?.text ?? '');
                  currentUser.updateData();
                  uploadFile();
                }).catchError((error) {
                  textFieldEmail.textFieldIn.controller?.text = '';
                  AlertDialogLocal(
                          "Failure",
                          AuthExceptionHandler.generateExceptionMessage(
                              AuthExceptionHandler.handleException(error)),
                          'OK',
                          '',
                          () {},
                          () {},
                          false,
                          '',
                          false)
                      .showAlert(cont);
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
              currentUser.email =
                  (textFieldEmail.textFieldIn.controller?.text ?? '');
              currentUser.updateData();
              uploadFile();
            }).catchError((error) {
              textFieldEmail.textFieldIn.controller?.text = '';
              AlertDialogLocal(
                      "Failure",
                      AuthExceptionHandler.generateExceptionMessage(
                          AuthExceptionHandler.handleException(error)),
                      'OK',
                      '',
                      () {},
                      () {},
                      false,
                      '',
                      false)
                  .showAlert(cont);
            });
          } else {
            uploadFile();
          }
        });
      } catch (error) {
        AlertDialogLocal(
                'Failed',
                AuthExceptionHandler.generateExceptionMessage(
                    AuthExceptionHandler.handleException(error)),
                'OK',
                '',
                () {},
                () {},
                false,
                '',
                false)
            .showAlert(cont);
      }
    }, (value) {}, true, 'OTP', true)
        .showAlert(cont);
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
    if (imageFile == null) {
      if (widget.Signup == true) {
        Timer.periodic(const Duration(seconds: 3), (timer) {
          timer.cancel();
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => TabBarVC(onClose: () {
                        if (FirebaseAuth.instance.currentUser == null) {
                          widget.onClose();
                        }
                      }),
                  fullscreenDialog: true));
        });
      } else {
        Navigator.pop(context);
      }
    } else {
      final destination =
          (FirebaseAuth.instance.currentUser?.uid ?? 'ProfilePicture');
      try {
        final ref = FirebaseStorage.instance
            .ref(destination)
            .child('ProfilePicture.${imageFile!.path.split('.').last}');
        await ref.putFile(imageFile!).then((p0) async {
          await ref.getDownloadURL().then((value) {
            var currentUser = Utility().getUserData();
            FirebaseAuth auth = FirebaseAuth.instance;
            auth.currentUser?.updatePhotoURL(value).then((value2) {
              currentUser.profilePictureUrl = value;
              currentUser.updateData();
              Timer.periodic(const Duration(seconds: 3), (timer) {
                imageFile = null;
                timer.cancel();
                initState();
                if (widget.Signup == true) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TabBarVC(onClose: () {
                                if (FirebaseAuth.instance.currentUser == null) {
                                  widget.onClose();
                                }
                              }),
                          fullscreenDialog: true));
                } else {
                  Navigator.pop(context);
                }
              });
            }).catchError((error) {
              AlertDialogLocal(
                      "Failure",
                      AuthExceptionHandler.generateExceptionMessage(
                          AuthExceptionHandler.handleException(error)),
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
        });
      } catch (e) {
        print('error occurred');
      }
    }
  }
}
