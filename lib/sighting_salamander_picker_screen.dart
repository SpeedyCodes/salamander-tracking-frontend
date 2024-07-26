import 'package:flutter/material.dart';
import 'candidate_details_screen.dart';

class SightingSalamanderPickerScreen extends StatelessWidget {
  const SightingSalamanderPickerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Candidates'),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        children: List.generate(20, (index) {
          return Column(
            children: [
              Hero(
                  tag: index,
                  child: Image.network('https://waarnemingen.be/media/photo/000/733/733977.jpg')
              ),
              TextButton(
                child: Text('Salamander $index'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CandidateDetailsScreen(index: index)),
                  );
                },
              )
            ],
          );
        }),
      ),
    );
  }
}
