import 'package:flutter/material.dart';
import 'package:salamander_tracker/models/location.dart';
import 'package:salamander_tracker/new_sighting_screen.dart';
import 'candidate_details_screen.dart';
import 'models/sighting_evaluation.dart';
import 'globals.dart' as globals;
import 'processed_images_screen.dart';
import 'package:http/http.dart' as http;

class SightingCandidatePickerScreen extends StatelessWidget {
  final SightingEvaluation sightingEvaluation;
  final Location? location;
  const SightingCandidatePickerScreen(
      {super.key, required this.sightingEvaluation, required this.location});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Candidates'),
        ), // TODO show original image here as well
        body: SizedBox.expand(
          child: Column(
            children: [
              Text("Image quality: ${sightingEvaluation.quality}"),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NewSightingScreen(
                          individualId: null,
                          sightingId: sightingEvaluation.sightingId,
                          initialLocation: location,
                        ),
                      ),
                    );
                  },
                  child: const Text('None of these candidates is correct')),
          
              ElevatedButton(
                  onPressed: () {
                    http.delete(
                      Uri.parse('${globals.serverAddress}/sightings/${sightingEvaluation.sightingId}'),
                      headers: {"Authorization": globals.authHeader}).then((value) {
                      Navigator.pop(context);
                    });
                  },
                  child: const Text('Delete sighting')),
          
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProcessedImagesScreen(
                          sightingId: sightingEvaluation.sightingId,
                        ),
                      ),
                    );
                  },
                  child: const Text('See processed images')),
              SizedBox(
                height: 500,
                // implement GridView.builder
                child: sightingEvaluation.candidates.isNotEmpty ? GridView.builder(
                    gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 300,
                        childAspectRatio: 2 / 3,
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 20),
                    itemCount: sightingEvaluation.candidates.length,
                    itemBuilder: (BuildContext ctx, index) {
                      return Column(
                        children: [
                          Hero(
                              tag: sightingEvaluation
                                  .candidates[index].individual.id,
                              child: Image.network(
                                '${globals.serverAddress}/individuals/${sightingEvaluation.candidates[index].individual.id}/image',
                                height: 120,
                              )),
                          TextButton(
                            child: Text('${sightingEvaluation
                                  .candidates[index].individual.name}\nConfidence: ${sightingEvaluation.candidates[index].confidence}'),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CandidateDetailsScreen(
                                    candidate: sightingEvaluation.candidates[index],
                                    newSightingId: sightingEvaluation.sightingId,
                                    initialLocation: location,
                                  ),
                                ),
                              );
                            },
                          )
                        ],
                      );
                    }) : const Text('No candidates found'),
              ),
            ],
          ),
        ));
  }
}
