//
//  DoctorInfoTableViewCell.swift
//  Medonapp iOS
//
//  Created by Harshal Kulkarni on 10/10/22.
//

import UIKit

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

    public func configure(doctorImage: UIImage, doctorName: String, designation: String, rating: Float, numberOfReviews: Int) {
        self.doctorImage.image = doctorImage
        self.doctorImage.layer.cornerRadius = 26
        self.doctorImage.contentMode = .scaleAspectFill
        self.doctorName.text = doctorName
        self.designation.text = designation
        self.rating.text = "\(rating)"
        self.numberOfReviews.text = "\(numberOfReviews) reviews"
        
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
