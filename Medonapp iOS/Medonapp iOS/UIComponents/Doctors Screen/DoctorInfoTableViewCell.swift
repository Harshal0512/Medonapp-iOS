//
//  DoctorInfoTableViewCell.swift
//  Medonapp iOS
//
//  Created by Harshal Kulkarni on 10/10/22.
//

import UIKit
import Localize_Swift

class DoctorInfoTableViewCell: UITableViewCell {

    static let identifier = "DoctorInfoTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "DoctorInfoTableViewCell", bundle: nil)
    }
    
    @IBOutlet private var doctorImage: UIImageView!
    @IBOutlet private var onlineStatusIcon: UIImageView!
    @IBOutlet private var doctorName: UILabel!
    @IBOutlet private var designation: UILabel!
    @IBOutlet private var rating: UILabel!
    @IBOutlet private var numberOfReviews: UILabel!
    @IBOutlet private var feesLabel: UILabel!
    @IBOutlet private var distanceLabel: UILabel!
    
    private var imageLink: String = ""

    public func configure(doctor: Doctor) {
        self.doctorImage.setKFImage(imageUrl: doctor.profileImage?.fileDownloadURI ?? "https://i.ibb.co/jHvKxC3/broken-1.jpg", placeholderImage: UIImage(named: (doctor.gender!.lowercased() == "male") ? "userPlaceholder-male" : "userPlaceholder-female")!)
        onlineStatusIcon.alpha = doctor.liveStatus! ? 1 : 0
        distanceLabel.alpha = Prefs.showDistanceFromUser ? 1 : 0
        
        self.doctorImage.layer.cornerRadius = 26
        self.doctorImage.contentMode = .scaleAspectFill
        self.doctorName.text = doctor.fullNameWithTitle
        self.designation.text = doctor.specialization ?? ""
        self.rating.text = String(format: "%.2f", doctor.avgRating ?? 0)
        self.numberOfReviews.text = "\(doctor.reviewCount ?? 0) " + "reviews".localized()
        self.feesLabel.text = doctor.fees?.clean
        
        self.doctorName.textColor = .black
        self.designation.textColor = UIColor(red: 0.29, green: 0.33, blue: 0.37, alpha: 1.00)
        self.distanceLabel.textColor = UIColor(red: 0.29, green: 0.33, blue: 0.37, alpha: 1.00)
        self.rating.textColor = .black
        self.numberOfReviews.textColor = UIColor(red: 0.29, green: 0.33, blue: 0.37, alpha: 1.00)
        
        self.distanceLabel.set(text: String(format: "%.2f kms", doctor.distanceFromUser/1000), leftIcon: UIImage(systemName: "location.fill")?.resizeImageTo(size: CGSize(width: 13, height: 13))?.withTintColor(UIColor(red: 0.29, green: 0.33, blue: 0.37, alpha: 1.00)))
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
