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
    apiKey: 'AIzaSyBxPQKGz7oIFZ4qd3Fplwxbn6QU12AN1KM',
    appId: '1:421354177046:web:b61a15e1f0d62920e36b37',
    messagingSenderId: '421354177046',
    projectId: 'nt-changes',
    authDomain: 'nt-changes.firebaseapp.com',
    storageBucket: 'nt-changes.appspot.com',
    measurementId: 'G-FD41DHL4NL',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDDrfOECocjp98rekiQhwzDsgl6s76B34A',
    appId: '1:421354177046:android:fd9fe98c84d87055e36b37',
    messagingSenderId: '421354177046',
    projectId: 'nt-changes',
    storageBucket: 'nt-changes.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDAqQ9ZoSOtbIx7zGJ97uYTlezuHEuPvmA',
    appId: '1:421354177046:ios:b8b0c29411933c04e36b37',
    messagingSenderId: '421354177046',
    projectId: 'nt-changes',
    storageBucket: 'nt-changes.appspot.com',
    androidClientId: '421354177046-5td6fl05hfg1rftcfq11e93jaalp4s3l.apps.googleusercontent.com',
    iosClientId: '421354177046-428fds62fqlijjjp7m3sv0tujhdt7mlj.apps.googleusercontent.com',
    iosBundleId: 'com.example.start',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDAqQ9ZoSOtbIx7zGJ97uYTlezuHEuPvmA',
    appId: '1:421354177046:ios:b8b0c29411933c04e36b37',
    messagingSenderId: '421354177046',
    projectId: 'nt-changes',
    storageBucket: 'nt-changes.appspot.com',
    androidClientId: '421354177046-5td6fl05hfg1rftcfq11e93jaalp4s3l.apps.googleusercontent.com',
    iosClientId: '421354177046-428fds62fqlijjjp7m3sv0tujhdt7mlj.apps.googleusercontent.com',
    iosBundleId: 'com.example.start',
  );
}
