//
//  RatingsWithStarsView.swift
//  Medonapp iOS
//
//  Created by Harshal Kulkarni on 04/04/23.
//

import UIKit

class RatingsWithStarsView: UIView {
    
    
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var outOfLabel: UILabel!
    @IBOutlet weak var fiveStarProgressBar: UIProgressView!
    @IBOutlet weak var fourStarProgressBar: UIProgressView!
    @IBOutlet weak var threeStarProgressBar: UIProgressView!
    @IBOutlet weak var twoStarProgressBar: UIProgressView!
    @IBOutlet weak var oneStarProgressBar: UIProgressView!
    
    static let shared = RatingsWithStarsView.instantiate()

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    static func instantiate() -> RatingsWithStarsView {
        let view: RatingsWithStarsView = initFromNib()
        
        view.fiveStarProgressBar.progress = 0.25
        view.fiveStarProgressBar.progressTintColor = UIColor(red: 0.11, green: 0.42, blue: 0.64, alpha: 1.00)
        view.fiveStarProgressBar.trackTintColor = UIColor(red: 0.75, green: 0.79, blue: 0.85, alpha: 1.00)
        
        view.fourStarProgressBar.progress = 0.25
        view.fourStarProgressBar.progressTintColor = UIColor(red: 0.11, green: 0.42, blue: 0.64, alpha: 1.00)
        view.fourStarProgressBar.trackTintColor = UIColor(red: 0.75, green: 0.79, blue: 0.85, alpha: 1.00)
        
        view.threeStarProgressBar.progress = 0.25
        view.threeStarProgressBar.progressTintColor = UIColor(red: 0.11, green: 0.42, blue: 0.64, alpha: 1.00)
        view.threeStarProgressBar.trackTintColor = UIColor(red: 0.75, green: 0.79, blue: 0.85, alpha: 1.00)
        
        view.twoStarProgressBar.progress = 0.25
        view.twoStarProgressBar.progressTintColor = UIColor(red: 0.11, green: 0.42, blue: 0.64, alpha: 1.00)
        view.twoStarProgressBar.trackTintColor = UIColor(red: 0.75, green: 0.79, blue: 0.85, alpha: 1.00)
        
        view.oneStarProgressBar.progress = 0.25
        view.oneStarProgressBar.progressTintColor = UIColor(red: 0.11, green: 0.42, blue: 0.64, alpha: 1.00)
        view.oneStarProgressBar.trackTintColor = UIColor(red: 0.75, green: 0.79, blue: 0.85, alpha: 1.00)
        
        return view
    }

}
