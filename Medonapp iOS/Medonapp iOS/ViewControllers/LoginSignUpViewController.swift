//
//  LoginSignUpViewController.swift
//  Medonapp iOS
//
//  Created by Harshal Kulkarni on 19/09/22.
//

import UIKit
import SwiftValidator

class LoginSignUpViewController: UIViewController {
    let validator = Validator()
    var scrollView: UIScrollView?
    var contentView: UIView?
    var pageTitle: UILabel?
    var loginButton: UIButtonBlueBackgroundVariableCR?
    var signUpButton: UIButton?
    var emailPhoneNumberLabel: UILabel?
    var emailPhoneNumberTextField: UITextFieldWithPlaceholder_CR8?
    var passwordLabel: UILabel?
    var passwordTextField: UITextFieldWithPlaceholder_CR8?
    var forgotPasswordButton: UIButton?
    var continueButton: UIButtonBlueBackgroundVariableCR?
    
    var activeTextField : UITextField? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dismissKeyboard()
        
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
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        scrollView = UIScrollView()
        contentView = UIView()
        
        view.addSubview(scrollView!)
        scrollView?.addSubview(contentView!)
        
        pageTitle = UILabel()
        pageTitle?.text = "Welcome to Medonapp"
        pageTitle?.textColor = .black
        pageTitle?.font = UIFont(name: "NunitoSans-ExtraBold", size: 24)
        contentView?.addSubview(pageTitle!)
        
        loginButton = UIButtonBlueBackgroundVariableCR()
        loginButton?.initButton(title: "Login", cornerRadius: 8)
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
        emailPhoneNumberLabel?.textColor = .black
        emailPhoneNumberLabel?.font = UIFont(name: "NunitoSans-ExtraBold", size: 18)
        contentView?.addSubview(emailPhoneNumberLabel!)
        
        emailPhoneNumberTextField = UITextFieldWithPlaceholder_CR8()
        emailPhoneNumberTextField?.delegate = self
        emailPhoneNumberTextField?.setPlaceholder(placeholder: "Email or Phone number")
        contentView?.addSubview(emailPhoneNumberTextField!)
        
        passwordLabel = UILabel()
        passwordLabel?.text = "Password"
        passwordLabel?.textColor = .black
        passwordLabel?.font = UIFont(name: "NunitoSans-ExtraBold", size: 18)
        contentView?.addSubview(passwordLabel!)
        
        passwordTextField = UITextFieldWithPlaceholder_CR8()
        passwordTextField?.delegate = self
        passwordTextField?.setPlaceholder(placeholder: "Password")
        contentView?.addSubview(passwordTextField!)
        
