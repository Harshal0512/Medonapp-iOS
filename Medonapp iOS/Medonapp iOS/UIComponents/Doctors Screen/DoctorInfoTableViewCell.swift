//
//  DoctorInfoTableViewCell.swift
//  Medonapp iOS
//
//  Created by Harshal Kulkarni on 10/10/22.
//

import UIKit
import Kingfisher

class DoctorInfoTableViewCell: UITableViewCell {

    static let identifier = "DoctorInfoTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "DoctorInfoTableViewCell", bundle: nil)
    }
    
    @IBOutlet private var doctorImage: UIImageView!
    @IBOutlet private var doctorName: UILabel!
    @IBOutlet private var designation: UILabel!
    @IBOutlet private var rating: UILabel!
    @IBOutlet private var numberOfReviews: UILabel!
    @IBOutlet private var feesLabel: UILabel!
    
    private var imageLink: String = ""

    public func configure(doctor: Doctor) {
        imageLink = doctor.profileImage?.fileDownloadURI ?? "https://i.ibb.co/jHvKxC3/broken-1.jpg"
        KF.url(URL(string: imageLink))
            .placeholder(UIImage(named: (doctor.gender!.lowercased() == "male") ? "userPlaceholder-male" : "userPlaceholder-female"))
            .loadDiskFileSynchronously()
            .cacheMemoryOnly()
            .fade(duration: 0.25)
            .onProgress { receivedSize, totalSize in }
            .onSuccess { result in }
            .onFailure { error in }
            .set(to: self.doctorImage)
        
        self.doctorImage.layer.cornerRadius = 26
        self.doctorImage.contentMode = .scaleAspectFill
        self.doctorName.text = (doctor.name?.firstName ?? "") + " " + (doctor.name?.lastName ?? "")
        self.designation.text = doctor.specialization ?? ""
        self.rating.text = String(format: "%.2f", doctor.avgRating ?? 0)
        self.numberOfReviews.text = "\(doctor.reviewCount ?? 0) reviews"
        self.feesLabel.text = doctor.fees?.clean
        
        self.doctorName.textColor = .black
        self.designation.textColor = UIColor(red: 0.29, green: 0.33, blue: 0.37, alpha: 1.00)
        self.rating.textColor = .black
        self.numberOfReviews.textColor = UIColor(red: 0.29, green: 0.33, blue: 0.37, alpha: 1.00)
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
