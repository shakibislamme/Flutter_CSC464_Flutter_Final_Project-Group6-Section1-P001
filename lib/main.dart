import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    if (kIsWeb) {
      await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: "AIzaSyBu7aXz3fQgrSBPG-xpRwGKdHnxFIDdJSo",
          authDomain: "ai-language-app-995a3.firebaseapp.com",
          projectId: "ai-language-app-995a3",
          storageBucket: "ai-language-app-995a3.firebasestorage.app",
          messagingSenderId: "791310533548",
          appId: "1:791310533548:web:61f6a380dc217c6bfe7009",
          measurementId: "G-76D1N9EK41",
        ),
      );
    } else {
      await Firebase.initializeApp();
    }
  } catch (e) {
    print("Firebase initialization error: $e");
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AI Language Tutor',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue),
      home: HomeScreen(),
    );
  }
}
