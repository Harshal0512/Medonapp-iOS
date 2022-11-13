//
//  UserLocation.swift
//  Medonapp iOS
//
//  Created by Harshal Kulkarni on 13/11/22.
//

import Foundation

class UserLocation: Codable {
    var longitude: Double
    var latitude: Double
    
    init(longitude: Double, latitude: Double) {
        self.longitude = longitude
        self.latitude = latitude
    }
    
    init() {
        self.longitude = 0.0
        self.latitude = 0.0
    }
}
