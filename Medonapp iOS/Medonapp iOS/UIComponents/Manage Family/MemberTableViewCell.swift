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
    
    public func configure(member: FamilyMember) {
        nameLabel.text = member.name! + ((member.id == User.getUserDetails().patient?.id) ? " (Me)" : "")
        ageAttributeLabel.text = (member.type == "ORGANIZER") ? "Organizer" : "Adult"
        memberImageView.setKFImage(imageUrl: member.url ?? "https://i.ibb.co/jHvKxC3/broken-1.jpg", placeholderImage: UIImage(named: ("male" == "male") ? "userPlaceholder-male" : "userPlaceholder-female")!)
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
