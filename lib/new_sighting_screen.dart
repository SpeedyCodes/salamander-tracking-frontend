import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:salamander_tracker/models/location.dart';
import 'package:salamander_tracker/new_location_screen.dart';
import 'globals.dart' as globals;
import 'package:salamander_tracker/utils.dart';

class NewSightingScreen extends StatefulWidget {
  final int? individualId;
  final int sightingId;
  final Location? initialLocation;
  const NewSightingScreen(
      {super.key,
      required this.individualId,
      required this.sightingId,
      required this.initialLocation});

  @override
  State<NewSightingScreen> createState() => _NewSightingScreenState();
}

class _NewSightingScreenState extends State<NewSightingScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String nickname = '';

  List<Location> locations = [];
  Location? locationSelected = null;

  DateTime spottedAt = DateTime.now();

  @override
  void initState() {
    super.initState();
    fetchLocations().then(
      (value) => setState(() {
        if (widget.initialLocation != null) {
          locations.add(widget.initialLocation!);
          locationSelected = widget.initialLocation;
        } else {
          locations = value;
          locationSelected = locations.isEmpty ? null : locations[0];
        }
      }),
    );
  }

  // on init, fetch locations
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('New Sighting'),
        ),
        body: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // ElevatedButton(onPressed: (){
              //   Navigator.push(
              //             context,
              //             MaterialPageRoute(
              //                 builder: (context) =>
              //                     const LocationPicker()),
              //           );
              // }, child: const Text('Pick location')),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => NewLocationScreen()),
                    ).then(
                      (value) => {
                        if (value != null)
                          {
                            setState(() {
                              locations.add(value as Location);
                              locationSelected = value;
                            })
                          }
                      },
                    );
                  },
                  child: const Text('Create new location')),
              const Text('Location:'),
              DropdownButton<Location>(
                value: locationSelected,
                elevation: 16,
                style: const TextStyle(color: Colors.deepPurple),
                underline: Container(
                  height: 2,
                  color: Colors.deepPurpleAccent,
                ),
                onChanged: (Location? value) {
                  // This is called when the user selects an item.
                  setState(() {
                    locationSelected = value!;
                  });
                },
                items: locations
                    .map<DropdownMenuItem<Location>>((Location location) {
                  return DropdownMenuItem<Location>(
                    value: location,
                    child: Text(location.name),
                  );
                }).toList(),
              ),
              widget.individualId == null
                  ? const Text('Nickname for the newly created salamander:')
                  : Container(),
              widget.individualId == null
                  ? TextFormField(
                      onSaved: (String? value) {
                        nickname = value!;
                      },
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a name';
                        }
                        return null;
                      },
                    )
                  : Container(),
              const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Text('Date of sighting:')),
              InputDatePickerFormField(
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime.now(),
                fieldLabelText: "",
                onDateSaved: (DateTime value) {
                  spottedAt = value;
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: TextButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      String url = widget.individualId == null
                          ? '${globals.serverUrl()}/confirm/${widget.sightingId}?'
                          : '${globals.serverUrl()}/confirm/${widget.sightingId}?individual_id=${widget.individualId}';
                      Map body = {
                        'spotted_at': spottedAt.toIso8601String(),
                      };
                      if (locationSelected != null) {
                        url += '&location_id=${locationSelected!.id}';
                      }
                      if (widget.individualId == null) {
                        body['nickname'] = nickname;
                      }
                      http
                          .post(Uri.parse(url),
                              headers: {
                                'Content-Type': 'application/json',
                                "Authorization": globals.authHeader
                              },
                              body: json.encode(body))
                          .then((response) {
                        Navigator.popUntil(context, ModalRoute.withName('/'));
                      });
                    }
                  },
                  child: const Text('Submit'),
                ),
              ),
            ],
          ),
        ));
  }
}
