//
//  AppointmentHistoryViewController.swift
//  Medonapp iOS
//
//  Created by Harshal Kulkarni on 19/10/22.
//

import UIKit
import SkeletonView
import Toast_Swift
import NotificationBannerSwift

class BookedAppointmentsViewController: UIViewController {

    private var navTitle: UILabel?
    private var todayButton: UIImageView?
    private var monthView: MonthViewBookedAppointments?
    private var scheduleTable: UITableView?
    
    private var appointments: Appointments = []
    private var appointmentsByDate: [Int: [Int]] = [:]
    
    private var sectionHeaderIDForPresent: Int = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationItem.largeTitleDisplayMode = .never
        navigationController?.isNavigationBarHidden = true
        
        initialise()
        setupUI()
        setConstraints()
        
        scheduleTable?.register(BookedAppointmentsTableViewCell.nib(), forCellReuseIdentifier: BookedAppointmentsTableViewCell.identifier)
        scheduleTable?.delegate = self
        scheduleTable?.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        Utils.checkForReachability()
        
        populateAppointmentsTable()
        
        if Prefs.isNetworkAvailable {
            self.refreshData()
        }
        
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        monthView?.presentLabel.alpha = 0
    }
    
    @objc func refreshData() {
        view.showAnimatedGradientSkeleton(transition: .crossDissolve(0.25))
        monthView?.showAnimatedGradientSkeleton(transition: .crossDissolve(0.25))
        AppointmentElement.refreshAppointments { isSuccess in
            self.populateAppointmentsTable()
        }
    }
    
    func populateAppointmentsTable() {
        self.monthView?.hideSkeleton(transition: .crossDissolve(0.25))
        self.view.hideSkeleton(transition: .crossDissolve(0.25))
        self.appointments = AppointmentElement.getAppointments()
        self.monthView?.resetToToday()
    }
    
    func initialise() {
    }
    
    func setupUI() {
        view.isSkeletonable = true
        
        navTitle = UILabel()
        navTitle?.text = "Booked Appointments"
        navTitle?.textAlignment = .center
        navTitle?.textColor = .black
        navTitle?.font = UIFont(name: "NunitoSans-Bold", size: 20)
        view.addSubview(navTitle!)
        
        todayButton = UIImageView()
        todayButton?.image = UIImage(named: "calendarIconWithTick")
        todayButton?.contentMode = .scaleAspectFit
        view.addSubview(todayButton!)
        let todayTap = UITapGestureRecognizer(target: self, action: #selector(self.handleTodayTapAction(_:)))
        todayButton?.addGestureRecognizer(todayTap)
        todayButton?.isUserInteractionEnabled = true
        
        monthView = MonthViewBookedAppointments.shared
        monthView?.delegate = self
        view.addSubview(monthView!)
        monthView?.isUserInteractionEnabled = true
        
        scheduleTable = UITableView()
        scheduleTable?.separatorStyle = .none
        view.addSubview(scheduleTable!)
    }
    
    func setConstraints() {
        navTitle?.translatesAutoresizingMaskIntoConstraints = false
        todayButton?.translatesAutoresizingMaskIntoConstraints = false
        monthView?.translatesAutoresizingMaskIntoConstraints = false
        scheduleTable?.translatesAutoresizingMaskIntoConstraints = false
        
        
        navTitle?.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 18).isActive = true
        navTitle?.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        navTitle?.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        todayButton?.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        todayButton?.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -28).isActive = true
        todayButton?.widthAnchor.constraint(equalToConstant: 40).isActive = true
        todayButton?.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        monthView?.topAnchor.constraint(equalTo: navTitle!.bottomAnchor, constant: 20).isActive = true
        monthView?.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        monthView?.widthAnchor.constraint(equalToConstant: 255).isActive = true
        monthView?.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        scheduleTable?.topAnchor.constraint(equalTo: monthView!.bottomAnchor, constant: 10).isActive = true
        scheduleTable?.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10).isActive = true
        scheduleTable?.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10).isActive = true
        scheduleTable?.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true
    }
    
    @objc func handleTodayTapAction(_ sender: UITapGestureRecognizer? = nil) {
        self.monthView?.resetToToday()
    }
    
}

