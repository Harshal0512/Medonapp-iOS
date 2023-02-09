//
//  LGOptions.swift
//  LGSegmentedControl
//
//  Created by Linus Geffarth on 05.12.18.
//

import UIKit

class LGSegmentOptions {
    
    /// Segments' corner radius, default: 6
    var cornerRadius: CGFloat = 8
    
    /// Determines whether there should be a short fade animation when selecting a segment
    var animateStateChange: Bool = true
    
    /// Background and text color of the selected segment
    var selectedColor: (background: UIColor, text: UIColor) = (UIColor(red: 0.11, green: 0.42, blue: 0.64, alpha: 1.00), .white)
    
    /// Background and text color of a deselected segment
    var deselectedColor: (background: UIColor, text: UIColor) = (.clear, .black)
    
    /// Font of the segments' title labels
    var font: UIFont = UIFont.systemFont(ofSize: 15)
    
    /// Background and text color of the segments' badges
    var badgeColor: (background: UIColor, text: UIColor) = (UIColor(red: 0.88, green: 0.62, blue: 0.12, alpha: 1.00), .white)
    
    init() {  }
}
