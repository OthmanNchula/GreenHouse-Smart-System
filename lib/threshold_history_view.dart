import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class ThresholdHistoryView extends StatefulWidget {
  const ThresholdHistoryView({super.key});

  @override
  _ThresholdHistoryViewState createState() => _ThresholdHistoryViewState();
}

class _ThresholdHistoryViewState extends State<ThresholdHistoryView> {
  final DatabaseReference databaseReference = FirebaseDatabase.instance.ref().child('thresholds_history');
  Map<String, List<Map<String, dynamic>>> thresholdsByDate = {};
  bool isLoading = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    _loadThresholdHistory();
  }

  void _loadThresholdHistory() {
    databaseReference.onValue.listen((event) {
      final data = event.snapshot.value as Map?;
      if (data != null) {
        setState(() {
          thresholdsByDate = _groupThresholdsByDate(data);
          isLoading = false;
          hasError = false;
        });
      } else {
        setState(() {
          isLoading = false;
          hasError = true;
        });
      }
    }, onError: (error) {
      setState(() {
        isLoading = false;
        hasError = true;
      });
      if (kDebugMode) {
        print('Error fetching threshold history: $error');
      }
    });
  }

  Map<String, List<Map<String, dynamic>>> _groupThresholdsByDate(Map data) {
    Map<String, List<Map<String, dynamic>>> groupedData = {};

    data.forEach((key, value) {
      final date = key.toString().split(' ')[0]; // Group by date part of the key
      if (!groupedData.containsKey(date)) {
        groupedData[date] = [];
      }
      groupedData[date]!.add({
        'temperatureThreshold': value['temperatureThreshold'],
        'soilMoistureThreshold': value['soilMoistureThreshold'],
        'lightThreshold': value['lightThreshold'],
        'time': key,
      });
    });

    if (kDebugMode) {
      print('Grouped Data: $groupedData');
    }
    return groupedData;
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (hasError) {
      return const Center(child: Text('Failed to load threshold history.'));
    }

    return ListView(
      children: thresholdsByDate.entries.map((entry) {
        final date = entry.key;
        final thresholds = entry.value;
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: ExpansionTile(
            title: Text(date, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            children: thresholds.map((threshold) {
              return ListTile(
                title: Text('Temperature: ${threshold['temperatureThreshold']}°C'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Soil Moisture: ${threshold['soilMoistureThreshold']}%'),
                    Text('Light: ${threshold['lightThreshold']}%'),
                    Text('Time: ${threshold['time']}'),
                  ],
                ),
              );
            }).toList(),
          ),
        );
      }).toList(),
    );
  }
}
