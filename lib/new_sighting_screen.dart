import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'globals.dart' as globals;

class NewSightingScreen extends StatelessWidget {
  final String? individualId;
  final String sightingId;
  NewSightingScreen(
      {super.key, required this.individualId, required this.sightingId});

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String nickname = '';

  DateTime spottedAt = DateTime.now();

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
              individualId == null
                  ? const Text('Nickname for the newly created salamander')
                  : Container(),
              individualId == null
                  ? TextFormField(
                      onSaved: (String? value) {
                        nickname = value!;
                      },
                      decoration: const InputDecoration(
                        hintText: 'jimmy',
                      ),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a name';
                        }
                        return null;
                      },
                    )
                  : Container(),
              const Text('Date of sighting'),
              InputDatePickerFormField(
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime.now(),
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
                      if (individualId == null) {
                        http
                            .post(
                          Uri.parse(
                              '${globals.serverAddress}/confirm/$sightingId'),
                          headers: <String, String>{
                            'Content-Type': 'application/json',
                          },
                          body: jsonEncode(<String, String>{
                            'nickname': nickname,
                            'spotted_at': spottedAt.toIso8601String()
                          }),
                        )
                            .then((response) {
                          Navigator.popUntil(context, ModalRoute.withName('/'));
                        });
                      } else {
                        http
                            .post(
                                Uri.parse(
                                    '${globals.serverAddress}/confirm/$sightingId?individual_id=$individualId'),
                                headers: {'Content-Type': 'application/json'},
                                body: json.encode({
                                  'spotted_at': spottedAt.toIso8601String()
                                }))
                            .then((response) {
                          Navigator.popUntil(context, ModalRoute.withName('/'));
                        });
                      }
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
