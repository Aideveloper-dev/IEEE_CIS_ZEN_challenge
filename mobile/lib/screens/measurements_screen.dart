import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Import the http package
import 'dart:convert'; // Import for JSON encoding
import 'avatar_screen.dart'; // Ensure you import the AvatarScreen

class MeasurementsScreen extends StatefulWidget {
  const MeasurementsScreen({Key? key}) : super(key: key);

  @override
  _MeasurementsScreenState createState() => _MeasurementsScreenState();
}

class _MeasurementsScreenState extends State<MeasurementsScreen> {
  final TextEditingController neckGirthController = TextEditingController();
  final TextEditingController backNeckToWaistController = TextEditingController();
  final TextEditingController upperArmGirthRController = TextEditingController();
  final TextEditingController upperArmGirthLController = TextEditingController();
  final TextEditingController backNeckToWristRController = TextEditingController();
  final TextEditingController backNeckToWristLController = TextEditingController();
  final TextEditingController acrossShoulderWidthController = TextEditingController();
  final TextEditingController bustGirthController = TextEditingController();
  final TextEditingController waistGirthController = TextEditingController();
  final TextEditingController hipGirthController = TextEditingController();
  final TextEditingController thighGirthRController = TextEditingController();
  final TextEditingController thighGirthLController = TextEditingController();
  final TextEditingController totalCrotchLengthController = TextEditingController();
  final TextEditingController insideLegHeightController = TextEditingController();

  String selectedGender = 'Female'; // Default gender

  void _submitMeasurements(BuildContext context) async {
    // Collect the measurements
    Map<String, dynamic> measurements = {
      'Gender': selectedGender,
      'NeckGirth': double.tryParse(neckGirthController.text) ?? 0.0,
      'BackNeckToWaist': double.tryParse(backNeckToWaistController.text) ?? 0.0,
      'UpperArmGirthR': double.tryParse(upperArmGirthRController.text) ?? 0.0,
      'UpperArmGirthL': double.tryParse(upperArmGirthLController.text) ?? 0.0,
      'BackNeckToWristR': double.tryParse(backNeckToWristRController.text) ?? 0.0,
      'BackNeckToWristL': double.tryParse(backNeckToWristLController.text) ?? 0.0,
      'AcrossShoulderWidth': double.tryParse(acrossShoulderWidthController.text) ?? 0.0,
      'BustGirth': double.tryParse(bustGirthController.text) ?? 0.0,
      'WaistGirth': double.tryParse(waistGirthController.text) ?? 0.0,
      'HipGirth': double.tryParse(hipGirthController.text) ?? 0.0,
      'ThighGirthR': double.tryParse(thighGirthRController.text) ?? 0.0,
      'ThighGirthL': double.tryParse(thighGirthLController.text) ?? 0.0,
      'TotalCrotchLength': double.tryParse(totalCrotchLengthController.text) ?? 0.0,
      'InsideLegHeight': double.tryParse(insideLegHeightController.text) ?? 0.0,
    };

    // Print the measurements for debugging
    print('Measurements: $measurements');

    // Send the measurements to the backend
    try {
      final response = await http.post(
        Uri.parse('http://192.168.1.4:5000/avatar/generate'), // Update with your backend URL
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(measurements), // Convert the measurements to JSON
      );

      if (response.statusCode == 200) {
        // If the server returns a 200 OK response, navigate to the AvatarScreen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AvatarScreen(meshData: measurements), // Pass the measurements to AvatarScreen
          ),
        );
      } else {
        // Handle error response
        print('Failed to generate avatar: ${response.statusCode}');
        // Optionally show an error message to the user
      }
    } catch (e) {
      print('Error sending measurements: $e');
      // Optionally show an error message to the user
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Input Your Measurements')),
      body: SingleChildScrollView( // Wrap the Column in a SingleChildScrollView
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                value: selectedGender,
                decoration: InputDecoration(labelText: 'Gender'),
                items: const [
                  DropdownMenuItem(value: 'Female', child: Text('Female')),
                  DropdownMenuItem(value: 'Male', child: Text('Male')),
                ],
                onChanged: (value) {
                  setState(() {
                    selectedGender = value!;
                  });
                },
              ),
              TextField(
                controller: neckGirthController,
                decoration: InputDecoration(labelText: 'Neck Girth (mm)'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: backNeckToWaistController,
                decoration: InputDecoration(labelText: 'Back Neck to Waist (mm)'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: upperArmGirthRController,
                decoration: InputDecoration(labelText: 'Upper Arm Girth Right (mm)'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: upperArmGirthLController,
                decoration: InputDecoration(labelText: 'Upper Arm Girth Left (mm)'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: backNeckToWristRController,
                decoration: InputDecoration(labelText: 'Back Neck to Wrist Right (mm)'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: backNeckToWristLController,
                decoration: InputDecoration(labelText: 'Back Neck to Wrist Left (mm)'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: acrossShoulderWidthController,
                decoration: InputDecoration(labelText: 'Across Shoulder Width (mm)'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: bustGirthController,
                decoration: InputDecoration(labelText: 'Bust Girth (mm)'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: waistGirthController,
                decoration: InputDecoration(labelText: 'Waist Girth (mm)'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: hipGirthController,
                decoration: InputDecoration(labelText: 'Hip Girth (mm)'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: thighGirthRController,
                decoration: InputDecoration(labelText: 'Thigh Girth Right (mm)'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: thighGirthLController,
                decoration: InputDecoration(labelText: 'Thigh Girth Left (mm)'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: totalCrotchLengthController,
                decoration: InputDecoration(labelText: 'Total Crotch Length (mm)'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: insideLegHeightController,
                decoration: InputDecoration(labelText: 'Inside Leg Height (mm)'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _submitMeasurements(context),
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}