import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_3d_controller/flutter_3d_controller.dart';
import 'dart:convert';

const List<String> SKIN_COLORS = [
  '#FFDBAC', // Light
  '#F1C27D', // Medium light
  '#C68642', // Medium
  '#8D5524', // Medium dark
  '#4C3024'  // Dark
];

const List<Map<String, String>> DRESSES = [
  {
    'id': 'dress',
    'name': 'Evening Dress',
    'modelPath': 'static/3D_CLOTHING/dress'
  }
];

const List<String> DRESS_COLORS = [
  '#000000', // Black
  '#FF0000', // Red
  '#00FF00', // Green
  '#0000FF', // Blue
  '#800080'  // Purple
];

const List<String> DRESS_SIZES = ['S', 'M', 'L'];

class AvatarScreen extends StatefulWidget {
  final Map<String, dynamic>? meshData;

  const AvatarScreen({Key? key, this.meshData}) : super(key: key);

  @override
  _AvatarScreenState createState() => _AvatarScreenState();
}

class _AvatarScreenState extends State<AvatarScreen> {
  String? avatarUrl;
  bool isLoading = false;
  String? errorMessage;
  String selectedSkinColor = SKIN_COLORS[0];
  String? selectedDress;
  String? selectedSize;
  String selectedDressColor = DRESS_COLORS[0];
  String sanitizeUrl(String url) {
    // Replace backslashes with forward slashes
    url = url.replaceAll('\\', '/');
    
    // Ensure there's a slash after the port number
    url = url.replaceAll(':5000static', ':5000/static');
    
    return url;
  }  

  @override
  void initState() {
    super.initState();
    if (widget.meshData != null) {
      _processAvatarData(widget.meshData!);
    }
  }

  void _processAvatarData(Map<String, dynamic> meshData) async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('http://192.168.1.4:5000/avatar/generate'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(meshData),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        
        if (responseData['avatar_file_path'] != null) {
          String rawUrl = 'http://192.168.1.4:5000${responseData['avatar_file_path']}';
          avatarUrl = sanitizeUrl(rawUrl);
          print('Avatar URL: $avatarUrl');

          final urlResponse = await http.get(Uri.parse(avatarUrl!));
          if (urlResponse.statusCode != 200) {
            throw Exception('Failed to load model from URL: $avatarUrl');
          }

          setState(() {
            isLoading = false;
          });
        } else {
          setState(() {
            errorMessage = 'Avatar file path is missing in the response.';
            isLoading = false;
          });
        }
      } else {
        setState(() {
          errorMessage = 'Failed to generate avatar: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error fetching avatar: $e';
        isLoading = false;
      });
    }
  }

  Widget _build3DViewer() {
    if (errorMessage != null) {
      return Center(child: Text(errorMessage!));
    }

    if (avatarUrl == null) {
      return const Center(child: Text('No avatar available'));
    }

    print('Building 3D Viewer with URL: $avatarUrl'); // Debug statement

    return Flutter3DViewer.obj(
      src: avatarUrl!,
      scale: 5,
      cameraX: 0,
      cameraY: 2,
      cameraZ: 4,
      //progressBarColor: Colors.orange,
      onProgress: (double progressValue) {
        debugPrint('Model loading progress: $progressValue');
      },
      onLoad: (String modelAddress) {
        debugPrint('Model loaded: $modelAddress');
        // Change the avatar color after the model is loaded
//_changeAvatarColor(selectedSkinColor);
      },
      onError: (String error) {
        debugPrint('Model failed to load: $error');
      },
    );
  }

  Widget _buildCustomizationPanel() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Skin Color', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Wrap(
            spacing: 8,
            children: SKIN_COLORS.map((color) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedSkinColor = color;
                  });
                },
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Color(int.parse('0xFF${color.substring(1)}')),
                    border: Border.all(
                      color: selectedSkinColor == color ? Colors.black : Colors.transparent,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              );
            }).toList(),
          ),
          SizedBox(height: 16),
          Text('Select Dress', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Wrap(
            spacing: 8,
            children: DRESSES.map((dress) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedDress = dress['id'];
                  });
                },
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: selectedDress == dress['id'] ? Colors.green[100] : Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(dress['name'] ?? 'Unknown Dress'),
                ),
              );
            }).toList(),
          ),
          SizedBox(height: 16),
          if (selectedDress != null) ...[
            Text('Select Size', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: DRESS_SIZES.map((size) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedSize = size;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: selectedSize == size ? Colors.blue[100] : Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(size),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 16),
            Text('Dress Color', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Wrap(
              spacing: 8,
              children: DRESS_COLORS.map((color) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedDressColor = color;
                    });
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Color(int.parse('0xFF${color.substring(1)}')),
                      border: Border.all(
                        color: selectedDressColor == color ? Colors.black : Colors.transparent,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Avatar Preview'),
      ),
      body: Column(
        children: [
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : _build3DViewer(),
          ),
          _buildCustomizationPanel(),
        ],
      ),
    );
  }
}

