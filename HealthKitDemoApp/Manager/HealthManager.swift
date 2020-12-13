//
//  HealthManager.swift
//  HealthKitDemoApp
//
//  Created by Lukas Schmelcer on 13/12/2020.
//

import Foundation
import HealthKit

class HealthManager{
    
    static let shared = HealthManager()
    private var healthStore: HKHealthStore?
    init() {
        if HKHealthStore.isHealthDataAvailable(){
            self.healthStore = HKHealthStore()
            
        }
    }
}


extension HealthManager{
    func authorize(handler: @escaping (Bool) -> Void){
        if let healthStore = self.healthStore {
            healthStore.requestAuthorization(toShare: ([.workoutType(), HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!]), read: ([.workoutType(), HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!])) { (succ, err) in
                handler(succ)
            }
        }
    }
    
    func queryWokouts(of type: HKWorkoutActivityType, from last: Int, handler: @escaping ([HKWorkout]) -> Void){
            guard let healthStore = self.healthStore else {return}
            let activityType = HKQuery.predicateForWorkouts(with: type)
            let timeFrame = HKQuery.predicateForSamples(withStart: Calendar.current.date(byAdding: .day ,value: -last, to: Date()), end: Date(), options: [])
            let sortBy = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: true)
    
            let combined = NSCompoundPredicate(andPredicateWithSubpredicates: [activityType,timeFrame])
    
            let query = HKSampleQuery.init(sampleType: .workoutType(), predicate: combined, limit: 0, sortDescriptors: [sortBy]) { (query, samples, err) in
                DispatchQueue.main.async {
                    guard let samples = samples as? [HKWorkout] else { return }
                    handler(samples)
                }
            }
        
            healthStore.execute(query)
    }
    
    func queryHeartRateForWorkout(from startDate: Date,to endDate: Date, handler: @escaping ([HKQuantitySample]) -> Void){
        guard let healthStore = self.healthStore else { return }
        let timeFrame = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: [])
        guard let type = HKQuantityType.quantityType(forIdentifier: .heartRate) else { return }
        
        let query = HKSampleQuery.init(sampleType: type, predicate: timeFrame, limit: 0, sortDescriptors: []) { (query, samples, err) in
            if let samples = samples as? [HKQuantitySample]{
                
                handler(samples)
            }
        }
        
        healthStore.execute(query)
    }
}
