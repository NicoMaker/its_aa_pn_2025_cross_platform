import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TODO App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightGreen),
      ),
      home: const MyHomePage(title: 'TODO'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // TODO define your state

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          ElevatedButton.icon(
            icon: Icon(Icons.refresh),
            onPressed: () {
              // TODO: implement a function that resets all state to initial
              print("reset");
            },
            label: const Text('Reset All'),
          ),
          SizedBox(width: 40),
          ElevatedButton.icon(
            icon: Icon(Icons.invert_colors),
            onPressed: () {
              // TODO implement a function that inverts all states
            },
            label: const Text('Invert All'),
          ),
          SizedBox(width: 40),
        ],
      ),
      body: Center(
        child: ListView(
          children: [
            // TODO iterate on your state
            Checkbox(
              value: true, // TODO use state
              onChanged: (value) {
                // TODO implement a function that inverts this checkbox
              },
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO implement a function that adds a checkbox to state
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
