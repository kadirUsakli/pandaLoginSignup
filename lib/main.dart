import 'package:flutter/material.dart';
import 'package:panda_login/pages/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:rive/rive.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await RiveFile.initialize(); 
  runApp(myApp());
}

class myApp extends StatelessWidget {
  const myApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Panda_Login_Signup',
      theme: ThemeData(primaryColor: Colors.blue),
      home: const loginPage(),
    );
  }
}
