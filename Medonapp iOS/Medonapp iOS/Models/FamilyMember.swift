//
//  FamilyMember.swift
//  Medonapp iOS
//
//  Created by Harshal Kulkarni on 02/03/23.
//

import Foundation

class FamilyMember: Codable {
    var name, requestStatus, type: String?
    var url: String?

    init(name: String?, requestStatus: String?, type: String?, url: String?) {
        self.name = name
        self.requestStatus = requestStatus
        self.type = type
        self.url = url
    }
}
