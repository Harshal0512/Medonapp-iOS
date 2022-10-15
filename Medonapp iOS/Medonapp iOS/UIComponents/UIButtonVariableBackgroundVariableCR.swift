//
//  UIButtonVariableBackgroundVariableCR.swift
//  Medonapp iOS
//
//  Created by Harshal Kulkarni on 02/10/22.
//

import Foundation
import UIKit

enum buttonVariants {
    case blueBack
    case whiteBack
    case blackBack
}

class UIButtonVariableBackgroundVariableCR: UIButton {
    private var variant: buttonVariants?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    func setupUI() {
        self.titleLabel?.font = UIFont(name: "NunitoSans-Bold", size: 14)
    }
    
    func initButton(title: String, cornerRadius: CGFloat, variant: buttonVariants, titleColor: UIColor = .clear) {
        self.setTitle(title, for: .normal)
        self.layer.cornerRadius = cornerRadius
        self.variant = variant
        
        switch variant {
        case .blueBack:
            self.backgroundColor = UIColor(red: 0.11, green: 0.42, blue: 0.64, alpha: 1.00)
            self.setTitleColor(.white, for: .normal)
            
        case .whiteBack:
            self.backgroundColor = .white
            self.layer.borderColor = UIColor(red: 0.75, green: 0.79, blue: 0.85, alpha: 1.00).cgColor
            self.layer.borderWidth = 1
            self.setTitleColor(UIColor(red: 0.48, green: 0.55, blue: 0.62, alpha: 1.00), for: .normal)
            
        case .blackBack:
            self.backgroundColor = .black
            self.setTitleColor(.white, for: .normal)
            self.layer.borderWidth = 0
        }
        
        if titleColor != .clear {
            self.setTitleColor(titleColor, for: .normal)
        }
    }
}