        forgotPasswordButton = UIButton()
        let forgotPasswordButtonAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: "NunitoSans-Bold", size: 14)!,
              .foregroundColor: UIColor(red: 0.48, green: 0.55, blue: 0.62, alpha: 1.00),
              .underlineStyle: NSUnderlineStyle.single.rawValue
          ]
        forgotPasswordButton?.setAttributedTitle(NSMutableAttributedString(
            string: "Forgot Password?",
            attributes: forgotPasswordButtonAttributes), for: .normal)
        forgotPasswordButton?.contentHorizontalAlignment = .leading
        contentView?.addSubview(forgotPasswordButton!)
        
        continueButton = UIButtonBlueBackgroundVariableCR()
        continueButton?.initButton(title: "Continue", cornerRadius: 14)
        contentView?.addSubview(continueButton!)
    }
    
    
    
    
    private func setConstraints() {
        scrollView?.translatesAutoresizingMaskIntoConstraints = false
        contentView?.translatesAutoresizingMaskIntoConstraints = false
        pageTitle?.translatesAutoresizingMaskIntoConstraints = false
        loginButton?.translatesAutoresizingMaskIntoConstraints = false
        signUpButton?.translatesAutoresizingMaskIntoConstraints = false
        emailPhoneNumberLabel?.translatesAutoresizingMaskIntoConstraints = false
        emailPhoneNumberTextField?.translatesAutoresizingMaskIntoConstraints = false
        passwordLabel?.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField?.translatesAutoresizingMaskIntoConstraints = false
        forgotPasswordButton?.translatesAutoresizingMaskIntoConstraints = false
        continueButton?.translatesAutoresizingMaskIntoConstraints = false
        
        
        
        scrollView?.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        scrollView?.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        scrollView?.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        scrollView?.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        
        contentView?.topAnchor.constraint(equalTo: scrollView!.topAnchor).isActive = true
        contentView?.leadingAnchor.constraint(equalTo: scrollView!.leadingAnchor).isActive = true
        contentView?.trailingAnchor.constraint(equalTo: scrollView!.trailingAnchor).isActive = true
        contentView?.bottomAnchor.constraint(equalTo: scrollView!.bottomAnchor).isActive = true
        contentView?.widthAnchor.constraint(equalTo: scrollView!.widthAnchor).isActive = true
        
        
        pageTitle?.topAnchor.constraint(equalTo: contentView!.topAnchor, constant: 39).isActive = true
        pageTitle?.leadingAnchor.constraint(equalTo: contentView!.leadingAnchor, constant: 28).isActive = true
        pageTitle?.trailingAnchor.constraint(greaterThanOrEqualTo: contentView!.trailingAnchor, constant: -30).isActive = true
        
        
        loginButton?.topAnchor.constraint(equalTo: pageTitle!.bottomAnchor, constant: 22).isActive = true
        loginButton?.leadingAnchor.constraint(equalTo: contentView!.leadingAnchor, constant: 28).isActive = true
        loginButton?.trailingAnchor.constraint(equalTo: signUpButton!.leadingAnchor, constant: -20).isActive = true
        loginButton?.heightAnchor.constraint(equalToConstant: 61).isActive = true
        
        
        signUpButton?.topAnchor.constraint(equalTo: loginButton!.topAnchor).isActive = true
        signUpButton?.trailingAnchor.constraint(equalTo: contentView!.trailingAnchor, constant: -28).isActive = true
        
        signUpButton?.widthAnchor.constraint(equalTo: loginButton!.widthAnchor).isActive = true
        signUpButton?.heightAnchor.constraint(equalToConstant: 61).isActive = true
        
        
        emailPhoneNumberLabel?.topAnchor.constraint(equalTo: loginButton!.bottomAnchor, constant: 22).isActive = true
        emailPhoneNumberLabel?.leadingAnchor.constraint(equalTo: contentView!.leadingAnchor, constant: 28).isActive = true
        emailPhoneNumberLabel?.trailingAnchor.constraint(equalTo: contentView!.trailingAnchor, constant: -28).isActive = true
        
        emailPhoneNumberTextField?.topAnchor.constraint(equalTo: emailPhoneNumberLabel!.bottomAnchor, constant: 5).isActive = true
        emailPhoneNumberTextField?.leadingAnchor.constraint(equalTo: contentView!.leadingAnchor, constant: 28).isActive = true
        emailPhoneNumberTextField?.trailingAnchor.constraint(equalTo: contentView!.trailingAnchor, constant: -28).isActive = true
        emailPhoneNumberTextField?.heightAnchor.constraint(equalToConstant: 61).isActive = true
        
        passwordLabel?.topAnchor.constraint(equalTo: emailPhoneNumberTextField!.bottomAnchor, constant: 15).isActive = true
        passwordLabel?.leadingAnchor.constraint(equalTo: emailPhoneNumberLabel!.leadingAnchor).isActive = true
        passwordLabel?.trailingAnchor.constraint(equalTo: emailPhoneNumberLabel!.trailingAnchor).isActive = true
        
        passwordTextField?.topAnchor.constraint(equalTo: passwordLabel!.bottomAnchor, constant: 5).isActive = true
        passwordTextField?.leadingAnchor.constraint(equalTo: emailPhoneNumberTextField!.leadingAnchor).isActive = true
        passwordTextField?.trailingAnchor.constraint(equalTo: emailPhoneNumberTextField!.trailingAnchor).isActive = true
        passwordTextField?.widthAnchor.constraint(equalTo: emailPhoneNumberTextField!.widthAnchor).isActive = true
        passwordTextField?.heightAnchor.constraint(equalTo: emailPhoneNumberTextField!.heightAnchor).isActive = true
        
        forgotPasswordButton?.topAnchor.constraint(equalTo: passwordTextField!.bottomAnchor, constant: 6).isActive = true
        forgotPasswordButton?.leadingAnchor.constraint(equalTo: emailPhoneNumberTextField!.leadingAnchor).isActive = true
        forgotPasswordButton?.trailingAnchor.constraint(equalTo: emailPhoneNumberTextField!.trailingAnchor).isActive = true
        
        continueButton?.topAnchor.constraint(equalTo: forgotPasswordButton!.bottomAnchor, constant: 25).isActive = true
        continueButton?.leadingAnchor.constraint(equalTo: emailPhoneNumberTextField!.leadingAnchor).isActive = true
        continueButton?.trailingAnchor.constraint(equalTo: emailPhoneNumberTextField!.trailingAnchor).isActive = true
        continueButton?.heightAnchor.constraint(equalToConstant: 56).isActive = true
        
        continueButton?.bottomAnchor.constraint(equalTo: contentView!.bottomAnchor, constant: -10).isActive = true
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            
            // if keyboard size is not available for some reason, dont do anything
            return
        }
        
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height , right: 0.0)
        scrollView!.contentInset = contentInsets
        scrollView!.scrollIndicatorInsets = contentInsets
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        
        // reset back the content inset to zero after keyboard is gone
        scrollView!.contentInset = contentInsets
        scrollView!.scrollIndicatorInsets = contentInsets
    }
}

extension LoginSignUpViewController : UITextFieldDelegate {
    // when user select a textfield, this method will be called
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // set the activeTextField to the selected textfield
        self.activeTextField = textField
    }
    
    // when user click 'done' or dismiss the keyboard
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.activeTextField = nil
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
