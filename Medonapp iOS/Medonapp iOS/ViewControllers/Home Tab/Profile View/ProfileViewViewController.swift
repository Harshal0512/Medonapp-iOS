//
//  ProfileViewViewController.swift
//  Medonapp iOS
//
//  Created by Harshal Kulkarni on 12/10/22.
//

import UIKit
import MessageUI
import NotificationBannerSwift
import Localize_Swift

class ProfileViewViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    var notifBanner: GrowingNotificationBanner?
    
    private var scrollView: UIScrollView?
    private var contentView: UIView?
    private var backButton: UIImageView?
    private var profileImageView: UIImageView?
    private var nameLabel: UILabel?
    private var emailLabel: UILabel?
    private var accountSettingsButton: WhiteBackgroundButtonWithIcon?
    private var manageFamilyButton: WhiteBackgroundButtonWithIcon?
    private var privacyPolicyButton: WhiteBackgroundButtonWithIcon?
    private var tellAFriendButton: WhiteBackgroundButtonWithIcon?
    private var contactUsButton: WhiteBackgroundButtonWithIcon?
    private var logoutButton: UIImageView?
    
    private var userDetails = User.getUserDetails()

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
        
        if !Prefs.isNetworkAvailable {
            DispatchQueue.main.async {
                self.notifBanner = Utils.displayNoNetworkBanner(self)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.notifBanner?.dismiss()
    }
    
    func initialise() {
    }
    
    func setupUI() {
        scrollView = UIScrollView()
        contentView = UIView()
        
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
        profileImageView?.makeRoundCorners(byRadius: 26)
        profileImageView?.contentMode = .scaleAspectFill
        contentView?.addSubview(profileImageView!)
        profileImageView?.setKFImage(imageUrl: userDetails.patient?.profileImage?.fileDownloadURI ?? "https://i.ibb.co/jHvKxC3/broken-1.jpg", placeholderImage: UIImage(named: (userDetails.patient!.gender!.lowercased() == "male") ? "userPlaceholder-male" : "userPlaceholder-female")!)
        
        nameLabel = UILabel()
        nameLabel?.text = (userDetails.patient?.name?.firstName ?? "") + " " + (userDetails.patient?.name?.lastName ?? "")
        nameLabel?.textColor = .white
        nameLabel?.textAlignment = .center
        nameLabel?.font = UIFont(name: "NunitoSans-ExtraBold", size: 20)
        contentView?.addSubview(nameLabel!)
        
        emailLabel = UILabel()
        emailLabel?.text = userDetails.patient?.credential?.email ?? ""
        emailLabel?.textColor = .white
        emailLabel?.textAlignment = .center
        emailLabel?.font = UIFont(name: "NunitoSans-Regular", size: 15)
        contentView?.addSubview(emailLabel!)
        
        accountSettingsButton = WhiteBackgroundButtonWithIcon()
        accountSettingsButton?.initButton(title: "account_settings".localized(), icon: UIImage(named: "accountSettingsIcon"))
        contentView?.addSubview(accountSettingsButton!)
        accountSettingsButton?.addTarget(self, action: #selector(openAccountSettings), for: .touchUpInside)
        accountSettingsButton?.isUserInteractionEnabled = true
        
        manageFamilyButton = WhiteBackgroundButtonWithIcon()
        manageFamilyButton?.initButton(title: "manage_family".localized(), icon: UIImage(named: "familyIconFilled"))
        contentView?.addSubview(manageFamilyButton!)
        manageFamilyButton?.addTarget(self, action: #selector(manageFamily), for: .touchUpInside)
        manageFamilyButton?.isUserInteractionEnabled = true
        
        privacyPolicyButton = WhiteBackgroundButtonWithIcon()
        privacyPolicyButton?.initButton(title: "privacy_policy".localized(), icon: UIImage(named: "compassIcon"))
        contentView?.addSubview(privacyPolicyButton!)
        
        tellAFriendButton = WhiteBackgroundButtonWithIcon()
        tellAFriendButton?.initButton(title: "tell_friend".localized(), icon: UIImage(named: "shareIcon"))
        contentView?.addSubview(tellAFriendButton!)
        tellAFriendButton?.addTarget(self, action: #selector(openShareSheet), for: .touchUpInside)
        tellAFriendButton?.isUserInteractionEnabled = true
        
        contactUsButton = WhiteBackgroundButtonWithIcon()
        contactUsButton?.initButton(title: "contact_us".localized(), icon: UIImage(named: "headphoneIcon"))
        contentView?.addSubview(contactUsButton!)
        contactUsButton?.addTarget(self, action: #selector(handleMailAction), for: .touchUpInside)
        contactUsButton?.isUserInteractionEnabled = true
        
        logoutButton = UIImageView()
        logoutButton?.image = UIImage(named: "logOutPng")!
        logoutButton?.contentMode = .scaleAspectFit
        contentView?.addSubview(logoutButton!)
        let logoutTap = UITapGestureRecognizer(target: self, action: #selector(self.handleLogoutAction(_:)))
        logoutButton?.addGestureRecognizer(logoutTap)
        logoutButton?.isUserInteractionEnabled = true
    }
    
    func setConstraints() {
        scrollView?.translatesAutoresizingMaskIntoConstraints = false
        contentView?.translatesAutoresizingMaskIntoConstraints = false
        backButton?.translatesAutoresizingMaskIntoConstraints = false
        profileImageView?.translatesAutoresizingMaskIntoConstraints = false
        nameLabel?.translatesAutoresizingMaskIntoConstraints = false
        emailLabel?.translatesAutoresizingMaskIntoConstraints = false
        accountSettingsButton?.translatesAutoresizingMaskIntoConstraints = false
        manageFamilyButton?.translatesAutoresizingMaskIntoConstraints = false
        privacyPolicyButton?.translatesAutoresizingMaskIntoConstraints = false
        tellAFriendButton?.translatesAutoresizingMaskIntoConstraints = false
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
        profileImageView?.topAnchor.constraint(equalTo: contentView!.topAnchor, constant: 70).isActive = true
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
        
        accountSettingsButton?.topAnchor.constraint(equalTo: emailLabel!.bottomAnchor, constant: 30).isActive = true
        accountSettingsButton?.leadingAnchor.constraint(equalTo: contentView!.leadingAnchor, constant: 20).isActive = true
        accountSettingsButton?.trailingAnchor.constraint(equalTo: contentView!.trailingAnchor, constant: -20).isActive = true
        accountSettingsButton?.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        manageFamilyButton?.topAnchor.constraint(equalTo: accountSettingsButton!.bottomAnchor, constant: 20).isActive = true
        manageFamilyButton?.leadingAnchor.constraint(equalTo: accountSettingsButton!.leadingAnchor).isActive = true
        manageFamilyButton?.trailingAnchor.constraint(equalTo: accountSettingsButton!.trailingAnchor).isActive = true
        manageFamilyButton?.heightAnchor.constraint(equalTo: accountSettingsButton!.heightAnchor).isActive = true
        
        privacyPolicyButton?.topAnchor.constraint(equalTo: manageFamilyButton!.bottomAnchor, constant: 20).isActive = true
        privacyPolicyButton?.leadingAnchor.constraint(equalTo: accountSettingsButton!.leadingAnchor).isActive = true
        privacyPolicyButton?.trailingAnchor.constraint(equalTo: accountSettingsButton!.trailingAnchor).isActive = true
        privacyPolicyButton?.heightAnchor.constraint(equalTo: accountSettingsButton!.heightAnchor).isActive = true
        
        tellAFriendButton?.topAnchor.constraint(equalTo: privacyPolicyButton!.bottomAnchor, constant: 20).isActive = true
        tellAFriendButton?.leadingAnchor.constraint(equalTo: accountSettingsButton!.leadingAnchor).isActive = true
        tellAFriendButton?.trailingAnchor.constraint(equalTo: accountSettingsButton!.trailingAnchor).isActive = true
        tellAFriendButton?.heightAnchor.constraint(equalTo: accountSettingsButton!.heightAnchor).isActive = true
        
        contactUsButton?.topAnchor.constraint(equalTo: tellAFriendButton!.bottomAnchor, constant: 20).isActive = true
        contactUsButton?.leadingAnchor.constraint(equalTo: accountSettingsButton!.leadingAnchor).isActive = true
        contactUsButton?.trailingAnchor.constraint(equalTo: accountSettingsButton!.trailingAnchor).isActive = true
        contactUsButton?.heightAnchor.constraint(equalTo: accountSettingsButton!.heightAnchor).isActive = true
        
        logoutButton?.topAnchor.constraint(equalTo: contactUsButton!.bottomAnchor, constant: 30).isActive = true
        logoutButton?.centerXAnchor.constraint(equalTo: contentView!.centerXAnchor).isActive = true
        logoutButton?.heightAnchor.constraint(equalToConstant: 28).isActive = true
        logoutButton?.bottomAnchor.constraint(equalTo: contentView!.bottomAnchor, constant: -20).isActive = true
    }

    @objc func handleBackAction(_ sender: UITapGestureRecognizer? = nil) {
        self.dismiss(animated: true)
    }
    
    @objc func handleLogoutAction(_ sender: UITapGestureRecognizer? = nil) {
        Utils.displayYesREDNoAlertWithHandler("Are you sure you want to logout?", viewController: self, style: .actionSheet) { _ in
            
        } yesHandler: { _ in
            self.dismiss(animated: true) {
                NotificationCenter.default.post(name: Notification.Name("logout"), object: nil)
            }
        }
    }
    
    @objc func manageFamily() {
        let manageFamilyVC = UIStoryboard.init(name: "HomeTab", bundle: Bundle.main).instantiateViewController(withIdentifier: "manageFamily") as? ManageFamilyViewController
        manageFamilyVC?.modalPresentationStyle = .fullScreen
        manageFamilyVC?.modalTransitionStyle = .coverVertical
        self.navigationController?.pushViewController(manageFamilyVC!, animated: true)
    }
    
    @objc func openAccountSettings() {
        let accountSettingsVC = UIStoryboard.init(name: "HomeTab", bundle: Bundle.main).instantiateViewController(withIdentifier: "accountSettingsVC") as? AccountSettingsViewController
        accountSettingsVC?.modalPresentationStyle = .fullScreen
        accountSettingsVC?.modalTransitionStyle = .coverVertical
        self.navigationController?.pushViewController(accountSettingsVC!, animated: true)
    }
    
    @objc func openShareSheet() {
        Utils.openShareAppSheet(on: self)
    }
    
    @objc func handleMailAction() {
        // Modify following variables with your text / recipient
        let udid = UIDevice.current.identifierForVendor?.uuidString
        let name = UIDevice.current.name
        let version = UIDevice.current.systemVersion
        let modelName = UIDevice.current.model
        let recipientEmail = "project.medonapp@gmail.com"
        let subject = "Email from Medonapp user"
        let body = """
        Device Details:
        Device ID: \(udid!)
        Device Model: \(name)
        Device iOS Version: \(version)
        Device Model Name: \(modelName)
        -------------------------------------------------
        
        Start writing below the line
        
        
        Describe your problem below:
        
        
        """
        
        // Show default mail composer
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([recipientEmail])
            mail.setSubject(subject)
            mail.setMessageBody(body, isHTML: false)
            
            present(mail, animated: true)
            
            // Show third party email composer if default Mail app is not present
        } else if let emailUrl = Utils.createEmailUrl(to: recipientEmail, subject: subject, body: body) {
            UIApplication.shared.open(emailUrl)
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
}
