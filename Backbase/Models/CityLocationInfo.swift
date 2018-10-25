//
//  CityLocationInfo.swift
//  Backbase
//
//  Created by george liu on 10/24/18.
//  Copyright © 2018 george liu. All rights reserved.
//

import MapKit


class CityLocationInfo: NSObject, MKAnnotation {
    let title: String?
    let locationName: String
    let discipline: String
    let coordinate: CLLocationCoordinate2D
    
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
