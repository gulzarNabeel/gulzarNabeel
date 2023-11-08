import 'package:diabetes/Usables/AlertDialogLocal.dart';
import 'package:diabetes/Usables/Utility.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

enum AuthResultStatus {
  successful,
  emailAlreadyExists,
  wrongPassword,
  invalidEmail,
  userNotFound,
  userDisabled,
  operationNotAllowed,
  tooManyRequests,
  undefined,
}

class AuthHandler {
  static handleException(e) {
    var status;
    switch (e.code) {
      case "ERROR_INVALID_EMAIL":
        status = AuthResultStatus.invalidEmail;
        break;
      case 'invalid-email':
        status = AuthResultStatus.invalidEmail;
        break;
      case "ERROR_WRONG_PASSWORD":
        status = AuthResultStatus.wrongPassword;
        break;
      case "ERROR_USER_NOT_FOUND":
        status = AuthResultStatus.userNotFound;
        break;
      case "ERROR_USER_DISABLED":
        status = AuthResultStatus.userDisabled;
        break;
      case "ERROR_TOO_MANY_REQUESTS":
        status = AuthResultStatus.tooManyRequests;
        break;
      case "ERROR_OPERATION_NOT_ALLOWED":
        status = AuthResultStatus.operationNotAllowed;
        break;
      case "ERROR_EMAIL_ALREADY_IN_USE":
        status = AuthResultStatus.emailAlreadyExists;
        break;
      case "email-already-in-use":
        status = AuthResultStatus.emailAlreadyExists;
        break;
      default:
        status = AuthResultStatus.undefined;
    }
    print('Error Code: ' + e.code);
    return status;
  }

  ///
  /// Accepts AuthExceptionHandler.errorType
  ///
  static generateExceptionMessage(exceptionCode) {
    String errorMessage;
    switch (exceptionCode) {
      case AuthResultStatus.invalidEmail:
        errorMessage = "Your email address appears to be malformed.";
        break;
      case AuthResultStatus.wrongPassword:
        errorMessage = "Your password is wrong.";
        break;
      case AuthResultStatus.userNotFound:
        errorMessage = "User with this user doesn't exist.";
        break;
      case AuthResultStatus.userDisabled:
        errorMessage = "User with this email has been disabled.";
        break;
      case AuthResultStatus.tooManyRequests:
        errorMessage = "Too many requests. Try again later.";
        break;
      case AuthResultStatus.operationNotAllowed:
        errorMessage = "Signing in with Email and Password is not enabled.";
        break;
      case AuthResultStatus.emailAlreadyExists:
        errorMessage =
            "The email has already been used. Please use alternative email.";
        break;
      default:
        errorMessage = "An undefined Error happened.";
    }

    return errorMessage;
  }

  sendOTP(BuildContext con, String countryCodeIn,String phoneNumber, String YesButton, String NoButton, Function onClose) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    auth.verifyPhoneNumber(phoneNumber: countryCodeIn+phoneNumber,verificationCompleted: (_){
      print("Done\n\n\n\nverificationCompleted");
    }, verificationFailed: (error){
      print("Done\n\n\n$error");
    }, codeSent: (String verificationId, int? token) async {
      final result = await showAlertDialog(con, verificationId,YesButton,NoButton,(){
        print('Returning In Result Onclose: ');
        onClose();
      });
      setState() {
        print('Returning In Result:' + result.toString());
      }
    }, codeAutoRetrievalTimeout: (_){
      print("Done\n\n\n\ncodeAutoRetrievalTimeout");
    });
    // return result;
  }

  showAlertDialog(BuildContext cont, String idVerification, String YesButton, String NoButton, Function onClose) async {
    // set up the buttons
    AlertDialogLocal(
            'OTP Verification',
            'Please enter your OTP received in your phone',
            YesButton,
            NoButton, (String value) async {
      FirebaseAuth auth = FirebaseAuth.instance;
      final credentials = PhoneAuthProvider.credential(
          verificationId: idVerification, smsCode: value);
      try {
        await auth.currentUser
            ?.reauthenticateWithCredential(credentials)
            .then((authResult) {
            onClose();
        });
      } catch (error) {
        AlertDialogLocal(
                'Failed',
                generateExceptionMessage(handleException(error)),
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
}
