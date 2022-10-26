//
//  DoctorsScreenCarouselCollectionViewCell.swift
//  Medonapp iOS
//
//  Created by Harshal Kulkarni on 10/10/22.
//

import UIKit
import Kingfisher

class DoctorsScreenCarouselCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "DoctorsScreenCarouselCollectionViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "DoctorsScreenCarouselCollectionViewCell", bundle: nil)
    }
    
    @IBOutlet private var doctorImage: UIImageView!
    
    private var imageLink: String = ""

    public func configure(doctor: Doctor) {
        imageLink = doctor.profileImage?.fileDownloadURI ?? "https://i.ibb.co/jHvKxC3/broken-1.jpg"
        KF.url(URL(string: imageLink))
            .placeholder(UIImage(named: "doctorPlaceholder"))
            .loadDiskFileSynchronously()
            .cacheMemoryOnly()
            .fade(duration: 0.25)
            .onProgress { receivedSize, totalSize in  }
            .onSuccess { result in  }
            .onFailure { error in }
            .set(to: self.doctorImage)
        
        self.layer.cornerRadius = 26
        self.doctorImage.contentMode = .scaleAspectFill
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    

}
