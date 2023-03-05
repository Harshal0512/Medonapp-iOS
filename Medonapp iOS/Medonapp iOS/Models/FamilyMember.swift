//
//  FamilyMember.swift
//  Medonapp iOS
//
//  Created by Harshal Kulkarni on 02/03/23.
//

import Foundation

class FamilyMember: Codable {
    var id: Int?
    var name, requestStatus, type: String?
    var url: String?

    init(id: Int?, name: String?, requestStatus: String?, type: String?, url: String?) {
        self.id = id
        self.name = name
        self.requestStatus = requestStatus
        self.type = type
        self.url = url
    }
}
