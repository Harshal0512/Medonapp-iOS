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

    
    func setupUI() {
        self.layer.cornerRadius = 10
        self.layer.borderColor = UIColor(red: 0.75, green: 0.79, blue: 0.85, alpha: 1.00).cgColor
        self.textColor = .black
        self.layer.borderWidth = 1
        self.font = UIFont(name: "NunitoSans-Bold", size: 16)
        
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
            string: placeholder,
            attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 0.48, green: 0.55, blue: 0.62, alpha: 1.00), NSAttributedString.Key.font: UIFont(name: "NunitoSans-Bold", size: 16)!]
        )
    }
    
}
