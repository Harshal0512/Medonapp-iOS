//
//  LoginSignUpViewController.swift
//  Medonapp iOS
//
//  Created by Harshal Kulkarni on 19/09/22.
//

import UIKit
import SwiftValidator

enum views {
    case login
    case signup
}

class LoginSignUpViewController: UIViewController {
    let validator = Validator()
    var scrollView: UIScrollView?
    var pageTitle: UILabel?
    var loginButton: UIButtonVariableBackgroundVariableCR?
    var signUpButton: UIButtonVariableBackgroundVariableCR?
    public var activeView: views = .login //change value to toggle between initially active view
    
    var loginScreenContentView: UIView?
    var emailPhoneNumberLabel: UILabel?
    var emailPhoneNumberTextField: UITextFieldWithPlaceholder_CR8?
    var passwordLabel: UILabel?
    var passwordTextField: UITextFieldWithPlaceholder_CR8?
    var forgotPasswordButton: UIButton?
    var loginContinueButton: UIButtonVariableBackgroundVariableCR?
    var loginContinueButtonBottomConstraint: NSLayoutConstraint?
    
    var signUpScreenContentView: UIView?
    var emailLabel: UILabel?
    var emailTextField: UITextFieldWithPlaceholder_CR8?
    var choosePasswordLabel: UILabel?
    var choosePasswordTextField: UITextFieldWithPlaceholder_CR8?
    var confirmPasswordLabel: UILabel?
    var confirmPasswordTextField: UITextFieldWithPlaceholder_CR8?
    var signupContinueButton: UIButtonVariableBackgroundVariableCR?
    var signupContinueButtonBottomConstraint: NSLayoutConstraint?
    
    
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
        
        
        //activate view according to initialized value
        (activeView == .login) ? loginButtonPressed() : signUpButtonPressed()
        
        // Do any additional setup after loading the view.
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
        
        signupContinueButton = UIButtonVariableBackgroundVariableCR()
        signupContinueButton?.initButton(title: "Continue", cornerRadius: 14, variant: .blueBack)
        signUpScreenContentView?.addSubview(signupContinueButton!)
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
        
        signupContinueButton?.topAnchor.constraint(equalTo: confirmPasswordTextField!.bottomAnchor, constant: 22).isActive = true
        signupContinueButton?.leadingAnchor.constraint(equalTo: confirmPasswordTextField!.leadingAnchor).isActive = true
        signupContinueButton?.trailingAnchor.constraint(equalTo: confirmPasswordTextField!.trailingAnchor).isActive = true
        signupContinueButton?.heightAnchor.constraint(equalToConstant: 56).isActive = true
        
        signupContinueButtonBottomConstraint = signupContinueButton?.bottomAnchor.constraint(equalTo: signUpScreenContentView!.bottomAnchor, constant: -10)
    }
    
    @objc func loginButtonPressed() {
        UIView.animate(withDuration: 0.2, delay: 0.0, options: UIView.AnimationOptions.transitionCurlUp, animations: {
            //change active button colors
            self.signUpButton?.initButton(title: "Signup", cornerRadius: 8, variant: .whiteBack)
            self.loginButton?.initButton(title: "Login", cornerRadius: 8, variant: .blueBack)
            
            //set active view opacity
            self.signUpScreenContentView?.alpha = 0
        }, completion: {
            (finished: Bool) -> Void in
            
            //Activate and deactivate constraints
            self.signupContinueButtonBottomConstraint?.isActive = false
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
            self.activeView = .signup
        })
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
