//
//  TabViewInContactScreen.swift
//  Medonapp iOS
//
//  Created by Harshal Kulkarni on 13/10/22.
//

import UIKit

class TabViewInContactScreen: UIView {

    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var innerView: UIView!
    @IBOutlet weak var icon:UIImageView?
    @IBOutlet weak var label: UILabel?
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    static func instantiate(icon: UIImage, title: String) -> TabViewInContactScreen {
        let view: TabViewInContactScreen = initFromNib()
        
        view.outerView.layer.cornerRadius = 20
        view.outerView.layer.borderWidth = 1
        view.outerView.layer.borderColor = UIColor(red: 0.84, green: 0.87, blue: 0.92, alpha: 1.00).cgColor

        view.innerView.layer.cornerRadius = 16
        view.innerView.layer.borderWidth = 1
        view.innerView.layer.borderColor = UIColor(red: 0.84, green: 0.87, blue: 0.92, alpha: 1.00).cgColor
        
        view.icon?.image = icon
        view.icon?.tintColor = .black
        view.icon?.contentMode = .scaleAspectFit
        
        view.label?.text = title
        view.label?.textColor = .black
        
        return view
    }
}
