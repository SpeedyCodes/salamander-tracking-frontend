import 'package:flutter/material.dart';
import 'package:salamander_tracker/new_sighting_screen.dart';
import 'candidate_details_screen.dart';
import 'models/sighting_evaluation.dart';

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
            TextButton(
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
                child: Text('None of these candidates is correct')),
            SizedBox(
              height: 50,
              // implement GridView.builder
              child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 150,
                      childAspectRatio: 2 / 3,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20),
                  itemCount: sightingEvaluation.candidates.length,
                  itemBuilder: (BuildContext ctx, index) {
                    return Column(
                      children: [
                        Hero(
                            tag: sightingEvaluation
                                .candidates[index].individualId,
                            child: Container(
                              child: Image.network(
                                'http://192.168.0.141:5000/individuals/${sightingEvaluation.candidates[index].individualId}/image',
                                height: 20,
                              ),
                            )),
                        TextButton(
                          child: Text('Salamander $index'),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CandidateDetailsScreen(
                                  individualId: sightingEvaluation
                                      .candidates[index].individualId,
                                  sightingId: sightingEvaluation.sightingId,
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
