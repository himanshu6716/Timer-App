import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Timer App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
      ),
      home: TimerScreen(),
    );
  }
}

class TimerScreen extends StatefulWidget {
  @override
  _TimerScreenState createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  int _seconds = 30;
  late Timer _timer;
  bool _isRunning = false;
  bool _isSoundOn = true;
  late AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
  }

  void toggleTimer() {
    if (_isRunning) {
      _timer.cancel();
    } else {
      startTimer();
    }
    setState(() {
      _isRunning = !_isRunning;
    });
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_seconds > 0) {
          _seconds--;
        } else {
          _timer.cancel();
          _isRunning = false;
          if (_isSoundOn) {
            playSound();
          }
        }
      });
    });
  }

  void playSound() async {
    await _audioPlayer.play('' as Source);
  }

  void resetTimer() {
    _timer.cancel();
    setState(() {
      _seconds = 30;
      _isRunning = false;
    });
  }

  void toggleSound() {
    setState(() {
      _isSoundOn = !_isSoundOn;
    });
  }

  String formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Timer App'),
        backgroundColor: Colors.yellow,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 200,
              height: 200,
              color: Colors.cyan,

              child: Stack(
                alignment: Alignment.center,
                children: [
                  CircularProgressIndicator(
                    value: 1 - (_seconds / 30),
                    backgroundColor: Colors.white,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
                    strokeWidth: 8,
                  ),
                  Text(
                    formatTime(_seconds),
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 50,),
            SizedBox(
              height: 50,
              width: 200,
           child: ElevatedButton(
              onPressed: () {
                toggleTimer();
              },
              child: Text(_isRunning ? 'Pause' : 'Start'),
            ),
            ),
            SizedBox(height:30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Sound On'),
                Switch(
                  value: _isSoundOn,
                  onChanged: (value) {
                    toggleSound();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
