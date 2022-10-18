//
//  ReportCellWithIconAndDescription.swift
//  Medonapp iOS
//
//  Created by Harshal Kulkarni on 10/10/22.
//

import UIKit

class ReportCellWithIconAndDescription: UIView {
   
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var iconView: UIView!
    @IBOutlet weak var iconLabel: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var numberOfFilesLabel: UILabel!
    @IBOutlet weak var moreIcon: UIImageView!
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    static func instantiate(viewBackgroundColor: UIColor, icon: UIImage, iconBackgroundColor: UIColor, title: String, numberOfFiles: Int, showOutline: Bool = true, showMoreIcon: Bool = true) -> ReportCellWithIconAndDescription {
        let view: ReportCellWithIconAndDescription = initFromNib()
        view.containerView.backgroundColor = viewBackgroundColor
        view.containerView.layer.borderWidth = showOutline ? 1 : 0
        view.containerView.layer.borderColor = UIColor(red: 0.84, green: 0.87, blue: 0.92, alpha: 1.00).cgColor
        view.containerView.layer.cornerRadius = 28
//        view.dropShadow(color: UIColor(red: 0.42, green: 0.53, blue: 0.70, alpha: 1.00), opacity: 0.25, offSet: CGSize(width: 0, height: 6), radius: 24, cornerRadius: 28)

        view.iconView.layer.cornerRadius = 20
        view.iconView.backgroundColor = iconBackgroundColor
        view.iconLabel.image = icon
        
        view.titleLabel.text = title
        view.numberOfFilesLabel.text = "\(numberOfFiles) files"
        
        view.moreIcon.alpha = showMoreIcon ? 1 : 0
        return view
    }
    
}
