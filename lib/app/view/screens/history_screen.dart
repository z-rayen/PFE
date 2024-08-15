// app/view/screens/history_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:typed_data';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'package:doctor_skin/app/view/widgets/NavBar.dart';
import 'package:doctor_skin/app/view/screens/ResultsScreen.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<Map<String, dynamic>> historyData = [];

  @override
  void initState() {
    super.initState();
    fetchHistory();
  }

  Future<void> fetchHistory() async {
    String? userId = await getUserId();
    if (userId == null) {
      print("User ID is not available.");
      return;
    }

    var uri =
        Uri.parse('http://192.168.30.141:3000/Images/user/$userId/uploads');
    try {
      var response = await http.get(uri);
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          historyData = data.map((item) {
            Uint8List imageBytes =
                base64Decode(item['imageData'].replaceAll("\n", ""));
            Map<String, String> predictionsText = {};
            item['predictions'].forEach((pred) {
              predictionsText[pred['class_label']] = '${pred['probability']}%';
            });
            String formattedDate = DateFormat('MMMM dd, yyyy')
                .format(DateTime.parse(item['createdAt']));

            return {
              'imageBytes': imageBytes, // Store the decoded image bytes
              'result': predictionsText,
              'date': formattedDate,
              'imageId': item['_id'],
            };
          }).toList();
        });
      } else {
        print("Failed to fetch history: ${response.body}");
      }
    } catch (e) {
      print("Error occurred while fetching history: $e");
    }
  }

  Future<String?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/bg2.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          ListView.builder(
            itemCount: historyData.length,
            itemBuilder: (context, index) {
              var entry = historyData[index];
              String resultSummary = entry['result']
                  .entries
                  .map((e) => '${e.key}: ${e.value}')
                  .join(', ');
              return Card(
                margin: const EdgeInsets.all(8),
                child: ListTile(
                  leading: Image.memory(
                      entry['imageBytes']), // Display the image from bytes
                  title: Text(resultSummary),
                  subtitle: Text(entry['date']),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ResultsScreen(
                          resultss: entry['result'],
                          imageFile: entry['imageBytes'],
                          imageid: entry['imageId'],
                        ),
                      ),
                    );
                    // Handle tap, possibly show more details or options
                  },
                ),
              );
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 100,
              child: CustomBottomNavBar(
                currentIndex: 1, // Assuming the history page is at index 1
                onChange: (index) {
                  // Handle navigation
                },
                imagePaths: [
                  'assets/images/home_icon.png',
                  'assets/images/history_icon.png',
                  'assets/images/camera_icon.png',
                  'assets/images/help_icon.png',
                  'assets/images/profile_icon.png'
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
