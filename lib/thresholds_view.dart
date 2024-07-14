import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';

class ThresholdsView extends StatefulWidget {
  const ThresholdsView({super.key});

  @override
  _ThresholdsViewState createState() => _ThresholdsViewState();
}

class _ThresholdsViewState extends State<ThresholdsView> {
  double temperatureThreshold = 0;
  double soilMoistureThreshold = 0;
  double lightThreshold = 0;

  final DatabaseReference databaseReference = FirebaseDatabase.instance.ref();

  Future<void> _saveThresholds() async {
    try {
      await databaseReference.child('thresholds').set({
        'temperatureThreshold': temperatureThreshold,
        'soilMoistureThreshold': soilMoistureThreshold,
        'lightThreshold': lightThreshold,
      });

      // Save to history
      String timestamp = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
      await databaseReference.child('thresholds_history').child(timestamp).set({
        'temperatureThreshold': temperatureThreshold,
        'soilMoistureThreshold': soilMoistureThreshold,
        'lightThreshold': lightThreshold,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Thresholds saved successfully')),
      );

      setState(() {
        temperatureThreshold = 0;
        soilMoistureThreshold = 0;
        lightThreshold = 0;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save thresholds: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Set Thresholds',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        Slider(
          value: temperatureThreshold,
          min: 0,
          max: 100,
          divisions: 100,
          label: temperatureThreshold.round().toString(),
          onChanged: (double value) {
            setState(() {
              temperatureThreshold = value;
            });
          },
        ),
        Text('Temperature Threshold: ${temperatureThreshold.round()}°C'),
        const SizedBox(height: 20),
        Slider(
          value: soilMoistureThreshold,
          min: 0,
          max: 100,
          divisions: 100,
          label: soilMoistureThreshold.round().toString(),
          onChanged: (double value) {
            setState(() {
              soilMoistureThreshold = value;
            });
          },
        ),
        Text('Soil Moisture Threshold: ${soilMoistureThreshold.round()}%'),
        const SizedBox(height: 20),
        Slider(
          value: lightThreshold,
          min: 0,
          max: 100,
          divisions: 100,
          label: lightThreshold.round().toString(),
          onChanged: (double value) {
            setState(() {
              lightThreshold = value;
            });
          },
        ),
        Text('Light Threshold: ${lightThreshold.round()}%'),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: _saveThresholds,
          child: const Text('Save Thresholds'),
        ),
      ],
    );
  }
}
