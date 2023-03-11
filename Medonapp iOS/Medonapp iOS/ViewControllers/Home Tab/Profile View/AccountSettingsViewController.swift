//
//  AccountSettingsViewController.swift
//  Medonapp iOS
//
//  Created by Harshal Kulkarni on 10/03/23.
//

import UIKit

class AccountSettingsViewController: UIViewController {
    
    private var scrollView: UIScrollView?
    private var contentView: UIView?
    private var backButton: UIImageView?
    private var profileImageView: UIImageView?
    private var nameLabel: UILabel?
    private var emailLabel: UILabel?
    
    private var userDetails = User.getUserDetails()

    override func viewDidLoad() {
        super.viewDidLoad()

        initialise()
        setupUI()
        setConstraints()
    }
    
    func initialise() {
    }
    
    func setupUI() {
        scrollView = UIScrollView()
        contentView = UIView()
        
        view.addSubview(scrollView!)
        scrollView?.addSubview(contentView!)
        
        backButton = UIImageView()
        backButton?.image = UIImage(named: "backIcon_White")?.resizeImageTo(size: CGSize(width: 50, height: 50))
        backButton?.contentMode = .scaleAspectFit
        view.addSubview(backButton!)
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
        nameLabel?.textColor = .black
        nameLabel?.textAlignment = .center
        nameLabel?.font = UIFont(name: "NunitoSans-ExtraBold", size: 20)
        contentView?.addSubview(nameLabel!)
        
        emailLabel = UILabel()
        emailLabel?.text = userDetails.patient?.credential?.email ?? ""
        emailLabel?.textColor = .black
        emailLabel?.textAlignment = .center
        emailLabel?.font = UIFont(name: "NunitoSans-Regular", size: 15)
        contentView?.addSubview(emailLabel!)
    }
    
    func setConstraints() {
        scrollView?.translatesAutoresizingMaskIntoConstraints = false
        contentView?.translatesAutoresizingMaskIntoConstraints = false
        backButton?.translatesAutoresizingMaskIntoConstraints = false
        profileImageView?.translatesAutoresizingMaskIntoConstraints = false
        nameLabel?.translatesAutoresizingMaskIntoConstraints = false
        emailLabel?.translatesAutoresizingMaskIntoConstraints = false
        
        
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
    }
    
    @objc func handleBackAction(_ sender: UITapGestureRecognizer? = nil) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
