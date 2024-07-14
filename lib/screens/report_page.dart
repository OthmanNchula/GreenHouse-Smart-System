import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  DateTimeRange? _dateRange;
  List<Map<String, dynamic>> _data = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() async {
    if (_dateRange == null) {
      return;
    }

    DatabaseReference databaseReference = FirebaseDatabase.instance.ref().child('data');
    Query query = databaseReference
        .orderByKey()
        .startAt(_dateRange!.start.toIso8601String())
        .endAt(_dateRange!.end.toIso8601String());

    DataSnapshot snapshot = await query.get();

    List<Map<String, dynamic>> data = [];
    if (snapshot.exists) {
      Map<String, dynamic> fetchedData = snapshot.value as Map<String, dynamic>;
      fetchedData.forEach((key, value) {
        data.add({
          'date': DateTime.parse(key),
          'temperature': value['temperature'],
          'light': value['light'],
          'soilMoisture': value['soilMoisture'],
        });
      });

      setState(() {
        _data = data;
      });
    }
  }

  void _selectDateRange() async {
    DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        _dateRange = picked;
      });
      _fetchData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Report & Analysis'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Report', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Select Date Range:', style: TextStyle(fontSize: 16)),
                  ElevatedButton(
                    onPressed: _selectDateRange,
                    child: const Text('Pick Date Range'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              if (_dateRange != null)
                Text('Selected Range: ${_dateRange!.start.toLocal()} - ${_dateRange!.end.toLocal()}'),
              const SizedBox(height: 20),
              const Text('Summary', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              _buildSummary(),
              const SizedBox(height: 20),
              const Text('Detailed Data', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              _buildDetailedDataTable(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummary() {
    if (_data.isEmpty) {
      return const Text('No data available for the selected range.');
    }

    double avgTemp = _data.map((e) => e['temperature']).reduce((a, b) => a + b) / _data.length;
    double minTemp = _data.map((e) => e['temperature']).reduce((a, b) => a < b ? a : b);
    double maxTemp = _data.map((e) => e['temperature']).reduce((a, b) => a > b ? a : b);

    double avgLight = _data.map((e) => e['light']).reduce((a, b) => a + b) / _data.length;
    double minLight = _data.map((e) => e['light']).reduce((a, b) => a < b ? a : b);
    double maxLight = _data.map((e) => e['light']).reduce((a, b) => a > b ? a : b);

    double avgMoisture = _data.map((e) => e['soilMoisture']).reduce((a, b) => a + b) / _data.length;
    double minMoisture = _data.map((e) => e['soilMoisture']).reduce((a, b) => a < b ? a : b);
    double maxMoisture = _data.map((e) => e['soilMoisture']).reduce((a, b) => a > b ? a : b);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildSummaryCard('Temperature', 'Min: $minTemp°C\nMax: $maxTemp°C\nAvg: ${avgTemp.toStringAsFixed(1)}°C'),
        _buildSummaryCard('Light', 'Min: $minLight\nMax: $maxLight\nAvg: ${avgLight.toStringAsFixed(1)}'),
        _buildSummaryCard('Soil Moisture', 'Min: $minMoisture%\nMax: $maxMoisture%\nAvg: ${avgMoisture.toStringAsFixed(1)}%'),
      ],
    );
  }

  Widget _buildSummaryCard(String title, String data) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text(data),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailedDataTable() {
    if (_data.isEmpty) {
      return const Text('No data available for the selected range.');
    }

    return Table(
      border: TableBorder.all(),
      children: [
        TableRow(
          children: [
            _buildTableCell('Date'),
            _buildTableCell('Temperature'),
            _buildTableCell('Light'),
            _buildTableCell('Soil Moisture'),
          ],
        ),
        ..._data.map((data) => TableRow(
          children: [
            _buildTableCell(data['date'].toString()),
            _buildTableCell(data['temperature'].toString()),
            _buildTableCell(data['light'].toString()),
            _buildTableCell(data['soilMoisture'].toString()),
          ],
        )).toList(),
      ],
    );
  }

  Widget _buildTableCell(String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(text),
    );
  }
}
