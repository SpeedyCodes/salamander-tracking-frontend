import 'package:flutter/material.dart';
import 'package:salamander_tracker/new_sighting_screen.dart';
import 'globals.dart' as globals;

class CandidateDetailsScreen extends StatelessWidget {
  final String individualId;
  final String sightingId;
  const CandidateDetailsScreen(
      {super.key, required this.individualId, required this.sightingId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Candidate Details'),
      ),
      body: Column(
        children: [
          Hero(
              tag: individualId,
              child: Image.network(
                  '${globals.serverAddress}/individuals/$individualId/image')),
          Text(
            'Salamander $individualId',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NewSightingScreen(
                    individualId: individualId,
                    sightingId: sightingId,
                  ),
                ),
              );
            },
            child: const Text('Pick'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Back'),
          ),
        ],
      ),
    );
  }
}