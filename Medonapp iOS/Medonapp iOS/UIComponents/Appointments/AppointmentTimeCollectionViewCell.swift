//
//  AppointmentTimeCollectionViewCell.swift
//  Medonapp iOS
//
//  Created by Harshal Kulkarni on 14/10/22.
//

import UIKit

class AppointmentTimeCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "AppointmentTimeCollectionViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "AppointmentTimeCollectionViewCell", bundle: nil)
    }
    
    @IBOutlet var cellContentView: UIView?
    @IBOutlet var timeLabel: UILabel?
    
    public func configure(timeString: String, isActive: Bool) {
        timeLabel?.text = timeString
        cellContentView?.layer.cornerRadius = 10
        cellContentView?.layer.borderWidth = 1
        cellContentView?.layer.borderColor = UIColor.white.cgColor
        cellContentView?.backgroundColor = .clear
        
        if isActive {
            UIView.animate(withDuration: 0.2, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {
                self.cellContentView?.backgroundColor = UIColor(red: 0.88, green: 0.62, blue: 0.12, alpha: 1.00)
            }, completion: {
                (finished: Bool) -> Void in
            })
        }
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
