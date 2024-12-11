import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Import the http package
import 'dart:convert'; // For JSON encoding
import 'package:audioplayers/audioplayers.dart';
import 'word_pool.dart';
import 'dart:math';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spelling Practice App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String selectedWord = '';
  String inputWord = '';
  String audioUrl = '';
  String feedback = '';
  bool isWordRevealed = false;
  FocusNode _focusNode = FocusNode(); 

  final TextEditingController _controller = TextEditingController();
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose(); // Dispose of the FocusNode
    super.dispose();
  }

  // Function to get the audio URL for a word
  Future<void> getAudioUrl() async {
    final word = wordPool[(wordPool.length * (DateTime.now().millisecondsSinceEpoch % 1000) ~/ 1000) % wordPool.length];
    setState(() {
      selectedWord = word.toUpperCase();
    });

    final url = Uri.parse('https://spelling-bee-backend-prod-7d78cdbb39a3.herokuapp.com/api/v1/speech/generate');
    //final url = Uri.parse('https://api.murf.ai/v1/speech/generate');

    final response = await http.post(
      url,
      headers: {"content-type": "application/json",
                "accept": "application/json",
                "api-key": "ap2_553f7996-b9b2-40ec-a412-ff812b10031b"},
      body: json.encode({
          "voiceId": "en-US-june",
          "style": "Promo",
          "text": word,
          "rate": -15,
          "pitch": 0,
          "sampleRate": 48000,
          "format": "MP3",
          "channelType": "MONO",
          "pronunciationDictionary": {},
          "encodeAsBase64": false,
          "variation": 1,
          "audioDuration": 0,
          "modelVersion": "GEN2"  
      }),
    );
    
    if (response.statusCode == 200) {
      // Parse the response
      var jsonResponse = json.decode(response.body);
      var audioFileUrl = jsonResponse['audioFile'];  // Extract the 'audioFile' URL

      setState(() {
        audioUrl = audioFileUrl;  // Update the state with the audio URL
      });

      // Play the audio
      await _audioPlayer.play(UrlSource(audioUrl));
    } else {
      print('Request failed with status: ${response.statusCode}');
    }
  }

  Future<void> repeatAudio() async {
    await _audioPlayer.play(UrlSource(audioUrl));
  }
  
  // Function to check the user's input
  void checkSpelling() {
    setState(() {
      if (inputWord.toUpperCase() == selectedWord) {
        feedback = 'Correct!';
      } else {
        feedback = 'Incorrect, try again!';
      }
    });
    _focusNode.requestFocus();
  }

  // Function to reveal the word
  void revealWord() {
    setState(() {
      isWordRevealed = true;
    });
  }

  // Function to reset the spelling input and feedback
  void reset() {
    setState(() {
      _controller.clear();
      feedback = '';
      isWordRevealed = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Spelling Practice'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Word selection and play audio
                ElevatedButton(
                  onPressed: getAudioUrl,
                  child: Text('Select New Word'),
                ),
                SizedBox(width: 10),
                // Repeat button to play the word again
                ElevatedButton(
                  onPressed: repeatAudio,
                  child: Text('Repeat Audio'),
                ),
              ],
            ),
            SizedBox(height: 20),

            // Input field and feedback
            Container(
              width: 300.0,
              child: TextField(
                controller: _controller,
                focusNode: _focusNode,
                onChanged: (value) {
                  setState(() {
                    inputWord = value;
                    feedback = '';
                  });
                },
                onSubmitted: (value) {
                  checkSpelling();
                },
                decoration: InputDecoration(
                  labelText: 'Type the word here',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: checkSpelling,
              child: Text('Submit'),
            ),
            SizedBox(height: 10),
            Text(feedback, style: TextStyle(fontSize: 18, color: feedback == 'Correct!' ? Colors.green : Colors.red)),

            SizedBox(height: 20),

            // Reveal word
            ElevatedButton(
              onPressed: revealWord,
              child: Text('Reveal Word'),
            ),
            if (isWordRevealed)
              Text(
                'The word is: $selectedWord',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            SizedBox(height: 20),

            // Reset button to clear the input and feedback
            ElevatedButton(
              onPressed: reset,
              child: Text('Clear All'),
            ),
          ],
        ),
      ),
    );
  }
}