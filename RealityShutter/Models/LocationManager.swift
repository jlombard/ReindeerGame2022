//
//  LocationFetcher.swift
//  RealityShutter
//
//  Created by Sergen Gönenç on 02/12/2022.
//

/// **
/// Written completely by OpenAI ChatGPT.
/// Literal magic!
/// **

import CoreLocation

final class LocationManager: NSObject {
    private let locationManager = CLLocationManager()
    var userLocation: CLLocation?
    
    override init() {
        super.init()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func requestLocation() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
}

// MARK: - CLLocationManagerDelegate

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        userLocation = locations.first
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error: \(error.localizedDescription)")
    }
}
