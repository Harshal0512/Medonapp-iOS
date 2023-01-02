//
//  User.swift
//  Medonapp iOS
//
//  Created by Harshal Kulkarni on 26/10/22.
//

import Foundation
import CoreLocation

class User: Codable {
    var token: String?
    var patient: Patient?

    init(token: String?, patient: Patient?) {
        self.token = token
        self.patient = patient
    }
    
    init() {
        patient = Patient()
        token = ""
    }
    
    static private var userDetails: User = User()
    
    static func getUserDetails() -> User {
        return userDetails
    }
    
    static func clearUserDetails() {
        userDetails = User()
        Prefs.userDetails = User()
    }
    
    static func setUserDetails(userDetails: User) {
        self.userDetails.token = userDetails.token
        self.userDetails.patient = userDetails.patient
        
        saveToPrefs()
    }
    
    static func setPatientDetails(patient: Patient) {
        self.userDetails.patient = patient
        
        saveToPrefs()
    }
    
    static func saveToPrefs() {
        Prefs.userDetails = userDetails
    }
    
    static func loadFromPrefs() {
        userDetails = Prefs.userDetails
    }
    
    static func setUserLocation(location: CLLocation) {
        self.userDetails.patient?.currentUserlocation = location
    }
    
    static func getUserLocation() -> CLLocation {
        return (self.userDetails.patient?.currentUserlocation)!
    }
}
