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
    apiKey: 'AIzaSyBTaxrKrSkhLl33ElL3_7RWBtihHUSSmG8',
    appId: '1:522582382156:web:ed562a8c103d3d185a06e9',
    messagingSenderId: '522582382156',
    projectId: 'wael-abo-hamza-4bd1e',
    authDomain: 'wael-abo-hamza-4bd1e.firebaseapp.com',
    storageBucket: 'wael-abo-hamza-4bd1e.appspot.com',
    measurementId: 'G-ME5BFV3H21',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBK46sDEONiPlHK7YApOBJR7diR0RLAt9M',
    appId: '1:522582382156:android:64fe15409c1385335a06e9',
    messagingSenderId: '522582382156',
    projectId: 'wael-abo-hamza-4bd1e',
    storageBucket: 'wael-abo-hamza-4bd1e.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDb_j39duZDSGzx274oqKfkzDDtSIeVGlI',
    appId: '1:522582382156:ios:bce779453292e7f05a06e9',
    messagingSenderId: '522582382156',
    projectId: 'wael-abo-hamza-4bd1e',
    storageBucket: 'wael-abo-hamza-4bd1e.appspot.com',
    iosBundleId: 'com.example.waelfirebase',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDb_j39duZDSGzx274oqKfkzDDtSIeVGlI',
    appId: '1:522582382156:ios:9b074b5d16a7df2d5a06e9',
    messagingSenderId: '522582382156',
    projectId: 'wael-abo-hamza-4bd1e',
    storageBucket: 'wael-abo-hamza-4bd1e.appspot.com',
    iosBundleId: 'com.example.waelfirebase.RunnerTests',
  );
}
