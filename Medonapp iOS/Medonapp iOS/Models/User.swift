//
//  User.swift
//  Medonapp iOS
//
//  Created by Harshal Kulkarni on 26/10/22.
//

import Foundation

class User: Codable {
    var token: String?
    var patient: Patient?

    init(token: String?, patient: Patient?) {
        self.token = token
        self.patient = patient
    }
    
    init() {
        token = ""
        patient = nil
    }
    
    static private var userDetails: User = User()
    
    static func getUserDetails() -> User {
        return userDetails
    }
    
    static func clearUserDetails() {
        userDetails = User()
//        saveToPrefs()
    }
    
    static func setUserDetails(userDetails: User) {
        self.userDetails.token = userDetails.token
        self.userDetails.patient = userDetails.patient
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
