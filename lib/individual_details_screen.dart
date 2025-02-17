

import 'package:flutter/material.dart';
import 'package:salamander_tracker/models/individual.dart';
import 'globals.dart' as globals;
import 'models/sighting.dart';
import 'sighting_details_screen.dart';
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
      body: 
      ListView.builder(
                itemCount: widget.sightings.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: widget.sightings[index].location != null ? Text(
                        "Spotted at ${widget.sightings[index].location!.name} on ${formatDate(widget.sightings[index].date)}") : null,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SightingDetailsScreen(
                                sighting: widget.sightings[index])),
                      );
                    },
                  );
                },
              ),
    );
  }
}