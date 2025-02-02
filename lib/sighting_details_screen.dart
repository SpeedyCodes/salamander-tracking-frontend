

import 'package:flutter/material.dart';
import 'package:salamander_tracker/models/sighting.dart';
import 'globals.dart' as globals;
import 'utils.dart';
import 'processed_images_screen.dart';

class SightingDetailsScreen extends StatelessWidget {
  final Sighting sighting;
  const SightingDetailsScreen({super.key, required this.sighting});

  @override
  Widget build(BuildContext context) {
    onPressed() {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProcessedImagesScreen(sightingId: sighting.id),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sighting Details'),
      ),
      body: Column(
        children: [
          Text('Sighting Details for ${sighting.individual!.name}'),
          Text('Sighted on ${formatDate(sighting.date)}'),
          TextButton(onPressed: onPressed, child: const Text('See processed images')),
          Image.network(
                  '${globals.serverAddress}/individuals/${sighting.individualId}/image')
        ],
      ),
    );
  }
}