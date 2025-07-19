import 'package:intl/intl.dart';
import 'package:salamander_tracker/models/location.dart';
import 'globals.dart' as globals;
import 'package:http/http.dart' as http;
import 'dart:convert';

String formatDate(DateTime dt) {
  final DateFormat formatter = DateFormat('dd-MM-yyyy');
  return formatter.format(dt);
}

DateTime parseDate(String dt) {
  return DateTime.parse(dt);
}

Future<List<Location>> fetchLocations() async {
  final response =
      await http.get(Uri.parse('${globals.serverAddress}/locations'));
  if (response.statusCode == 200) {
    return locationsFromJson(response.body);
  }
  return [];
}

Future<bool> login(String? value) async {
  http.Response response = await http.post(
    Uri.parse('${globals.serverAddress}/auth'),
    headers: {'Content-Type': 'application/json'},
    body: json.encode({"password": value}),
  );
  if (response.statusCode != 200) {
    return false;
  }
  globals.authHeader = "Bearer ${json.decode(response.body)["token"]}";
  return true;
}

  Future<http.Response> deleteSighting(int sightingId) {
    return http.delete(
                      Uri.parse(
                          '${globals.serverAddress}/sightings/$sightingId'),
                      headers: {
                        "Authorization": globals.authHeader
                      });
  }
