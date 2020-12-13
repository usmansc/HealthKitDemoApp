//
//  MainViewModel.swift
//  HealthKitDemoApp
//
//  Created by Lukas Schmelcer on 13/12/2020.
//

import Foundation
import Combine
import HealthKit
final class MainViewModel: ObservableObject{
    @Published var workouts = [Workout]()
    
    var dataManager: HealthManager
    
    init(dataManager: HealthManager = HealthManager.shared) {
        self.dataManager = dataManager
    }
}

extension MainViewModel{
    func getWorkouts(){
        self.dataManager.authorize { (succ) in
            if succ {
                self.dataManager.queryWokouts(of: .running, from: 7) { (workouts) in
                    DispatchQueue.main.async {
                        for workout in workouts{
                            let duration = workout.duration
                            if let distance = workout.totalDistance?.doubleValue(for: .meter()), let startDate = workout.workoutEvents?.first?.dateInterval.start, let endDate = workout.workoutEvents?.last?.dateInterval.end {
                                self.dataManager.queryHeartRateForWorkout(from: startDate, to: endDate,handler: { samples in
                                    var heartRate: [Double] = []
                                    for sample in samples{
                                        heartRate.append(sample.quantity.doubleValue(for: HKUnit.init(from: "count/min")))
                                    }
                                    DispatchQueue.main.async {
                                        self.workouts.append(Workout(distance: distance, stratDateTime: startDate, endDateTime: endDate, duration: duration, heartRate: heartRate))
                                    }
                                    
                                    
                                })
                            }
                            
                        }
                    }
                    
                }
            }
        }
    }
}
