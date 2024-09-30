import 'package:flutter/material.dart';
import 'package:salamander_tracker/new_sighting_screen.dart';
import 'candidate_details_screen.dart';
import 'models/sighting_evaluation.dart';
import 'globals.dart' as globals;

class SightingCandidatePickerScreen extends StatelessWidget {
  final SightingEvaluation sightingEvaluation;
  const SightingCandidatePickerScreen(
      {super.key, required this.sightingEvaluation});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Candidates'),
        ), // TODO show original image here as well
        body: Column(
          children: [
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NewSightingScreen(
                        individualId: null,
                        sightingId: sightingEvaluation.sightingId,
                      ),
                    ),
                  );
                },
                child: const Text('None of these candidates is correct')),
            SizedBox(
              height: 500,
              // implement GridView.builder
              child: GridView.builder(
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
                                ),
                              ),
                            );
                          },
                        )
                      ],
                    );
                  }),
            ),
          ],
        ));
  }
}
