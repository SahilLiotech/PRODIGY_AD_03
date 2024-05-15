import 'dart:async';

import 'package:flutter/material.dart';

class MyStopWatch extends StatefulWidget {
  const MyStopWatch({super.key});

  @override
  State<MyStopWatch> createState() => _MyStopWatchState();
}

enum StopwatchState { stopped, running, paused }

class _MyStopWatchState extends State<MyStopWatch> {
  Stopwatch stopwatch = Stopwatch();
  Timer? timer;
  StopwatchState stopwatchState = StopwatchState.stopped;
  String timeString = '00:00:00';

  @override
  void dispose() {
    stopwatch.stop();
    timer?.cancel();
    super.dispose();
  }

  void startTimer() {
    setState(() {
      stopwatchState = StopwatchState.running;
      stopwatch.start();
      timer = Timer.periodic(const Duration(milliseconds: 10), updateTime);
    });
  }

  void pauseTimer() {
    setState(() {
      stopwatchState = StopwatchState.paused;
      stopwatch.stop();
    });
  }

  void resumeTimer() {
    setState(() {
      stopwatchState = StopwatchState.running;
      stopwatch.start();
    });
  }

  void stopTimer() {
    setState(() {
      stopwatchState = StopwatchState.stopped;
      stopwatch.reset();
      stopwatch.stop();
      timer?.cancel();
      timeString = '00:00:00';
    });
  }

  void resetTimer() {
    setState(() {
      stopwatch.reset();
      timeString = '00:00:00';
    });
  }

  void updateTime(Timer timer) {
    setState(() {
      timeString = formatTime(stopwatch.elapsedMilliseconds);
    });
  }

  String formatTime(int milliseconds) {
    int seconds = (milliseconds / 1000).truncate();
    int minutes = (seconds / 60).truncate();

    String minutesStr = (minutes % 60).toString().padLeft(2, '0');
    String secondsStr = (seconds % 60).toString().padLeft(2, '0');
    String millisecondsStr = (milliseconds % 1000 ~/ 10).toString().padLeft(2, '0');

    return '$minutesStr:$secondsStr:$millisecondsStr';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        foregroundColor: Colors.white,
        title: const Text("StopWatch"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.center,
                  height: 250,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.lightBlue, width: 3),
                  ),
                  child: Text(
                    timeString,
                    style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 10.0),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      if (stopwatchState == StopwatchState.stopped)
                        ElevatedButton(
                          onPressed: startTimer,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text(
                            "START",
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      if (stopwatchState == StopwatchState.running ||
                          stopwatchState == StopwatchState.paused)
                        ElevatedButton(
                          onPressed: stopTimer,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                          ),
                          child: Text(
                            stopwatchState == StopwatchState.stopped
                                ? "RESET"
                                : "STOP",
                            style: const TextStyle(fontSize: 18),
                          ),
                        ),
                      if (stopwatchState == StopwatchState.running)
                        ElevatedButton(
                          onPressed: pauseTimer,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.yellow,
                            foregroundColor: Colors.black,
                          ),
                          child: const Text(
                            "PAUSE",
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      if (stopwatchState == StopwatchState.paused)
                        ElevatedButton(
                          onPressed: resumeTimer,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text(
                            "RESUME",
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ElevatedButton(
                        onPressed: resetTimer,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text(
                          "RESET",
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      drawer: const Drawer(),
    );
  }
}

