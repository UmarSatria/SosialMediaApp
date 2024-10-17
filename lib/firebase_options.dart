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
    apiKey: 'AIzaSyBmvFLii8CJv6OSiBb_M2z87_djigaToOo',
    appId: '1:948940044268:web:dde78418e96115098172c9',
    messagingSenderId: '948940044268',
    projectId: 'sosial-media-app-d3cc9',
    authDomain: 'sosial-media-app-d3cc9.firebaseapp.com',
    storageBucket: 'sosial-media-app-d3cc9.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBxn7pyGK9stAmWQO4f4rwVNhlH1IromFA',
    appId: '1:948940044268:android:5b3d5e77243181e88172c9',
    messagingSenderId: '948940044268',
    projectId: 'sosial-media-app-d3cc9',
    storageBucket: 'sosial-media-app-d3cc9.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCKnBDK4aaVUx2qpVSokQvxS7bIbn-jG_g',
    appId: '1:948940044268:ios:70334bce2148f5a58172c9',
    messagingSenderId: '948940044268',
    projectId: 'sosial-media-app-d3cc9',
    storageBucket: 'sosial-media-app-d3cc9.appspot.com',
    iosBundleId: 'com.example.sosialmediaapp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCKnBDK4aaVUx2qpVSokQvxS7bIbn-jG_g',
    appId: '1:948940044268:ios:70334bce2148f5a58172c9',
    messagingSenderId: '948940044268',
    projectId: 'sosial-media-app-d3cc9',
    storageBucket: 'sosial-media-app-d3cc9.appspot.com',
    iosBundleId: 'com.example.sosialmediaapp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBmvFLii8CJv6OSiBb_M2z87_djigaToOo',
    appId: '1:948940044268:web:00b624371709ce718172c9',
    messagingSenderId: '948940044268',
    projectId: 'sosial-media-app-d3cc9',
    authDomain: 'sosial-media-app-d3cc9.firebaseapp.com',
    storageBucket: 'sosial-media-app-d3cc9.appspot.com',
  );
}
