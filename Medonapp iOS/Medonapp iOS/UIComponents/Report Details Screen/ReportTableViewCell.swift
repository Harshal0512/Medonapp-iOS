//
//  ReportTableViewCell.swift
//  Medonapp iOS
//
//  Created by Harshal Kulkarni on 18/10/22.
//

import UIKit

class ReportTableViewCell: UITableViewCell {
    
    static let identifier = "ReportTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "ReportTableViewCell", bundle: nil)
    }
    
    @IBOutlet private var cellContentView: UIView!
    @IBOutlet private var iconView: UIView!
    @IBOutlet private var iconImage: UIImageView!
    @IBOutlet private var reportTitle: UILabel!
    @IBOutlet private var moreIcon: UIImageView!
    
    public func configure(icon: UIImage, reportTitle: String, reportCellVariant: reportVariant) {
        cellContentView.layer.cornerRadius = 28
        self.iconImage.image = icon
        
        self.iconView.backgroundColor = .clear
        self.iconView.layer.cornerRadius = 20
        
        self.reportTitle.text = reportTitle
        
        self.reportTitle.textColor = .black
        
        switch reportCellVariant {
        case .user:
            cellContentView.backgroundColor = UIColor(red: 0.86, green: 0.93, blue: 0.98, alpha: 1.00)
            iconView.layer.borderColor = UIColor(red: 0.11, green: 0.42, blue: 0.64, alpha: 1.00).cgColor
            iconView.layer.borderWidth = 2
            iconImage.image = iconImage.image!.withTintColor(UIColor(red: 0.11, green: 0.42, blue: 0.64, alpha: 1.00))
        case .family:
            cellContentView.backgroundColor = UIColor(red: 0.84, green: 1.00, blue: 0.95, alpha: 1.00)
            iconView.layer.borderColor = UIColor(red: 0.00, green: 0.54, blue: 0.37, alpha: 1.00).cgColor
            iconView.layer.borderWidth = 2
            iconImage.image = iconImage.image!.withTintColor(UIColor(red: 0.00, green: 0.54, blue: 0.37, alpha: 1.00))
        }
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
