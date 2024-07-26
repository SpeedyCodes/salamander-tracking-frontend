import 'package:flutter/material.dart';

class CandidateDetailsScreen extends StatelessWidget {
  final int index;
  const CandidateDetailsScreen({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Candidate Details'),
      ),
      body: Column(
        children: [
          Hero(
                  tag: index,
                  child: Image.network('https://waarnemingen.be/media/photo/000/733/733977.jpg')
          ),
          Text(
            'Salamander $index',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          Text(
            'The salamander is a small amphibian that lives in the water.',
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
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