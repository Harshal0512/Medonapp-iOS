//
//  ProfileViewViewController.swift
//  Medonapp iOS
//
//  Created by Harshal Kulkarni on 12/10/22.
//

import UIKit

class ProfileViewViewController: UIViewController {
    
    private var scrollView: UIScrollView?
    private var contentView: UIView?
    private var backButton: UIImageView?
    private var profileImageView: UIImageView?
    private var nameLabel: UILabel?
    private var emailLabel: UILabel?
    private var accountSettingsButton: WhiteBackgroundButtonWithIcon?
    private var privacyPolicyButton: WhiteBackgroundButtonWithIcon?
    private var referAFriendButton: WhiteBackgroundButtonWithIcon?
    private var contactUsButton: WhiteBackgroundButtonWithIcon?
    private var logoutButton: UIImageView?

    override func viewDidLoad() {
        super.viewDidLoad()
    
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationItem.largeTitleDisplayMode = .never
        navigationController?.isNavigationBarHidden = true

        initialise()
        setupUI()
        setConstraints()
    }
    
    func initialise() {
    }
    
    func setupUI() {
        scrollView = UIScrollView()
        contentView = UIView()
        contentView?.isUserInteractionEnabled = true
        
        view.addSubview(scrollView!)
        scrollView?.addSubview(contentView!)
        
        view.backgroundColor = UIColor(red: 0.11, green: 0.42, blue: 0.64, alpha: 1.00)
        contentView?.backgroundColor = UIColor(red: 0.11, green: 0.42, blue: 0.64, alpha: 1.00)
        
        backButton = UIImageView()
        backButton?.image = UIImage(named: "backIcon_Transparent")?.resizeImageTo(size: CGSize(width: 50, height: 50))
        backButton?.contentMode = .scaleAspectFit
        view?.addSubview(backButton!)
        let backTap = UITapGestureRecognizer(target: self, action: #selector(self.handleBackAction(_:)))
        backButton?.addGestureRecognizer(backTap)
        backButton?.isUserInteractionEnabled = true
        
        profileImageView = UIImageView()
        profileImageView?.image = UIImage(named: "cat")!
        profileImageView?.makeRoundCorners(byRadius: 26)
        profileImageView?.contentMode = .scaleAspectFill
        contentView?.addSubview(profileImageView!)
        
        nameLabel = UILabel()
        nameLabel?.text = "Ritul Parmar"
        nameLabel?.textColor = .white
        nameLabel?.textAlignment = .center
        nameLabel?.font = UIFont(name: "NunitoSans-ExtraBold", size: 20)
        contentView?.addSubview(nameLabel!)
        
        emailLabel = UILabel()
        emailLabel?.text = "ritul.parmar18@nmims.edu.in"
        emailLabel?.textColor = .white
        emailLabel?.textAlignment = .center
        emailLabel?.font = UIFont(name: "NunitoSans-Regular", size: 15)
        contentView?.addSubview(emailLabel!)
        
        accountSettingsButton = WhiteBackgroundButtonWithIcon()
        accountSettingsButton?.initButton(title: "Account Settings", icon: UIImage(named: "accountSettingsIcon"))
        contentView?.addSubview(accountSettingsButton!)
        
        privacyPolicyButton = WhiteBackgroundButtonWithIcon()
        privacyPolicyButton?.initButton(title: "Privacy Policy", icon: UIImage(named: "compassIcon"))
        contentView?.addSubview(privacyPolicyButton!)
        
        referAFriendButton = WhiteBackgroundButtonWithIcon()
        referAFriendButton?.initButton(title: "Refer a friend", icon: UIImage(named: "cardIcon"), iconSize: CGSize(width: 27, height: 21))
        contentView?.addSubview(referAFriendButton!)
        
        contactUsButton = WhiteBackgroundButtonWithIcon()
        contactUsButton?.initButton(title: "Contact us", icon: UIImage(named: "cardIcon"), iconSize: CGSize(width: 27, height: 21))
        contentView?.addSubview(contactUsButton!)
        
        logoutButton = UIImageView()
        logoutButton?.image = UIImage(named: "logOutPng")!
        logoutButton?.contentMode = .scaleAspectFit
        contentView?.addSubview(logoutButton!)
    }
    
    func setConstraints() {
        scrollView?.translatesAutoresizingMaskIntoConstraints = false
        contentView?.translatesAutoresizingMaskIntoConstraints = false
        backButton?.translatesAutoresizingMaskIntoConstraints = false
        profileImageView?.translatesAutoresizingMaskIntoConstraints = false
        nameLabel?.translatesAutoresizingMaskIntoConstraints = false
        emailLabel?.translatesAutoresizingMaskIntoConstraints = false
        accountSettingsButton?.translatesAutoresizingMaskIntoConstraints = false
        privacyPolicyButton?.translatesAutoresizingMaskIntoConstraints = false
        referAFriendButton?.translatesAutoresizingMaskIntoConstraints = false
        contactUsButton?.translatesAutoresizingMaskIntoConstraints = false
        logoutButton?.translatesAutoresizingMaskIntoConstraints = false
        
        
        scrollView?.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        scrollView?.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        scrollView?.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        scrollView?.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        
        contentView?.topAnchor.constraint(equalTo: scrollView!.topAnchor).isActive = true
        contentView?.leadingAnchor.constraint(equalTo: scrollView!.leadingAnchor).isActive = true
        contentView?.trailingAnchor.constraint(equalTo: scrollView!.trailingAnchor).isActive = true
        contentView?.bottomAnchor.constraint(equalTo: scrollView!.bottomAnchor).isActive = true
        contentView?.widthAnchor.constraint(equalTo: scrollView!.widthAnchor).isActive = true
        
        
        backButton?.topAnchor.constraint(equalTo: view.topAnchor, constant: 65).isActive = true
        backButton?.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 28).isActive = true
        backButton?.widthAnchor.constraint(equalToConstant: 50).isActive = true
        backButton?.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        profileImageView?.centerXAnchor.constraint(equalTo: contentView!.centerXAnchor).isActive = true
        profileImageView?.topAnchor.constraint(equalTo: backButton!.bottomAnchor, constant: 50).isActive = true
        profileImageView?.heightAnchor.constraint(equalToConstant: 77).isActive = true
        profileImageView?.widthAnchor.constraint(equalToConstant: 77).isActive = true
        
        nameLabel?.topAnchor.constraint(equalTo: profileImageView!.bottomAnchor, constant: 20).isActive = true
        nameLabel?.centerXAnchor.constraint(equalTo: contentView!.centerXAnchor).isActive = true
        nameLabel?.leadingAnchor.constraint(equalTo: contentView!.leadingAnchor, constant: 10).isActive = true
        nameLabel?.trailingAnchor.constraint(equalTo: contentView!.trailingAnchor, constant: -10).isActive = true
        
        emailLabel?.topAnchor.constraint(equalTo: nameLabel!.bottomAnchor, constant: 4).isActive = true
        emailLabel?.centerXAnchor.constraint(equalTo: contentView!.centerXAnchor).isActive = true
        emailLabel?.leadingAnchor.constraint(equalTo: contentView!.leadingAnchor, constant: 10).isActive = true
        emailLabel?.trailingAnchor.constraint(equalTo: contentView!.trailingAnchor, constant: -10).isActive = true
        
        accountSettingsButton?.topAnchor.constraint(equalTo: emailLabel!.bottomAnchor, constant: 40).isActive = true
        accountSettingsButton?.leadingAnchor.constraint(equalTo: contentView!.leadingAnchor, constant: 20).isActive = true
        accountSettingsButton?.trailingAnchor.constraint(equalTo: contentView!.trailingAnchor, constant: -20).isActive = true
        accountSettingsButton?.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        privacyPolicyButton?.topAnchor.constraint(equalTo: accountSettingsButton!.bottomAnchor, constant: 20).isActive = true
        privacyPolicyButton?.leadingAnchor.constraint(equalTo: accountSettingsButton!.leadingAnchor).isActive = true
        privacyPolicyButton?.trailingAnchor.constraint(equalTo: accountSettingsButton!.trailingAnchor).isActive = true
        privacyPolicyButton?.heightAnchor.constraint(equalTo: accountSettingsButton!.heightAnchor).isActive = true
        
        referAFriendButton?.topAnchor.constraint(equalTo: privacyPolicyButton!.bottomAnchor, constant: 20).isActive = true
        referAFriendButton?.leadingAnchor.constraint(equalTo: accountSettingsButton!.leadingAnchor).isActive = true
        referAFriendButton?.trailingAnchor.constraint(equalTo: accountSettingsButton!.trailingAnchor).isActive = true
        referAFriendButton?.heightAnchor.constraint(equalTo: accountSettingsButton!.heightAnchor).isActive = true
        
        contactUsButton?.topAnchor.constraint(equalTo: referAFriendButton!.bottomAnchor, constant: 20).isActive = true
        contactUsButton?.leadingAnchor.constraint(equalTo: accountSettingsButton!.leadingAnchor).isActive = true
        contactUsButton?.trailingAnchor.constraint(equalTo: accountSettingsButton!.trailingAnchor).isActive = true
        contactUsButton?.heightAnchor.constraint(equalTo: accountSettingsButton!.heightAnchor).isActive = true
        
        logoutButton?.topAnchor.constraint(equalTo: contactUsButton!.bottomAnchor, constant: 75).isActive = true
        logoutButton?.centerXAnchor.constraint(equalTo: contentView!.centerXAnchor).isActive = true
        logoutButton?.heightAnchor.constraint(equalToConstant: 28).isActive = true
    }

    @objc func handleBackAction(_ sender: UITapGestureRecognizer? = nil) {
//        navigationController?.popViewController(animated: true)
        self.dismiss(animated: true)
    }
    
}
