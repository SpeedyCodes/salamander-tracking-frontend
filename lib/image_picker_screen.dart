import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:salamander_tracker/models/sighting_evaluation.dart';
import 'models/location.dart';
import 'new_location_screen.dart';
import 'sighting_salamander_picker_screen.dart';
import 'dart:convert';

import 'globals.dart' as globals;
import 'utils.dart';

class ImagePickerScreen extends StatefulWidget {
  const ImagePickerScreen({super.key});

  @override
  State<ImagePickerScreen> createState() => _ImagePickerScreenState();
}

class _ImagePickerScreenState extends State<ImagePickerScreen> {
  late XFile? imageFile = null;
  
  var locations = <Location>[];
  Location? locationSelected = null;

  Future<void> pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        imageFile = pickedFile;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchLocations().then(
      (value) => setState(() {
        locations = value;
        locationSelected = locations.isEmpty ? null : locations[0];
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Sighting'),
      ),
      body: Center(
        child: Column(children: [
          Expanded(
              child: SizedBox(
            height: 200.0,
            child: ListView(
              scrollDirection: Axis.vertical,
              children: [
                if (imageFile != null) ...[
                  Image.network(imageFile!.path),
                  ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => NewLocationScreen()),
                    ).then(
                      (value) => {
                        if (value != null)
                          {
                            setState(() {
                              locations.add(value as Location);
                              locationSelected = value;
                            })
                          }
                      },
                    );
                    
                  },
                  child: const Text('Create new location')),
              const Text('Location:'),
              DropdownButton<Location>(
                value: locationSelected,
                elevation: 16,
                style: const TextStyle(color: Colors.deepPurple),
                underline: Container(
                  height: 2,
                  color: Colors.deepPurpleAccent,
                ),
                onChanged: (Location? value) {
                  // This is called when the user selects an item.
                  setState(() {
                    locationSelected = value!;
                  });
                },
                items: locations.map<DropdownMenuItem<Location>>((Location location) {
                  return DropdownMenuItem<Location>(
                    value: location,
                    child: Text(location.name),
                  );
                }).toList(),
              ),
                  ElevatedButton(
                    child: const Text('Clear image'),
                    onPressed: () {
                      setState(() {
                        imageFile = null;
                      });
                    },
                  ),
                  ElevatedButton(
                    child: const Text('Upload image'),
                    onPressed: () async {
                      showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (_) {
                            return const Dialog(
                              // The background color
                              backgroundColor: Colors.transparent,
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 20),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // The loading indicator
                                    CircularProgressIndicator(),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    // Some text
                                    Text('Server is processing the image...')
                                  ],
                                ),
                              ),
                            );
                          });

                      Uint8List body = await imageFile!.readAsBytes();
                      http
                          .post(
                        Uri.parse('${globals.serverAddress}/store_sighting${locationSelected != null ? '?location_id=${locationSelected!.id}' : ''}'),
                        headers: {"Authorization": globals.authHeader},
                        body: body,
                      )
                          .then((response) {
                        if (response.statusCode == 400) {
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                              content: Text(
                                  "This image's quality is too low. Please try another image.")));
                          return;
                        }
                        final SightingEvaluation sightingEvaluation =
                            SightingEvaluation.fromJson(
                                json.decode(response.body));
                        Navigator.of(context).pop();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  SightingCandidatePickerScreen(
                                      sightingEvaluation: sightingEvaluation)),
                        );
                      });
                    },
                  ),
                ],
              ],
            ),
          )),
          ElevatedButton(
              child: const Text('Load image from storage'),
              onPressed: () {
                pickImage(ImageSource.gallery);
              }),
          ElevatedButton(
              child: const Text('Take a picture'),
              onPressed: () {
                pickImage(ImageSource.camera);
              }),
        ]),
      ),
    );
  }
}
