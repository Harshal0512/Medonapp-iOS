//
//  DefaultResponseModel.swift
//  Medonapp iOS
//
//  Created by Harshal Kulkarni on 13/12/22.
//

import Foundation
class DefaultResponseModel: Codable {
    var message: String?

    enum CodingKeys: String, CodingKey {
        case message
    }

    init(message: String?) {
        self.message = message
    }
}