extension BookedAppointmentsViewController: MonthViewBookedAppointmentsDelegate {
    func didMonthChange(sender: MonthViewBookedAppointments, isCurrentMonth: Bool) {
        AppointmentElement.arrangeAppointmentsByDate(month: monthView!.getMonth(), year: monthView!.getYear())
        self.appointmentsByDate = AppointmentElement.getAppointmentDate()
        self.scheduleTable!.reloadData()
        UIView.transition(with: scheduleTable!, duration: 0.15, options: .transitionCrossDissolve) {
            DispatchQueue.global(qos: .background).async {
                // Background Thread
                DispatchQueue.main.async {
                    // Run UI Updates
                    if isCurrentMonth && self.sectionHeaderIDForPresent != -1 {
                        self.scheduleTable?.scrollToRow(at: IndexPath(row: 0, section: self.sectionHeaderIDForPresent), at: .middle, animated: true)
                    } else {
                        self.sectionHeaderIDForPresent = -1
                    }
                }
            }
        }
    }
}

extension BookedAppointmentsViewController: UIContextMenuInteractionDelegate {
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        return nil
    }
    
    
}

extension BookedAppointmentsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        let dateComponents = DateComponents(year: monthView!.getYear(), month: monthView!.getMonth())
        let calendar = Calendar.current
        let date = calendar.date(from: dateComponents)!
        
        let range = calendar.range(of: .day, in: .month, for: date)!
        let numDays = range.count
        
        return numDays
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if appointmentsByDate[section + 1]?.count ?? 0 > 0 {
            if monthView!.getMonth() == Calendar(identifier: .gregorian).dateComponents([.month], from: Date().localDate()).month! && monthView!.getYear() == Calendar(identifier: .gregorian).dateComponents([.year], from: Date().localDate()).year! &&
                section + 1 == Calendar(identifier: .gregorian).dateComponents([.day], from: Date()).day! {
                self.sectionHeaderIDForPresent = section
                return "Today"
            }
            return "\(section + 1)/\(monthView!.getMonth())/\(monthView!.getYear())"
        } else {
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if appointmentsByDate[section + 1]?.count ?? 0 > 0 {
            return 40
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appointmentsByDate[section + 1]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = scheduleTable!.dequeueReusableCell(withIdentifier: BookedAppointmentsTableViewCell.identifier, for: indexPath) as! BookedAppointmentsTableViewCell
        
        let array = appointmentsByDate[indexPath.section + 1]
        
        cell.layer.cornerRadius = 30
        
        cell.configure(appointment: appointments[array![indexPath.row]])
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let identifier = NSString(string: "\(indexPath.row)")
        
        let cell = scheduleTable!.cellForRow(at: indexPath) as! BookedAppointmentsTableViewCell
        
        return UIContextMenuConfiguration(identifier: identifier, previewProvider: nil) { _ in
            return cell.optionsMenu
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        scheduleTable?.scrollToRow(at: indexPath, at: .middle, animated: true)
        scheduleTable?.deselectRow(at: indexPath, animated: true)
    }
}

extension BookedAppointmentsViewController: BookedAppointmentsCellProtocol {
    func feedbackButtonDidSelect(appointment: AppointmentElement) {
        if Prefs.isNetworkAvailable {
            // Create the view controller.
            let sheetViewController = RatingHalfScreenViewController()
            
            sheetViewController.appointment = appointment
            sheetViewController.delegate = self
            
            // Present it w/o any adjustments so it uses the default sheet presentation.
            present(sheetViewController, animated: true) {
                sheetViewController.isModalInPresentation = true
            }
        } else {
            self.view.makeToast("No Internet Connection Available")
        }
    }
    
    func feedbackDeletedClicked(appointment: AppointmentElement) {
        if Prefs.isNetworkAvailable {
            Utils.displayYesREDNoAlertWithHandler("Your review will be deleted. This action cannot be undone. Are you sure you want to continue?", viewController: self) { action in
                
            } yesHandler: { action in
                APIService(data: [:], headers: ["Authorization" : "Bearer \(User.getUserDetails().token ?? "")"], url: nil, service: .deleteReview(appointment.review!.id!), method: .delete, isJSONRequest: false).executeQuery() { (result: Result<DefaultResponseModel, Error>) in
                    switch result{
                    case .success(_):
                        Utils.displaySPIndicatorNotifWithoutMessage(title: "Review Deleted", iconPreset: .done, hapticPreset: .success, duration: 3)
                    case .failure(let error):
                        print(error)
                        Utils.displaySPIndicatorNotifWithoutMessage(title: "Could not delete review", iconPreset: .error, hapticPreset: .error, duration: 3)
                    }
                    self.refreshData()
                }
            }
        } else {
            self.view.makeToast("No Internet Connection Available")
        }
    }
    
    func editFeedbackDidSelect(appointment: AppointmentElement) {
        if Prefs.isNetworkAvailable {
            // Create the view controller.
            let sheetViewController = RatingHalfScreenViewController()
            
            sheetViewController.appointment = appointment
            sheetViewController.isReviewEditing = true
            sheetViewController.delegate = self
            
            // Present it w/o any adjustments so it uses the default sheet presentation.
            present(sheetViewController, animated: true) {
                sheetViewController.isModalInPresentation = true
            }
        } else {
            self.view.makeToast("No Internet Connection Available")
        }
    }
    
    func editAppointmentDidSelect(appointment: AppointmentElement) {
        if Prefs.isNetworkAvailable {
            let appointmentDetailsVC = UIStoryboard.init(name: "HomeTab", bundle: Bundle.main).instantiateViewController(withIdentifier: "appointmentDetailsVC") as? AppointmentDetailsViewController
            appointmentDetailsVC?.doctor = appointment.doctor
            appointmentDetailsVC?.modalPresentationStyle = .fullScreen
            appointmentDetailsVC?.isEditingAppointment = true
            appointmentDetailsVC?.appointment = appointment
            self.present(appointmentDetailsVC!, animated: true, completion: nil)
        } else {
            self.view.makeToast("No Internet Connection Available")
        }
    }
    
    func appointmentDeletedClicked(appointment: AppointmentElement) {
        if Prefs.isNetworkAvailable {
            Utils.displayYesREDNoAlertWithHandler("Your appointment will be cancelled. This action cannot be undone. Are you sure you want to continue?", viewController: self) { action in
                
            } yesHandler: { action in
                APIService(data: [:], headers: ["Authorization" : "Bearer \(User.getUserDetails().token ?? "")"], url: nil, service: .cancelAppointment(appointment.id!), method: .put, isJSONRequest: false).executeQuery() { (result: Result<AppointmentElement, Error>) in
                    switch result{
                    case .success(_):
                        Utils.displaySPIndicatorNotifWithoutMessage(title: "Appointment Deleted", iconPreset: .done, hapticPreset: .success, duration: 3)
                    case .failure(let error):
                        print(error)
                        Utils.displaySPIndicatorNotifWithoutMessage(title: "Could not delete appointment", iconPreset: .error, hapticPreset: .error, duration: 3)
                    }
                    self.refreshData()
                }
            }
        } else {
            self.view.makeToast("No Internet Connection Available")
        }
    }
}

extension BookedAppointmentsViewController: RatingHalfScreenDelegate {
    func feedbackClosed(isSuccess: Bool) {
        if isSuccess {
            Utils.displaySPIndicatorNotifWithMessage(title: "Success", message: "Feedback Recorded", iconPreset: .done, hapticPreset: .success, duration: 6)
        } else {
            Utils.displaySPIndicatorNotifWithMessage(title: "Error", message: "Unknown Error Occured", iconPreset: .error, hapticPreset: .error, duration: 6)
        }
        self.refreshData()
    }
}
