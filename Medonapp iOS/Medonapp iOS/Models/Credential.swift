//
//  Credential.swift
//  Medonapp iOS
//
//  Created by Harshal Kulkarni on 26/10/22.
//

import Foundation

class Credential: Codable {
    var email, password, createdOn, lastLogin: String?

    init(email: String?, password: String?, createdOn: String?, lastLogin: String?) {
        self.email = email
        self.password = password
        self.createdOn = createdOn
        self.lastLogin = lastLogin
    }
}
