//
//  MobileNumberShort.swift
//  Medonapp iOS
//
//  Created by Harshal Kulkarni on 26/10/22.
//

import Foundation

class MobileNumberShort: Codable {
    var contactNumber = ""
    var countryCode = ""

    init(contactNumber: String, countryCode: String) {
        self.contactNumber = contactNumber
        self.countryCode = countryCode
    }
}
