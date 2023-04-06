//
//  ReviewExpandedTableViewCell.swift
//  Medonapp iOS
//
//  Created by Harshal Kulkarni on 06/04/23.
//

import UIKit

class ReviewExpandedTableViewCell: UITableViewCell {
    
    static let identifier = "ReviewExpandedTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "ReviewExpandedTableViewCell", bundle: nil)
    }

    @IBOutlet weak var userProfileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var reviewLabel: UILabel!
    @IBOutlet weak var ratingView: JStarRatingView!
    
    public func configure(review: Review) {
        self.userProfileImageView.setKFImage(imageUrl: review.reviewerImage ?? "https://i.ibb.co/jHvKxC3/broken-1.jpg", placeholderImage: UIImage(named: "userPlaceholder-male")!)
        self.userProfileImageView.contentMode = .scaleAspectFill
        self.userProfileImageView.layer.cornerRadius = 20
        self.nameLabel.text = review.reviewerName!
        self.reviewLabel.text = review.review
        self.ratingView.rating = Float(review.rating!)
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
