//
//  NormalNotifWithImageAndIconTableViewCell.swift
//  Medonapp iOS
//
//  Created by Harshal Kulkarni on 06/03/23.
//

import UIKit

class NormalNotifWithImageAndIconTableViewCell: UITableViewCell {
    
    static let identifier = "NormalNotifWithImageAndIconTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "NormalNotifWithImageAndIconTableViewCell", bundle: nil)
    }
    
    var notification: NotificationElement?

    @IBOutlet weak var iconBackgroundView: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var notifTitleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    
    public func configure(notification: NotificationElement) {
        self.notification = notification
        if notification.type!.contains("ACCEPT") {
            iconImageView.image = UIImage(systemName: "person.2")
            iconImageView.tintColor = UIColor(red: 0.00, green: 0.54, blue: 0.37, alpha: 1.00)
            iconBackgroundView.backgroundColor = UIColor(red: 0.84, green: 1.00, blue: 0.85, alpha: 1.00)
        } else if notification.type!.contains("REJECT") {
            iconImageView.image = UIImage(systemName: "person.fill.xmark")
            iconImageView.tintColor = UIColor(red: 0.59, green: 0.11, blue: 0.11, alpha: 1.00)
            iconBackgroundView.backgroundColor = UIColor(red: 0.95, green: 0.89, blue: 0.89, alpha: 1.00)
        }
        notifTitleLabel.text = notification.message
        let date = Date.dateFromISOString(string: notification.timestamp!, ending: ".SSSSSS")
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .short

        subtitleLabel.text = formatter.string(from: date!)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        iconBackgroundView.layer.cornerRadius = 23
        iconImageView.layer.cornerRadius = 21
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
