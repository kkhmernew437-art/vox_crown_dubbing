import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

void main() {
  runApp(const VoxCrownApp());
}

class VoxCrownApp extends StatelessWidget {
  const VoxCrownApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'វ៉ុកក្រោន ឌឹបប៊ីង',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        fontFamily: 'Roboto',
      ),
      home: const DubbingHomePage(),
    );
  }
}

class DubbingHomePage extends StatefulWidget {
  const DubbingHomePage({super.key});

  @override
  State<DubbingHomePage> createState() => _DubbingHomePageState();
}

class _DubbingHomePageState extends State<DubbingHomePage> {
  late VideoPlayerController _videoController;
  bool isVideoInitialized = false;
  
  String sourceLang = 'ភាសាចិន';
  String targetVoice = 'តួអង្គស្រី';
  bool isProcessing = false;
  bool isRecording = false;
  String statusMessage = 'វីដេអូគំរូត្រៀមរួចរាល់សម្រាប់ការបកប្រែ';

  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.networkUrl(
      Uri.parse('https://www.w3schools.com/html/mov_bbb.mp4'),
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

  void _uploadVideo() {
    setState(() {
      statusMessage = 'បានផ្ទុកវីដេអូចូលដោយជោគជ័យ!';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('បានអាប់ឡូតវីដេអូរួចរាល់!')),
    );
  }

  void _startAI() {
    setState(() {
      isProcessing = true;
    });
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        isProcessing = false;
        statusMessage = 'AI បានបកប្រែជាភាសាខ្មែរ ($targetVoice) រួចរាល់!';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ការបកប្រែ AI ទទួលបានជោគជ័យ!')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('វ៉ុកក្រោន ឌឹបប៊ីង ស្តូឌីយ៉ូ'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ផ្នែកបង្ហាញវីដេអូ
            Container(
              height: 200,
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
            const SizedBox(height: 8),
            
            // ប៊ូតុងចាក់/ផ្អាកវីដេអូ
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    _videoController.value.isPlaying
                        ? _videoController.pause()
                        : _videoController.play();
                  });
                },
                icon: Icon(_videoController.value.isPlaying ? Icons.pause : Icons.play_arrow),
                label: Text(_videoController.value.isPlaying ? 'ផ្អាកវីដេអូ' : 'ចាក់វីដេអូ'),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              statusMessage,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 13),
            ),
            const Divider(height: 24),

            // ប៊ូតុងអាប់ឡូតវីដេអូ
            ElevatedButton.icon(
              onPressed: _uploadVideo,
              icon: const Icon(Icons.upload_file),
              label: const Text('អាប់ឡូតវីដេអូ (រហូតដល់ ១ម៉ោង)', style: TextStyle(fontSize: 15)),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.white,
              ),
            ),
            const SizedBox(height: 14),

            const Text('ជ្រើសរើសភាសាប្រភព និងសំឡេង AI:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: 6),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: sourceLang,
                    decoration: const InputDecoration(border: OutlineInputBorder(), contentPadding: EdgeInsets.symmetric(horizontal: 8)),
                    items: ['ភាសាចិន', 'ភាសាអង់គ្លេស'].map((l) => DropdownMenuItem(value: l, child: Text(l))).toList(),
                    onChanged: (val) => setState(() => sourceLang = val!),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: targetVoice,
                    decoration: const InputDecoration(border: OutlineInputBorder(), contentPadding: EdgeInsets.symmetric(horizontal: 8)),
                    items: ['តួអង្គប្រុស', 'តួអង្គស្រី'].map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
                    onChanged: (val) => setState(() => targetVoice = val!),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // ប៊ូតុងបញ្ជាបកប្រែ AI
            isProcessing
                ? const Center(child: Column(
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 8),
                      Text('AI កំពុងបកប្រែជាភាសាខ្មែរ...', style: TextStyle(color: Colors.deepPurple))
                    ],
                  ))
                : ElevatedButton.icon(
                    onPressed: _startAI,
                    icon: const Icon(Icons.auto_awesome),
                    label: const Text('ចាប់ផ្តើមបកប្រែ AI ស្វ័យប្រវត្តិ', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: Colors.orange[800],
                      foregroundColor: Colors.white,
                    ),
                  ),
            const SizedBox(height: 14),

            // ប៊ូតុងថតសំឡេងផ្ទាល់ខ្លួន
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  isRecording = !isRecording;
                });
              },
              icon: Icon(isRecording ? Icons.stop : Icons.mic),
              label: Text(isRecording ? 'កំពុងថតសំឡេង... (ចុចដើម្បីឈប់)' : 'បញ្ចូលសំឡេងនិយាយដោយខ្លួនឯង'),
              style: ElevatedButton.styleFrom(
                backgroundColor: isRecording ? Colors.red : Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
