//IMPORTANT: please note that you have to create your own
//firebase_options.dart file following the instructions at ep_03

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutterfire_ui/i10n.dart';
import 'data/firebase_helper.dart';
import 'data/labels.dart';
import 'firebase_options.dart';
import 'screens/authentication_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final helper = FirebaseHelper(); 
    helper.testData(); 
    return MaterialApp(
      localizationsDelegates: [
        FlutterFireUILocalizations.withDefaultOverrides(const LabelOverrides()),
      ],
      home: const AuthenticationScreen(),
    );
  }
}
