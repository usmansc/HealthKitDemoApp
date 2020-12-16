//
//  Workout.swift
//  HealthKitDemoApp
//
//  Created by Lukas Schmelcer on 13/12/2020.
//

import Foundation

import Foundation

struct Workout: Identifiable,Hashable {
    let id: UUID = UUID()
    var distance: Double?
    var stratDateTime: Date
    var endDateTime: Date
    var duration: TimeInterval
    var heartRate: [Double]
    var calories: Double?
}
