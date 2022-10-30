//
//  AppointmentHistoryViewController.swift
//  Medonapp iOS
//
//  Created by Harshal Kulkarni on 19/10/22.
//

import UIKit
import SkeletonView
import Toast_Swift

class BookedAppointmentsViewController: UIViewController {
    
    private var backButton: UIImageView?
    private var navTitle: UILabel?
    private var todayButton: UIImageView?
    private var monthView: MonthViewBookedAppointments?
    private var scheduleTable: UITableView?
    
    private var appointments: Appointments = []
    private var appointmentsByDate: [Int: [Int]] = [:]

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
        
        refreshData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        monthView?.presentLabel.alpha = 0
    }
    
    @objc func refreshData() {
        view.showAnimatedGradientSkeleton(transition: .crossDissolve(0.25))
        monthView?.showAnimatedGradientSkeleton(transition: .crossDissolve(0.25))
        view.makeToastActivity(.center)
        AppointmentElement.refreshAppointments { isSuccess in
            self.view.hideToastActivity()
            self.monthView?.hideSkeleton(transition: .crossDissolve(0.25))
            self.view.hideSkeleton(transition: .crossDissolve(0.25))
            self.appointments = AppointmentElement.getAppointments()
            self.monthView?.resetToToday()
        }
    }
    
    func initialise() {
    }
    
    func setupUI() {
        view.isSkeletonable = true
        
        backButton = UIImageView()
        backButton?.image = UIImage(named: "backIcon_White")?.resizeImageTo(size: CGSize(width: 50, height: 50))
        backButton?.contentMode = .scaleAspectFit
        view.addSubview(backButton!)
        let backTap = UITapGestureRecognizer(target: self, action: #selector(self.handleBackAction(_:)))
        backButton?.addGestureRecognizer(backTap)
        backButton?.isUserInteractionEnabled = true
        
        navTitle = UILabel()
        navTitle?.text = "Booked Appointments"
        navTitle?.textAlignment = .center
        navTitle?.textColor = .black
        navTitle?.font = UIFont(name: "NunitoSans-Bold", size: 18)
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
        backButton?.translatesAutoresizingMaskIntoConstraints = false
        navTitle?.translatesAutoresizingMaskIntoConstraints = false
        todayButton?.translatesAutoresizingMaskIntoConstraints = false
        monthView?.translatesAutoresizingMaskIntoConstraints = false
        scheduleTable?.translatesAutoresizingMaskIntoConstraints = false
        
        
        backButton?.topAnchor.constraint(equalTo: view.topAnchor, constant: 30).isActive = true
        backButton?.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 28).isActive = true
        backButton?.widthAnchor.constraint(equalToConstant: 50).isActive = true
        backButton?.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        navTitle?.topAnchor.constraint(equalTo: view.topAnchor, constant: 43).isActive = true
        navTitle?.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        navTitle?.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        todayButton?.topAnchor.constraint(equalTo: view.topAnchor, constant: 35).isActive = true
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
        scheduleTable?.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
    }
    
    @objc func handleBackAction(_ sender: UITapGestureRecognizer? = nil) {
        self.dismiss(animated: true)
    }
    
    @objc func handleTodayTapAction(_ sender: UITapGestureRecognizer? = nil) {
        self.monthView?.resetToToday()
    }

}

extension BookedAppointmentsViewController: MonthViewBookedAppointmentsDelegate {
    func didMonthChange(sender: MonthViewBookedAppointments) {
        AppointmentElement.arrangeAppointmentsByDate(month: monthView!.getMonth(), year: monthView!.getYear())
        self.appointmentsByDate = AppointmentElement.getAppointmentDate()
        UIView.transition(with: scheduleTable!, duration: 0.15, options: .transitionCrossDissolve, animations: {self.scheduleTable!.reloadData()}, completion: nil)
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
            return "\(section + 1)/\(monthView!.getMonth())/\(monthView!.getYear()) ------------------"
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
        
        cell.configure(appointment: appointments[array![indexPath.row]])
        cell.delegate = self
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        scheduleTable?.scrollToRow(at: indexPath, at: .middle, animated: true)
        scheduleTable?.deselectRow(at: indexPath, animated: true)
    }
}

extension BookedAppointmentsViewController: BookedAppointmentsCellProtocol {
    func feedbackButtonDidSelect(appointment: AppointmentElement) {
        // Create the view controller.
        let sheetViewController = RatingHalfScreenViewController()
        
        sheetViewController.appointment = appointment
        sheetViewController.delegate = self
        
        // Present it w/o any adjustments so it uses the default sheet presentation.
        present(sheetViewController, animated: true) {
            sheetViewController.isModalInPresentation = true
        }
    }
}

extension BookedAppointmentsViewController: RatingHalfScreenDelegate {
    func feedbackClosed(isSuccess: Bool) {
        if isSuccess {
            self.view.makeToast("Feedback Recorded Successfully", duration: 6.0, title: "Success", image: UIImage(named: "AppIcon"), completion: nil)
            self.refreshData()
        } else {
            self.view.makeToast("Unknown Error Occured", duration: 5.0, title: "Error", image: UIImage(named: "AppIcon"), completion: nil)
            self.refreshData()
        }
    }
}
