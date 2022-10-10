//
//  ScheduleTabDateCollectionViewCell.swift
//  Medonapp iOS
//
//  Created by Harshal Kulkarni on 09/10/22.
//

import UIKit

class ScheduleTabDateCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "ScheduleTabDateCollectionViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "ScheduleTabDateCollectionViewCell", bundle: nil)
    }
    
    @IBOutlet private var collectionCellContentView: UIView!
    @IBOutlet private var dateLabel: UILabel!
    @IBOutlet private var dayLabel: UILabel!

    public func configure(date: String, day: String, isActive: Bool) {
        collectionCellContentView.layer.cornerRadius = 24
        self.dateLabel.text = date
        self.dayLabel.text = day
        
        self.dateLabel.textColor = .black
        self.dayLabel.textColor = .black
        self.collectionCellContentView.backgroundColor = UIColor(red: 0.86, green: 0.93, blue: 0.98, alpha: 1.00)
        
        switch isActive {
        case true:
            UIView.animate(withDuration: 0.25, delay: 0.0, options: UIView.AnimationOptions.transitionCrossDissolve, animations: {
                self.dateLabel.textColor = .white
                self.dayLabel.textColor = .white
                self.collectionCellContentView.backgroundColor = UIColor(red: 0.11, green: 0.42, blue: 0.64, alpha: 1.00)
                
            }, completion: {
                (finished: Bool) -> Void in
            })
        case false:
            break
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    

}
