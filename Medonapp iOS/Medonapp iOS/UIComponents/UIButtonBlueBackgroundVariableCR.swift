//
//  UIButtonBlueBackgroundVariableCR.swift
//  Medonapp iOS
//
//  Created by Harshal Kulkarni on 02/10/22.
//

import Foundation
import UIKit

class UIButtonBlueBackgroundVariableCR: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    func setupUI() {
        self.backgroundColor = UIColor(red: 0.11, green: 0.42, blue: 0.64, alpha: 1.00)
        self.setTitleColor(.white, for: .normal)
        self.titleLabel?.font = UIFont(name: "NunitoSans-Bold", size: 14)
    }
    
    func initButton(title: String, cornerRadius: CGFloat) {
        self.setTitle(title, for: .normal)
        self.layer.cornerRadius = cornerRadius
    }
}
