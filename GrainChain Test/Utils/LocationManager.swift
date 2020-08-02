//
//  LocationManager.swift
//  GrainChain Test
//
//  Created by Misael Rivera on 30/07/20.
//  Copyright © 2020 Misael Rivera. All rights reserved.
//

import Foundation
import CoreLocation

protocol LocationManagerChangesDelagate {
    func userLocationDidChanged(location: CLLocationCoordinate2D)
    func showUserLocationInMap(location: CLLocationCoordinate2D?)
    func isTrackingModeOn(location: CLLocationCoordinate2D)
}

class LocationManager:NSObject {
    
    static var shared = LocationManager()
    private let locationManager = CLLocationManager()
    private var currentAccurateLocation:CLLocation?
    var isTracking = false
    var isTrackingModeOn = false
    var delegate: LocationManagerChangesDelagate?
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    func startTrackingGPS() {
        setupLocation()
    }
    
    func stopTrackingGPS() {
        locationManager.stopUpdatingLocation()
    }
    
    private func validateLocationUseAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .denied:
            //TODO: Show alert telling users how to turn on permissions
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            //TODO: Show an alert letting them know what's up
            break
        case .authorizedAlways,.authorizedWhenInUse:
            locationManager.startUpdatingLocation()
            self.delegate?.showUserLocationInMap(location: locationManager.location?.coordinate)
            break
        @unknown default:
            fatalError()
        }
    }
    
    private func setupLocation() {
        if CLLocationManager.locationServicesEnabled() {
            validateLocationUseAuthorization()
        }
    }
    
    public func getCurrentMoreAccurateLocation() -> CLLocation? {
        return self.currentAccurateLocation
    }
    
}

extension LocationManager:CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        setupLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        
        if isTracking {
            self.delegate?.userLocationDidChanged(location: location.coordinate)
        }else if isTrackingModeOn {
            self.delegate?.isTrackingModeOn(location: location.coordinate)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}
