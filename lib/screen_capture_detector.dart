
import 'screen_capture_detector_platform_interface.dart';

class ScreenCaptureDetector {
  Future<String?> getPlatformVersion() {
    return ScreenCaptureDetectorPlatform.instance.getPlatformVersion();
  }
}
