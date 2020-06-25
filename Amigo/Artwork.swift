//
//  Artwork.swift
//  Amigo
//
//  Created by אביעד on 08/01/2020.
//  Copyright © 2020 Shiran Klein. All rights reserved.
//
import MapKit

class Artwork: NSObject, MKAnnotation {
    let title: String?
    let locationName: String
    let discipline: String
    let coordinate: CLLocationCoordinate2D
    
    //func to define the marker
    init(title: String, locationName: String, discipline: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.locationName = locationName
        self.discipline = discipline
        self.coordinate = coordinate
        
        super.init()
    }
    
    var subtitle: String? {
        return locationName
    }
}

import Foundation
