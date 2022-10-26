//
//  Patient.swift
//  Medonapp iOS
//
//  Created by Harshal Kulkarni on 26/10/22.
//

import Foundation

class Patient: Codable {
    var id: Int?
    var credential: Credential?
    var name: NameInclMiddleName?
    var address: Address?
    var mobile: MobileWithCountryCode?
    var dob, bloodGroup, age, gender: String?
    var height: Double?
    var weight: Double?
    var healthStatus: JSONNull?
    var profileImage: ProfileImage?

    init(id: Int?, credential: Credential?, name: NameInclMiddleName?, address: Address?, mobile: MobileWithCountryCode?, dob: String?, bloodGroup: String?, age: String?, gender: String?, height: Double?, weight: Double?, healthStatus: JSONNull?, profileImage: ProfileImage?) {
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
