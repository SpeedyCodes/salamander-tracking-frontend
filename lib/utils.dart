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
  final DateFormat formatter = DateFormat("EEE, dd MMM yyyy HH:mm:ss 'GMT'");
  return formatter.parse(dt);
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

  globals.authHeader = "Bearer ${response.body}";
  return response.statusCode == 200;
}
