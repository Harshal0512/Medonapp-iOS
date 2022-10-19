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
    private static let month_UpperEnd: Int = Calendar(identifier: .gregorian).dateComponents([.month], from: Date()).month! //use +1 when checking with array
    private var month_CounterCurrent: Int = 0 {
        didSet {
            updateMonth()
        }
    }
    
    private static let year_LowerEnd: Int = 2000
    private static let year_UpperEnd: Int = Calendar(identifier: .gregorian).dateComponents([.year], from: Date()).year!
    private var year_CounterCurrent: Int = 2000 {
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
        
        view.month_CounterCurrent = MonthViewAppointmentHistory.month_UpperEnd
        view.year_CounterCurrent = MonthViewAppointmentHistory.year_UpperEnd
        
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
