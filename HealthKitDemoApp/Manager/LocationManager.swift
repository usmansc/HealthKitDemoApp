//
//  LocationManager.swift
//  HealthKitDemoApp
//
//  Created by Lukas Schmelcer on 13/12/2020.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
    static let shared: CLLocationManager = CLLocationManager()
    private var location: CLLocationCoordinate2D?
    var resetKalmanFilter: Bool = false
    var useKalmanFilter: Bool = false
    var useLocationFilter: Bool = true
    var horizontalAccuracy = 30.0
    var timeInterval = 10.0
    
    override init() {
        super.init()
        if CLLocationManager.locationServicesEnabled() {
            LocationManager.shared.delegate = self
            LocationManager.shared.requestWhenInUseAuthorization()
            LocationManager.shared.allowsBackgroundLocationUpdates = true
            LocationManager.shared.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        }else{
            print("Todo handle error" )
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let myLocation: CLLocation = locations.first!
        if useLocationFilter{
            if myLocation.horizontalAccuracy < 0 || myLocation.horizontalAccuracy > self.horizontalAccuracy || myLocation.timestamp.timeIntervalSinceNow > self.timeInterval {
                return
            }
        }
        
        if !useKalmanFilter {
            self.location = myLocation.coordinate
            return
        }
        
        self.location = myLocation.coordinate
        
        
    }
    
    
    func getLocation() -> CLLocationCoordinate2D? {
        return self.location
    }
    
}
