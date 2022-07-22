import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutterfire_ui/i10n.dart';
import 'data/firebase_helper.dart';
import 'firebase_options.dart';
import './screens/authentication_screen.dart';
import './data/labels.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> _messageHandler(RemoteMessage message) async {
  print('background message title ${message.notification!.title}');
  print('background message body ${message.notification!.body}');
  print('background data ${message.data.length}');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final messaging = FirebaseMessaging.instance;

  final notificationSettings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  print('Notification permission status: ' 
    + '${notificationSettings.authorizationStatus}');

  final key = await messaging.getToken() ?? '';
  print('Key is ' + key);

  FirebaseMessaging.onBackgroundMessage(_messageHandler);

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');

    if (message.notification != null) {
      print('Message notification: ${message.notification?.body}');
    }
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //final helper = FirebaseHelper();
    //helper.testData();
    return MaterialApp(
      localizationsDelegates: [
        FlutterFireUILocalizations.withDefaultOverrides(const LabelOverrides()),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        FlutterFireUILocalizations.delegate,
      ],
      debugShowCheckedModeBanner: false,
      title: 'Beginning FlutterFire',
      theme: ThemeData(
        primarySwatch: Colors.brown,
      ),
      home: const AuthenticationScreen(),
    );
  }
}
