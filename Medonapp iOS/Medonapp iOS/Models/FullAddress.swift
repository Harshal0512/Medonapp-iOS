//
//  Address.swift
//  Medonapp iOS
//
//  Created by Harshal Kulkarni on 26/10/22.
//

import Foundation

class FullAddress: Codable {
    var address, state, city, postalCode: String?
    var latitude, longitude: Double?
    var fullAddressWithoutState, fullAddressWithoutPostalCode, fullAddress: String?

    init(address: String?, state: String?, city: String?, postalCode: String?, latitude: Double?, longitude: Double?, fullAddressWithoutState: String?, fullAddressWithoutPostalCode: String?, fullAddress: String?) {
        self.address = address
        self.state = state
        self.city = city
        self.postalCode = postalCode
        self.latitude = latitude ?? 0.0
        self.longitude = longitude ?? 0.0
        self.fullAddressWithoutState = fullAddressWithoutState
        self.fullAddressWithoutPostalCode = fullAddressWithoutPostalCode
        self.fullAddress = fullAddress
    }
}
