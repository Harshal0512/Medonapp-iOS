//
//  Address.swift
//  Medonapp iOS
//
//  Created by Harshal Kulkarni on 26/10/22.
//

import Foundation

class Address: Codable {
    var address, state, city, postalCode: String?
    var latitude, longitude: JSONNull?
    var fullAddressWithoutState, fullAddressWithoutPostalCode, fullAddress: String?

    init(address: String?, state: String?, city: String?, postalCode: String?, latitude: JSONNull?, longitude: JSONNull?, fullAddressWithoutState: String?, fullAddressWithoutPostalCode: String?, fullAddress: String?) {
        self.address = address
        self.state = state
        self.city = city
        self.postalCode = postalCode
        self.latitude = latitude
        self.longitude = longitude
        self.fullAddressWithoutState = fullAddressWithoutState
        self.fullAddressWithoutPostalCode = fullAddressWithoutPostalCode
        self.fullAddress = fullAddress
    }
}
