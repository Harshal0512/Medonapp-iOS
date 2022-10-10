//
//  SearchBarWithSearchAndFilterIcon.swift
//  Medonapp iOS
//
//  Created by Harshal Kulkarni on 08/10/22.
//

import UIKit
import UIKit

class SearchBarWithSearchAndFilterIcon: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }

    let padding = UIEdgeInsets(top: 0, left: 35, bottom: 0, right: 20)

        override open func textRect(forBounds bounds: CGRect) -> CGRect {
            return bounds.inset(by: padding)
        }

        override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
            return bounds.inset(by: padding)
        }

        override open func editingRect(forBounds bounds: CGRect) -> CGRect {
            return bounds.inset(by: padding)
        }
    
    func setupUI() {
        self.layer.cornerRadius = 18
        self.layer.borderColor = UIColor(red: 0.93, green: 0.96, blue: 0.99, alpha: 1.00).cgColor
        self.backgroundColor = UIColor(red: 0.93, green: 0.96, blue: 0.99, alpha: 1.00)
        self.textColor = .black
        self.layer.borderWidth = 1
        self.font = UIFont(name: "NunitoSans-Regular", size: 14)
        self.autocorrectionType = .no
        self.clearButtonMode = .whileEditing
        
        let searchIconView = UIImageView(frame: CGRect(x: 10, y: 5, width: 22, height: 20))
        searchIconView.image = UIImage(systemName: "magnifyingglass")!
        searchIconView.tintColor = UIColor(red: 0.54, green: 0.63, blue: 0.74, alpha: 1.00)
        let searchIconContainerView: UIView = UIView(frame: CGRect(x: 20, y: 0, width: 30, height: 30))
        searchIconContainerView.addSubview(searchIconView)
        self.leftView = searchIconContainerView
        self.leftViewMode = .always
        
//        let filterIconView = UIImageView(frame: CGRect(x: 10, y: 5, width: 20, height: 20))
//        filterIconView.image = UIImage(systemName: "slider.horizontal.3")?.withTintColor(UIColor(red: 0.54, green: 0.63, blue: 0.74, alpha: 1.00))
//        let filterIconContainerView: UIView = UIView(frame: CGRect(x: 20, y: 0, width: 30, height: 30))
//        searchIconContainerView.addSubview(filterIconView)
//        self.rightView = filterIconContainerView
//        self.rightViewMode = .always
    }
    
    func setPlaceholder(placeholder: String) {
        self.attributedPlaceholder = NSAttributedString(
            string: " \(placeholder)",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 0.48, green: 0.55, blue: 0.62, alpha: 1.00), NSAttributedString.Key.font: UIFont(name: "NunitoSans-Regular", size: 14)!]
        )
    }
    
}
