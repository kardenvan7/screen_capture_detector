import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class MethodChannelScreenCaptureDetector {
  final _methodChannel = const MethodChannel('screen_capture_detector_mc');

  Future<bool> isScreenCaptured() async {
    return _platformWrapper(
      () async =>
          (await _methodChannel.invokeMethod<bool>('isScreenCaptured') ??
              false),
    );
  }

  Future<void> startWatcher() {
    return _platformWrapper(() => _methodChannel.invokeMethod('startWatcher'));
  }

  Future<void> stopWatcher() {
    return _platformWrapper(() => _methodChannel.invokeMethod('stopWatcher'));
  }

  Future<void> setWatcherInterval(Duration duration) {
    return _platformWrapper(
      () => _methodChannel.invokeMethod(
        'setWatcherInterval',
        duration.inMicroseconds / 1000000,
      ),
    );
  }

  Future<T> _platformWrapper<T>(Future<T> Function() method) {
    return switch (defaultTargetPlatform) {
      TargetPlatform.iOS => method(),
      _ => throw UnimplementedError(
          'Method "isScreenCaptured" is not implemented for $defaultTargetPlatform',
        ),
    };
  }
}
