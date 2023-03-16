//
//  UpdateUserModel.swift
//  Medonapp iOS
//
//  Created by Harshal Kulkarni on 16/03/23.
//

import Foundation

struct UpdateUserModel: Codable {
    var name: NameExclMiddleName
    var address: Address
    var gender: String = ""
    var mobile: MobileNumberShort
    var dob: String = ""
    var bloodGroup: String = ""
    var height: Double
    var weight: Double
}
