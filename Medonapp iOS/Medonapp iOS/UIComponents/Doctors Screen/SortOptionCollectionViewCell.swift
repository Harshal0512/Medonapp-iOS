//
//  SortOptionCollectionViewCell.swift
//  Medonapp iOS
//
//  Created by Harshal Kulkarni on 01/04/23.
//

import UIKit

enum SortType: CaseIterable {
    case distance
    case cost
    case rating
}

class SortOptionCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "SortOptionCollectionViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "SortOptionCollectionViewCell", bundle: nil)
    }
    
    @IBOutlet var cellContentView: UIView?
    @IBOutlet var titleLabel: UILabel?
    
    public var sortType: SortType?
    public var isNotAvailable = false
    
    public func configure(type: SortType, isActive: Bool, animateActive: Bool) {
        self.sortType = type
        
        switch type {
        case .distance:
            titleLabel?.text = "Distance"
            isNotAvailable = !Prefs.isLocationPerm
        case .cost:
            titleLabel?.text = "Cost"
        case .rating:
            titleLabel?.text = "Rating"
        }
        cellContentView?.layer.cornerRadius = 15
        cellContentView?.layer.borderWidth = 1
        
        
        if isNotAvailable {
            cellContentView?.backgroundColor = .white.withAlphaComponent(0.2)
            cellContentView?.alpha = 0.4
        } else {
            cellContentView?.backgroundColor = .clear
            cellContentView?.alpha = 1
        }
        
        if isActive {
            
            //Added async to prevent other reusable cells to wait for its animation to complete causing unusual visual artifacts
            DispatchQueue.main.async {
                UIView.animate(withDuration: animateActive ? 0.2 : 0, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {
                    self.cellContentView?.layer.borderColor = UIColor(red: 0.88, green: 0.62, blue: 0.12, alpha: 1.00).cgColor
                    self.titleLabel?.textColor = .white
                    self.cellContentView?.backgroundColor = UIColor(red: 0.88, green: 0.62, blue: 0.12, alpha: 1.00)
                }, completion: {
                    (finished: Bool) -> Void in
                })
            }
        } else {
            self.cellContentView?.layer.borderColor = UIColor.black.withAlphaComponent(0.7).cgColor
            self.titleLabel?.textColor = .black
            self.cellContentView?.backgroundColor = .clear
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
