import 'package:flutter/material.dart';

void main() {
  runApp(const VoxCrownApp());
}

class VoxCrownApp extends StatelessWidget {
  const VoxCrownApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vox Crown Dubbing',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const DubbingHomePage(),
    );
  }
}

class DubbingHomePage extends StatefulWidget {
  const DubbingHomePage({Key? key}) : super(key: key);

  @override
  _DubbingHomePageState createState() => _DubbingHomePageState();
}

class _DubbingHomePageState extends State<DubbingHomePage> {
  // Google Colab Backend API URL
  final String apiUrl = 'http://34.22.52.111:8000';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vox Crown Dubbing'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'ប្រព័ន្ធទស្សន៍ទាយ និងបំលែងសំឡេងវីដេអូ',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Text(
              'API Server: $apiUrl',
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                // កូដសម្រាប់បញ្ជូនទិន្នន័យទៅកាន់ API
              },
              child: const Text('ចាប់ផ្តើមបំលែង'),
            ),
          ],
        ),
      ),
    );
  }
}
