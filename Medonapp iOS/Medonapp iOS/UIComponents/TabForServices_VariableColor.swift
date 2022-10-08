//
//  TabForServices_VariableColor.swift
//  Medonapp iOS
//
//  Created by Harshal Kulkarni on 08/10/22.
//

import UIKit

enum tabVariants {
    case blue
    case orange
    case sky
    case pink
}

class TabForServices_VariableColor: UIView {
    private var variant: tabVariants?
    private var tabImage: UIImageView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    func setupUI() {
        self.tabImage = UIImageView()
    }
    
    func initTabButton(cornerRadius: CGFloat = 20, variant: tabVariants, tabImage: UIImage) {
        self.layer.cornerRadius = cornerRadius
        self.variant = variant
        self.tabImage?.contentMode = .scaleAspectFit
        
        switch variant {
        case .blue:
            self.backgroundColor = UIColor(red: 0.86, green: 0.93, blue: 0.98, alpha: 1.00)
            self.tabImage?.image = tabImage
            self.tabImage?.tintColor = UIColor(red: 0.11, green: 0.42, blue: 0.64, alpha: 1.00)
            
        case .orange:
            self.backgroundColor = UIColor(red: 0.98, green: 0.94, blue: 0.86, alpha: 1.00)
            self.tabImage?.image = tabImage
            self.tabImage?.tintColor = UIColor(red: 0.88, green: 0.62, blue: 0.12, alpha: 1.00)
            
        case .sky:
            self.backgroundColor = UIColor(red: 0.84, green: 0.96, blue: 1.00, alpha: 1.00)
            self.tabImage?.image = tabImage
            self.tabImage?.tintColor = UIColor(red: 0.00, green: 0.62, blue: 0.78, alpha: 1.00)
            
        case .pink:
            self.backgroundColor = UIColor(red: 0.95, green: 0.89, blue: 0.91, alpha: 1.00)
            self.tabImage?.image = tabImage
            self.tabImage?.tintColor = UIColor(red: 0.62, green: 0.30, blue: 0.42, alpha: 1.00)
        }
        
        //constrant
        self.addSubview(self.tabImage!)
        self.tabImage?.translatesAutoresizingMaskIntoConstraints = false
        
        self.tabImage?.topAnchor.constraint(equalTo: self.topAnchor, constant: 15).isActive = true
        self.tabImage?.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15).isActive = true
        self.tabImage?.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15).isActive = true
        self.tabImage?.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -15).isActive = true
        
        self.tabImage?.widthAnchor.constraint(equalToConstant: 30).isActive = true
        self.tabImage?.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
}
