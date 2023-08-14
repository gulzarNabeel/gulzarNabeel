// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyByqC0p3M6c8MCv9XyMI0veKS28baq-8m4',
    appId: '1:387896594277:web:afaa1a17a49cc103929b8c',
    messagingSenderId: '387896594277',
    projectId: 'diab-nabeel-test',
    authDomain: 'diab-nabeel-test.firebaseapp.com',
    databaseURL: 'https://diab-nabeel-test-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'diab-nabeel-test.appspot.com',
    measurementId: 'G-P0HWH5KQWL',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCni_FQicGURehRMu4Uq0Xz_9DQ050oHas',
    appId: '1:387896594277:android:6d686ecadcda0502929b8c',
    messagingSenderId: '387896594277',
    projectId: 'diab-nabeel-test',
    databaseURL: 'https://diab-nabeel-test-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'diab-nabeel-test.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBNSQGbhjTsNgMHUHXiesSmYEF51ul7Y3M',
    appId: '1:387896594277:ios:66a38d55a0cec2c8929b8c',
    messagingSenderId: '387896594277',
    projectId: 'diab-nabeel-test',
    databaseURL: 'https://diab-nabeel-test-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'diab-nabeel-test.appspot.com',
    iosClientId: '387896594277-g1ci86neumqmj3ks8m09t2tmu4o7dq1h.apps.googleusercontent.com',
    iosBundleId: 'gulzar.nabeel.diabetes',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBNSQGbhjTsNgMHUHXiesSmYEF51ul7Y3M',
    appId: '1:387896594277:ios:66a38d55a0cec2c8929b8c',
    messagingSenderId: '387896594277',
    projectId: 'diab-nabeel-test',
    databaseURL: 'https://diab-nabeel-test-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'diab-nabeel-test.appspot.com',
    iosClientId: '387896594277-g1ci86neumqmj3ks8m09t2tmu4o7dq1h.apps.googleusercontent.com',
    iosBundleId: 'gulzar.nabeel.diabetes',
  );
}
