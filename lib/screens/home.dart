import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../consent/gauge_widget.dart';
import '../customer_app_bar.dart';
import '../customer_drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isFanOn = false;
  bool isWaterPumpOn = false;
  bool isLightOn = false;

  double temperature = 0.0;
  double lightIntensity = 0.0;
  double humidity = 0.0;

  final DatabaseReference databaseReference = FirebaseDatabase.instance.ref();

  @override
  void initState() {
    super.initState();
    _initializeDatabaseListeners();
  }

  void _initializeDatabaseListeners() {
    databaseReference.child('sensorData/temperature').onValue.listen((event) {
      final newTemperature = event.snapshot.value;
      setState(() {
        temperature = (newTemperature != null) ? double.parse(newTemperature.toString()) : 0.0;
      });
    });
    databaseReference.child('lightintensity').onValue.listen((event) {
      final newLightIntensity = event.snapshot.value;
      setState(() {
        lightIntensity = (newLightIntensity != null) ? double.parse(newLightIntensity.toString()) : 0.0;
      });
    });
    databaseReference.child('sensorData/humidity').onValue.listen((event) {
      final newHumidity = event.snapshot.value;
      setState(() {
        humidity = (newHumidity != null) ? double.parse(newHumidity.toString()) : 0.0;
      });
    });

    databaseReference.child('fan').onValue.listen((event) {
      final fanStatus = event.snapshot.value;
      setState(() {
        isFanOn = fanStatus == 'on';
      });
    });

    databaseReference.child('light').onValue.listen((event) {
      final lightStatus = event.snapshot.value;
      setState(() {
        isLightOn = lightStatus == 'on';
      });
    });

    databaseReference.child('waterPump').onValue.listen((event) {
      final waterPumpStatus = event.snapshot.value;
      setState(() {
        isWaterPumpOn = waterPumpStatus == 'on';
      });
    });
  }

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    if (index == 1) {
      Navigator.pushNamed(context, '/editProfile');
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  void _logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context, title: 'Smart Greenhouse System'),
      drawer: CustomDrawer(onLogout: _logout),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GaugeWidget(label: 'Temperature', value: temperature, color: const Color(0xFF8B0000), maxValue: 100),
                      const SizedBox(width: 16), // Add space between indicators
                      GaugeWidget(label: 'Light', value: lightIntensity, color: const Color(0xFFB8860B), maxValue: 1023),
                    ],
                  ),
                  const SizedBox(height: 32), // Increase vertical space between rows
                  GaugeWidget(label: 'Humidity', value: humidity, color: const Color(0xFF00008B), maxValue: 100),
                ],
              ),
              const SizedBox(height: 20),
              Column(
                children: [
                  const Text('Actuators Status', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Text('fan: ${isFanOn ? 'on' : 'off'}', style: TextStyle(fontSize: 20, color: isFanOn ? Colors.red : Colors.red)),
                  Text('light: ${isLightOn ? 'on' : 'off'}', style: TextStyle(fontSize: 20, color: isLightOn ? Colors.yellow : Colors.yellow)),
                  Text('water pump: ${isWaterPumpOn ? 'on' : 'off'}', style: TextStyle(fontSize: 20, color: isWaterPumpOn ? Colors.blue : Colors.blue)),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.edit),
            label: 'Edit Info',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
