// app/view/screens/results_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:io';

class ResultsScreen extends StatelessWidget {
  final Map<String, double> results;
  final File imageFile;

  const ResultsScreen(
      {Key? key, required this.results, required this.imageFile})
      : super(key: key);

  List<PieChartSectionData> showingSections() {
    return List.generate(results.length, (i) {
      final isTouched = false;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      final label = results.keys.elementAt(i);
      final value = results.values.elementAt(i);

      return PieChartSectionData(
        color: Colors.primaries[i % Colors.primaries.length],
        value: value,
        title: '${value.toStringAsFixed(2)}%',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: const Color(0xffffffff),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Results Analysis'),
        leading: IconButton(
          icon: const Icon(Icons.home),
          onPressed: () =>
              Navigator.of(context).popUntil((route) => route.isFirst),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            PieChart(
              PieChartData(
                sections: showingSections(),
                centerSpaceRadius: 70,
                sectionsSpace: 0,
              ),
            ),
            const SizedBox(height: 20),
            ...results.entries.map((entry) => ListTile(
                  title: Text(entry.key),
                  trailing: Text('${entry.value.toStringAsFixed(2)}%'),
                )),
            const SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                labelText: 'Doctor\'s Prediction',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Enregistrer'),
            ),
          ],
        ),
      ),
    );
  }
}
