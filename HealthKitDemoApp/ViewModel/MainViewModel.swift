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
    @Published var age: Int? 
    @Published var sex: HKBiologicalSex?
    
    var dataManager: HealthManager
    
    init(dataManager: HealthManager = HealthManager.shared) {
        self.dataManager = dataManager
    }
}

extension MainViewModel{
    
    func saveWorkout(of type: HKWorkoutActivityType,from workout: Workout, handler: @escaping (Bool) -> Void){
        self.dataManager.saveWorout(of: type, from: workout) { (succ, err) in
            if succ{
                handler(true)
            }else{
                handler(false)
            }
        }
    }
    
    func getUserInfo(){
        self.dataManager.authorize { (succ) in
            if succ{
                self.dataManager.queryPersonalInfo { (age, sex) in
                    if let age = age, let sex = sex{
                        DispatchQueue.main.async {
                            self.age = age
                            self.sex = sex
                        }

                    }
                }
            }
        }
    }
    
    func getWorkouts(){
        self.dataManager.authorize { (succ) in
            if succ {
                self.dataManager.queryWokouts(of: .running, from: 7) { (workouts) in
                    DispatchQueue.main.async {
                        self.workouts.removeAll()
                        for workout in workouts{
                            let duration = workout.duration
                            if let distance = workout.totalDistance?.doubleValue(for: .meter()) {
                                let startDate = workout.startDate
                                let endDate = workout.endDate
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
