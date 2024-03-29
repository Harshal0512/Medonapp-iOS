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

enum applicationModes: Encodable, Decodable {
    case testing
    case production
}

struct Prefs {
    static var isNetworkAvailable: Bool = false
    
    @Storage(key: "applicationMode", defaultValue: .production)
    static var applicationMode: applicationModes
    
    @Storage(key: "isLocationPerm", defaultValue: false)
    static var isLocationPerm: Bool
    @Storage(key: "showDistanceFromUser", defaultValue: false)
    static var showDistanceFromUser: Bool
    
    @Storage(key: "userDetails", defaultValue: User())
    static var userDetails: User
    @Storage(key: "allDoctors", defaultValue: [])
    static var allDoctors: Doctors
    @Storage(key: "allAppointments", defaultValue: [])
    static var allAppointments: Appointments
    @Storage(key: "notifications", defaultValue: [])
    static var notifications: Notifications
    //    @EncryptedStringStorage(key: "password_key")
    //    static var password: String
    
}



class PrefDataManager {
    static func setApplicationMode(mode: applicationModes) {
        Prefs.applicationMode = mode
    }
    static func currentApplicationMode() -> applicationModes {
        return Prefs.applicationMode
    }
    static func clearAllPrefs() {
        Prefs.userDetails = User()
        Prefs.allDoctors = []
        Prefs.allAppointments = []
        Prefs.notifications = []
    }
}


extension Prefs {
    
    static func clearCredentials() {
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
        
    }
}
