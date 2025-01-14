import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:the_nomnom_collective/utilities/firebase_options.dart';
import 'LoginPage.dart';
import 'HomePage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await initialization(null);
  runApp(MyApp());
}

Future initialization(BuildContext? context) async {
  await Future.delayed(Duration(seconds: 1));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override

  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: FirebaseAuth.instance.currentUser != null ? Homepage() : LoginPage(),
    );
  
  }
}