import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Vox Crown Dubbing',
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: const DubbingHomeScreen(),
    );
  }
}

class DubbingHomeScreen extends StatefulWidget {
  const DubbingHomeScreen({super.key});

  @override
  State<DubbingHomeScreen> createState() => _DubbingHomeScreenState();
}

class _DubbingHomeScreenState extends State<DubbingHomeScreen> {
  // ជម្រើសតួអង្គ (ប្រុស ឬ ស្រី)
  String selectedCharacter = 'តួអង្គប្រុស (Male)';
  bool isRecording = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vox Crown Dubbing Studio'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ផ្នែកបង្ហាញវីដេអូ ឬ កាយវិការតួអង្គ
            Container(
              height: 220,
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Text(
                  '🎬 [កន្លែងបង្ហាញវីដេអូតួអង្គ]',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // ជ្រើសរើសប្រភេទតួអង្គ (ប្រុស/ស្រី)
            const Text(
              'ជ្រើសរើសសំឡេងតួអង្គ:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      selectedCharacter = 'តួអង្គប្រុស (Male)';
                    });
                  },
                  icon: const Icon(Icons.man),
                  label: const Text('ប្រុស'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selectedCharacter.contains('ប្រុស')
                        ? Colors.blue
                        : Colors.grey[300],
                    foregroundColor: selectedCharacter.contains('ប្រុស')
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      selectedCharacter = 'តួអង្គស្រី (Female)';
                    });
                  },
                  icon: const Icon(Icons.woman),
                  label: const Text('ស្រី'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selectedCharacter.contains('ស្រី')
                        ? Colors.pink
                        : Colors.grey[300],
                    foregroundColor: selectedCharacter.contains('ស្រី')
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // បង្ហាញស្ថានភាពតួអង្គដែលបានជ្រើស
            Center(
              child: Text(
                'កំពុងត្រៀមបញ្ចូលសំឡេងសម្រាប់៖ $selectedCharacter',
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ),
            const Spacer(),

            // ប៊ូតុងបញ្ជាថតសំឡេង (Record / Dub)
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  isRecording = !isRecording;
                });
              },
              icon: Icon(isRecording ? Icons.stop : Icons.mic),
              label: Text(isRecording ? 'កំពុងថត... (ចុចដើម្បីឈប់)' : 'ចាប់ផ្តើមបញ្ចូលសំឡេង'),
              style: ElevatedButton.styleFrom(
                backgroundColor: isRecording ? Colors.red : Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
