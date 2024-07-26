import 'package:flutter/material.dart';
import 'new_sighting_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
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
  static const List<String> titles = ['Sightings', 'Salamanders'];

  @override
  void initState() {
    super.initState();
    // fetch data
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
      body: <Widget>[
        ListView(
          // use builder  https://www.youtube.com/watch?v=HCmAwk2fnZc
          scrollDirection: Axis.vertical,
          children: const [
            ListTile(
              title: Text('Salamander 1'),
              subtitle: Text('Sighted on 2022-01-01'),
            ),
            ListTile(
              title: Text('Salamander 2'),
              subtitle: Text('Sighted on 2022-01-02'),
            ),
            ListTile(
              title: Text('Salamander 3'),
              subtitle: Text('Sighted on 2022-01-03'),
            ),
          ],
        ),
        GridView.count(
        crossAxisCount: 2,
        children: List.generate(20, (index) {
          return Column(
            children: [
              Hero(
                  tag: index,
                  child: Image.network('https://waarnemingen.be/media/photo/000/733/733977.jpg')
              ),
            ],
          );
        }),
      )
      ][currentPageIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NewSightingScreen()),
          );
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
        ],
      ),
    );
  }
}
