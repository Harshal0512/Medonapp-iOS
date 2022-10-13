//
//  WhiteBackgroundButtonWithIcon.swift
//  Medonapp iOS
//
//  Created by Harshal Kulkarni on 12/10/22.
//

import Foundation
import UIKit

class WhiteBackgroundButtonWithIcon: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    func setupUI() {
    }
    
    func initButton(title: String, icon: UIImage?, iconSize: CGSize = CGSize(width: 24, height: 24), cornerRadius: CGFloat = 12) {

        self.titleLabel?.font = UIFont(name: "NunitoSans-Bold", size: 18)
        self.setTitle(title, for: .normal)
        
        self.contentHorizontalAlignment = .left
        
        self.titleEdgeInsets = UIEdgeInsets(top: 0, left: 40, bottom: 0, right: 0)
        self.imageEdgeInsets = UIEdgeInsets(top: 0, left: 22, bottom: 0, right: 0)
        
        self.layer.cornerRadius = cornerRadius
        
        self.imageView?.image = icon?.resizeImageTo(size: iconSize)
        self.setImageTintColor(UIColor(red: 0.29, green: 0.33, blue: 0.37, alpha: 1.00))
//        self.imageView?.image = self.currentImage?.resizeImageTo(size: CGSize(width: 25, height: 25))
        
        self.backgroundColor = .white
        self.setTitleColor(.black, for: .normal)
    }
}
