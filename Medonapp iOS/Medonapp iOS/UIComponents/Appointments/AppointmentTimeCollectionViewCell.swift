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
    
    public var isAvailable: Bool = true
    
    public func configure(timeString: String, isActive: Bool, isAvailable: Bool) {
        timeLabel?.text = Date.dateTimeChangeFormat(str: timeString,
                                                    inDateFormat:  "HH:mm:ss",
                                                    outDateFormat: "hh:mm a")
        cellContentView?.layer.cornerRadius = 10
        cellContentView?.layer.borderWidth = 1
        cellContentView?.layer.borderColor = UIColor.white.cgColor
        cellContentView?.backgroundColor = .clear
        
        self.isAvailable = isAvailable
        
        if !isAvailable {
            cellContentView?.backgroundColor = .white.withAlphaComponent(0.2)
            cellContentView?.alpha = 0.4
        } else {
            cellContentView?.backgroundColor = .clear
            cellContentView?.alpha = 1
        }
        
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
