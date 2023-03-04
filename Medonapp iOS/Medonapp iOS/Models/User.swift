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
    
    static func refreshUserDetails(completionHandler: @escaping(Bool) -> ()) {
        APIService(data: [:], headers: ["Authorization" : "Bearer \(User.getUserDetails().token ?? "")"], url: nil, service: .getPatientWithID(userDetails.patient!.id!), method: .get, isJSONRequest: false).executeQuery() { (result: Result<Patient, Error>) in
            switch result{
            case .success(_):
                try? User.setPatientDetails(patient: result.get())
                completionHandler(true)
            case .failure(let error):
                print(error)
                completionHandler(false)
            }
        }
    }
    
    static func getUserDetails() -> User {
        return userDetails
    }
    
    static func clearUserDetails() {
        userDetails = User()
        Prefs.userDetails = User()
    }
    
    static func setUserDetails(userDetails: User) {
        self.userDetails.token = userDetails.token
        User.setPatientDetails(patient: userDetails.patient!)
    }
    
    static func setPatientDetails(patient: Patient) {
        self.userDetails.patient = patient
        initPendingRequestsCount()
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
    
    static func initPendingRequestsCount() {
        for i in 0..<self.userDetails.patient!.familyMembers!.count {
            if self.userDetails.patient!.familyMembers![i].requestStatus == "PENDING" {
                self.userDetails.patient?.familyRequestsPendingCountAsOrganizer.0 += 1
                self.userDetails.patient?.familyRequestsPendingCountAsOrganizer.1.append(i)
            } else if self.userDetails.patient!.familyMembers![i].requestStatus == "ACCEPTED" {
                self.userDetails.patient?.familyMembersActiveCount.0 += 1
                self.userDetails.patient?.familyMembersActiveCount.1.append(i)
            }
        }
    }
}
