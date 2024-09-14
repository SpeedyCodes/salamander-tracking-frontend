

import 'package:flutter/material.dart';
import 'package:salamander_tracker/models/individual.dart';
import 'globals.dart' as globals;
import 'models/sighting.dart';
import 'utils.dart';
import 'package:http/http.dart' as http;

class IndividualDetailsScreen extends StatefulWidget {
  final Individual individual;
  List<Sighting> sightings = [];
  IndividualDetailsScreen({super.key, required this.individual});

  @override
  State<IndividualDetailsScreen> createState() => _IndividualDetailsScreenState();
}

class _IndividualDetailsScreenState extends State<IndividualDetailsScreen> {


  @override
  void initState() {
    super.initState();
    fetchSightings();
  }

  void fetchSightings() async {
    var response = await http.get(
        Uri.parse('${globals.serverAddress}/sightings?individual_id=${widget.individual.id}'));
    if (response.statusCode == 200) {
      setState(() {
        widget.sightings = sightingsFromJson(response.body);
      });
    } else {
      throw Exception('Failed to load sightings');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Individual Details'),
      ),
      body: Column(
        children: [
          Text('Individual Details for ${widget.individual.name}'),
          for (var sighting in widget.sightings)
            Column(
              children: [
                Text('Sighted on ${formatDate(sighting.date)}'),
                Image.network(
                    '${globals.serverAddress}/sightings/${sighting.id}/image')
              ],
            )
        ],
      ),
    );
  }
}