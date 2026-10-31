import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

void main() {
  runApp(const VoxCrownAIApp());
}

class VoxCrownAIApp extends StatelessWidget {
  const VoxCrownAIApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Vox Crown AI Dubbing',
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: const AIDubbingHome(),
    );
  }
}

class AIDubbingHome extends StatefulWidget {
  const AIDubbingHome({super.key});

  @override
  State<AIDubbingHome> createState() => _AIDubbingHomeState();
}

class _AIDubbingHomeState extends State<AIDubbingHome> {
  late VideoPlayerController _videoController;
  bool isVideoInitialized = false;
  
  // ការកំណត់ការបកប្រែ AI
  String sourceLanguage = 'ចិន (Chinese)';
  String targetVoice = 'តួអង្គស្រី (Female AI Voice)';
  bool isProcessingAI = false;
  bool isRecordingCustom = false;
  String videoStatusText = 'វីដេអូគំរូ AI (ត្រៀមរួចរាល់សម្រាប់ការបកប្រែ)';

  @override
  void initState() {
    super.initState();
    // ប្រើប្រាស់វីដេអូគំរូសម្រាប់តេស្តប្រព័ន្ធ
    _videoController = VideoPlayerController.networkUrl(
      Uri.parse('https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4'),
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

  // មុខងារจำลองការជ្រើសរើសវីដេអូពីទូរសព្ទ (Upload Video)
  void _pickVideoFromDevice() {
    setState(() {
      videoStatusText = 'បានជ្រើសរើសវីដេអូថ្មី (ត្រៀមបញ្ជូនទៅ AI)';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('បានផ្ទុកវីដេអូចូលក្នុងប្រព័ន្ធដោយជោគជ័យ!')),
    );
  }

  // មុខងារបញ្ជូនទៅ AI បកប្រែភាសា (Chinese/English -> Khmer Dubbing)
  void _startAITranslation() {
    setState(() {
      isProcessingAI = true;
    });

    // จำลองដំណើរការ AI កំពុងវិភាគសំឡេង និងបកប្រែវីដេអូยาวៗ
    Future.delayed(const Duration(seconds: 4), () {
      setState(() {
        isProcessingAI = false;
        videoStatusText = 'AI បានបកប្រែជាភាសាខ្មែរ ($targetVoice) រួចរាល់!';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('AI Dubbing สำเร็จរួចរាល់! ចុច Play เพื่อស្តាប់')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vox Crown AI Dubbing Studio'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ផ្នែកបង្ហាញវីដេអូ
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
            
            // ប៊ូតុងបញ្ជាវីដេអូ
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
            const SizedBox(height: 10),
            Text(
              videoStatusText,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
            ),
            const Divider(height: 30),

            // ទី១៖ ប៊ូតុងអាប់ឡូតវីដេអូ (Upload Video)
            ElevatedButton.icon(
              onPressed: _pickVideoFromDevice,
              icon: const Icon(Icons.upload_file),
              label: const Text('អាប់ឡូតវីដេអូ (គាំទ្ររហូតដល់ ១ម៉ោង)', style: TextStyle(fontSize: 16)),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.white,
              ),
            ),
            const SizedBox(height: 15),

            // ទី២៖ ការជ្រើសរើសភាសា និងសំឡេង AI តួអង្គ
            const Text('ជ្រើសរើសភាសាប្រភព និង AI Voice:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: sourceLanguage,
                    decoration: const InputDecoration(border: OutlineInputBorder(), contentPadding: EdgeInsets.symmetric(horizontal: 10)),
                    items: ['ចិន (Chinese)', 'អង់គ្លេស (English)'].map((lang) {
                      return DropdownMenuItem(value: lang, child: Text(lang));
                    }).toList(),
                    onChanged: (val) {
                      setState(() {
                        sourceLanguage = val!;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: targetVoice,
                    decoration: const InputDecoration(border: OutlineInputBorder(), contentPadding: EdgeInsets.symmetric(horizontal: 10)),
                    items: ['តួអង្គប្រុស (Male AI)', 'តួអង្គស្រី (Female AI)'].map((voice) {
                      return DropdownMenuItem(value: voice, child: Text(voice));
                    }).toList(),
                    onChanged: (val) {
                      setState(() {
                        targetVoice = val!;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // ទី៣៖ ប៊ូតុងបញ្ជា AI ឱ្យបកប្រែស្វ័យប្រវត្តិ
            isProcessingAI
                ? const Center(child: Column(
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 10),
                      Text('AI กำลังถอดเสียงและแปลเป็นภาษาខ្មែរ (រង់ចាំបន្តិច)...', style: TextStyle(color: Colors.deepPurple))
                    ],
                  ))
                : ElevatedButton.icon(
                    onPressed: _startAITranslation,
                    icon: const Icon(Icons.auto_awesome),
                    label: const Text('เริ่มแปล AI ស្វ័យប្រវត្តិ (ចិន/អង់គ្លេស ➡️ ខ្មែរ)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: Colors.orange[800],
                      foregroundColor: Colors.white,
                    ),
                  ),
            const SizedBox(height: 20),

            // ទី៤៖ មុខងារថតសំឡេងផ្ទាល់ខ្លួន (Custom Voice Recording)
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  isRecordingCustom = !isRecordingCustom;
                });
              },
              icon: Icon(isRecordingCustom ? Icons.stop : Icons.mic),
              label: Text(isRecordingCustom ? 'កំពុងថតសំឡេងរបស់អ្នក... (ចុចเพื่อឈប់)' : 'បញ្ចូលសំឡេងនិយាយដោយខ្លួនឯງ (Custom Dubbing)'),
              style: ElevatedButton.styleFrom(
                backgroundColor: isRecordingCustom ? Colors.red : Colors.green,
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
