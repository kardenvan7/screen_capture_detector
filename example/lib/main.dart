import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:screen_capture_detector/screen_capture_detector.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isLoading = true;
  bool _isCaptured = false;
  String? _errorText;

  final _screenCaptureDetector = ScreenCaptureDetector.instance;

  @override
  void initState() {
    super.initState();
    getIsScreenCaptured();
  }

  @override
  void dispose() {
    _screenCaptureDetector.removeListener(_isScreenCapturedListener);
    super.dispose();
  }

  void _isScreenCapturedListener(bool isCaptured) {
    if (_isCaptured != isCaptured) {
      setState(
        () {
          _isCaptured = isCaptured;
          _errorText = null;
          _isLoading = false;
        },
      );
    }
  }

  void _cancelSub() {
    _screenCaptureDetector.removeListener(_isScreenCapturedListener);
  }

  void _subscribe() {
    _screenCaptureDetector
        .setListenerInterval(const Duration(milliseconds: 100))
        .then(
          (value) =>
              _screenCaptureDetector.addListener(_isScreenCapturedListener),
        );
  }

  Future<void> getIsScreenCaptured() async {
    if (!_isLoading) {
      setState(() => _isLoading = true);
    }

    bool isCaptured = _isCaptured;
    String? errorText = _errorText;

    try {
      isCaptured = await _screenCaptureDetector.isScreenCaptured();
      errorText = null;
    } on PlatformException {
      errorText = 'Failed to get platform version.';
    }

    if (!mounted) return;

    setState(() {
      _isCaptured = isCaptured;
      _errorText = errorText;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final errorText = _errorText;

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Screen Capture Detector'),
          actions: [
            IconButton(
              onPressed: () {
                getIsScreenCaptured();
              },
              icon: const Icon(Icons.refresh),
            ),
            IconButton(
              onPressed: () {
                _cancelSub();
              },
              icon: const Icon(Icons.close),
            ),
            IconButton(
              onPressed: () {
                _subscribe();
              },
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        body: Scaffold(
          backgroundColor: _isLoading
              ? Colors.blue
              : _isCaptured || errorText != null
                  ? Colors.red
                  : Colors.green,
          body: Center(
            child: Text(
              _isLoading
                  ? 'Loading ...'
                  : errorText != null
                      ? 'ERROR:\n$errorText'
                      : 'Is captured: $_isCaptured\n',
            ),
          ),
        ),
      ),
    );
  }
}
