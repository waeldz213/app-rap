import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// TODO: Run `flutterfire configure` to generate the real firebase_options.dart
/// Then replace this file with the generated one.
///
/// Installation:
/// ```
/// dart pub global activate flutterfire_cli
/// flutterfire configure
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) return web;
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  // TODO: Replace with real values from flutterfire configure
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'TODO_REPLACE_WITH_REAL_API_KEY',
    appId: 'TODO_REPLACE_WITH_REAL_APP_ID',
    messagingSenderId: 'TODO_REPLACE_WITH_REAL_SENDER_ID',
    projectId: 'TODO_REPLACE_WITH_REAL_PROJECT_ID',
    authDomain: 'TODO_REPLACE_WITH_REAL_AUTH_DOMAIN',
    storageBucket: 'TODO_REPLACE_WITH_REAL_STORAGE_BUCKET',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'TODO_REPLACE_WITH_REAL_API_KEY',
    appId: 'TODO_REPLACE_WITH_REAL_APP_ID',
    messagingSenderId: 'TODO_REPLACE_WITH_REAL_SENDER_ID',
    projectId: 'TODO_REPLACE_WITH_REAL_PROJECT_ID',
    storageBucket: 'TODO_REPLACE_WITH_REAL_STORAGE_BUCKET',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'TODO_REPLACE_WITH_REAL_API_KEY',
    appId: 'TODO_REPLACE_WITH_REAL_APP_ID',
    messagingSenderId: 'TODO_REPLACE_WITH_REAL_SENDER_ID',
    projectId: 'TODO_REPLACE_WITH_REAL_PROJECT_ID',
    storageBucket: 'TODO_REPLACE_WITH_REAL_STORAGE_BUCKET',
    iosClientId: 'TODO_REPLACE_WITH_REAL_IOS_CLIENT_ID',
    iosBundleId: 'com.apprap.app',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'TODO_REPLACE_WITH_REAL_API_KEY',
    appId: 'TODO_REPLACE_WITH_REAL_APP_ID',
    messagingSenderId: 'TODO_REPLACE_WITH_REAL_SENDER_ID',
    projectId: 'TODO_REPLACE_WITH_REAL_PROJECT_ID',
    storageBucket: 'TODO_REPLACE_WITH_REAL_STORAGE_BUCKET',
    iosClientId: 'TODO_REPLACE_WITH_REAL_IOS_CLIENT_ID',
    iosBundleId: 'com.apprap.app',
  );
}
