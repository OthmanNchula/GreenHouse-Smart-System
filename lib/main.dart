import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../consent/navigation.dart';
import '../AuthViewModel.dart';
import '../app_lifecycle_observer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isAndroid) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyAoI4DGhxx2gDgcHUMJyfMApeanGeUQ9hc",
        authDomain: "greenhouse-smart-system.firebaseapp.com",
        projectId: "greenhouse-smart-system",
        storageBucket: "greenhouse-smart-system.appspot.com",
        messagingSenderId: "525350777350",
        appId: "1:525350777350:web:6ee83d54dafe2860480987",
        measurementId: "G-QE65ZSNX6Q",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }

  runApp(
    ChangeNotifierProvider(
      create: (_) => AuthViewModel(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  late AppLifecycleObserver _appLifecycleObserver;

  @override
  void initState() {
    super.initState();
    _appLifecycleObserver = AppLifecycleObserver(context);
    WidgetsBinding.instance.addObserver(_appLifecycleObserver);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(_appLifecycleObserver);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const AppNavigator();
  }
}
