//
//  LoginSignUpViewController.swift
//  Medonapp iOS
//
//  Created by Harshal Kulkarni on 19/09/22.
//

import UIKit
import DPOTPView

enum views {
    case login
    case signupInitialDetails
    case signupPersonalDetails
    case signupAddressDetails
    case signupOtpVerification
}

class LoginSignUpViewController: UIViewController {
    var scrollView: UIScrollView?
    var pageTitle: UILabel?
    var loginButton: UIButtonVariableBackgroundVariableCR?
    var signUpButton: UIButtonVariableBackgroundVariableCR?
    public var activeView: views = .login //change value to toggle between initially active view
    var progressBar: UIProgressView?
    
    var loginScreenContentView: UIView?
    var emailPhoneNumberLabel: UILabel?
    var emailPhoneNumberTextField: UITextFieldWithPlaceholder_CR8?
    var passwordLabel: UILabel?
    var passwordTextField: UITextFieldWithPlaceholder_CR8?
    var forgotPasswordButton: UIButton?
    var loginContinueButton: UIButtonVariableBackgroundVariableCR?
    var loginContinueButtonBottomConstraint: NSLayoutConstraint?
    
    
    var signUpScreenContentView: UIView?
    
    //initial details
    var emailLabel: UILabel?
    var emailTextField: UITextFieldWithPlaceholder_CR8?
    var choosePasswordLabel: UILabel?
    var choosePasswordTextField: UITextFieldWithPlaceholder_CR8?
    var confirmPasswordLabel: UILabel?
    var confirmPasswordTextField: UITextFieldWithPlaceholder_CR8?
    
    //personal details
    var firstNameLabel: UILabel?
    var firstNameField: UITextFieldWithPlaceholder_CR8?
    var lastNameLabel: UILabel?
    var lastNameField: UITextFieldWithPlaceholder_CR8?
    
    //address details
    var phoneNumberLabel: UILabel?
    var countryCodeLabel: UILabel?
    var phoneNumberField: UITextFieldWithPlaceholder_CR8?
    var addressTextView: UITextViewWithPlaceholder_CR8?
    
    //otp verification
    var otpDetailsLabel: UILabel?
    var txtOTPView: DPOTPView?
    
    var signupContinueButton: UIButtonVariableBackgroundVariableCR?
    var progressBarTopConstraint: NSLayoutConstraint?
    var signupContinueButtonTopConstraint: NSLayoutConstraint?
    var signupContinueButtonBottomConstraint: NSLayoutConstraint?
    
    
    var activeTextField : UITextField? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dismissKeyboard()
        
        if let presentationController = presentationController as? UISheetPresentationController {
            presentationController.detents = [
                .medium(), .large()
            ]
            presentationController.prefersGrabberVisible = true
            presentationController.preferredCornerRadius = 35
            presentationController.largestUndimmedDetentIdentifier = .medium
        }
        
        initialise()
        setupUI()
        setConstraints()
        
        
        //activate view according to initialized value
        (activeView == .login) ? loginButtonPressed() : signUpButtonPressed()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func initialise() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        scrollView = UIScrollView()
        loginScreenContentView = UIView()
        signUpScreenContentView = UIView()
        
        view.addSubview(scrollView!)
        scrollView?.addSubview(loginScreenContentView!)
        scrollView?.addSubview(signUpScreenContentView!)
        
        pageTitle = UILabel()
        pageTitle?.text = "Welcome to Medonapp"
        pageTitle?.textColor = .black
        pageTitle?.font = UIFont(name: "NunitoSans-ExtraBold", size: 24)
        scrollView?.addSubview(pageTitle!)
        
