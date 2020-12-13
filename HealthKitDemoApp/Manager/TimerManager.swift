//
//  TimerManager.swift
//  HealthKitDemoApp
//
//  Created by Lukas Schmelcer on 13/12/2020.
//

import Foundation

class TimerManager {
    static let shared: TimerManager = TimerManager()
    private var timer:Timer = Timer()
    
    init() {
        timer.tolerance = 0.1
    }
}

extension TimerManager {
    func runTimer(every: Double, unit: Unit,handler: @escaping () -> Void) {
        var time: Double
        switch unit {
        case .milisecond:
            time = every / 1000
        case .second:
            time = every
        case .minute:
            time = every * 60
        default:
            time = every * 60 * 60 * 24
        }
        timer = Timer.scheduledTimer(withTimeInterval: time, repeats: true, block: { (timer) in
            handler()
        })
        RunLoop.current.add(self.timer, forMode: .common)
    }
    
    func endTimer(){
        self.timer.invalidate()
    }
    
    
}
