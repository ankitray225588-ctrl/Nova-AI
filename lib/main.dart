import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

void main() {
  runApp(const NovaAI());
}

class NovaAI extends StatelessWidget {
  const NovaAI({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Nova AI',
      theme: ThemeData.dark(),
      home: const NovaHome(),
    );
  }
}

class NovaHome extends StatefulWidget {
  const NovaHome({super.key});

  @override
  State<NovaHome> createState() => _NovaHomeState();
}

class _NovaHomeState extends State<NovaHome> {
  final stt.SpeechToText speech = stt.SpeechToText();

  bool listening = false;
  String text = "Press the microphone and speak";

  Future<void> startListening() async {
    final available = await speech.initialize();

    if (!available) {
      setState(() {
        text = "Microphone is not available";
      });
      return;
    }

    setState(() {
      listening = true;
      text = "Listening...";
    });

    await speech.listen(
      onResult: (result) {
        setState(() {
          text = result.recognizedWords;
        });
      },
    );
  }

  Future<void> stopListening() async {
    await speech.stop();

    setState(() {
      listening = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1020),
      appBar: AppBar(
        title: const Text("Nova AI"),
        centerTitle: true,
        backgroundColor: const Color(0xFF11182D),
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 40),
            child: FloatingActionButton.large(
              onPressed:
                  listening ? stopListening : startListening,
              child: Icon(
                listening ? Icons.stop : Icons.mic,
                size: 36,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
