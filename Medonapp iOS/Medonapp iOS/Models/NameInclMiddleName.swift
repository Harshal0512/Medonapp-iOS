//
//  NameInclMiddleName.swift
//  Medonapp iOS
//
//  Created by Harshal Kulkarni on 26/10/22.
//

import Foundation

class NameInclMiddleName: Codable {
    var firstName, middleName, lastName, fullName: String?

    init(firstName: String?, middleName: String?, lastName: String?, fullName: String?) {
        self.firstName = firstName
        self.middleName = middleName
        self.lastName = lastName
        self.fullName = fullName
    }
}
