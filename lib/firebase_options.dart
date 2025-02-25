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
    apiKey: 'AIzaSyCupFV-Cfx_6bWByr3kmfZKu7YOCtxJ5B0',
    appId: '1:829136940579:web:f680590a833dc031f58b96',
    messagingSenderId: '829136940579',
    projectId: 'myapp-6f91b',
    authDomain: 'myapp-6f91b.firebaseapp.com',
    storageBucket: 'myapp-6f91b.appspot.com',
    measurementId: 'G-SK55YZVE58',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAB--E6RLdkuP2K7CbstoOeequEhn1GcYQ',
    appId: '1:829136940579:android:f4bd1d0cfa934eb9f58b96',
    messagingSenderId: '829136940579',
    projectId: 'myapp-6f91b',
    storageBucket: 'myapp-6f91b.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAUE5FFZpUNsnTMzCDMV2PH_I9x0EnGiVQ',
    appId: '1:829136940579:ios:c82ceb7e4af98129f58b96',
    messagingSenderId: '829136940579',
    projectId: 'myapp-6f91b',
    storageBucket: 'myapp-6f91b.appspot.com',
    iosClientId: '829136940579-b3j5gjk426mvoat40ubchqb0k5pjoqfv.apps.googleusercontent.com',
    iosBundleId: 'com.example.myapplication',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAUE5FFZpUNsnTMzCDMV2PH_I9x0EnGiVQ',
    appId: '1:829136940579:ios:44c9dafb4144b381f58b96',
    messagingSenderId: '829136940579',
    projectId: 'myapp-6f91b',
    storageBucket: 'myapp-6f91b.appspot.com',
    iosClientId: '829136940579-e9s16u08m9kns6sk3111qa8aco3hleqg.apps.googleusercontent.com',
    iosBundleId: 'com.example.myapplication.RunnerTests',
  );
}
