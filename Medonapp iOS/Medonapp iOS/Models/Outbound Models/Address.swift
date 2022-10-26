//
//  Address.swift
//  Medonapp iOS
//
//  Created by Harshal Kulkarni on 26/10/22.
//

import Foundation

class Address: Codable {
    var address = ""
    var state = ""
    var city = ""
    var postalCode = ""

    init(address: String, state: String, city: String, postalCode: String) {
        self.address = address
        self.state = state
        self.city = city
        self.postalCode = postalCode
    }
}
