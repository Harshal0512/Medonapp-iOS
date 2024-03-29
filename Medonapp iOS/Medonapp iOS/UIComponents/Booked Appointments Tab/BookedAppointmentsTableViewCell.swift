//
//  AppointmentHistoryTableViewCell.swift
//  Medonapp iOS
//
//  Created by Harshal Kulkarni on 20/10/22.
//

import UIKit

enum feedbackStates {
    case due
    case completed
    case notYet
    case cancelled
}

protocol BookedAppointmentsCellProtocol {
    func feedbackButtonDidSelect(appointment: AppointmentElement)
    func feedbackDeletedClicked(appointment: AppointmentElement)
    func editFeedbackDidSelect(appointment: AppointmentElement)
    func editAppointmentDidSelect(appointment: AppointmentElement)
    func appointmentDeletedClicked(appointment: AppointmentElement)
}

class BookedAppointmentsTableViewCell: UITableViewCell {
    
    static let identifier = "BookedAppointmentsTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "BookedAppointmentsTableViewCell", bundle: nil)
    }
    
    @IBOutlet private var containerView: UIView!
    @IBOutlet private var doctorImage: UIImageView!
    @IBOutlet private var timeLabel: UILabel!
    @IBOutlet private var doctorName: UILabel!
    @IBOutlet private var designationLabel: UILabel!
    @IBOutlet private var feedbackButton: UIButton!
    @IBOutlet private var moreOptionsButton: UIButton!
    
    var delegate: BookedAppointmentsCellProtocol!
    
    var appointment: AppointmentElement?
    var optionsMenu: UIMenu?
    
    public func configure(appointment: AppointmentElement) {
        self.appointment = appointment
        
        self.containerView.backgroundColor = UIColor(red: 0.11, green: 0.42, blue: 0.64, alpha: 1.00)
        self.containerView.layer.cornerRadius = 28
        
        self.doctorImage.setKFImage(imageUrl: appointment.doctor?.profileImage?.fileDownloadURI ?? "", placeholderImage: UIImage(named: (appointment.doctor?.gender?.lowercased() ?? "male" == "male") ? "userPlaceholder-male" : "userPlaceholder-female")!)
        
        self.doctorImage.contentMode = .scaleAspectFill
        self.doctorImage.makeRoundCorners(byRadius: 20)
        
        self.timeLabel.textColor = .white
        self.doctorName.textColor = .white
        self.designationLabel.textColor = .white
        self.designationLabel.alpha = 0.65
        
        self.timeLabel.text = "\(Date.getTimeFromDate(dateString: appointment.startTime!))"
        self.doctorName.text = "Dr. " + (appointment.doctor?.name?.firstName ?? "") + " " + (appointment.doctor?.name?.lastName ?? "")
        self.designationLabel.text = appointment.doctor?.specialization ?? ""
        
        self.feedbackButton.titleLabel?.font = UIFont(name: "NunitoSans-Bold", size: 14)
        self.feedbackButton.layer.cornerRadius = 14
        
        var isFeedbackDue: feedbackStates = .notYet
        if appointment.status == "cancelled" {
            isFeedbackDue = .cancelled
        } else if appointment.review == nil && Date.dateFromISOString(string: appointment.startTime!, timezone: "GMT")! < Date().localDate() {
            isFeedbackDue = .due
        } else if Date.dateFromISOString(string: appointment.startTime!, timezone: "GMT")! > Date().localDate() {
            isFeedbackDue = .notYet
        } else {
            isFeedbackDue = .completed
        }
        
        let menu: UIMenu?
        
        switch isFeedbackDue {
        case .cancelled:
            self.feedbackButton.backgroundColor = .white
            self.feedbackButton.setTitle("Cancelled", for: .normal)
            self.feedbackButton.layer.borderWidth = 0
            self.feedbackButton.setTitleColor(UIColor(red: 0.72, green: 0.00, blue: 0.00, alpha: 1.00), for: .normal)
            self.feedbackButton.setImage(nil, for: .normal)
            self.feedbackButton.isUserInteractionEnabled = false
            
            menu = UIMenu(children: [])
        case .due:
            self.feedbackButton.backgroundColor = .white
            self.feedbackButton.setTitle("Give Review", for: .normal)
            self.feedbackButton.layer.borderWidth = 0
            self.feedbackButton.setTitleColor(UIColor(red: 0.11, green: 0.42, blue: 0.64, alpha: 1.00), for: .normal)
            self.feedbackButton.setImage(nil, for: .normal)
            self.feedbackButton.isUserInteractionEnabled = true
            self.feedbackButton.addTarget(self, action: #selector(feedbackButtonClicked), for: .touchUpInside)
            
            let giveFeedback = UIAction(title: "Give Review", image: UIImage(systemName: "checkmark.seal")) { action in
                self.feedbackButtonClicked()
            }
            menu = UIMenu(children: [giveFeedback])
        case .completed:
            self.feedbackButton.backgroundColor = .clear
            self.feedbackButton.layer.borderWidth = 2
            self.feedbackButton.layer.borderColor = UIColor.white.cgColor
            self.feedbackButton.setTitle("  \(appointment.review?.rating ?? 0)", for: .normal)
            self.feedbackButton.setTitleColor(.white, for: .normal)
            self.feedbackButton.setImage(UIImage(named: "starIcon")?.resizeImageTo(size: CGSize(width: 13, height: 13)), for: .normal)
            self.feedbackButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 2, right: 0)
            self.feedbackButton.setImageTintColor(UIColor(red: 0.85, green: 0.65, blue: 0.13, alpha: 1.00))
            self.feedbackButton.isUserInteractionEnabled = false
            
            let editFeedback = UIAction(title: "Edit Review", image: UIImage(systemName: "pencil")) { action in
                self.delegate.editFeedbackDidSelect(appointment: self.appointment!)
            }
            let deleteFeedback = UIAction(title: "Delete Review", image: UIImage(systemName: "trash"), attributes: .destructive) { action in
                self.delegate.feedbackDeletedClicked(appointment: self.appointment!)
            }
            menu = UIMenu(children: [editFeedback, deleteFeedback])
        case .notYet:
            self.feedbackButton.backgroundColor = .white
            self.feedbackButton.setTitle("Appointment Booked", for: .normal)
            self.feedbackButton.layer.borderWidth = 0
            self.feedbackButton.setTitleColor(UIColor(red: 0.11, green: 0.42, blue: 0.64, alpha: 1.00), for: .normal)
            self.feedbackButton.setImage(nil, for: .normal)
            self.feedbackButton.isUserInteractionEnabled = false
            
            let updateAppointment = UIAction(title: "Update Appointment", image: UIImage(systemName: "pencil")) { action in
                self.delegate.editAppointmentDidSelect(appointment: self.appointment!)
            }
            let cancelAppointment = UIAction(title: "Cancel Appointment", image: UIImage(systemName: "exclamationmark.circle"), attributes: .destructive) { action in
                self.delegate.appointmentDeletedClicked(appointment: self.appointment!)
            }
            menu = UIMenu(children: [updateAppointment, cancelAppointment])
        }
        self.moreOptionsButton.menu = menu
        self.moreOptionsButton.showsMenuAsPrimaryAction = true
        self.optionsMenu = menu
    }
    
    @objc func feedbackButtonClicked() {
        self.delegate.feedbackButtonDidSelect(appointment: self.appointment!)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
