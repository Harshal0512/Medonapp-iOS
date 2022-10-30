//
//  MonthViewBookedAppointments.swift
//  Medonapp iOS
//
//  Created by Harshal Kulkarni on 19/10/22.
//

import UIKit
import SkeletonView

protocol MonthViewBookedAppointmentsDelegate: AnyObject {
  func didMonthChange(sender: MonthViewBookedAppointments)
}

class MonthViewBookedAppointments: UIView {
    
    static let shared = MonthViewBookedAppointments.instantiate()
    
    weak var delegate: MonthViewBookedAppointmentsDelegate?
    
    @IBOutlet private var monthLabel: UILabel!
    @IBOutlet private var yearLabel: UILabel!
    @IBOutlet private var leftArrow: UIImageView!
    @IBOutlet private var rightArrow: UIImageView!
    @IBOutlet public var presentLabel: UILabel!
    
    private static let monthArray: [String] = ["", "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    private var month_CounterCurrent: Int = Calendar(identifier: .gregorian).dateComponents([.month], from: Date().localDate()).month! {
        didSet {
            updateMonth()
            if month_CounterCurrent == Calendar(identifier: .gregorian).dateComponents([.month], from: Date().localDate()).month! && year_CounterCurrent == Calendar(identifier: .gregorian).dateComponents([.year], from: Date().localDate()).year! {
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

    private var year_CounterCurrent: Int = Calendar(identifier: .gregorian).dateComponents([.year], from: Date().localDate()).year! {
        didSet {
            updateYear()
        }
    }
    
    private var lowerLimitMonth: Int = Calendar(identifier: .gregorian).dateComponents([.month], from: Date.dateFromISOString(string: (User.getUserDetails().patient?.credential?.createdOn!)!, timezone: "IST", ending: ".SSS")!).month!
    private var lowerLimitYear: Int = Calendar(identifier: .gregorian).dateComponents([.year], from: Date.dateFromISOString(string: (User.getUserDetails().patient?.credential?.createdOn!)!, timezone: "IST", ending: ".SSS")!).year!
    
    
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
            self.monthLabel.text = MonthViewBookedAppointments.monthArray[self.month_CounterCurrent]
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
        self.year_CounterCurrent = Calendar(identifier: .gregorian).dateComponents([.year], from: Date().localDate()).year!
        self.month_CounterCurrent = Calendar(identifier: .gregorian).dateComponents([.month], from: Date().localDate()).month!
    }
    
    static func instantiate() -> MonthViewBookedAppointments {
        let view: MonthViewBookedAppointments = initFromNib()
        view.isSkeletonable = true
        
        view.presentLabel.alpha = 0
        
        view.leftArrow.isUserInteractionEnabled = true
        view.leftArrow.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.decrementMonth)))
        
        view.rightArrow.isUserInteractionEnabled = true
        view.rightArrow.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.incrementMonth)))
        
        view.monthLabel.text = MonthViewBookedAppointments.monthArray[view.month_CounterCurrent]
        view.monthLabel.isSkeletonable = true
        view.yearLabel.isSkeletonable = true
        view.yearLabel.text = "\(view.year_CounterCurrent)"
        
        return view
    }
    
    @objc static func decrementMonth() {
        let tempMonth = MonthViewBookedAppointments.shared.month_CounterCurrent
        let tempYear = MonthViewBookedAppointments.shared.year_CounterCurrent
        
        if MonthViewBookedAppointments.shared.month_CounterCurrent == 1 {
            MonthViewBookedAppointments.shared.year_CounterCurrent -= 1
            MonthViewBookedAppointments.shared.month_CounterCurrent = MonthViewBookedAppointments.monthArray.count - 1
        } else {
            MonthViewBookedAppointments.shared.month_CounterCurrent -= 1
        }
        
        if MonthViewBookedAppointments.shared.month_CounterCurrent < MonthViewBookedAppointments.shared.lowerLimitMonth &&
            MonthViewBookedAppointments.shared.year_CounterCurrent <= MonthViewBookedAppointments.shared.lowerLimitYear {
            MonthViewBookedAppointments.shared.month_CounterCurrent = tempMonth
            MonthViewBookedAppointments.shared.year_CounterCurrent = tempYear
        }
    }
    
    @objc static func incrementMonth() {
        let tempMonth = MonthViewBookedAppointments.shared.month_CounterCurrent
        let tempYear = MonthViewBookedAppointments.shared.year_CounterCurrent
        
        if MonthViewBookedAppointments.shared.month_CounterCurrent == MonthViewBookedAppointments.monthArray.count - 1 {
            MonthViewBookedAppointments.shared.year_CounterCurrent += 1
            MonthViewBookedAppointments.shared.month_CounterCurrent = 1
        } else {
            MonthViewBookedAppointments.shared.month_CounterCurrent += 1
        }
        
//        if MonthViewBookedAppointments.shared.month_CounterCurrent > Calendar(identifier: .gregorian).dateComponents([.month], from: Date().localDate()).month! &&
//            MonthViewBookedAppointments.shared.year_CounterCurrent >= Calendar(identifier: .gregorian).dateComponents([.year], from: Date().localDate()).year! {
//            MonthViewBookedAppointments.shared.month_CounterCurrent = tempMonth
//            MonthViewBookedAppointments.shared.year_CounterCurrent = tempYear
//        }
    }
    
    func getMonth() -> Int {
        return month_CounterCurrent
    }
    
    func getYear() -> Int {
        return year_CounterCurrent
    }
    
}
