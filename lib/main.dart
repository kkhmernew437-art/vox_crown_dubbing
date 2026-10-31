import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

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
      home: const DubbingScreen(),
    );
  }
}

class DubbingScreen extends StatefulWidget {
  const DubbingScreen({super.key});

  @override
  State<DubbingScreen> createState() => _DubbingScreenState();
}

class _DubbingScreenState extends State<DubbingScreen> {
  late VideoPlayerController _videoController;
  String selectedCharacter = 'តួអង្គប្រុស (Male)';
  bool isRecording = false;
  bool isVideoInitialized = false;

  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.networkUrl(
      Uri.parse('https://www.flutter.dev/assets/videos/bee_ad.mp4'),
    )..initialize().then((_) {
        setState(() {
          isVideoInitialized = true;
        });
      });
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

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
            Container(
              height: 220,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(12),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: isVideoInitialized
                    ? AspectRatio(
                        aspectRatio: _videoController.value.aspectRatio,
                        child: VideoPlayer(_videoController),
                      )
                    : const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      _videoController.value.isPlaying
                          ? _videoController.pause()
                          : _videoController.play();
                    });
                  },
                  icon: Icon(_videoController.value.isPlaying
                      ? Icons.pause
                      : Icons.play_arrow),
                  label: Text(_videoController.value.isPlaying ? 'ផ្អាកវីដេអូ' : 'ចាក់វីដេអូ'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'ជ្រើសរើសតួអង្គសម្រាប់បញ្ចូលសំឡេង:',
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
            const SizedBox(height: 15),
            Center(
              child: Text(
                'កំពុងត្រៀមបញ្ចូលសំឡេង៖ $selectedCharacter',
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ),
            const Spacer(),
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  isRecording = !isRecording;
                });
              },
              icon: Icon(isRecording ? Icons.stop : Icons.mic),
              label: Text(isRecording ? 'កំពុងថតសំឡេង... (ចុចដើម្បីឈប់)' : 'ចាប់ផ្តើមថតសំឡេងតួអង្គ'),
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
