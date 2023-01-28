//
//  ManageFamilyViewController.swift
//  Medonapp iOS
//
//  Created by Harshal Kulkarni on 28/01/23.
//

import UIKit

class ManageFamilyViewController: UIViewController {
    
    private var backButton: UIImageView?
    private var navTitle: UILabel?
    private var addMemberButton: UIImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationItem.largeTitleDisplayMode = .never
        navigationController?.isNavigationBarHidden = true
        
        initialise()
        setupUI()
        setConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        Utils.checkForReachability()
        
        populateFamilyTable()
        
        if Prefs.isNetworkAvailable {
            self.refreshData()
        }
        
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    @objc func refreshData() {
        AppointmentElement.refreshAppointments { isSuccess in
            self.populateFamilyTable()
        }
    }
    
    func populateFamilyTable() {
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
        navTitle?.text = "Manage Family"
        navTitle?.textAlignment = .center
        navTitle?.textColor = .black
        navTitle?.font = UIFont(name: "NunitoSans-Bold", size: 18)
        view.addSubview(navTitle!)
        
        addMemberButton = UIImageView()
        addMemberButton?.image = UIImage(systemName: "person.crop.circle.badge.plus")
        addMemberButton?.tintColor = .black
        view.addSubview(addMemberButton!)
        addMemberButton?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.handleAddMemberTapAction(_:))))
        addMemberButton?.isUserInteractionEnabled = true
    }
    
    func setConstraints() {
        backButton?.translatesAutoresizingMaskIntoConstraints = false
        navTitle?.translatesAutoresizingMaskIntoConstraints = false
        addMemberButton?.translatesAutoresizingMaskIntoConstraints = false
        
        
        backButton?.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        backButton?.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 28).isActive = true
        backButton?.widthAnchor.constraint(equalToConstant: 50).isActive = true
        backButton?.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        navTitle?.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 13).isActive = true
        navTitle?.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        navTitle?.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        addMemberButton?.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        addMemberButton?.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -28).isActive = true
        addMemberButton?.widthAnchor.constraint(equalToConstant: 32).isActive = true
        addMemberButton?.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    @objc func handleBackAction(_ sender: UITapGestureRecognizer? = nil) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func handleAddMemberTapAction(_ sender: UITapGestureRecognizer? = nil) {
        
    }
    
}
