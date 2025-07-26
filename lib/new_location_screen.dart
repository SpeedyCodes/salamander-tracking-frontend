import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'globals.dart' as globals;
import 'package:salamander_tracker/models/location.dart';


class NewLocationScreen extends StatelessWidget {
  NewLocationScreen({super.key});
  
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String name = '';
  double longitude = 0;
  double latitude = 0;

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
              const Text('Longitude:'),
              TextFormField(
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^[+-]?([0-9]+([.][0-9]*)?|[.][0-9]+)$'))],
                        maxLines: 1,
                        validator: (val) => val == null || val.isEmpty ? 'This field is required' : null,
                        onSaved: (newValue) => longitude = double.parse(newValue!),
                      ),
              const Text('Latitude:'),
              TextFormField(
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^[+-]?([0-9]+([.][0-9]*)?|[.][0-9]+)$'))],
                        maxLines: 1,
                        validator: (val) => val == null || val.isEmpty ? 'This field is required' : null,
                        onSaved: (newValue) => latitude = double.parse(newValue!),
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
                                    '${globals.serverUrl()}/locations'),
                                headers: {'Content-Type': 'application/json', "Authorization": globals.authHeader},
                                body: locationToJson(Location(name: name, preciseLocation: [longitude, latitude])))
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