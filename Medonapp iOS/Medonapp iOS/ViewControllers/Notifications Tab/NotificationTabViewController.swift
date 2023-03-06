//
//  NotificationTabViewController.swift
//  Medonapp iOS
//
//  Created by Harshal Kulkarni on 24/02/23.
//

import UIKit
import NotificationBannerSwift
import Toast_Swift

class NotificationTabViewController: UIViewController {
    
    var notifBanner: GrowingNotificationBanner?
    
    var navTitle: UILabel?
    var notifTable: UITableView?
    
    private var userDetails = User.getUserDetails()
    
    private var notifications: Notifications = NotificationElement.getNotifications()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationItem.largeTitleDisplayMode = .never
        navigationController?.isNavigationBarHidden = true
        
        initialise()
        setupUI()
        setConstraints()
        
        notifTable?.register(FamilyRequestTableViewCell.nib(), forCellReuseIdentifier: FamilyRequestTableViewCell.identifier)
        notifTable?.register(NormalNotifWithImageAndIconTableViewCell.nib(), forCellReuseIdentifier: NormalNotifWithImageAndIconTableViewCell.identifier)
        notifTable?.delegate = self
        notifTable?.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        populateNotifTable()
        
        if !Prefs.isNetworkAvailable {
            DispatchQueue.main.async {
                self.notifBanner = Utils.displayNoNetworkBanner(self)
            }
        } else {
            refreshData()
        }
        
        if let selectedIndexPath = notifTable?.indexPathForSelectedRow {
            notifTable?.deselectRow(at: selectedIndexPath, animated: animated)
        }
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        notifBanner?.dismiss()
    }
    
    func initialise() {
    }
    
    func setupUI() {
        navTitle = UILabel()
        navTitle?.text = "Notifications"
        navTitle?.textAlignment = .left
        navTitle?.textColor = .black
        navTitle?.font = UIFont(name: "NunitoSans-Bold", size: 27)
        view.addSubview(navTitle!)
        
        notifTable = UITableView()
        notifTable?.separatorStyle = .none
        notifTable?.showsVerticalScrollIndicator = false
        view.addSubview(notifTable!)
    }
    
    func setConstraints() {
        navTitle?.translatesAutoresizingMaskIntoConstraints = false
        notifTable?.translatesAutoresizingMaskIntoConstraints = false
        
        
        navTitle?.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 18).isActive = true
        navTitle?.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 28).isActive = true
        navTitle?.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -28).isActive = true
        
        notifTable?.topAnchor.constraint(equalTo: navTitle!.bottomAnchor, constant: 20).isActive = true
        notifTable?.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10).isActive = true
        notifTable?.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10).isActive = true
        notifTable?.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true
    }
    
    @objc func refreshData() {
        view.isUserInteractionEnabled = false
        self.view.makeToastActivity(.center)
        
        NotificationElement.refreshNotifications { isSuccess in
            if isSuccess {
                self.notifications = NotificationElement.getNotifications()
                self.populateNotifTable()
            } else {
                Utils.displaySPIndicatorNotifWithoutMessage(title: "Could not refresh data", iconPreset: .error, hapticPreset: .error, duration: 2)
            }
            self.view.isUserInteractionEnabled = true
            self.view.hideToastActivity()
        }
    }
    
    func populateNotifTable() {
        let sections = NSIndexSet(indexesIn: NSMakeRange(0, self.notifTable!.numberOfSections))
        self.notifTable!.reloadSections(sections as IndexSet, with: .fade)
    }
}

extension NotificationTabViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if notifications[indexPath.row].type == "FAMILY_REQUEST" {
            return 150
        } else {
            return 100
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if notifications[indexPath.row].type == "FAMILY_REQUEST" {
            let tableCell = tableView.dequeueReusableCell(withIdentifier: FamilyRequestTableViewCell.identifier, for: indexPath) as! FamilyRequestTableViewCell
            
            tableCell.configure(notification: notifications[indexPath.row])
            tableCell.layer.cornerRadius = 20
            tableCell.delegate = self
            return tableCell
        } else {
            let tableCell = tableView.dequeueReusableCell(withIdentifier: NormalNotifWithImageAndIconTableViewCell.identifier, for: indexPath) as! NormalNotifWithImageAndIconTableViewCell
            
            tableCell.configure(notification: notifications[indexPath.row])
            tableCell.layer.cornerRadius = 20
            return tableCell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        notifTable?.deselectRow(at: indexPath, animated: true)
    }
}

extension NotificationTabViewController: FamilyRequestCellProtocol {
    func didAcceptFamilyRequest(notification: NotificationElement) {
        Utils.displayYesNoAlertWithHandler("Are you sure you want to accept the family request from \(notification.senderName!)?", viewController: self) { _ in
            //no handler
        } yesHandler: { _ in
            self.handleFamilyRequest(didAccept: true, notification: notification)
        }
    }
    
    func didRejectFamilyRequest(notification: NotificationElement) {
        Utils.displayYesNoAlertWithHandler("Are you sure you want to decline the family request from \(notification.senderName!)?", viewController: self) { _ in
            //no handler
        } yesHandler: { _ in
            self.handleFamilyRequest(didAccept: false, notification: notification)
        }
    }
    
    func handleFamilyRequest(didAccept: Bool, notification: NotificationElement) {
        APIService(data: [:], headers: ["Authorization" : "Bearer \(User.getUserDetails().token ?? "")"], url: nil, service: (didAccept == true) ? .acceptFamilyRequest(User.getUserDetails().patient!.id!, notification.senderID!, notification.id!) : .rejectFamilyRequest(User.getUserDetails().patient!.id!, notification.senderID!, notification.id!), method: .post, isJSONRequest: true).executeQuery() { (result: Result<Patient, Error>) in
            
            switch result{
            case .success(_):
                try? User.setPatientDetails(patient: result.get())
                didAccept == true ? Utils.displaySPIndicatorNotifWithoutMessage(title: "Family Request Accepted", iconPreset: .done, hapticPreset: .success, duration: 2) : Utils.displaySPIndicatorNotifWithoutMessage(title: "Family Request Rejected", iconPreset: .error, hapticPreset: .error, duration: 2)
            case .failure(let error):
                print(error)
                Utils.displaySPIndicatorNotifWithoutMessage(title: "An error occured", iconPreset: .error, hapticPreset: .error, duration: 2.0)
            }
            self.refreshData()
        }
    }
}
