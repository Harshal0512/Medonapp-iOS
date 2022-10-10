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

    public func configure(doctorImage: UIImage) {
        self.doctorImage.image = doctorImage
        self.layer.cornerRadius = 26
        self.doctorImage.contentMode = .scaleAspectFill
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    

}
