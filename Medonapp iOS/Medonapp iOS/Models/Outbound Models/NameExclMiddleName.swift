//
//  NameExclMiddleName.swift
//  Medonapp iOS
//
//  Created by Harshal Kulkarni on 26/10/22.
//

import Foundation

class NameExclMiddleName: Codable {
    var firstName = ""
    var lastName = ""

    init(firstName: String, lastName: String) {
        self.firstName = firstName
        self.lastName = lastName
    }
}
