//
//  UIButtonCircularWithLogo.swift
//  Medonapp iOS
//
//  Created by Harshal Kulkarni on 13/01/23.
//

import Foundation
import UIKit

enum circularButtonVariants {
    case blueBack
    case greenBack
    case blackBack
}

class UIButtonCircularWithLogo: UIButton {
    private var variant: circularButtonVariants?
    public var isDisabled = false {
        didSet {
            self.isUserInteractionEnabled = !isDisabled
            switch variant {
            case .blueBack:
                UIView.animate(withDuration: 0.2, delay: 0.05, options: UIView.AnimationOptions.curveEaseOut, animations: {
                    self.backgroundColor = UIColor(red: 0.11, green: 0.42, blue: 0.64, alpha: self.isDisabled ? 0.4 : 1.00)
                    self.layer.borderWidth = 0
                    self.setImageTintColor(.white)
                })
                
            case .greenBack:
                UIView.animate(withDuration: 0.2, delay: 0.05, options: UIView.AnimationOptions.curveEaseOut, animations: {
                    self.backgroundColor = UIColor(red: 0.00, green: 0.54, blue: 0.37, alpha: 1.00).withAlphaComponent(self.isDisabled ? 0.4 : 1.00)
                    self.layer.borderWidth = 0
                    self.setImageTintColor(UIColor(red: 0.84, green: 1.00, blue: 0.95, alpha: 1.00))
                })
                
            case .blackBack:
                UIView.animate(withDuration: 0.2, delay: 0.05, options: UIView.AnimationOptions.curveEaseOut, animations: {
                    self.backgroundColor = .black.withAlphaComponent(self.isDisabled ? 0.4 : 1.00)
                    self.setImageTintColor(.white)
                    self.layer.borderWidth = 0
                })
            case .none: break
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    func setupUI() {
        self.clipsToBounds = true
    }
    
    func initButton(buttonIcon: UIImage, dimensions: CGFloat, variant: circularButtonVariants) {
        self.variant = variant
        self.frame = CGRect(x: 160, y: 100, width: dimensions, height: dimensions)
        self.layer.cornerRadius = 0.5 * dimensions
        self.setImage(buttonIcon.resizeImageTo(size: CGSize(width: dimensions/2.5, height: dimensions/2.5)), for: .normal)
        
        switch variant {
        case .blueBack:
            self.backgroundColor = UIColor(red: 0.11, green: 0.42, blue: 0.64, alpha: 1.00)
            self.layer.borderWidth = 0
            self.setImageTintColor(.white)
            
        case .greenBack:
            self.backgroundColor = UIColor(red: 0.00, green: 0.54, blue: 0.37, alpha: 1.00)
            self.layer.borderWidth = 0
            self.setImageTintColor(UIColor(red: 0.84, green: 1.00, blue: 0.95, alpha: 1.00))
            
        case .blackBack:
            self.backgroundColor = .black
            self.setImageTintColor(.white)
            self.layer.borderWidth = 0
        }
    }
}
