import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  if(kIsWeb){
    await Firebase.initializeApp(options: const FirebaseOptions(apiKey: "AIzaSyAN24-g6IlyCIHpmXinKagzEKRH2TQj7S0",
        authDomain: "black-stars-f4fbb.firebaseapp.com",
        databaseURL: "https://black-stars-f4fbb-default-rtdb.asia-southeast1.firebasedatabase.app",
        projectId: "black-stars-f4fbb",
        storageBucket: "black-stars-f4fbb.firebasestorage.app",
        messagingSenderId: "49595679109",
        appId: "1:49595679109:web:723ad133d6e2c1b20344ec",
        measurementId: "G-PT0KQT3B5M"));
  }
  else{
    await Firebase.initializeApp();
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Player Database',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}
