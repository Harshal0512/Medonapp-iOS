//
//  FavoriteDoctor.swift
//  Medonapp iOS
//
//  Created by Harshal Kulkarni on 20/12/22.
//

import Foundation

class FavoriteDoctor: Codable {
    var id: Int?
    var url: String?

    init(id: Int?, url: String?) {
        self.id = id
        self.url = url
    }
}
