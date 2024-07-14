import 'package:flutter/material.dart';


class CustomDrawer extends StatelessWidget {
  final VoidCallback onLogout;

  const CustomDrawer({super.key, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          Container(
            color: Colors.blue,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(left: 16.0),
            height: kToolbarHeight,
            child: const Text(
              'Menu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              // Navigate to home if necessary
            },
          ),
          ListTile(
            leading: const Icon(Icons.analytics),
            title: const Text('Report & Analysis'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/report');// Close the drawer
              // Navigate to Report & Analysis page if necessary
            },
          ),
          Expanded(
            child: Container(),
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: onLogout,
          ),
        ],
      ),
    );
  }
}
