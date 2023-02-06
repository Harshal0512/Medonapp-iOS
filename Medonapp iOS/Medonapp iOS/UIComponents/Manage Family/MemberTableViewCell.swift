//
//  MemberTableViewCell.swift
//  Medonapp iOS
//
//  Created by Harshal Kulkarni on 28/01/23.
//

import UIKit

class MemberTableViewCell: UITableViewCell {
    
    static let identifier = "MemberTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "MemberTableViewCell", bundle: nil)
    }
    
    @IBOutlet weak var memberImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageAttributeLabel: UILabel!
    
    public func configure(name: String, age: String, link: String) {
        nameLabel.text = name
        ageAttributeLabel.text = age
        memberImageView.setKFImage(imageUrl: link ?? "https://i.ibb.co/jHvKxC3/broken-1.jpg", placeholderImage: UIImage(named: ("male" == "male") ? "userPlaceholder-male" : "userPlaceholder-female")!)
        memberImageView.layer.cornerRadius = 20
        memberImageView.contentMode = .scaleAspectFill
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
