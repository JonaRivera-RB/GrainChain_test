//
//  MapViewModel.swift
//  GrainChain Test
//
//  Created by Misael Rivera on 30/07/20.
//  Copyright © 2020 Misael Rivera. All rights reserved.
//

import UIKit
import GoogleMaps

struct MapViewModel {
    
    var lastLocationSaved: CLLocationCoordinate2D?
    
    func verifyIfUserHasChangedLocation(lastLocation: CLLocationCoordinate2D) -> CLLocationCoordinate2D? {
        
        guard let lastLatitudeSaved = lastLocationSaved?.latitude else { return nil}
        guard let lastLongitudeSaved = lastLocationSaved?.longitude else { return nil}
        
        let startLocation = CLLocation(latitude: lastLatitudeSaved, longitude: lastLongitudeSaved)
        let endLocation = CLLocation(latitude: lastLocation.latitude, longitude: lastLocation.longitude)
        
        let distance: CLLocationDistance = startLocation.distance(from: endLocation)
        let km = distance.inKilometers()
        
        if km > 0.05 {
            return lastLocation
        }else {
            return nil
        }
    }
    
    mutating func setupLastLocation(lastLocation: CLLocationCoordinate2D) {
        self.lastLocationSaved = lastLocation
    }
}
