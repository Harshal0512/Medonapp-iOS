//
//  UITextViewWithPlaceholder_CR8.swift
//  Medonapp iOS
//
//  Created by Harshal Kulkarni on 04/10/22.
//

import Foundation
import UIKit

class UITextViewWithPlaceholder_CR8: UITextView {
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
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
    }
    
    func setPlaceholder(placeholder: String) {
        self.attributedText = NSAttributedString(
            string: placeholder,
            attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 0.48, green: 0.55, blue: 0.62, alpha: 1.00), NSAttributedString.Key.font: UIFont(name: "NunitoSans-Bold", size: 16)!]
        )
    }
    
}
