import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

AppBar adminAppBar(BuildContext context, {required String title}) {
  return AppBar(
    title: Text(title),
    actions: [
      PopupMenuButton<String>(
        onSelected: (String result) async {
          if (result == 'logout') {
            await FirebaseAuth.instance.signOut();
            Navigator.pushReplacementNamed(context, '/login');
          }
        },
        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
          const PopupMenuItem<String>(
            value: 'logout',
            child: Text('Logout'),
          ),
        ],
      ),
    ],
  );
}
