//
//  ScheduleTabTableViewCell.swift
//  Medonapp iOS
//
//  Created by Harshal Kulkarni on 08/10/22.
//

import UIKit

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

    public func configure(doctorImage: UIImage, appointmentTime: String, doctorName: String, typeOfDoctor: String) {
        cellContentView.layer.cornerRadius = 28
        self.doctorImage.image = doctorImage
        self.appointmentTime.text = appointmentTime
        self.doctorName.text = doctorName
        self.typeOfDoctor.text = typeOfDoctor
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
