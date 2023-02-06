//
//  FamilyMemberCollectionViewCell.swift
//  Medonapp iOS
//
//  Created by Harshal Kulkarni on 28/01/23.
//

import UIKit

class FamilyMemberCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "FamilyMemberCollectionViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "FamilyMemberCollectionViewCell", bundle: nil)
    }
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var memberImageView: UIImageView!
    
    public func configure(imageURL: String) {
        containerView.backgroundColor = .clear
        memberImageView.setKFImage(imageUrl: imageURL ?? "https://i.ibb.co/jHvKxC3/broken-1.jpg", placeholderImage: UIImage(named: ("male" == "male") ? "userPlaceholder-male" : "userPlaceholder-female")!)
        memberImageView.layer.cornerRadius = 27
        memberImageView.layer.borderWidth = 3
        memberImageView.layer.borderColor = UIColor.white.cgColor
        memberImageView.contentMode = .scaleAspectFill
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
