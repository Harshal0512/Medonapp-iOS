//
//  DoctorDetailsScreenTopView.swift
//  Medonapp iOS
//
//  Created by Harshal Kulkarni on 11/10/22.
//

import UIKit
import Kingfisher

class DoctorDetailsScreenTopView: UIView {

    @IBOutlet weak var outerBlueView: UIView!
    @IBOutlet weak var innerContainerView: UIView!
    @IBOutlet weak var doctorImage: UIImageView!
    @IBOutlet weak var doctorNameLabel: UILabel!
    @IBOutlet weak var doctorDesignationLabel: UILabel!
    
    var imageLink: String = ""
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    static func instantiate(doctor: Doctor) -> DoctorDetailsScreenTopView {
        let view: DoctorDetailsScreenTopView = initFromNib()
        
        view.innerContainerView.layer.cornerRadius = 28
        view.innerContainerView.dropShadow(color: UIColor(red: 0.42, green: 0.53, blue: 0.70, alpha: 1.00), opacity: 0.25, offSet: CGSize(width: 0, height: 6), radius: 24, cornerRadius: 28)

        view.doctorImage.layer.cornerRadius = 18
        view.doctorImage.contentMode = .scaleAspectFill
        view.imageLink = doctor.profileImage?.fileDownloadURI ?? "https://i.ibb.co/jHvKxC3/broken-1.jpg"
        KF.url(URL(string: view.imageLink))
            .placeholder(UIImage(named: (doctor.gender!.lowercased() == "male") ? "userPlaceholder-male" : "userPlaceholder-female"))
            .loadDiskFileSynchronously()
            .cacheMemoryOnly()
            .fade(duration: 0.25)
            .onProgress { receivedSize, totalSize in  }
            .onSuccess { result in  }
            .onFailure { error in }
            .set(to: view.doctorImage)
        
        view.doctorNameLabel.text = (doctor.name?.firstName ?? "") + " " + (doctor.name?.lastName ?? "")
        view.doctorDesignationLabel.text = doctor.specialization ?? ""
        view.doctorDesignationLabel.textColor = UIColor(red: 0.29, green: 0.33, blue: 0.37, alpha: 1.00)
        return view
    }

}
