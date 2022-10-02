//
//  UITextFieldWithPlaceholder_CR8.swift
//  Medonapp iOS
//
//  Created by Harshal Kulkarni on 02/10/22.
//

import Foundation
import UIKit

class UITextFieldWithPlaceholder_CR8: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }

    
    func setupUI() {
        self.layer.cornerRadius = 10
        self.layer.borderColor = UIColor(red: 0.75, green: 0.79, blue: 0.85, alpha: 1.00).cgColor
        self.textColor = .black
        self.layer.borderWidth = 1
        let paddingView = UIView(frame: CGRectMake(0, 0, 15, self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = .always
        self.rightView = paddingView
        self.rightViewMode = .always
    }
    
    func setPlaceholder(placeholder: String) {
        self.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 0.48, green: 0.55, blue: 0.62, alpha: 1.00), NSAttributedString.Key.font: UIFont(name: "NunitoSans-Bold", size: 16)!]
        )
    }
    
}
