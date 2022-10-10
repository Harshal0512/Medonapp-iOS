//
//  ScheduleTabTableViewCell.swift
//  Medonapp iOS
//
//  Created by Harshal Kulkarni on 08/10/22.
//

import UIKit

enum cellVariants {
    case blue
    case pink
    case yellow
}

class ScheduleTabTableViewCell: UITableViewCell {
    
    static let identifier = "ScheduleTabTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "ScheduleTabTableViewCell", bundle: nil)
    }
    
    @IBOutlet private var cellContentView: UIView!
    @IBOutlet private var doctorImage: UIImageView!
    @IBOutlet private var appointmentTime: UILabel!
    @IBOutlet private var doctorName: UILabel!
    @IBOutlet private var typeOfDoctor: UILabel!
    @IBOutlet private var accessoryButton: UIButton!

    public func configure(doctorImage: UIImage, appointmentTime: String, doctorName: String, typeOfDoctor: String, cellVariant: cellVariants) {
        cellContentView.layer.cornerRadius = 28
        self.doctorImage.image = doctorImage
        self.appointmentTime.text = appointmentTime
        self.doctorName.text = doctorName
        self.typeOfDoctor.text = typeOfDoctor
        
        self.appointmentTime.textColor = .black
        self.doctorName.textColor = .black
        self.typeOfDoctor.textColor = .black
        self.accessoryButton.setImageTintColor(.black)
        
        switch cellVariant {
        case .blue:
            cellContentView.backgroundColor = UIColor(red: 0.11, green: 0.42, blue: 0.64, alpha: 1.00)
            self.appointmentTime.textColor = .white
            self.doctorName.textColor = .white
            self.typeOfDoctor.textColor = .white
            self.accessoryButton.setImageTintColor(.white)
        case .pink:
            cellContentView.backgroundColor = UIColor(red: 0.95, green: 0.90, blue: 0.92, alpha: 1.00)
        case .yellow:
            cellContentView.backgroundColor = UIColor(red: 0.98, green: 0.94, blue: 0.86, alpha: 1.00)
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
