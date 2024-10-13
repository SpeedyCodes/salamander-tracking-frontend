import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:salamander_tracker/individual_details_screen.dart';
import 'package:salamander_tracker/sighting_details_screen.dart';
import 'package:salamander_tracker/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_android/shared_preferences_android.dart';
import 'package:shared_preferences_ios/shared_preferences_ios.dart';
import 'image_picker_screen.dart';
import 'package:http/http.dart' as http;
import 'globals.dart' as globals;
import 'models/sighting.dart';
import 'models/individual.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Salamander Tracker',
      locale: const Locale('en', 'GB'),
      supportedLocales: const [
        Locale('en', 'GB'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      localeResolutionCallback: (locale, supportedLocales) => locale,  
      theme: ThemeData(
        colorScheme: const ColorScheme.dark(),
        useMaterial3: true,
      ),
      home: const SightingsPage(),
    );
  }
}

class SightingsPage extends StatefulWidget {
  const SightingsPage({super.key});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  State<SightingsPage> createState() => _SightingsPageState();
}

class _SightingsPageState extends State<SightingsPage> {
  int currentPageIndex = 0;
  static const List<String> titles = ['Sightings', 'Salamanders', 'Settings'];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<Sighting> sightings = [];
  List<Individual> individuals = [];

  @override
  void initState() {
    super.initState();
    currentPageIndex = 0;
    if (kIsWeb) {}
    else if (Platform.isAndroid) SharedPreferencesAndroid.registerWith();
    else if (Platform.isIOS) SharedPreferencesIOS.registerWith();
    getServerAddress();
    refresh();
  }

  Future<void> fetchSightings() async{
    await http.get(Uri.parse('${globals.serverAddress}/sightings')).then((value){
      setState(() {
        sightings = sightingsFromJson(value.body);
        return;
      });
    });
  }

  Future<void> fetchIndividuals() async{
    await http.get(Uri.parse('${globals.serverAddress}/individuals')).then((value){
      setState(() {
        individuals = individualsFromJson(value.body);
        return;
      });
    });
  }

  Future<void> refresh() async {
    Future<void> f1 = fetchSightings();
    Future<void> f2 = fetchIndividuals();
    await Future.wait([f1, f2]);
  }

  void getServerAddress() async {
    final prefs = await SharedPreferences.getInstance();
    String address = prefs.getString("serverAddress") ?? '';
    if(address.isNotEmpty) {
      globals.serverAddress = address;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(titles[currentPageIndex]),
      ),
      body: IndexedStack(
        index: currentPageIndex,
        children: <Widget>[
        RefreshIndicator(
          onRefresh: refresh,
          child: ListView.builder(
          itemCount: sightings.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text(sightings[index].individualName!),
              subtitle: Text(formatDate(sightings[index].date)),
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SightingDetailsScreen(sighting: sightings[index])),
                );
              },
            );
          },
        )),
        RefreshIndicator(
          onRefresh: refresh,
          child: ListView.builder(
          itemCount: individuals.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text(individuals[index].name),
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => IndividualDetailsScreen(individual: individuals[index])),
                );
              },
            );
          },
        )),
        Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text('Server address'),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'http://192.168.0.10',
                ),
                initialValue: globals.serverAddress,
                onSaved: (value) async {
                  final prefs = await SharedPreferences.getInstance();
                  globals.serverAddress = value!;
                  prefs.setString('serverAddress', value);
                },
              ),
              TextButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                    }
                  },
                  child: const Text("Save")),
            ],
          ),
        )
      ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ImagePickerScreen()),
          ).then((onValue){
            refresh();
          });
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(Icons.visibility),
            label: 'Sightings',
          ),
          NavigationDestination(
            icon: Icon(Icons.group),
            label: 'Salamanders',
          ),
          NavigationDestination(icon: Icon(Icons.settings), label: 'Settings')
        ],
      ),
    );
  }
}
