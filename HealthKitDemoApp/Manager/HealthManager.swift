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
    // Funkcia na poziadanie povolenia o citanie a zapis jednotlivych zaznamov z HK
    func authorize(handler: @escaping (Bool) -> Void){
        if let healthStore = self.healthStore {
            healthStore.requestAuthorization(toShare: ([.workoutType(), HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!, HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.distanceWalkingRunning)!, HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.activeEnergyBurned)!]), read: ([.workoutType(), HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!, HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.distanceWalkingRunning)!, HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.activeEnergyBurned)!,HKObjectType.characteristicType(forIdentifier: .dateOfBirth)!,HKObjectType.characteristicType(forIdentifier: .biologicalSex)!])) { (succ, err) in
                handler(succ)
            }
        }
    }
   
    // Funkcia na uloženie tréningu
    func saveWorout(of type: HKWorkoutActivityType,from workout: Workout, handler: @escaping (Bool, Error?) -> Void){
        let conf = HKWorkoutConfiguration() // Vytvorenie konfigurýcie
        conf.activityType = type
        if let healthStore = self.healthStore{ // Ak je zariadenie pripravené na HK
            let builder = HKWorkoutBuilder(healthStore: healthStore, configuration: conf, device: .local()) // Builder pre zostavenie treningu
            builder.beginCollection(withStart: workout.stratDateTime) { (succ, err) in // Oznacime zaciatok treningu
                if !succ {
                    handler(false,err)
                    return
                }
            }
            
            guard let quantityType = HKQuantityType.quantityType( forIdentifier: .activeEnergyBurned) else { // Vytvorime kvantitativne typy pre spalene kalorie
                handler(false, nil)
                return
            }
            
            guard let distanceQuantityType = HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning) else { // Vytvorime kvantitativny typ pre vzdialenost
                handler(false,nil)
                return
            }
            
            let kcalBurned = HKQuantity(unit: .kilocalorie(), doubleValue: workout.calories ?? 0)
            let sample = HKCumulativeQuantitySample(type: quantityType, quantity: kcalBurned, start: workout.stratDateTime, end: workout.endDateTime)
            let distance = HKQuantity(unit: HKUnit.meterUnit(with: .kilo), doubleValue: (workout.distance ?? 0) / 1000 )
            let distanceSample = HKCumulativeQuantitySample(type: distanceQuantityType, quantity: distance, start: workout.stratDateTime, end: workout.endDateTime)
            
            
            builder.add([sample, distanceSample]) { (succ, err) in // Nahrame dane hodnoty do treningu
                if !succ {
                    handler(false,err)
                    return
                }
                
                builder.endCollection(withEnd: workout.endDateTime) { (succ, err) in // Ukoncime kolekciu sucastnym datumom
                    if !succ {
                        handler(false,err)
                        return
                    }
                    
                    builder.finishWorkout { (_, err) in // Ukoncime trening
                        let succ = err == nil
                        handler(succ, err)
                    }
                }
                
                
            }
        }
        
    }
    // Funkcia na ziskanie informácií o veku a pohlaví
    func queryPersonalInfo(handler: @escaping (Int?, HKBiologicalSex?) -> Void){
        guard let healthStore = self.healthStore else {return}
        do{
            let birthdayComponents =  try healthStore.dateOfBirthComponents()
            let biologicalSex =       try healthStore.biologicalSex()
            
            // Vypocet veku uzivatela
            let today = Date()
            let calendar = Calendar.current
            let todayDateComponents = calendar.dateComponents([.year],
                                                              from: today)
            let thisYear = todayDateComponents.year!
            let age = thisYear - birthdayComponents.year!
            handler(age, biologicalSex.biologicalSex)
        }catch{
            handler(nil,nil)
        }
    }
    
    // Funkcia na citanie treningov
    func queryWokouts(of type: HKWorkoutActivityType, from last: Int, handler: @escaping ([HKWorkout]) -> Void){
        guard let healthStore = self.healthStore else {return}
        let activityType = HKQuery.predicateForWorkouts(with: type)
        let timeFrame = HKQuery.predicateForSamples(withStart: Calendar.current.date(byAdding: .day ,value: -last, to: Date()), end: Date(), options: []) // Urcujeme od kedy chceme dane treningy hladat
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
    
    // Funkcia na citanie zodpovedajucej srdcovej frekvencie danemu treningu
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
