//
//  Patient.swift
//  Medonapp iOS
//
//  Created by Harshal Kulkarni on 26/10/22.
//

import Foundation
import CoreLocation

class Patient: Codable {
    var id: Int?
    var credential: Credential?
    var name: NameInclMiddleName?
    var address: FullAddress?
    var mobile: MobileWithCountryCode?
    var currentUserlocation: CLLocation = CLLocation()
    var dob, bloodGroup, age, gender: String?
    var height: Double?
    var weight: Double?
    var healthStatus: JSONNull?
    var profileImage: FileModel?
    var favoriteDoctors: [FavoriteDoctor]?
    var medicalFiles: [FileModel]?
    
    enum CodingKeys: CodingKey {
        case id
        case credential
        case name
        case address
        case mobile
        case dob
        case bloodGroup
        case age
        case gender
        case height
        case weight
        case healthStatus
        case profileImage
        case favoriteDoctors
        case medicalFiles
    }

    init(id: Int?, credential: Credential?, name: NameInclMiddleName?, address: FullAddress?, mobile: MobileWithCountryCode?, dob: String?, bloodGroup: String?, age: String?, gender: String?, height: Double?, weight: Double?, healthStatus: JSONNull?, profileImage: FileModel?, favoriteDoctors: [FavoriteDoctor]?, medicalFiles: [FileModel]?) {
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
        self.favoriteDoctors = favoriteDoctors
        self.medicalFiles = medicalFiles
    }
    
    init() {
        self.id = 0
        self.credential = nil
        self.name = nil
        self.address = nil
        self.mobile = nil
        self.dob = ""
        self.bloodGroup = ""
        self.age = ""
        self.gender = ""
        self.height = 0.0
        self.weight = 0.0
        self.healthStatus = nil
        self.profileImage = nil
        self.favoriteDoctors = []
        self.medicalFiles = []
    }
}
