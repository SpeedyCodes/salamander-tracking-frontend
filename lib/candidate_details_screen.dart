import 'package:flutter/material.dart';
import 'package:salamander_tracker/models/location.dart';
import 'package:salamander_tracker/models/sighting_evaluation.dart';
import 'package:salamander_tracker/new_sighting_screen.dart';
import 'globals.dart' as globals;

class CandidateDetailsScreen extends StatelessWidget {
  final Candidate candidate;
  final int newSightingId;
  final Location? initialLocation;
  const CandidateDetailsScreen(
      {super.key, required this.candidate , required this.newSightingId, required this.initialLocation});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Candidate Details'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: SizedBox(
              height: 200.0,
              child: ListView(
                scrollDirection: Axis.vertical,
                children: [Hero(
              tag: candidate.individual.id,
              child: Image.network(
                  '${globals.serverAddress}/individuals/${candidate.individual.id}/image'))],
              ),
            )),
          ),
          Text(
            candidate.individual.name,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NewSightingScreen(
                    individualId: candidate.individual.id,
                    sightingId: newSightingId,
                    initialLocation: initialLocation,
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
          const Text("new photo: "),
          Expanded(
            child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: SizedBox(
              height: 200.0,
              child: ListView(
                scrollDirection: Axis.vertical,
                children: [Image.network('${globals.serverAddress}/sightings/$newSightingId/image')],
              ),
            )),
          )
          ,
        ],
      ),
    );
  }
}