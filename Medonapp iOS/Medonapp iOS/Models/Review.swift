//
//  Review.swift
//  Medonapp iOS
//
//  Created by Harshal Kulkarni on 29/10/22.
//

import Foundation

typealias Reviews = [Review]

class Review: Codable {
    var id, appointmentID: Int?
    var rating: Double?
    var review, reviewerName, reviewerImage: String?

    enum CodingKeys: String, CodingKey {
        case id
        case appointmentID = "appointmentId"
        case rating, review, reviewerName, reviewerImage
    }

    init(id: Int?, appointmentID: Int?, rating: Double?, review: String?, reviewerName: String?, reviewerImage: String?) {
        self.id = id
        self.appointmentID = appointmentID
        self.rating = rating
        self.review = review
        self.reviewerName = reviewerName
        self.reviewerImage = reviewerImage
    }
}
