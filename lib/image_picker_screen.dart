import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:salamander_tracker/models/sighting_evaluation.dart';
import 'sighting_salamander_picker_screen.dart';
import 'dart:convert';

import 'globals.dart' as globals;

class ImagePickerScreen extends StatefulWidget {
  const ImagePickerScreen({super.key});

  @override
  State<ImagePickerScreen> createState() => _ImagePickerScreenState();
}

class _ImagePickerScreenState extends State<ImagePickerScreen> {
  late XFile? imageFile = null;

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
                  Image.file(File(imageFile!.path)),
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
                        Uri.parse('${globals.serverAddress}/store_sighting'),
                        body: body,
                      )
                          .then((response) {
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
