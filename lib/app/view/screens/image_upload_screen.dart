// app/view/screens/image_upload_screen.dart
import 'dart:convert';
import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'dart:typed_data';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:doctor_skin/app/view/widgets/NavBar.dart';
import 'package:doctor_skin/app/view/widgets/rectangle_button.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:image_cropper/image_cropper.dart';

import 'package:doctor_skin/app/view/screens/ResultsScreen.dart';

Future<Uint8List> fileToUint8List(String filePath) async {
  File file = File(filePath);
  Uint8List bytes = await file.readAsBytes();
  return bytes;
}

Future<String?> getUserId() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString(
      'userId'); // This key must match the key used when saving the user ID during login
}

class UploadScreen extends StatefulWidget {
  const UploadScreen({Key? key}) : super(key: key);

  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  final ImagePicker _picker = ImagePicker();
  File? _imageFile;
  int _currentIndex = 2;

  void _onItemTapped(int newIndex) {
    setState(() {
      _currentIndex = newIndex;
    });
  }

  Future<void> _pickImage() async {
    final XFile? selectedImage =
        await _picker.pickImage(source: ImageSource.gallery);
    if (selectedImage != null) {
      setState(() {
        _imageFile = File(selectedImage.path);
      });
      _cropImage();
    }
  }

  Future<void> _takePhoto() async {
    final XFile? takenPhoto =
        await _picker.pickImage(source: ImageSource.camera);
    if (takenPhoto != null) {
      setState(() {
        _imageFile = File(takenPhoto.path);
      });
      _cropImage();
    }
  }

  Future<void> _sendImageAndGetResults() async {
    if (_croppedFile == null) return;

    // Predictions URL
    var predictionUri = Uri.parse('http://192.168.30.141:5000/predict');
    var request = http.MultipartRequest('POST', predictionUri)
      ..files
          .add(await http.MultipartFile.fromPath('file', _croppedFile!.path));

    var predictionResponse = await request.send();
    if (predictionResponse.statusCode == 200) {
      var responseData = await predictionResponse.stream.bytesToString();
      List<dynamic> resultList = json.decode(responseData);
      Map<String, String> results = {};
      for (var item in resultList) {
        String label = item['class_label'];
        String probability = '${item['probability'].toStringAsFixed(2)}%';
        results[label] = probability;
      }
      // Directly pass the resultList to save results
      _saveImageAndResults(json.encode(resultList), results);
    } else {
      _showErrorDialog('Failed to get predictions from the server.');
    }
  }

  Future<void> _saveImageAndResults(
      String resultListJson, Map<String, String> results) async {
    String? userId = await getUserId();
    if (userId == null) {
      _showErrorDialog("No user ID found. Please log in again.");
      return;
    }
    var saveUri = Uri.parse('http://192.168.30.141:3000/Images/upload');
    var saveRequest = http.MultipartRequest('POST', saveUri)
      ..files
          .add(await http.MultipartFile.fromPath('image', _croppedFile!.path))
      ..fields['user'] = userId
      ..fields['predictions'] = resultListJson;

    var saveResponse = await saveRequest.send();
    if (saveResponse.statusCode == 201) {
      final responseData = await saveResponse.stream.bytesToString();
      Map<String, dynamic> data = json.decode(responseData);
      var imageId = data['imageId'] ?? '';
      Uint8List imageBytes = await fileToUint8List(_croppedFile!.path);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultsScreen(
            resultss: results,
            imageFile: imageBytes,
            imageid: imageId,
          ),
        ),
      );
    } else {
      var responseBody = await saveResponse.stream.bytesToString();
      _showErrorDialog(responseBody);
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: const Text('Close'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }

  CroppedFile? _croppedFile;

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
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 40),
              child: Text(
                'Upload Image',
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 5, 19,
                      145), // Even darker shade for better visibility
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
            ),
          ),
          ListView(
            padding: const EdgeInsets.only(top: 160),
            children: [
              if (_imageFile != null)
                Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: FileImage(_imageFile!),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(
                      20), // Add padding around the button for better spacing
                  child: GestureDetector(
                    onTap: _sendImageAndGetResults,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 50,
                          vertical: 20), // Control the size via padding
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF82b3c9), Color(0xFFb3e5fc)],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            offset: Offset(0, 3),
                            blurRadius: 5,
                          )
                        ],
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Text(
                        'Analyze Image',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize:
                              16, // Adjust font size according to your preference
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
          Align(
            alignment: Alignment(0.7, 0.7),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CustomButton(
                    label: 'Select a Photo',
                    onPressed: _pickImage,
                    depth: 8.0,
                    imagePath: 'assets/images/gallery.png',
                  ),
                  CustomButton(
                    label: 'Take a Photo',
                    onPressed: _takePhoto,
                    depth: 8.0,
                    imagePath: 'assets/images/camera.png',
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 100,
              child: CustomBottomNavBar(
                currentIndex: _currentIndex,
                onChange: _onItemTapped,
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

  Future<void> _cropImage() async {
    if (_imageFile != null) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: _imageFile!.path,
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 100,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: false,
            aspectRatioPresets: [
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPresetCustom(),
            ],
          ),
        ],
      );
      if (croppedFile != null) {
        setState(() {
          _croppedFile = croppedFile;
        });
        _sendImageAndGetResults();
      }
    }
  }
}

class CropAspectRatioPresetCustom implements CropAspectRatioPresetData {
  @override
  (int, int)? get data => (2, 3);

  @override
  String get name => '2x3 (customized)';
}
