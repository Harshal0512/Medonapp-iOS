//
//  FamilyRequestTableViewCell.swift
//  Medonapp iOS
//
//  Created by Harshal Kulkarni on 24/02/23.
//

import UIKit

protocol FamilyRequestCellProtocol {
    func didAcceptFamilyRequest(notification: NotificationElement)
    func didRejectFamilyRequest(notification: NotificationElement)
}

class FamilyRequestTableViewCell: UITableViewCell {
    
    static let identifier = "FamilyRequestTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "FamilyRequestTableViewCell", bundle: nil)
    }
    
    var delegate: FamilyRequestCellProtocol!
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var rejectButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    
    let boldConfig = UIImage.SymbolConfiguration(weight: .semibold)
    
    var notification: NotificationElement?

    public func configure(notification: NotificationElement) {
        self.notification = notification
        profileImageView.setKFImage(imageUrl: notification.senderURL ?? "https://i.ibb.co/jHvKxC3/broken-1.jpg", placeholderImage: UIImage(named: ("male" == "male") ? "userPlaceholder-male" : "userPlaceholder-female")!)
        nameLabel.text = notification.senderName
    }
    
    @IBAction func acceptButtonClicked(_ sender: Any) {
        delegate.didAcceptFamilyRequest(notification: notification!)
    }
    
    @IBAction func rejectButtonClicked(_ sender: Any) {
        delegate.didRejectFamilyRequest(notification: notification!)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        profileImageView.layer.cornerRadius = 23
        
        acceptButton.setImage(UIImage(systemName: "checkmark", withConfiguration: boldConfig), for: .normal)
        rejectButton.setImage(UIImage(systemName: "xmark", withConfiguration: boldConfig), for: .normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
