//
//  Review.swift
//  Medonapp iOS
//
//  Created by Harshal Kulkarni on 29/10/22.
//

import Foundation

class Review: Codable {
    var id, appointmentID: Int?
    var rating: Double?
    var review: String?

    enum CodingKeys: String, CodingKey {
        case id
        case appointmentID = "appointmentId"
        case rating, review
    }

    init(id: Int?, appointmentID: Int?, rating: Double?, review: String?) {
        self.id = id
        self.appointmentID = appointmentID
        self.rating = rating
        self.review = review
    }
}
