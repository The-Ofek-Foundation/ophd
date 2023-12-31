// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
		show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// // ...
// await Firebase.initializeApp(
//   options = DefaultFirebaseOptions.currentPlatform,
// );
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
		apiKey: 'AIzaSyDzJIJIGknWTPVo_-ZiyGRlIr2tKIQrchk',
		appId: '1:1010354726289:web:05a5a6286d269dbbc96630',
		messagingSenderId: '1010354726289',
		projectId: 'ophd-53b5e',
		authDomain: 'ophd-53b5e.firebaseapp.com',
		storageBucket: 'ophd-53b5e.appspot.com',
		measurementId: 'G-D1TC9ZKGG6',
	);

	static const FirebaseOptions android = FirebaseOptions(
		apiKey: 'AIzaSyDCvo2oeXQMxXVPnap0alLBCltN-0i39a8',
		appId: '1:1010354726289:android:cd1c2383e71cdcc7c96630',
		messagingSenderId: '1010354726289',
		projectId: 'ophd-53b5e',
		storageBucket: 'ophd-53b5e.appspot.com',
	);

	static const FirebaseOptions ios = FirebaseOptions(
		apiKey: 'AIzaSyA-ZYDCcZ4WTS9Pigq3mvny4DTk8aCVOW4',
		appId: '1:1010354726289:ios:f7b9cddc270cbb83c96630',
		messagingSenderId: '1010354726289',
		projectId: 'ophd-53b5e',
		storageBucket: 'ophd-53b5e.appspot.com',
		iosClientId: '1010354726289-mmofuol7th9t49o6goe4qg1hdjiusv4q.apps.googleusercontent.com',
		iosBundleId: 'com.example.ophd',
	);

	static const FirebaseOptions macos = FirebaseOptions(
		apiKey: 'AIzaSyA-ZYDCcZ4WTS9Pigq3mvny4DTk8aCVOW4',
		appId: '1:1010354726289:ios:ed6d5c0d6e1c7d14c96630',
		messagingSenderId: '1010354726289',
		projectId: 'ophd-53b5e',
		storageBucket: 'ophd-53b5e.appspot.com',
		iosClientId: '1010354726289-00t6dl5hiip4e6g6vg40s35nv2k3h07g.apps.googleusercontent.com',
		iosBundleId: 'com.example.ophd.RunnerTests',
	);
}
