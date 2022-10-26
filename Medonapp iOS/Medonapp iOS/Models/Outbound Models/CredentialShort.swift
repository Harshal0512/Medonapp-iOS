//
//  CredentialShort.swift
//  Medonapp iOS
//
//  Created by Harshal Kulkarni on 26/10/22.
//

import Foundation

class CredentialShort: Codable {
    var email = ""
    var password = ""

    init(email: String, password: String) {
        self.email = email
        self.password = password
    }
}
