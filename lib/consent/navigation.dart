import 'package:flutter/material.dart';
import 'package:smartgreenhouse/screens/admin.dart';
import '../auth/login.dart';
import '../auth/signup.dart';
import '../screens/adminlogin.dart';
import '../screens/edit_profile.dart';
import '../screens/home.dart';
import '../screens/report_page.dart';
import '../screens/welcome_page.dart';

class AppNavigator extends StatelessWidget {
  const AppNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Greenhouse System',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const WelcomePage(),
        '/login': (context) => const LoginPage(),
        '/signup': (context) => const SignupPage(),
        '/home': (context) => const HomePage(),
        '/admin': (context) => const AdminPage(),
        '/user': (context) => const HomePage(),
        '/report': (context) => const ReportPage(),
        '/adminLogin': (context) => const AdminLoginPage(),
        '/editProfile': (context) => const EditProfilePage(),
      },
    );
  }
}