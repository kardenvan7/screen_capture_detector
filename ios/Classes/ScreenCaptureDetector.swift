//
//  ScreenCaptureDetector.swift
//  screen_capture_detector
//
//  Created by Kardenvan on 30.10.23.
//

import Foundation

class ScreenCaptureDetector {
    private let defaultTimerIntervalSeconds: Double = 0.1
    
    private var timerIntervalSeconds: Double
    private var timer: Timer?
    private var callback: ((Bool)->())?
    
    init(timerIntervalSeconds: Double? = nil) {
        self.timerIntervalSeconds = timerIntervalSeconds ?? defaultTimerIntervalSeconds
    }
    
    func isCaptured() -> Bool {
        return UIApplication.shared.getIsCaptured()
    }
    
    func watch(callback: @escaping ((Bool)->())) {
        self.callback = callback
        resetTimer()
    }
    
    func stopWatcher() {
        self.callback = nil
        stopAndRemoveTimer()
    }
    
    func setWatcherInterval(interval: Double) {
        timerIntervalSeconds = interval
        
        resetTimer()
    }
    
    private func resetTimer() {
        if (callback == nil) { return }
        
        stopAndRemoveTimer()
        
        timer = Timer.scheduledTimer(
            withTimeInterval: timerIntervalSeconds,
            repeats: true
        ) { timer in
            if (self.callback == nil) {
                self.stopAndRemoveTimer()
            }

            self.callback?(self.isCaptured())
        }
    }
    
    private func stopAndRemoveTimer() {
        timer?.invalidate()
        timer = nil
    }
}

private extension UIApplication {
    func getIsCaptured() -> Bool {
        if #available(iOS 13, *) {
            for scene in connectedScenes {
                if let windowScene = scene as? UIWindowScene {
                    for window in windowScene.windows {
                        let screen = window.screen
                        
                        if screen.isCaptured || screen.mirrored != nil {
                            return true
                        }
                    }
                }
            }
        }

        let screen = keyWindow?.screen
        
        if screen == nil {
            return false
        }

        return screen!.isCaptured || screen!.mirrored != nil
    }
}
