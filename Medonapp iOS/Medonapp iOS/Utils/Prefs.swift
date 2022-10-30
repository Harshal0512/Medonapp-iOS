//
//  Prefs.swift
//  Medonapp iOS
//
//  Created by Harshal Kulkarni on 26/10/22.
//

import Foundation

@propertyWrapper
struct Storage<T: Codable> {
    
    struct Wrapper<T> : Codable where T : Codable {
        let wrapped : T
    }
    
    private let key: String
    private let defaultValue: T
    
    init(key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }
    
    var wrappedValue: T {
        get {
            // Read value from UserDefaults
            guard let data = UserDefaults.standard.object(forKey: key) as? Data else {
                // Return defaultValue when no data in UserDefaults
                return defaultValue
            }
            
            // Convert data to the desire data type
            let value = try? JSONDecoder().decode(Wrapper<T>.self, from: data)
            return value?.wrapped ?? defaultValue
        }
        set {
            do {
                // Convert newValue to data
                let data = try JSONEncoder().encode(Wrapper(wrapped: newValue))
                // Set value to UserDefaults
                UserDefaults.standard.set(data, forKey: key)
            }catch{
                print(error)
            }
        }
    }
}

struct Prefs {
    
    @Storage(key: "authToken", defaultValue: "")
    static var authToken: String
    @Storage(key: "userId", defaultValue: "")
    static var userId: String
    @Storage(key: "profilePic", defaultValue: "")
    static var profile: String
    @Storage(key: "notifFromTime", defaultValue: "")
    static var notifFromTime: String
    @Storage(key: "fcmToken", defaultValue: "")
    static var fcmToken: String
    @Storage(key: "inProgressLiveClassId", defaultValue: "")
    static var inProgressLiveClassId: String
    
    @Storage(key: "userLat", defaultValue: 0.0)
    static var userLat: Double
    @Storage(key: "userLon", defaultValue: 0.0)
    static var userLon: Double
    
    @Storage(key: "name", defaultValue: "")
    static var name: String
    
    @Storage(key: "suburb", defaultValue: "")
    static var suburb: String
    
    @Storage(key: "email", defaultValue: "")
    static var email: String
    
    @Storage(key: "isDeliveryAgent", defaultValue: false)
    static var isDeliveryAgent: Bool
    
    @Storage(key: "isAgentVerified", defaultValue: false)
    static var isAgentVerified: Bool
    
    @Storage(key: "stripeBankConnected", defaultValue: false)
    static var stripeBankConnected: Bool
    
    @Storage(key: "accountLinkUrl", defaultValue: "")
    static var accountLinkUrl: String
    
    @Storage(key: "stripeCustomerId", defaultValue: "")
    static var stripeCustomerId: String
    
    @Storage(key: "activationCode", defaultValue: "")
    static var activationCode: String
    
    @Storage(key: "passwordCode", defaultValue: "x")
    static var passwordCode: String
    
    @Storage(key: "newPassword", defaultValue: "")
    static var newPassword: String
    
    @Storage(key: "oldPassword", defaultValue: "")
    static var oldPassword: String
    
    @Storage(key: "classCount", defaultValue: 0)
    static var classCount: Int
    @Storage(key: "hideCountInviteStudentsInClassOverview", defaultValue: 0)
    static var hideCountInviteStudentsInClassOverview: Int
    @Storage(key: "currentLanguage", defaultValue: "ro")
    static var currentLanguage: String
    
    @Storage(key: "isRefreshedAppVersionInfo", defaultValue: 0)
    static var isRefreshedAppVersionInfo: TimeInterval
    
    // Declare a User object
//    @Storage(key: "userDetails", defaultValue: nil)
//    static var userDetails: UserDetailsObject?
    
//    @Storage(key: "appConfigData", defaultValue: nil)
//    static var appConfigData: AppConfigDataObject?
    
    @Storage(key: "hasEverSwitchedToTeacher", defaultValue: false)
    static var hasEverSwitchedToTeacher: Bool
    
    //Review prefs
    @Storage(key: "meetingStartTime", defaultValue: nil)
    static var meetingStartTime: Date?
    @Storage(key: "hasSeenAttendance", defaultValue: false)
    static var hasSeenAttendance: Bool
    @Storage(key: "hasUploadedResource", defaultValue: false)
    static var hasUploadedResource: Bool
    @Storage(key: "hasSentCoteacherRequest", defaultValue: false)
    static var hasSentCoteacherRequest: Bool
    @Storage(key: "hasTeacherSeenStudentReports", defaultValue: false)
    static var hasTeacherSeenStudentReports: Bool
    @Storage(key: "hasCreatedPoll", defaultValue: false)
    static var hasCreatedPoll: Bool
    
    @Storage(key: "hasAddedComment", defaultValue: false)
    static var hasAddedComment: Bool
    @Storage(key: "hasOpenedResource", defaultValue: false)
    static var hasOpenedResource: Bool
    @Storage(key: "hasCreatedPoster", defaultValue: false)
    static var hasCreatedPoster: Bool
    @Storage(key: "hasVotedInPoll", defaultValue: false)
    static var hasVotedInPoll: Bool
    @Storage(key: "hasSeenStudentReports", defaultValue: false)
    static var hasSeenStudentReports: Bool
    @Storage(key: "hasSeenLectureRecording", defaultValue: false)
    static var hasSeenLectureRecording: Bool
    
    //    @EncryptedStringStorage(key: "password_key")
    //    static var password: String
    
}



class PrefDataManager {
    
}


extension Prefs {
    
    static func saveAppVersionInfoRefreshTimeStamp() {
        let earlyDate = Calendar.current.date(
            byAdding: .day,
            value: 2,
            to: Date().localDate())
        Prefs.isRefreshedAppVersionInfo = earlyDate?.timeIntervalSince1970 ?? 0
    }
    
    static func isAppVersionInfoRefreshNeeded() -> Bool {
        if Prefs.isRefreshedAppVersionInfo == 0{
            return true
        }
        let refreshedTimeStamp = Prefs.isRefreshedAppVersionInfo
        let dateRefreshed: Date = Date.init(timeIntervalSince1970: refreshedTimeStamp)
        if Date().localDate() >  dateRefreshed {
            return true
        }
        return false
    }
    
    static func clearCredentials() {
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
        
    }
}
