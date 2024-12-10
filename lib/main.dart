import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple App',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Simple Flutter App'),
        ),
        body: Center(
          child: MyAppBody(),
        ),
      ),
    );
  }
}

class MyAppBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // "Select Word" Button
          ElevatedButton(
            onPressed: () {
              // Action for "Select Word" can go here later
            },
            child: Text('Select Word'),
          ),
          SizedBox(height: 20), // Spacing between elements

          // Text Input Field
          TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Enter Text',
            ),
          ),
          SizedBox(height: 20), // Spacing between elements

          // "Submit" Button
          ElevatedButton(
            onPressed: () {
              // Action for "Submit" can go here later
            },
            child: Text('Submit'),
          ),
        ],
      ),
    );
  }
}