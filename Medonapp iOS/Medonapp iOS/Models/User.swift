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
        Prefs.authToken = ""
        Prefs.userId = "0"
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
        Prefs.authToken = userDetails.token ?? ""
        Prefs.userId = "\(userDetails.patient?.id ?? 0)"
    }
    
    static func loadFromPrefs() {
        userDetails.token = Prefs.authToken
        userDetails.patient?.id = Int(Prefs.userId)
    }
    
    static func setUserLocation(location: CLLocation) {
        self.userDetails.patient?.currentUserlocation = location
    }
    
    static func getUserLocation() -> CLLocation {
        return (self.userDetails.patient?.currentUserlocation)!
    }
    
//    static func saveToPrefs() {
//        Prefs.authToken = self.userDetails.token
//        Prefs.email = self.userDetails.email
//        Prefs.userId = self.userDetails.id
//        Prefs.name = self.userDetails.name
//        Prefs.profile = self.userDetails.displayPhoto
//        Prefs.suburb = self.userDetails.suburb
//        Prefs.isDeliveryAgent = self.userDetails.isDeliveryAgent
//        Prefs.isAgentVerified = self.userDetails.isAgentVerified
//        Prefs.stripeBankConnected = self.userDetails.stripeBankConnected
//        Prefs.stripeCustomerId = self.userDetails.stripeCustomerId
//        Prefs.accountLinkUrl = self.userDetails.accountLinkUrl
//    }
//
//    static func loadFromPrefs() {
//        self.userDetails.token = Prefs.authToken
//        self.userDetails.email = Prefs.email
//        self.userDetails.id = Prefs.userId
//        self.userDetails.name = Prefs.name
//        self.userDetails.displayPhoto = Prefs.profile
//        self.userDetails.suburb = Prefs.suburb
//        self.userDetails.isDeliveryAgent = Prefs.isDeliveryAgent
//        self.userDetails.isAgentVerified = Prefs.isAgentVerified
//        self.userDetails.stripeCustomerId = Prefs.stripeCustomerId
//        self.userDetails.stripeBankConnected = Prefs.stripeBankConnected
//        self.userDetails.accountLinkUrl = Prefs.accountLinkUrl
//    }
}
