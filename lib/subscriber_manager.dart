import 'dart:async';

import 'package:screen_capture_detector/screen_capture_detector_event_channel.dart';
import 'package:screen_capture_detector/screen_capture_detector_method_channel.dart';

class SubscriberManager {
  SubscriberManager({
    required MethodChannelScreenCaptureDetector methodChannel,
    required EventChannelScreenCaptureDetector eventChannel,
  })  : _eventChannel = eventChannel,
        _methodChannel = methodChannel;

  final MethodChannelScreenCaptureDetector _methodChannel;
  final EventChannelScreenCaptureDetector _eventChannel;

  final Map<int, StreamSubscription> _hashToSubMap = {};

  bool _isWatcherActive = false;

  void addListener(void Function(bool isCaptured) listener) {
    if (!_isWatcherActive) {
      _methodChannel.startWatcher();
      _isWatcherActive = true;
    }

    final subscription = _eventChannel.listen(listener);

    _hashToSubMap[listener.hashCode] = subscription;
  }

  void removeListener(void Function(bool isCaptured) listener) {
    _hashToSubMap.remove(listener.hashCode);
    _stopListeningIfNoSubs();
  }

  void _stopListeningIfNoSubs() {
    if (_hashToSubMap.isEmpty) {
      _methodChannel.stopWatcher();
      _isWatcherActive = false;
    }
  }
}
