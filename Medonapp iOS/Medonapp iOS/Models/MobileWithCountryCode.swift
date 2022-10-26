//
//  MobileWithCountryCode.swift
//  Medonapp iOS
//
//  Created by Harshal Kulkarni on 26/10/22.
//

import Foundation

class MobileWithCountryCode: Codable {
    var contactNumber, countryCode, contactNumberWithCountryCode: String?

    init(contactNumber: String?, countryCode: String?, contactNumberWithCountryCode: String?) {
        self.contactNumber = contactNumber
        self.countryCode = countryCode
        self.contactNumberWithCountryCode = contactNumberWithCountryCode
    }
}
