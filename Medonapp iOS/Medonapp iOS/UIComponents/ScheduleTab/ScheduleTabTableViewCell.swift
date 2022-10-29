//
//  ScheduleTabTableViewCell.swift
//  Medonapp iOS
//
//  Created by Harshal Kulkarni on 08/10/22.
//

import UIKit
import Kingfisher

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

    public func configure(appointment: AppointmentElement, cellVariant: cellVariants) {
        cellContentView.layer.cornerRadius = 28
        KF.url(URL(string: appointment.doctor?.profileImage?.fileDownloadURI ?? ""))
            .placeholder(UIImage(named: (appointment.doctor?.gender?.lowercased() ?? "male" == "male") ? "userPlaceholder-male" : "userPlaceholder-female"))
            .loadDiskFileSynchronously()
            .cacheMemoryOnly()
            .fade(duration: 0.25)
            .onProgress { receivedSize, totalSize in  }
            .onSuccess { result in  }
            .onFailure { error in }
            .set(to: doctorImage)
        self.appointmentTime.text = "\(Date.getTimeFromDate(dateString: appointment.startTime!))"
        self.doctorName.text = (appointment.doctor?.name?.firstName ?? "") + " " + (appointment.doctor?.name?.lastName ?? "")
        self.typeOfDoctor.text = appointment.doctor?.specialization ?? ""
        
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
