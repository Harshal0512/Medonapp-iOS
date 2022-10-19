//
//  MonthViewAppointmentHistory.swift
//  Medonapp iOS
//
//  Created by Harshal Kulkarni on 19/10/22.
//

import UIKit

class MonthViewAppointmentHistory: UIView {
    
    static let shared = MonthViewAppointmentHistory.instantiate()
    
    @IBOutlet private var monthLabel: UILabel!
    @IBOutlet private var yearLabel: UILabel!
    @IBOutlet private var leftArrow: UIImageView!
    @IBOutlet private var rightArrow: UIImageView!
    
    private static let monthArray: [String] = ["", "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    private var month_CounterCurrent: Int = Calendar(identifier: .gregorian).dateComponents([.month], from: Date()).month! {
        didSet {
            updateMonth()
        }
    }

    private var year_CounterCurrent: Int = Calendar(identifier: .gregorian).dateComponents([.year], from: Date()).year! {
        didSet {
            updateYear()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func updateMonth()  {
        UIView.transition(with: self.monthLabel,
                          duration: 0.25,
                          options: .transitionFlipFromBottom,
                          animations: {
            self.monthLabel.text = MonthViewAppointmentHistory.monthArray[self.month_CounterCurrent]
        }, completion: nil)
    }
    
    func updateYear() {
        UIView.transition(with: self.yearLabel,
                          duration: 0.25,
                          options: .transitionFlipFromBottom,
                          animations: {
            self.yearLabel.text = "\(self.year_CounterCurrent)"
        }, completion: nil)
    }
    
    static func instantiate() -> MonthViewAppointmentHistory {
        let view: MonthViewAppointmentHistory = initFromNib()
        
        view.leftArrow.isUserInteractionEnabled = true
        view.leftArrow.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.decrementMonth)))
        
        view.rightArrow.isUserInteractionEnabled = true
        view.rightArrow.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.incrementMonth)))
        
        view.monthLabel.text = MonthViewAppointmentHistory.monthArray[view.month_CounterCurrent]
        view.yearLabel.text = "\(view.year_CounterCurrent)"
        
        return view
    }
    
    @objc static func decrementMonth() {
        if MonthViewAppointmentHistory.shared.month_CounterCurrent == 1 {
            MonthViewAppointmentHistory.shared.year_CounterCurrent -= 1
            MonthViewAppointmentHistory.shared.month_CounterCurrent = MonthViewAppointmentHistory.monthArray.count - 1
        } else {
            MonthViewAppointmentHistory.shared.month_CounterCurrent -= 1
        }
    }
    
    @objc static func incrementMonth() {
        if MonthViewAppointmentHistory.shared.month_CounterCurrent == MonthViewAppointmentHistory.monthArray.count - 1 {
            MonthViewAppointmentHistory.shared.year_CounterCurrent += 1
            MonthViewAppointmentHistory.shared.month_CounterCurrent = 1
        } else {
            MonthViewAppointmentHistory.shared.month_CounterCurrent += 1
        }
    }
    
}
