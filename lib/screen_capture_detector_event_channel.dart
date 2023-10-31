import 'dart:async';

import 'package:flutter/services.dart';

class EventChannelScreenCaptureDetector {
  final eventChannel = const EventChannel('screen_capture_detector_ec');
  late final Stream _stream = eventChannel.receiveBroadcastStream();

  StreamSubscription listen(void Function(bool) listener) {
    return _stream.listen((value) {
      if (value is bool) {
        listener(value);
      }
    });
  }
}
