import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'globals.dart' as globals;
import 'package:salamander_tracker/models/location.dart';


class NewLocationScreen extends StatelessWidget {
  NewLocationScreen({super.key});
  
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String name = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Location'),
      ),
      body: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text('Name for the new location:'),
              TextFormField(
                      onSaved: (String? value) {
                        name = value!;
                      },
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a name';
                        }
                        return null;
                      },
                    ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: TextButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      http
                            .post(
                                Uri.parse(
                                    '${globals.serverAddress}/locations'),
                                headers: {'Content-Type': 'application/json'},
                                body: locationToJson(Location(name: name, preciseLocation: [0, 0])))
                            .then((response) {
                          Navigator.pop(context, locationFromJson(response.body));
                        });
                    }
                  },
                  child: const Text('Submit'),
                ),
              ),
            ],
          ),
        )
    );
  }
}