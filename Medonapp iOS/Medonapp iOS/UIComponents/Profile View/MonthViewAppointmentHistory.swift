//
//  MonthViewAppointmentHistory.swift
//  Medonapp iOS
//
//  Created by Harshal Kulkarni on 19/10/22.
//

import UIKit
import SkeletonView

protocol MonthViewAppointmentHistoryDelegate: AnyObject {
  func didMonthChange(sender: MonthViewAppointmentHistory)
}

class MonthViewAppointmentHistory: UIView {
    
    static let shared = MonthViewAppointmentHistory.instantiate()
    
    weak var delegate: MonthViewAppointmentHistoryDelegate?
    
    @IBOutlet private var monthLabel: UILabel!
    @IBOutlet private var yearLabel: UILabel!
    @IBOutlet private var leftArrow: UIImageView!
    @IBOutlet private var rightArrow: UIImageView!
    @IBOutlet public var presentLabel: UILabel!
    
    private static let monthArray: [String] = ["", "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    private var month_CounterCurrent: Int = Calendar(identifier: .gregorian).dateComponents([.month], from: Date()).month! {
        didSet {
            updateMonth()
            if month_CounterCurrent == Calendar(identifier: .gregorian).dateComponents([.month], from: Date()).month! && year_CounterCurrent == Calendar(identifier: .gregorian).dateComponents([.year], from: Date()).year! {
                UIView.transition(with: self.presentLabel,
                                  duration: 0.25,
                                  options: .transitionFlipFromBottom,
                                  animations: {
                    self.presentLabel.alpha = 1
                }, completion: nil)
            } else {
                UIView.transition(with: self.presentLabel,
                                  duration: 0.25,
                                  options: .transitionFlipFromBottom,
                                  animations: {
                    self.presentLabel.alpha = 0
                }, completion: nil)
            }
            delegate?.didMonthChange(sender: self)
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
    
    func resetToToday() {
        self.year_CounterCurrent = Calendar(identifier: .gregorian).dateComponents([.year], from: Date()).year!
        self.month_CounterCurrent = Calendar(identifier: .gregorian).dateComponents([.month], from: Date()).month!
    }
    
    static func instantiate() -> MonthViewAppointmentHistory {
        let view: MonthViewAppointmentHistory = initFromNib()
        view.isSkeletonable = true
        
        view.presentLabel.alpha = 0
        
        view.leftArrow.isUserInteractionEnabled = true
        view.leftArrow.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.decrementMonth)))
        
        view.rightArrow.isUserInteractionEnabled = true
        view.rightArrow.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.incrementMonth)))
        
        view.monthLabel.text = MonthViewAppointmentHistory.monthArray[view.month_CounterCurrent]
        view.monthLabel.isSkeletonable = true
        view.yearLabel.isSkeletonable = true
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
    
    func getMonth() -> Int {
        return month_CounterCurrent
    }
    
    func getYear() -> Int {
        return year_CounterCurrent
    }
    
}
