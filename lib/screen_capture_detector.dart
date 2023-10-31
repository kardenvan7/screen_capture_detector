import 'dart:async';

import 'package:screen_capture_detector/screen_capture_detector_event_channel.dart';
import 'package:screen_capture_detector/screen_capture_detector_method_channel.dart';
import 'package:screen_capture_detector/subscriber_manager.dart';

class ScreenCaptureDetector {
  ScreenCaptureDetector._();

  static ScreenCaptureDetector instance = ScreenCaptureDetector._();

  final _methodChannel = MethodChannelScreenCaptureDetector();
  final _eventChannel = EventChannelScreenCaptureDetector();

  late final _subManager = SubscriberManager(
    methodChannel: _methodChannel,
    eventChannel: _eventChannel,
  );

  Future<bool> isScreenCaptured() => _methodChannel.isScreenCaptured();

  void addListener(void Function(bool isCaptured) listener) {
    _subManager.addListener(listener);
  }

  void removeListener(void Function(bool isCaptured) listener) {
    _subManager.removeListener(listener);
  }

  Future<void> setListenerInterval(Duration duration) {
    return _methodChannel.setWatcherInterval(duration);
  }
}
