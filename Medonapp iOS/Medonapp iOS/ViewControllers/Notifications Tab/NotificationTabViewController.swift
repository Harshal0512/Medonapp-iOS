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
            return 50
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell = tableView.dequeueReusableCell(withIdentifier: FamilyRequestTableViewCell.identifier, for: indexPath) as! FamilyRequestTableViewCell
        
        tableCell.configure(notification: notifications[indexPath.row])
        tableCell.layer.cornerRadius = 20
        tableCell.delegate = self
        return tableCell
    }
    
    
}

extension NotificationTabViewController: FamilyRequestCellProtocol {
    func didAcceptFamilyRequest() {
        Utils.displayYesNoAlertWithHandler("Are you sure you want to accept the family request from \("")?", viewController: self) { _ in
            
        } yesHandler: { _ in
            Utils.displaySPIndicatorNotifWithoutMessage(title: "Family Request Accepted", iconPreset: .done, hapticPreset: .success, duration: 2)
        }
    }
    
    func didRejectFamilyRequest() {
        Utils.displayYesNoAlertWithHandler("Are you sure you want to decline the family request from \("")?", viewController: self) { _ in
            
        } yesHandler: { _ in
            Utils.displaySPIndicatorNotifWithoutMessage(title: "Family Request Rejected", iconPreset: .error, hapticPreset: .error, duration: 2)
        }
    }
    
    
}
