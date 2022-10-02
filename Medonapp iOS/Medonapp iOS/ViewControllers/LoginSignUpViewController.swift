//
//  LoginSignUpViewController.swift
//  Medonapp iOS
//
//  Created by Harshal Kulkarni on 19/09/22.
//

import UIKit

class LoginSignUpViewController: UIViewController {
    var scrollView: UIScrollView?
    var contentView: UIView?
    var pageTitle: UILabel?
    var loginButton: UIButton?
    var signUpButton: UIButton?
    var emailPhoneNumberLabel: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let presentationController = presentationController as? UISheetPresentationController {
            presentationController.detents = [
                .medium()
            ]
            presentationController.prefersGrabberVisible = true
            presentationController.preferredCornerRadius = 35
            presentationController.largestUndimmedDetentIdentifier = .medium
        }
        
        initialise()
        setupUI()
        setConstraints()

        // Do any additional setup after loading the view.
    }
    
    private func initialise() {
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        scrollView = UIScrollView()
        contentView = UIView()
        
        view.addSubview(scrollView!)
        scrollView?.addSubview(contentView!)
        
        pageTitle = UILabel()
        pageTitle?.text = "Welcome to Medonapp"
        pageTitle?.font = UIFont(name: "NunitoSans-ExtraBold", size: 24)
        contentView?.addSubview(pageTitle!)
        
        loginButton = UIButton()
        loginButton?.setTitle("Login", for: .normal)
        loginButton?.backgroundColor = UIColor(red: 0.11, green: 0.42, blue: 0.64, alpha: 1.00)
        loginButton?.setTitleColor(.white, for: .normal)
        loginButton?.titleLabel?.font = UIFont(name: "NunitoSans-Bold", size: 14)
        loginButton?.layer.cornerRadius = 8
        contentView?.addSubview(loginButton!)
        
        signUpButton = UIButton()
        signUpButton?.setTitle("Signup", for: .normal)
        signUpButton?.backgroundColor = .white
        signUpButton?.layer.borderColor = UIColor(red: 0.75, green: 0.79, blue: 0.85, alpha: 1.00).cgColor
        signUpButton?.layer.borderWidth = 1
        signUpButton?.setTitleColor(UIColor(red: 0.48, green: 0.55, blue: 0.62, alpha: 1.00), for: .normal)
        signUpButton?.titleLabel?.font = UIFont(name: "NunitoSans-Bold", size: 14)
        signUpButton?.layer.cornerRadius = 8
        contentView?.addSubview(signUpButton!)
        
        emailPhoneNumberLabel = UILabel()
        emailPhoneNumberLabel?.text = "Email or Phone Number"
        emailPhoneNumberLabel?.font = UIFont(name: "NunitoSans-ExtraBold", size: 18)
        contentView?.addSubview(emailPhoneNumberLabel!)
    }
    
    
    
    
    private func setConstraints() {
        scrollView?.translatesAutoresizingMaskIntoConstraints = false
        contentView?.translatesAutoresizingMaskIntoConstraints = false
        pageTitle?.translatesAutoresizingMaskIntoConstraints = false
        loginButton?.translatesAutoresizingMaskIntoConstraints = false
        signUpButton?.translatesAutoresizingMaskIntoConstraints = false
        emailPhoneNumberLabel?.translatesAutoresizingMaskIntoConstraints = false
        
        
        
        scrollView?.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView?.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView?.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView?.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        
        contentView?.topAnchor.constraint(equalTo: scrollView!.topAnchor).isActive = true
        contentView?.leadingAnchor.constraint(equalTo: scrollView!.leadingAnchor).isActive = true
        contentView?.trailingAnchor.constraint(equalTo: scrollView!.trailingAnchor).isActive = true
        contentView?.bottomAnchor.constraint(equalTo: scrollView!.bottomAnchor).isActive = true
        
        
        pageTitle?.topAnchor.constraint(equalTo: scrollView!.topAnchor, constant: 39).isActive = true
        pageTitle?.leadingAnchor.constraint(equalTo: scrollView!.leadingAnchor, constant: 28).isActive = true
        pageTitle?.trailingAnchor.constraint(greaterThanOrEqualTo: scrollView!.trailingAnchor, constant: -30).isActive = true
        
        
        loginButton?.topAnchor.constraint(equalTo: pageTitle!.bottomAnchor, constant: 22).isActive = true
        loginButton?.leadingAnchor.constraint(equalTo: contentView!.leadingAnchor, constant: 28).isActive = true
        loginButton?.widthAnchor.constraint(equalToConstant: 152).isActive = true
        loginButton?.heightAnchor.constraint(equalToConstant: 61).isActive = true
        
        
        signUpButton?.topAnchor.constraint(equalTo: loginButton!.topAnchor).isActive = true
        signUpButton?.leadingAnchor.constraint(greaterThanOrEqualTo: loginButton!.trailingAnchor, constant: 20).isActive = true
        signUpButton?.trailingAnchor.constraint(equalTo: contentView!.trailingAnchor, constant: -28).isActive = true
        signUpButton?.widthAnchor.constraint(equalTo: loginButton!.widthAnchor).isActive = true
        signUpButton?.heightAnchor.constraint(equalToConstant: 61).isActive = true
        
        
        emailPhoneNumberLabel?.topAnchor.constraint(equalTo: loginButton!.bottomAnchor, constant: 22).isActive = true
        emailPhoneNumberLabel?.leadingAnchor.constraint(equalTo: contentView!.leadingAnchor, constant: 28).isActive = true
        emailPhoneNumberLabel?.trailingAnchor.constraint(equalTo: contentView!.trailingAnchor, constant: 28).isActive = true
    }
}
