import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'sighting_salamander_picker_screen.dart';

class NewSightingScreen extends StatefulWidget {
  const NewSightingScreen({super.key});

  @override
  State<NewSightingScreen> createState() => _NewSightingScreenState();
}

class _NewSightingScreenState extends State<NewSightingScreen> {
  late XFile? imageFile = null;

  Future<void> pickImage(ImageSource source) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile = await _picker.pickImage(source: source);
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
                      Uint8List body = await imageFile!.readAsBytes();
                      http.post(
                        Uri.parse('http://192.168.0.140:5000/recognize'),
                        body: body,
                      )
                          .then((response) {
                        print(response.body);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const SightingSalamanderPickerScreen()),
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
