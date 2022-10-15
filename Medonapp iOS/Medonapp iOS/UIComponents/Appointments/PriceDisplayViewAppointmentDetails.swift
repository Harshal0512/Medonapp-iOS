//
//  PriceDisplayViewAppointmentDetails.swift
//  Medonapp iOS
//
//  Created by Harshal Kulkarni on 14/10/22.
//

import UIKit

class PriceDisplayViewAppointmentDetails: UIView {
    
    @IBOutlet private var priceLabel: UILabel?

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    static func instantiate(price: String) -> PriceDisplayViewAppointmentDetails {
        let view: PriceDisplayViewAppointmentDetails = initFromNib()
        
        view.priceLabel?.text = price
        
        return view
    }

}
