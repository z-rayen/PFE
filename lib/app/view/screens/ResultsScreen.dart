// app/view/screens/ResultsScreen.dart
import 'dart:io';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:typed_data';

class ResultsScreen extends StatelessWidget {
  final Map<String, String> resultss;
  final Uint8List imageFile;
  final String imageid; // Passed image file

  const ResultsScreen(
      {Key? key,
      required this.resultss,
      required this.imageFile,
      required this.imageid})
      : super(key: key);

  List<PieChartSectionData> getSections() {
    final List<PieChartSectionData> sections = [];
    int index = 0; // Maintain index for color differentiation
    bool allBelowThreshold = true;

    resultss.forEach((key, value) {
      final double percentage = double.parse(value.replaceAll('%', ''));
      if (percentage >= 40) {
        allBelowThreshold = false;
      }
      final color = Colors.primaries[index % Colors.primaries.length];
      sections.add(PieChartSectionData(
        color: color,
        value: percentage,
        title: '${percentage.toStringAsFixed(2)}%',
        radius: 100,
        titleStyle: TextStyle(
          fontSize: 18,
          color: Colors.white,
        ),
        titlePositionPercentageOffset: 0.55,
      ));
      index++; // Increment index for next color
    });

    if (allBelowThreshold) {
      sections.add(PieChartSectionData(
        color: Colors.green,
        value: 100,
        title: 'Healthy',
        radius: 100,
        titleStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ));
    }

    return sections;
  }

  @override
  Widget build(BuildContext context) {
    Future<void> updateDoctorPrediction(
        String imageId, String prediction) async {
      var updateUri = Uri.parse(
          'http://192.168.30.141:3000/Images/update-doctor-prediction/$imageId');
      try {
        var response = await http.put(
          updateUri,
          headers: <String, String>{
            'Content-Type': 'application/json',
          },
          body: jsonEncode({'doctorPrediction': prediction}),
        );

        if (response.statusCode == 200) {
          print("Update successful");
          // Optionally navigate or show a success message
        } else {
          print("Failed to update: ${response.body}");
        }
      } catch (e) {
        print("Error occurred: $e");
      }
    }

    TextEditingController doctorNoteController = TextEditingController();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bg2.png"),
            fit: BoxFit.cover,
          ),
        ),
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 40),
            Text(
              "Results Analysis",
              style: TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(
                    255, 5, 19, 145), // Even darker shade for better visibility
                shadows: [
                  Shadow(
                    offset: Offset(1.0, 1.0),
                    blurRadius: 3.0,
                    color: Color.fromRGBO(0, 0, 0, 0.25),
                  ),
                ],
                fontFamily: 'Open Sans',
              ),
            ),
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  PieChart(
                    PieChartData(
                      sections: getSections(),
                      centerSpaceRadius: 60, // Smaller radius to fit the image
                      sectionsSpace: 2,
                      startDegreeOffset: -90,
                    ),
                  ),
                  CircleAvatar(
                    backgroundImage:
                        MemoryImage(imageFile), // Use the passed image
                    radius: 30, // Adjust the radius as needed
                  ),
                ],
              ),
            ),
            TextField(
              controller: doctorNoteController,
              decoration: InputDecoration(
                labelText: 'Doctor\'s Prediction',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            Wrap(
              children: resultss.entries.map((entry) {
                final color = Colors.primaries[
                    resultss.keys.toList().indexOf(entry.key) %
                        Colors.primaries.length];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(Icons.circle, color: color),
                      SizedBox(width: 8),
                      Text('${entry.key}: ${entry.value}'),
                    ],
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  if (doctorNoteController.text.isNotEmpty) {
                    updateDoctorPrediction(imageid, doctorNoteController.text);
                  } else {
                    print("No prediction entered");
                  }
                },
                child: Text('Enregistrer'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.blueAccent, // Button color
                  textStyle: TextStyle(color: Colors.white), // Text color
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
