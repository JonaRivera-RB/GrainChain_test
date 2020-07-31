//
//  CLLocationDistanceExtension.swift
//  GrainChain Test
//
//  Created by Misael Rivera on 30/07/20.
//  Copyright © 2020 Misael Rivera. All rights reserved.
//

import GoogleMaps

extension CLLocationDistance {
    func inMiles() -> CLLocationDistance {
        return self*0.00062137
    }
    
    func inKilometers() -> CLLocationDistance {
        return self/1000
    }
}
