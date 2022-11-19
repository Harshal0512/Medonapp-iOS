//
//  DoctorsScreenCarouselCollectionViewCell.swift
//  Medonapp iOS
//
//  Created by Harshal Kulkarni on 10/10/22.
//

import UIKit

class DoctorsScreenCarouselCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "DoctorsScreenCarouselCollectionViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "DoctorsScreenCarouselCollectionViewCell", bundle: nil)
    }
    
    @IBOutlet private var doctorImage: UIImageView!
    
    private var imageLink: String = ""

    public func configure(doctor: Doctor) {
        self.doctorImage.setKFImage(imageUrl: doctor.profileImage?.fileDownloadURI ?? "https://i.ibb.co/jHvKxC3/broken-1.jpg", placeholderImage: UIImage(named: (doctor.gender!.lowercased() == "male") ? "userPlaceholder-male" : "userPlaceholder-female")!)
        self.layer.cornerRadius = 26
        self.doctorImage.contentMode = .scaleAspectFill
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    

}
