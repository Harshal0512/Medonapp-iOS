//
//  Patient.swift
//  Medonapp iOS
//
//  Created by Harshal Kulkarni on 26/10/22.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let user = try? newJSONDecoder().decode(User.self, from: jsonData)

//
// To parse values from Alamofire responses:
//
//   Alamofire.request(url).responseUser { response in
//     if let user = response.result.value {
//       ...
//     }
//   }

import Foundation
import Alamofire

// MARK: - User
class User: Codable {
    var token: String?
    var patient: Patient?

    init(token: String?, patient: Patient?) {
        self.token = token
        self.patient = patient
    }
}

//
// To parse values from Alamofire responses:
//
//   Alamofire.request(url).responsePatient { response in
//     if let patient = response.result.value {
//       ...
//     }
//   }

// MARK: - Patient
class Patient: Codable {
    var id: Int?
    var credential: Credential?
    var name: NameInclMiddleName?
    var address: Address?
    var mobile: MobileWithCountryCode?
    var dob, bloodGroup, age, gender: String?
    var height: Int?
    var weight: Double?
    var healthStatus: JSONNull?
    var profileImage: ProfileImage?

    init(id: Int?, credential: Credential?, name: NameInclMiddleName?, address: Address?, mobile: MobileWithCountryCode?, dob: String?, bloodGroup: String?, age: String?, gender: String?, height: Int?, weight: Double?, healthStatus: JSONNull?, profileImage: ProfileImage?) {
        self.id = id
        self.credential = credential
        self.name = name
        self.address = address
        self.mobile = mobile
        self.dob = dob
        self.bloodGroup = bloodGroup
        self.age = age
        self.gender = gender
        self.height = height
        self.weight = weight
        self.healthStatus = healthStatus
        self.profileImage = profileImage
    }
}
