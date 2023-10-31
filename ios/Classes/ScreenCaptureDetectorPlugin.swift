import Flutter
import UIKit

public class ScreenCaptureDetectorPlugin: NSObject, FlutterPlugin {
    private let detector: ScreenCaptureDetector = ScreenCaptureDetector()
    private var eventSink: FlutterEventSink?
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let methodChannel = FlutterMethodChannel(
            name: "screen_capture_detector_mc",
            binaryMessenger: registrar.messenger()
        )
        let eventChannel = FlutterEventChannel(
            name: "screen_capture_detector_ec",
            binaryMessenger: registrar.messenger()
        )
        let instance = ScreenCaptureDetectorPlugin()

        eventChannel.setStreamHandler(instance)
        methodChannel.setMethodCallHandler(instance.handle)
        registrar.addMethodCallDelegate(instance, channel: methodChannel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
            case "isScreenCaptured":
                result(getIsCaptured())
            case "setWatcherInterval":
                setWatcherInterval(interval: call.arguments as! Double)
                result(nil)
            case "startWatcher":
                startWatcher()
                result(nil)
            case "stopWatcher":
                stopWatcher()
                result(nil)
            default:
                result(FlutterMethodNotImplemented)
        }
    }
    
    private func setWatcherInterval(interval: Double) {
        detector.setWatcherInterval(interval: interval)
    }
    
    private func startWatcher() {
        detector.watch(callback: { isCaptured in
            self.eventSink?(isCaptured)
        })
    }
    
    private func stopWatcher() {
        detector.stopWatcher()
    }
    
    private func getIsCaptured() -> Bool {
        return detector.isCaptured()
    }
}

extension ScreenCaptureDetectorPlugin: FlutterStreamHandler {
    public func onListen(
        withArguments arguments: Any?,
        eventSink events: @escaping FlutterEventSink
    ) -> FlutterError? {
        self.eventSink = events
        return nil
    }
    
    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        self.eventSink = nil
        return nil
    }
}
