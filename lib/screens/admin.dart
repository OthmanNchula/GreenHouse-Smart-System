import 'package:flutter/material.dart';
import 'package:smartgreenhouse/admin_app_bar.dart';
import '../auth/signup.dart';
import '../thresholds_view.dart';
import '../threshold_history_view.dart';
import '../users_views.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  int _selectedIndex = 0;

  void _onDestinationSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: adminAppBar(context, title: 'Admin Page'),
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: _onDestinationSelected,
            labelType: NavigationRailLabelType.all,
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.person_add),
                selectedIcon: Icon(Icons.person_add),
                label: Text('Register User'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.person),
                selectedIcon: Icon(Icons.person),
                label: Text('Users'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.tune),
                selectedIcon: Icon(Icons.tune),
                label: Text('Thresholds'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.history),
                selectedIcon: Icon(Icons.history),
                label: Text('Threshold History'),
              ),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: _selectedIndex == 0
                  ? const SignupPage()
                  : _selectedIndex == 1
                  ? const UsersView()
                  : _selectedIndex == 2
                  ? const ThresholdsView()
                  : const ThresholdHistoryView(),
            ),
          ),
        ],
      ),
    );
  }
}
