//
//  CityInfo.swift
//  Backbase
//
//  Created by george liu on 10/24/18.
//  Copyright © 2018 george liu. All rights reserved.
//

import Foundation

class CityInfo {
    
    var name: String
    var country: String
    var lat: Double
    var lon: Double
    
    init () {
        self.name = String()
        self.country = String()
        self.lat = 0.00
        self.lon = 0.00
    }
    
    init (name: String, country: String, lat: Double, lon: Double) {
        self.name = name
        self.country = country
        self.lat = lat
        self.lon = lon
    }

}   // end class CityInfo
