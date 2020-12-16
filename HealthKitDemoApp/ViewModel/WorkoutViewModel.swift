//
//  WorkoutViewModel.swift
//  HealthKitDemoApp
//
//  Created by Lukas Schmelcer on 13/12/2020.
//

import Foundation
import Combine
import CoreLocation


final class WorkoutViewModel: ObservableObject{
    var dataManager:CLLocationManager
    
    @Published var startCoordinates: CLLocation?
    @Published var currentCoordinates: CLLocation?
    @Published var distanceFromStart: Double = 0.0
    
    var route: [CLLocation] = [] 
    
    init(dataManager:CLLocationManager = LocationManager.shared) {
        self.dataManager = dataManager
        
    }
    
    func startCapturing(){
        self.dataManager.startUpdatingLocation()
        self.route = []
        self.actualizeLocation()
    }
    
    func stopCapturing(){
        self.dataManager.stopUpdatingLocation()
    }
    
    func actualizeLocation(){
        self.route.append(self.dataManager.location!)
        if startCoordinates == nil {
            self.startCoordinates = self.dataManager.location
        }else{
            self.currentCoordinates = self.dataManager.location
        }
        calculateDistance()
    }
    
    func calculateDistance(){
        
        if let currentCoordinates = self.currentCoordinates, let startCoordinates = startCoordinates{
            self.distanceFromStart = currentCoordinates.distance(from: startCoordinates)
        }
        
    }
}