        loginButton = UIButtonVariableBackgroundVariableCR()
        scrollView?.addSubview(loginButton!)
        loginButton?.addTarget(self, action: #selector(loginButtonPressed), for: .touchUpInside)
        
        signUpButton = UIButtonVariableBackgroundVariableCR()
        scrollView?.addSubview(signUpButton!)
        signUpButton?.addTarget(self, action: #selector(signUpButtonPressed), for: .touchUpInside)
        
        
        //MARK: Initializing variables for login view
        
        emailPhoneNumberLabel = UILabel()
        emailPhoneNumberLabel?.text = "Email or Phone Number"
        emailPhoneNumberLabel?.textColor = .black
        emailPhoneNumberLabel?.font = UIFont(name: "NunitoSans-ExtraBold", size: 18)
        loginScreenContentView?.addSubview(emailPhoneNumberLabel!)
        
        emailPhoneNumberTextField = UITextFieldWithPlaceholder_CR8()
        emailPhoneNumberTextField?.delegate = self
        emailPhoneNumberTextField?.setPlaceholder(placeholder: "Email or Phone number")
        loginScreenContentView?.addSubview(emailPhoneNumberTextField!)
        
        passwordLabel = UILabel()
        passwordLabel?.text = "Password"
        passwordLabel?.textColor = .black
        passwordLabel?.font = UIFont(name: "NunitoSans-ExtraBold", size: 18)
        loginScreenContentView?.addSubview(passwordLabel!)
        
        passwordTextField = UITextFieldWithPlaceholder_CR8()
        passwordTextField?.delegate = self
        passwordTextField?.setPlaceholder(placeholder: "Password")
        loginScreenContentView?.addSubview(passwordTextField!)
        
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
        loginScreenContentView?.addSubview(forgotPasswordButton!)
        
        loginContinueButton = UIButtonVariableBackgroundVariableCR()
        loginContinueButton?.initButton(title: "Continue", cornerRadius: 14, variant: .blueBack)
        loginScreenContentView?.addSubview(loginContinueButton!)
        
        
        //MARK: Initializing variables for signup view
        
        emailLabel = UILabel()
        emailLabel?.text = "Email"
        emailLabel?.textColor = .black
        emailLabel?.font = UIFont(name: "NunitoSans-ExtraBold", size: 18)
        signUpScreenContentView?.addSubview(emailLabel!)
        
        emailTextField = UITextFieldWithPlaceholder_CR8()
        emailTextField?.delegate = self
        emailTextField?.setPlaceholder(placeholder: "Email")
        firstNameField?.autocapitalizationType = .none
        firstNameField?.autocorrectionType = .no
        firstNameField?.keyboardType = .emailAddress
        signUpScreenContentView?.addSubview(emailTextField!)
        
        choosePasswordLabel = UILabel()
        choosePasswordLabel?.text = "Choose your Password"
        choosePasswordLabel?.textColor = .black
        choosePasswordLabel?.font = UIFont(name: "NunitoSans-ExtraBold", size: 18)
        signUpScreenContentView?.addSubview(choosePasswordLabel!)
        
        choosePasswordTextField = UITextFieldWithPlaceholder_CR8()
        choosePasswordTextField?.delegate = self
        choosePasswordTextField?.setPlaceholder(placeholder: "Password")
        signUpScreenContentView?.addSubview(choosePasswordTextField!)
        
        confirmPasswordLabel = UILabel()
        confirmPasswordLabel?.text = "Confirm Password"
        confirmPasswordLabel?.textColor = .black
        confirmPasswordLabel?.font = UIFont(name: "NunitoSans-ExtraBold", size: 18)
        signUpScreenContentView?.addSubview(confirmPasswordLabel!)
        
        confirmPasswordTextField = UITextFieldWithPlaceholder_CR8()
        confirmPasswordTextField?.delegate = self
        confirmPasswordTextField?.setPlaceholder(placeholder: "Confirm Password")
        signUpScreenContentView?.addSubview(confirmPasswordTextField!)
        
        firstNameLabel = UILabel()
        firstNameLabel?.text = "First Name"
        firstNameLabel?.textColor = .black
        firstNameLabel?.font = UIFont(name: "NunitoSans-ExtraBold", size: 18)
        signUpScreenContentView?.addSubview(firstNameLabel!)
        firstNameLabel?.alpha = 0
        
        firstNameField = UITextFieldWithPlaceholder_CR8()
        firstNameField?.delegate = self
        firstNameField?.setPlaceholder(placeholder: "First Name")
        firstNameField?.autocapitalizationType = .words
        firstNameField?.autocorrectionType = .no
        firstNameField?.keyboardType = .default
        signUpScreenContentView?.addSubview(firstNameField!)
        firstNameField?.alpha = 0
        
        lastNameLabel = UILabel()
        lastNameLabel?.text = "Last Name"
        lastNameLabel?.textColor = .black
        lastNameLabel?.font = UIFont(name: "NunitoSans-ExtraBold", size: 18)
        signUpScreenContentView?.addSubview(lastNameLabel!)
        lastNameLabel?.alpha = 0
        
        lastNameField = UITextFieldWithPlaceholder_CR8()
        lastNameField?.delegate = self
        lastNameField?.setPlaceholder(placeholder: "Last Name")
        firstNameField?.autocapitalizationType = .words
        firstNameField?.autocorrectionType = .no
        firstNameField?.keyboardType = .default
        signUpScreenContentView?.addSubview(lastNameField!)
        lastNameField?.alpha = 0
        
        phoneNumberLabel = UILabel()
        phoneNumberLabel?.text = "Phone Number"
        phoneNumberLabel?.textColor = .black
        phoneNumberLabel?.font = UIFont(name: "NunitoSans-ExtraBold", size: 18)
        signUpScreenContentView?.addSubview(phoneNumberLabel!)
        phoneNumberLabel?.alpha = 0
        
        countryCodeLabel = UILabel()
        countryCodeLabel?.text = "+91"
        countryCodeLabel?.textColor = UIColor(red: 0.48, green: 0.55, blue: 0.62, alpha: 1.00)
        countryCodeLabel?.layer.borderColor = UIColor(red: 0.75, green: 0.79, blue: 0.85, alpha: 1.00).cgColor
        countryCodeLabel?.textAlignment = .center
        countryCodeLabel?.layer.borderWidth = 1
        countryCodeLabel?.layer.cornerRadius = 10
        countryCodeLabel?.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        countryCodeLabel?.font = UIFont(name: "NunitoSans-ExtraBold", size: 18)
        signUpScreenContentView?.addSubview(countryCodeLabel!)
        countryCodeLabel?.alpha = 0
        
        phoneNumberField = UITextFieldWithPlaceholder_CR8()
        phoneNumberField?.delegate = self
        phoneNumberField?.setPlaceholder(placeholder: "Phone Number")
        firstNameField?.autocapitalizationType = .none
        firstNameField?.autocorrectionType = .no
        firstNameField?.keyboardType = .namePhonePad
        phoneNumberField?.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        
        addressTextView = UITextViewWithPlaceholder_CR8()
        addressTextView?.setPlaceholder(placeholder: "Address")
        addressTextView?.autocapitalizationType = .words
        addressTextView?.autocorrectionType = .no
        addressTextView?.keyboardType = .default
        addressTextView?.font = UIFont(name: "NunitoSans-Bold", size: 18)
        signUpScreenContentView?.addSubview(addressTextView!)
        addressTextView?.alpha = 0
        
        otpDetailsLabel = UILabel()
        otpDetailsLabel?.text = "Please enter Verification code sent to email "
        otpDetailsLabel?.textColor = .black
        otpDetailsLabel?.numberOfLines = 0
        otpDetailsLabel?.font = UIFont(name: "NunitoSans-ExtraBold", size: 18)
        signUpScreenContentView?.addSubview(otpDetailsLabel!)
        otpDetailsLabel?.alpha = 0
        
        txtOTPView = DPOTPView()
        txtOTPView?.placeholder = "...."
        txtOTPView?.count = 4
        txtOTPView?.spacing = 15
        txtOTPView?.fontTextField = UIFont(name: "NunitoSans-ExtraBold", size: CGFloat(20.0))!
        txtOTPView?.dismissOnLastEntry = true
        txtOTPView?.borderColorTextField = UIColor(red: 0.75, green: 0.79, blue: 0.85, alpha: 1.00)
        txtOTPView?.selectedBorderColorTextField = UIColor.blue
        txtOTPView?.borderWidthTextField = 2
        txtOTPView?.backGroundColorTextField = UIColor.black.withAlphaComponent(0.06)
        txtOTPView?.cornerRadiusTextField = 8
        txtOTPView?.isCursorHidden = true
        //txtOTPView.isSecureTextEntry = true
        //txtOTPView.isBottomLineTextField = true
        //txtOTPView.isCircleTextField = true
        signUpScreenContentView?.addSubview(txtOTPView!)
        txtOTPView?.alpha = 0
        
        
        signUpScreenContentView?.addSubview(phoneNumberField!)
        phoneNumberField?.alpha = 0
        
        progressBar = UIProgressView(progressViewStyle: .default)
        progressBar?.progress = 0.25
        progressBar?.progressTintColor = UIColor(red: 0.11, green: 0.42, blue: 0.64, alpha: 1.00)
        progressBar?.trackTintColor = UIColor(red: 0.75, green: 0.79, blue: 0.85, alpha: 1.00)
        signUpScreenContentView?.addSubview(progressBar!)
        
        signupContinueButton = UIButtonVariableBackgroundVariableCR()
        signupContinueButton?.initButton(title: "Continue", cornerRadius: 14, variant: .blueBack)
        signUpScreenContentView?.addSubview(signupContinueButton!)
        signupContinueButton?.addTarget(self, action: #selector(signUpContinueButtonPressed), for: .touchUpInside)
    }
    
    
    private func setConstraints() {
        scrollView?.translatesAutoresizingMaskIntoConstraints = false
        pageTitle?.translatesAutoresizingMaskIntoConstraints = false
        loginButton?.translatesAutoresizingMaskIntoConstraints = false
        signUpButton?.translatesAutoresizingMaskIntoConstraints = false
        
        loginScreenContentView?.translatesAutoresizingMaskIntoConstraints = false
        emailPhoneNumberLabel?.translatesAutoresizingMaskIntoConstraints = false
        emailPhoneNumberTextField?.translatesAutoresizingMaskIntoConstraints = false
        passwordLabel?.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField?.translatesAutoresizingMaskIntoConstraints = false
        forgotPasswordButton?.translatesAutoresizingMaskIntoConstraints = false
        loginContinueButton?.translatesAutoresizingMaskIntoConstraints = false
        
        
        signUpScreenContentView?.translatesAutoresizingMaskIntoConstraints = false
        emailLabel?.translatesAutoresizingMaskIntoConstraints = false
        emailTextField?.translatesAutoresizingMaskIntoConstraints = false
        choosePasswordLabel?.translatesAutoresizingMaskIntoConstraints = false
        choosePasswordTextField?.translatesAutoresizingMaskIntoConstraints = false
        confirmPasswordLabel?.translatesAutoresizingMaskIntoConstraints = false
        confirmPasswordTextField?.translatesAutoresizingMaskIntoConstraints = false
        
        firstNameLabel?.translatesAutoresizingMaskIntoConstraints = false
        firstNameField?.translatesAutoresizingMaskIntoConstraints = false
        lastNameLabel?.translatesAutoresizingMaskIntoConstraints = false
        lastNameField?.translatesAutoresizingMaskIntoConstraints = false
        
        phoneNumberLabel?.translatesAutoresizingMaskIntoConstraints = false
        countryCodeLabel?.translatesAutoresizingMaskIntoConstraints = false
        phoneNumberField?.translatesAutoresizingMaskIntoConstraints = false
        addressTextView?.translatesAutoresizingMaskIntoConstraints = false
        
        otpDetailsLabel?.translatesAutoresizingMaskIntoConstraints = false
        txtOTPView?.translatesAutoresizingMaskIntoConstraints = false
        
        progressBar?.translatesAutoresizingMaskIntoConstraints = false
        signupContinueButton?.translatesAutoresizingMaskIntoConstraints = false
        
        
        
        scrollView?.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        scrollView?.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        scrollView?.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        scrollView?.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        
        loginScreenContentView?.topAnchor.constraint(equalTo: scrollView!.topAnchor).isActive = true
        loginScreenContentView?.leadingAnchor.constraint(equalTo: scrollView!.leadingAnchor).isActive = true
        loginScreenContentView?.trailingAnchor.constraint(equalTo: scrollView!.trailingAnchor).isActive = true
        loginScreenContentView?.bottomAnchor.constraint(equalTo: scrollView!.bottomAnchor).isActive = true
        loginScreenContentView?.widthAnchor.constraint(equalTo: scrollView!.widthAnchor).isActive = true
        
        
        signUpScreenContentView?.topAnchor.constraint(equalTo: scrollView!.topAnchor).isActive = true
        signUpScreenContentView?.leadingAnchor.constraint(equalTo: scrollView!.leadingAnchor).isActive = true
        signUpScreenContentView?.trailingAnchor.constraint(equalTo: scrollView!.trailingAnchor).isActive = true
        signUpScreenContentView?.bottomAnchor.constraint(equalTo: scrollView!.bottomAnchor).isActive = true
        signUpScreenContentView?.widthAnchor.constraint(equalTo: scrollView!.widthAnchor).isActive = true
        
        
        
        pageTitle?.topAnchor.constraint(equalTo: scrollView!.topAnchor, constant: 39).isActive = true
        pageTitle?.leadingAnchor.constraint(equalTo: scrollView!.leadingAnchor, constant: 28).isActive = true
        pageTitle?.trailingAnchor.constraint(greaterThanOrEqualTo: scrollView!.trailingAnchor, constant: -30).isActive = true
        
        
        loginButton?.topAnchor.constraint(equalTo: pageTitle!.bottomAnchor, constant: 22).isActive = true
        loginButton?.leadingAnchor.constraint(equalTo: scrollView!.leadingAnchor, constant: 28).isActive = true
        loginButton?.trailingAnchor.constraint(equalTo: signUpButton!.leadingAnchor, constant: -20).isActive = true
        loginButton?.heightAnchor.constraint(equalToConstant: 61).isActive = true
        
        
        signUpButton?.topAnchor.constraint(equalTo: loginButton!.topAnchor).isActive = true
        signUpButton?.trailingAnchor.constraint(equalTo: scrollView!.trailingAnchor, constant: -28).isActive = true
        
        signUpButton?.widthAnchor.constraint(equalTo: loginButton!.widthAnchor).isActive = true
        signUpButton?.heightAnchor.constraint(equalToConstant: 61).isActive = true
        
        
        //MARK: Constraints for login view
        emailPhoneNumberLabel?.topAnchor.constraint(equalTo: loginButton!.bottomAnchor, constant: 22).isActive = true
        emailPhoneNumberLabel?.leadingAnchor.constraint(equalTo: loginScreenContentView!.leadingAnchor, constant: 28).isActive = true
        emailPhoneNumberLabel?.trailingAnchor.constraint(equalTo: loginScreenContentView!.trailingAnchor, constant: -28).isActive = true
        
        emailPhoneNumberTextField?.topAnchor.constraint(equalTo: emailPhoneNumberLabel!.bottomAnchor, constant: 5).isActive = true
        emailPhoneNumberTextField?.leadingAnchor.constraint(equalTo: loginScreenContentView!.leadingAnchor, constant: 28).isActive = true
        emailPhoneNumberTextField?.trailingAnchor.constraint(equalTo: loginScreenContentView!.trailingAnchor, constant: -28).isActive = true
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
        
        loginContinueButton?.topAnchor.constraint(equalTo: forgotPasswordButton!.bottomAnchor, constant: 25).isActive = true
        
        loginContinueButton?.leadingAnchor.constraint(equalTo: emailPhoneNumberTextField!.leadingAnchor).isActive = true
        loginContinueButton?.trailingAnchor.constraint(equalTo: emailPhoneNumberTextField!.trailingAnchor).isActive = true
        loginContinueButton?.heightAnchor.constraint(equalToConstant: 56).isActive = true
        
        loginContinueButtonBottomConstraint = loginContinueButton?.bottomAnchor.constraint(equalTo: loginScreenContentView!.bottomAnchor, constant: -10)
        
        
        
        //MARK: Constraints for signup view
        
        initializeAndActivateViewConstraints(view: .signupInitialDetails)
        
        progressBar?.leadingAnchor.constraint(equalTo: emailTextField!.leadingAnchor).isActive = true
        progressBar?.trailingAnchor.constraint(equalTo: emailTextField!.trailingAnchor).isActive = true
        progressBar?.widthAnchor.constraint(equalTo: emailTextField!.widthAnchor).isActive = true
        progressBar?.heightAnchor.constraint(equalToConstant: 5).isActive = true
        
        signupContinueButton?.topAnchor.constraint(equalTo: progressBar!.bottomAnchor, constant: 22).isActive = true
        signupContinueButton?.leadingAnchor.constraint(equalTo: confirmPasswordTextField!.leadingAnchor).isActive = true
        signupContinueButton?.trailingAnchor.constraint(equalTo: confirmPasswordTextField!.trailingAnchor).isActive = true
        signupContinueButton?.heightAnchor.constraint(equalToConstant: 56).isActive = true
        
        signupContinueButtonBottomConstraint = signupContinueButton?.bottomAnchor.constraint(equalTo: signUpScreenContentView!.bottomAnchor, constant: -10)
    }
    
    @objc func loginButtonPressed() {
        if let presentationController = presentationController as? UISheetPresentationController {
            presentationController.animateChanges {
                presentationController.selectedDetentIdentifier = .medium
            }
        }
        UIView.animate(withDuration: 0.2, delay: 0.0, options: UIView.AnimationOptions.transitionCurlUp, animations: {
            //change active button colors
            self.signUpButton?.initButton(title: "Signup", cornerRadius: 8, variant: .whiteBack)
            self.loginButton?.initButton(title: "Login", cornerRadius: 8, variant: .blueBack)
            
            //set active view opacity
            self.signUpScreenContentView?.alpha = 0
        }, completion: {
            (finished: Bool) -> Void in
            
            //Activate and deactivate constraints
            self.signupContinueButtonTopConstraint?.isActive = false
            self.signupContinueButtonBottomConstraint?.isActive = false
            self.progressBarTopConstraint?.isActive = false
            self.loginContinueButtonBottomConstraint?.isActive = true
            
            //Set hidden views
            self.signUpScreenContentView?.isHidden = true
            self.loginScreenContentView?.alpha = 0
            self.loginScreenContentView?.isHidden = false
            
            // Fade in new view
            UIView.animate(withDuration: 0.2, delay: 0.0, options: UIView.AnimationOptions.transitionCurlUp, animations: {
                self.loginScreenContentView?.alpha = 1.0
            }, completion: nil)
            
            //set active view
            self.activeView = .login
        })
    }
    
    @objc func signUpButtonPressed() {
        if let presentationController = presentationController as? UISheetPresentationController {
            presentationController.animateChanges {
                presentationController.selectedDetentIdentifier = .large
            }
        }
        UIView.animate(withDuration: 0.2, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {
            //change active button colors
            self.loginButton?.initButton(title: "Login", cornerRadius: 8, variant: .whiteBack)
            self.signUpButton?.initButton(title: "Signup", cornerRadius: 8, variant: .blueBack)
            
            //set active view opacity
            self.loginScreenContentView?.alpha = 0
        }, completion: {
            (finished: Bool) -> Void in
            
            //Activate and deactivate constraints
            self.loginContinueButtonBottomConstraint?.isActive = false
            self.progressBarTopConstraint?.isActive = true
            self.signupContinueButtonTopConstraint?.isActive = true
            self.signupContinueButtonBottomConstraint?.isActive = true
            
            //Set hidden views
            self.loginScreenContentView?.isHidden = true
            self.signUpScreenContentView?.alpha = 0
            self.signUpScreenContentView?.isHidden = false
            
            // Fade in new view
            UIView.animate(withDuration: 0.2, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, animations: {
                self.signUpScreenContentView?.alpha = 1.0
            }, completion: nil)
            
            //set active view
            self.activeView = .signupInitialDetails
        })
    }
    
    @objc func signUpContinueButtonPressed() {
        if activeView == .signupInitialDetails {
            UIView.animate(withDuration: 0.2, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {
                self.pageTitle?.alpha = 0
                self.loginButton?.alpha = 0
                self.signUpButton?.alpha = 0
                self.emailLabel?.alpha = 0
                self.emailTextField?.alpha = 0
                self.choosePasswordLabel?.alpha = 0
                self.choosePasswordTextField?.alpha = 0
                self.confirmPasswordLabel?.alpha = 0
                self.confirmPasswordTextField?.alpha = 0
            }, completion: {
                (finished: Bool) -> Void in
                self.pageTitle?.text = "Enter your details"
                UIView.animate(withDuration: 0.2, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, animations: {
                    self.pageTitle?.alpha = 1
                    self.initializeAndActivateViewConstraints(view: .signupPersonalDetails)
                    self.progressBar?.setProgress(0.50, animated: true)
                }, completion: nil)
            })
        } else if activeView == .signupPersonalDetails {
            UIView.animate(withDuration: 0.2, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {
                self.firstNameLabel?.alpha = 0
                self.firstNameField?.alpha = 0
                self.lastNameLabel?.alpha = 0
                self.lastNameField?.alpha = 0
            }, completion: {
                (finished: Bool) -> Void in
                UIView.animate(withDuration: 0.2, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, animations: {
                    self.initializeAndActivateViewConstraints(view: .signupAddressDetails)
                    self.progressBar?.setProgress(0.75, animated: true)
                }, completion: nil)
            })
        } else if activeView == .signupAddressDetails {
            UIView.animate(withDuration: 0.2, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {
                self.pageTitle?.alpha = 0
                self.phoneNumberLabel?.alpha = 0
                self.countryCodeLabel?.alpha = 0
                self.phoneNumberField?.alpha = 0
                self.addressTextView?.alpha = 0
            }, completion: {
                (finished: Bool) -> Void in
                self.pageTitle?.text = "You’re all set"
                UIView.animate(withDuration: 0.2, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, animations: {
                    self.pageTitle?.alpha = 1
                    self.initializeAndActivateViewConstraints(view: .signupOtpVerification)
                    self.progressBar?.setProgress(0.87, animated: true)
                }, completion: nil)
            })
        } else if activeView == .signupOtpVerification {
            UIView.animate(withDuration: 0.2, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {
                self.progressBar?.setProgress(0.87, animated: true)
            }, completion: {
                (finished: Bool) -> Void in
                self.pageTitle?.text = "You’re all set"
                UIView.animate(withDuration: 0.2, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, animations: {
                    self.dismiss(animated: true) {
                        NotificationCenter.default.post(name: Notification.Name("goToDashboard"), object: nil)
                    }
                }, completion: nil)
            })
        }
        
        
    }
    
    func initializeAndActivateViewConstraints(view: views) {
        switch view {
        case .login:
            break
        case .signupInitialDetails:
            emailLabel?.topAnchor.constraint(equalTo: loginButton!.bottomAnchor, constant: 22).isActive = true
            emailLabel?.leadingAnchor.constraint(equalTo: signUpScreenContentView!.leadingAnchor, constant: 28).isActive = true
            emailLabel?.trailingAnchor.constraint(equalTo: signUpScreenContentView!.trailingAnchor, constant: -28).isActive = true
            
            emailTextField?.topAnchor.constraint(equalTo: emailLabel!.bottomAnchor, constant: 5).isActive = true
            emailTextField?.leadingAnchor.constraint(equalTo: signUpScreenContentView!.leadingAnchor, constant: 28).isActive = true
            emailTextField?.trailingAnchor.constraint(equalTo: signUpScreenContentView!.trailingAnchor, constant: -28).isActive = true
            emailTextField?.heightAnchor.constraint(equalToConstant: 61).isActive = true
            
            choosePasswordLabel?.topAnchor.constraint(equalTo: emailTextField!.bottomAnchor, constant: 15).isActive = true
            choosePasswordLabel?.leadingAnchor.constraint(equalTo: emailLabel!.leadingAnchor).isActive = true
            choosePasswordLabel?.trailingAnchor.constraint(equalTo: emailLabel!.trailingAnchor).isActive = true
            
            choosePasswordTextField?.topAnchor.constraint(equalTo: choosePasswordLabel!.bottomAnchor, constant: 5).isActive = true
            choosePasswordTextField?.leadingAnchor.constraint(equalTo: emailTextField!.leadingAnchor).isActive = true
            choosePasswordTextField?.trailingAnchor.constraint(equalTo: emailTextField!.trailingAnchor).isActive = true
            choosePasswordTextField?.widthAnchor.constraint(equalTo: emailTextField!.widthAnchor).isActive = true
            choosePasswordTextField?.heightAnchor.constraint(equalTo: emailTextField!.heightAnchor).isActive = true
            
            confirmPasswordLabel?.topAnchor.constraint(equalTo: choosePasswordTextField!.bottomAnchor, constant: 15).isActive = true
            confirmPasswordLabel?.leadingAnchor.constraint(equalTo: emailLabel!.leadingAnchor).isActive = true
            confirmPasswordLabel?.trailingAnchor.constraint(equalTo: emailLabel!.trailingAnchor).isActive = true
            
            confirmPasswordTextField?.topAnchor.constraint(equalTo: confirmPasswordLabel!.bottomAnchor, constant: 5).isActive = true
            confirmPasswordTextField?.leadingAnchor.constraint(equalTo: emailTextField!.leadingAnchor).isActive = true
            confirmPasswordTextField?.trailingAnchor.constraint(equalTo: emailTextField!.trailingAnchor).isActive = true
            confirmPasswordTextField?.widthAnchor.constraint(equalTo: emailTextField!.widthAnchor).isActive = true
            confirmPasswordTextField?.heightAnchor.constraint(equalTo: emailTextField!.heightAnchor).isActive = true
            
            progressBarTopConstraint?.isActive = false
            progressBarTopConstraint = progressBar?.topAnchor.constraint(equalTo: confirmPasswordTextField!.bottomAnchor, constant: 29)
            progressBarTopConstraint?.isActive = true
        case .signupPersonalDetails:
            firstNameLabel?.topAnchor.constraint(equalTo: pageTitle!.bottomAnchor, constant: 22).isActive = true
            firstNameLabel?.leadingAnchor.constraint(equalTo: signUpScreenContentView!.leadingAnchor, constant: 28).isActive = true
            firstNameLabel?.trailingAnchor.constraint(equalTo: signUpScreenContentView!.trailingAnchor, constant: -28).isActive = true
            
            firstNameField?.topAnchor.constraint(equalTo: firstNameLabel!.bottomAnchor, constant: 5).isActive = true
            firstNameField?.leadingAnchor.constraint(equalTo: signUpScreenContentView!.leadingAnchor, constant: 28).isActive = true
            firstNameField?.trailingAnchor.constraint(equalTo: signUpScreenContentView!.trailingAnchor, constant: -28).isActive = true
            firstNameField?.heightAnchor.constraint(equalToConstant: 61).isActive = true
            
            lastNameLabel?.topAnchor.constraint(equalTo: firstNameField!.bottomAnchor, constant: 22).isActive = true
            lastNameLabel?.leadingAnchor.constraint(equalTo: signUpScreenContentView!.leadingAnchor, constant: 28).isActive = true
            lastNameLabel?.trailingAnchor.constraint(equalTo: signUpScreenContentView!.trailingAnchor, constant: -28).isActive = true
            
            lastNameField?.topAnchor.constraint(equalTo: lastNameLabel!.bottomAnchor, constant: 5).isActive = true
            lastNameField?.leadingAnchor.constraint(equalTo: signUpScreenContentView!.leadingAnchor, constant: 28).isActive = true
            lastNameField?.trailingAnchor.constraint(equalTo: signUpScreenContentView!.trailingAnchor, constant: -28).isActive = true
            lastNameField?.heightAnchor.constraint(equalToConstant: 61).isActive = true
            
            firstNameLabel?.alpha = 1
            firstNameField?.alpha = 1
            lastNameLabel?.alpha = 1
            lastNameField?.alpha = 1
            
            progressBarTopConstraint?.isActive = false
            progressBarTopConstraint = progressBar?.topAnchor.constraint(equalTo: lastNameField!.bottomAnchor, constant: 29)
            progressBarTopConstraint?.isActive = true
            
            self.activeView = .signupPersonalDetails
            break
        case .signupAddressDetails:
            phoneNumberLabel?.topAnchor.constraint(equalTo: pageTitle!.bottomAnchor, constant: 22).isActive = true
            phoneNumberLabel?.leadingAnchor.constraint(equalTo: signUpScreenContentView!.leadingAnchor, constant: 28).isActive = true
            phoneNumberLabel?.trailingAnchor.constraint(equalTo: signUpScreenContentView!.trailingAnchor, constant: -28).isActive = true
            
            countryCodeLabel?.topAnchor.constraint(equalTo: phoneNumberLabel!.bottomAnchor, constant: 22).isActive = true
            countryCodeLabel?.leadingAnchor.constraint(equalTo: signUpScreenContentView!.leadingAnchor, constant: 28).isActive = true
            countryCodeLabel?.widthAnchor.constraint(equalToConstant: 60).isActive = true
            countryCodeLabel?.heightAnchor.constraint(equalToConstant: 61).isActive = true
            
            phoneNumberField?.topAnchor.constraint(equalTo: countryCodeLabel!.topAnchor).isActive = true
            phoneNumberField?.leadingAnchor.constraint(equalTo: countryCodeLabel!.trailingAnchor, constant: 0).isActive = true
            phoneNumberField?.trailingAnchor.constraint(equalTo: signUpScreenContentView!.trailingAnchor, constant: -28).isActive = true
            phoneNumberField?.heightAnchor.constraint(equalToConstant: 61).isActive = true
            
            addressTextView?.topAnchor.constraint(equalTo: phoneNumberField!.bottomAnchor, constant: 22).isActive = true
            addressTextView?.leadingAnchor.constraint(equalTo: signUpScreenContentView!.leadingAnchor, constant: 28).isActive = true
            addressTextView?.trailingAnchor.constraint(equalTo: signUpScreenContentView!.trailingAnchor, constant: -28).isActive = true
            addressTextView?.heightAnchor.constraint(equalToConstant: 150).isActive = true
            
            phoneNumberLabel?.alpha = 1
            countryCodeLabel?.alpha = 1
            phoneNumberField?.alpha = 1
            addressTextView?.alpha = 1
            
            progressBarTopConstraint?.isActive = false
            progressBarTopConstraint = progressBar?.topAnchor.constraint(equalTo: addressTextView!.bottomAnchor, constant: 29)
            progressBarTopConstraint?.isActive = true
            
            self.activeView = .signupAddressDetails
            break
        case .signupOtpVerification:
            otpDetailsLabel?.topAnchor.constraint(equalTo: pageTitle!.bottomAnchor, constant: 22).isActive = true
            otpDetailsLabel?.leadingAnchor.constraint(equalTo: signUpScreenContentView!.leadingAnchor, constant: 28).isActive = true
            otpDetailsLabel?.trailingAnchor.constraint(equalTo: signUpScreenContentView!.trailingAnchor, constant: -28).isActive = true
            otpDetailsLabel?.heightAnchor.constraint(equalToConstant: 90).isActive = true
            
            txtOTPView?.topAnchor.constraint(equalTo: otpDetailsLabel!.bottomAnchor, constant: 28).isActive = true
            txtOTPView?.leadingAnchor.constraint(equalTo: signUpScreenContentView!.leadingAnchor, constant: 28).isActive = true
            txtOTPView?.trailingAnchor.constraint(equalTo: signUpScreenContentView!.trailingAnchor, constant: -28).isActive = true
            txtOTPView?.centerXAnchor.constraint(equalTo: signUpScreenContentView!.centerXAnchor).isActive = true
            txtOTPView?.heightAnchor.constraint(equalToConstant: 60).isActive = true
            
            otpDetailsLabel?.alpha = 1
            txtOTPView?.alpha = 1
            
            progressBarTopConstraint?.isActive = false
            progressBarTopConstraint = progressBar?.topAnchor.constraint(equalTo: txtOTPView!.bottomAnchor, constant: 29)
            progressBarTopConstraint?.isActive = true
            
            self.activeView = .signupOtpVerification
            break
        }
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

extension LoginSignUpViewController : UITextFieldDelegate, DPOTPViewDelegate {
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
    
    func dpOTPViewAddText(_ text: String, at position: Int) {
         print("addText:- " + text + " at:- \(position)" )
     }
     
     func dpOTPViewRemoveText(_ text: String, at position: Int) {
         print("removeText:- " + text + " at:- \(position)" )
     }
     
     func dpOTPViewChangePositionAt(_ position: Int) {
         print("at:-\(position)")
     }
     func dpOTPViewBecomeFirstResponder() {
         
     }
     func dpOTPViewResignFirstResponder() {
         
     }
}
