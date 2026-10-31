import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:file_picker/file_picker.dart'; // សម្រាប់ជ្រើសរើសវីដេអូពីក្នុងទូរសព្ទ

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
  VideoPlayerController? _videoController;
  String selectedCharacter = 'តួអង្គប្រុស (Male)';
  String sourceLanguage = 'ចិន (Chinese)'; // ភាសាដើម (ចិន ឬ អង់គ្លេស)
  bool isRecording = false;
  bool isVideoInitialized = false;

  // មុខងារជ្រើសរើសវីដេអូពីក្នុងទូរសព្ទផ្ទាល់
  Future<void> _pickVideoFromPhone() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.video,
    );

    if (result != null && result.files.single.path != null) {
      String videoPath = result.files.single.path!;
      
      // បញ្ឈប់ និងលុប Controller ចាស់ចោលបើសិនជាមាន
      _videoController?.dispose();

      // បង្កើត Controller ថ្មីដោយប្រើវីដេអូពីក្នុងទូរសព្ទ
      _videoController = VideoPlayerController.file(File(videoPath))
        ..initialize().then((_) {
          setState(() {
            isVideoInitialized = true;
          });
          _videoController!.play();
        });
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
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
            // ប្រអប់បង្ហាញវីដេអូ
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(12),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: isVideoInitialized && _videoController != null
                    ? AspectRatio(
                        aspectRatio: _videoController!.value.aspectRatio,
                        child: VideoPlayer(_videoController!),
                      )
                    : const Center(
                        child: Text(
                          'សូមជ្រើសរើសវីដេអូពីក្នុងទូរសព្ទរបស់អ្នក',
                          style: TextStyle(color: Colors.white70),
                          textAlign: TextAlign.center,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 10),
            
            // ប៊ូតុងជ្រើសរើសវីដេអូ និង Play/Pause
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: _pickVideoFromPhone,
                  icon: const Icon(Icons.video_file),
                  label: const Text('យករូបវីដេអូពីទូរសព្ទ'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, foregroundColor: Colors.white),
                ),
                if (isVideoInitialized)
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        _videoController!.value.isPlaying
                            ? _videoController!.pause()
                            : _videoController!.play();
                      });
                    },
                    icon: Icon(_videoController!.value.isPlaying
                        ? Icons.pause
                        : Icons.play_arrow),
                    label: Text(_videoController!.value.isPlaying ? 'ផ្អាក' : 'ចាក់'),
                  ),
              ],
            ),
            const SizedBox(height: 15),

            // ជ្រើសរើសភាសាដើម (ចិន / អង់គ្លេស មក ខ្មែរ)
            const Text(
              'ប្រភពភាសាដើមសម្រាប់បកប្រែមកខ្មែរ៖',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ChoiceChip(
                  label: const Text('ពីភាសាចិន ➔ ខ្មែរ'),
                  selected: sourceLanguage == 'ចិន (Chinese)',
                  onSelected: (selected) {
                    setState(() {
                      sourceLanguage = 'ចិន (Chinese)';
                    });
                  },
                ),
                const SizedBox(width: 10),
                ChoiceChip(
                  label: const Text('ពីអង់គ្លេស ➔ ខ្មែរ'),
                  selected: sourceLanguage == 'អង់គ្លេស (English)',
                  onSelected: (selected) {
                    setState(() {
                      sourceLanguage = 'អង់គ្លេស (English)';
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),

            // ជ្រើសរើសតួអង្គប្រុស / ស្រី តាមកាយវិការ
            const Text(
              'ជ្រើសរើសតួអង្គបញ្ចូលសំឡេង៖',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      selectedCharacter = 'តួអង្គប្រុស (Male Voice)';
                    });
                  },
                  icon: const Icon(Icons.man),
                  label: const Text('ប្រុស'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selectedCharacter.contains('ប្រុស') ? Colors.blue : Colors.grey[300],
                    foregroundColor: selectedCharacter.contains('ប្រុស') ? Colors.white : Colors.black,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      selectedCharacter = 'តួអង្គស្រី (Female Voice)';
                    });
                  },
                  icon: const Icon(Icons.woman),
                  label: const Text('ស្រី'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selectedCharacter.contains('ស្រី') ? Colors.pink : Colors.grey[300],
                    foregroundColor: selectedCharacter.contains('ស្រី') ? Colors.white : Colors.black,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Center(
              child: Text(
                'កំពុងបកប្រែពី [$sourceLanguage] សម្រាប់៖ $selectedCharacter',
                style: const TextStyle(fontSize: 13, color: Colors.indigo, fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
            ),
            const Spacer(),

            // ប៊ូតុងថតសំឡេងបញ្ចូល
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  isRecording = !isRecording;
                });
              },
              icon: Icon(isRecording ? Icons.stop : Icons.mic),
              label: Text(isRecording ? 'កំពុងថតសំឡេងបកប្រែ... (ចុចដើម្បីឈប់)' : 'ចាប់ផ្តើមថតសំឡេងតាមកាយវិការតួអង្គ'),
              style: ElevatedButton.styleFrom(
                backgroundColor: isRecording ? Colors.red : Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
