//
//  SignUpModel.swift
//  Medonapp iOS
//
//  Created by Harshal Kulkarni on 26/10/22.
//

import Foundation

struct SignUpModel: Codable {
    var credential: CredentialShort
    var name: NameExclMiddleName
    var address: Address
    var gender: String = ""
    var mobile: MobileNumberShort
    var dob: String = ""
    var bloodGroup: String = ""
    var height: Double
    var weight: Double
}
