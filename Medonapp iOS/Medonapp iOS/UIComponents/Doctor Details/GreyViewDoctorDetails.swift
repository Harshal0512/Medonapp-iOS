//
//  GreyViewDoctorDetails.swift
//  Medonapp iOS
//
//  Created by Harshal Kulkarni on 11/10/22.
//

import UIKit

class GreyViewDoctorDetails: UIView {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var metricsLabel: UILabel!
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    static func instantiate(title: String, metrics: String) -> GreyViewDoctorDetails {
        let view: GreyViewDoctorDetails = initFromNib()

        view.contentView.backgroundColor = UIColor(red: 0.93, green: 0.96, blue: 0.99, alpha: 1.00)
        view.contentView.layer.cornerRadius = 24
        view.titleLabel.text = title
        view.titleLabel.textColor = UIColor(red: 0.29, green: 0.33, blue: 0.37, alpha: 1.00)
        view.metricsLabel.text = metrics
        return view
    }
}
