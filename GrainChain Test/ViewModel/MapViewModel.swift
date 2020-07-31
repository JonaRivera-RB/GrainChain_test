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
    private var km: String = ""
    private let database = Database()
    
    init() {
        database.initDatabase()
        database.createDatabase()
    }
    
    mutating func verifyIfUserHasChangedLocation(lastLocation: CLLocationCoordinate2D) -> CLLocationCoordinate2D? {
        
        guard let lastLatitudeSaved = lastLocationSaved?.latitude else { return nil}
        guard let lastLongitudeSaved = lastLocationSaved?.longitude else { return nil}
        
        let startLocation = CLLocation(latitude: lastLatitudeSaved, longitude: lastLongitudeSaved)
        let endLocation = CLLocation(latitude: lastLocation.latitude, longitude: lastLocation.longitude)
        
        let distance: CLLocationDistance = startLocation.distance(from: endLocation)
        let km = distance.inKilometers()
        
        if km > 0.05 {
            self.km = String(format: "%.3f", km)
            return lastLocation
        }else {
            return nil
        }
    }
    
    mutating func setupLastLocation(lastLocation: CLLocationCoordinate2D) {
        self.lastLocationSaved = lastLocation
    }
    
    func saveRouteInDatabase(routes: [Coordinates], forNameRoute name: String, time: Int) {
        
        var latitudes = ""
        var longitudes = ""
        
        for route in routes {
            latitudes += String(route.latitude) + ","
        }
        
        for route in routes {
            longitudes += String(route.longitude) + ","
        }
        
        let (h,m,s) = secondsToHoursMinutesSeconds(seconds: time)
        let stringTime = "Mi recorrido fue de \(h) horas :\(m) minutos :\(s) segundos!"
        let route = Route(id: 0, name: name, km: km + " KM", time: stringTime, latitude: latitudes, longitude: longitudes)
        database.insertRoute(route: route) { success in
            print("SUCCESS")
        }
    }
    
    private func secondsToHoursMinutesSeconds(seconds : Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
}
