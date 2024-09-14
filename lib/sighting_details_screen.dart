

import 'package:flutter/material.dart';
import 'package:salamander_tracker/models/sighting.dart';
import 'globals.dart' as globals;
import 'utils.dart';

class SightingDetailsScreen extends StatelessWidget {
  final Sighting sighting;
  const SightingDetailsScreen({super.key, required this.sighting});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sighting Details'),
      ),
      body: Column(
        children: [
          Text('Sighting Details for ${sighting.individualName!}'),
          Text('Sighted on ${formatDate(sighting.date)}'),
          Image.network(
                  '${globals.serverAddress}/individuals/${sighting.individualId}/image')
        ],
      ),
    );
  }
}