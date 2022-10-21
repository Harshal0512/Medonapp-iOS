//
//  Doctor.swift
//  Medonapp iOS
//
//  Created by Harshal Kulkarni on 17/10/22.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let doctor = try? newJSONDecoder().decode(Doctor.self, from: jsonData)

//
// To parse values from Alamofire responses:
//
//   Alamofire.request(url).responseDoctor { response in
//     if let doctor = response.result.value {
//       ...
//     }
//   }

import Foundation
import Alamofire

// MARK: - Doctor
class Doctor: Codable {
    var id: Int?
    var credential: Credential?
    var profileImage: ProfileImage?
    var name: Name?
    var address: Address?
    var mobile: Mobile?
    var gender, specialization: String?
    var experience: Int?
    var about: [String]?
    var fees: Int?
    var liveStatus: Bool?
    var avgRating: Int?
    var availableFromInWeekdays, availableFromInWeekends: String?
    var maxAppointmentsInWeekdays, maxAppointmentsInWeekends: Int?
    var appointmentDuration: String?
    var weekdayAppointmentSlots, weekendAppointmentSlots: [String]?
    var patientCount: Int?
    
    init(id: Int?, credential: Credential?, profileImage: ProfileImage?, name: Name?, address: Address?, mobile: Mobile?, gender: String?, specialization: String?, experience: Int?, about: [String]?, fees: Int?, liveStatus: Bool?, avgRating: Int?, availableFromInWeekdays: String?, availableFromInWeekends: String?, maxAppointmentsInWeekdays: Int?, maxAppointmentsInWeekends: Int?, appointmentDuration: String?, weekdayAppointmentSlots: [String]?, weekendAppointmentSlots: [String]?, patientCount: Int?) {
        self.id = id
        self.credential = credential
        self.profileImage = profileImage
        self.name = name
        self.address = address
        self.mobile = mobile
        self.gender = gender
        self.specialization = specialization
        self.experience = experience
        self.about = about
        self.fees = fees
        self.liveStatus = liveStatus
        self.avgRating = avgRating
        self.availableFromInWeekdays = availableFromInWeekdays
        self.availableFromInWeekends = availableFromInWeekends
        self.maxAppointmentsInWeekdays = maxAppointmentsInWeekdays
        self.maxAppointmentsInWeekends = maxAppointmentsInWeekends
        self.appointmentDuration = appointmentDuration
        self.weekdayAppointmentSlots = weekdayAppointmentSlots
        self.weekendAppointmentSlots = weekendAppointmentSlots
        self.patientCount = patientCount
    }
    
    static private var doctors: [Doctor] = []
    
    static func getDoctors() -> [Doctor] {
        return doctors
    }
    
    static func clearDoctors() {
        doctors = []
    }
    
    static func refreshDoctors(completionHandler: @escaping () -> ()) {
        //Refresh Doctors from API
    }
    
    static func initDoctors(doctors: [Doctor]) {
        self.doctors = doctors
    }
}

//
// To parse values from Alamofire responses:
//
//   Alamofire.request(url).responseAddress { response in
//     if let address = response.result.value {
//       ...
//     }
//   }

// MARK: - Address
class Address: Codable {
    var address, state, city, postalCode: String?
    var latitude, longitude: JSONNull?
    var fullAddressWithoutState, fullAddressWithoutPostalCode, fullAddress: String?

    init(address: String?, state: String?, city: String?, postalCode: String?, latitude: JSONNull?, longitude: JSONNull?, fullAddressWithoutState: String?, fullAddressWithoutPostalCode: String?, fullAddress: String?) {
        self.address = address
        self.state = state
        self.city = city
        self.postalCode = postalCode
        self.latitude = latitude
        self.longitude = longitude
        self.fullAddressWithoutState = fullAddressWithoutState
        self.fullAddressWithoutPostalCode = fullAddressWithoutPostalCode
        self.fullAddress = fullAddress
    }
}

//
// To parse values from Alamofire responses:
//
//   Alamofire.request(url).responseCredential { response in
//     if let credential = response.result.value {
//       ...
//     }
//   }

// MARK: - Credential
class Credential: Codable {
    var email, password, createdOn, lastLogin: String?

    init(email: String?, password: String?, createdOn: String?, lastLogin: String?) {
        self.email = email
        self.password = password
        self.createdOn = createdOn
        self.lastLogin = lastLogin
    }
}

//
// To parse values from Alamofire responses:
//
//   Alamofire.request(url).responseName { response in
//     if let name = response.result.value {
//       ...
//     }
//   }

// MARK: - Mobile
class Mobile: Codable {
    var contactNumber, countryCode, contactNumberWithCountryCode: String?

    init(contactNumber: String?, countryCode: String?, contactNumberWithCountryCode: String?) {
        self.contactNumber = contactNumber
        self.countryCode = countryCode
        self.contactNumberWithCountryCode = contactNumberWithCountryCode
    }
}

// MARK: - Name
class Name: Codable {
    var firstName, middleName, lastName, fullName: String?

    init(firstName: String?, middleName: String?, lastName: String?, fullName: String?) {
        self.firstName = firstName
        self.middleName = middleName
        self.lastName = lastName
        self.fullName = fullName
    }
}

//
// To parse values from Alamofire responses:
//
//   Alamofire.request(url).responseProfileImage { response in
//     if let profileImage = response.result.value {
//       ...
//     }
//   }

// MARK: - ProfileImage
class ProfileImage: Codable {
    var fileName, filePath: String?
    var fileDownloadURI: String?
    var fileType: String?
    var fileSize: Int?

    enum CodingKeys: String, CodingKey {
        case fileName, filePath
        case fileDownloadURI = "fileDownloadUri"
        case fileType, fileSize
    }

    init(fileName: String?, filePath: String?, fileDownloadURI: String?, fileType: String?, fileSize: Int?) {
        self.fileName = fileName
        self.filePath = filePath
        self.fileDownloadURI = fileDownloadURI
        self.fileType = fileType
        self.fileSize = fileSize
    }
}

