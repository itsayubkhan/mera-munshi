// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        return windows;
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
    apiKey: 'AIzaSyDFA2EIBz52pi9rFDwwMyRAg3mV9EP0unE',
    appId: '1:529427106536:web:ec617a85bc43ec4c1f575d',
    messagingSenderId: '529427106536',
    projectId: 'mymunshee-56691',
    authDomain: 'mymunshee-56691.firebaseapp.com',
    storageBucket: 'mymunshee-56691.appspot.com',
    measurementId: 'G-N58CBZ0HB9',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCPZvh5Euww8m6mrWjGHaIx13ImKq6HaUw',
    appId: '1:529427106536:android:2d85476296b3bb3a1f575d',
    messagingSenderId: '529427106536',
    projectId: 'mymunshee-56691',
    storageBucket: 'mymunshee-56691.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDWlEQ2aIl6rwDQpU9aVwFCW7bZw9_kDyU',
    appId: '1:529427106536:ios:1aae436e479a33dc1f575d',
    messagingSenderId: '529427106536',
    projectId: 'mymunshee-56691',
    storageBucket: 'mymunshee-56691.appspot.com',
    iosClientId: '529427106536-44b54k71idlf835e3difaa0ftnjo3lba.apps.googleusercontent.com',
    iosBundleId: 'com.example.mymunshi',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDWlEQ2aIl6rwDQpU9aVwFCW7bZw9_kDyU',
    appId: '1:529427106536:ios:1aae436e479a33dc1f575d',
    messagingSenderId: '529427106536',
    projectId: 'mymunshee-56691',
    storageBucket: 'mymunshee-56691.appspot.com',
    iosClientId: '529427106536-44b54k71idlf835e3difaa0ftnjo3lba.apps.googleusercontent.com',
    iosBundleId: 'com.example.mymunshi',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDFA2EIBz52pi9rFDwwMyRAg3mV9EP0unE',
    appId: '1:529427106536:web:ab3ee578d00ab0061f575d',
    messagingSenderId: '529427106536',
    projectId: 'mymunshee-56691',
    authDomain: 'mymunshee-56691.firebaseapp.com',
    storageBucket: 'mymunshee-56691.appspot.com',
    measurementId: 'G-1GMGB3CCTL',
  );
}
