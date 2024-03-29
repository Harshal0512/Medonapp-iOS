//
//  LoginSignUpViewController.swift
//  Medonapp iOS
//
//  Created by Harshal Kulkarni on 19/09/22.
//

import UIKit
import CryptoKit
import SwiftValidator
import DPOTPView
import iOSDropDown
import Toast_Swift
import Localize_Swift

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
    let validator = Validator()
    var loginButton: UIButtonVariableBackgroundVariableCR?
    var signUpButton: UIButtonVariableBackgroundVariableCR?
    public var activeView: views = .signupInitialDetails
    var progressBar: UIProgressView?
    
    var loginScreenContentView: UIView?
    var emailLabelLogin: UILabel?
    var emailTextFieldLogin: UITextFieldWithPlaceholder_CR8?
    var passwordLabel: UILabel?
    var passwordTextField: UITextFieldWithPlaceholder_CR8?
    var loginPasswordHint: UILabel?
    var forgotPasswordButton: UIButton?
    var loginContinueButton: UIButtonVariableBackgroundVariableCR?
    var loginContinueButtonBottomConstraint: NSLayoutConstraint?
    
    
    var signUpScreenContentView: UIView?
    
    //initial details
    var emailLabelSignUp: UILabel?
    var emailTextFieldSignUp: UITextFieldWithPlaceholder_CR8?
    var emailAlreadyExistsLabel: UILabel?
    var choosePasswordLabel: UILabel?
    var choosePasswordTextField: UITextFieldWithPlaceholder_CR8?
    var passwordHint: UILabel?
    var confirmPasswordLabel: UILabel?
    var confirmPasswordTextField: UITextFieldWithPlaceholder_CR8?
    
    //personal details
    var firstNameLabel: UILabel?
    var firstNameField: UITextFieldWithPlaceholder_CR8?
    var lastNameLabel: UILabel?
    var lastNameField: UITextFieldWithPlaceholder_CR8?
    var dobLabel: UILabel?
    var dobPicker: UIDatePicker?
    var bloodGroupLabel: UILabel?
    var bloodGroupDropdown: DropDown?
    var weightLabel: UILabel?
    var weightField: UITextFieldWithPlaceholder_CR8?
    
    //address details
    var phoneNumberLabel: UILabel?
    var countryCodeLabel: UILabel?
    var phoneNumberField: UITextFieldWithPlaceholder_CR8?
    var addressLabel: UILabel?
    var addressTextView: UITextViewWithPlaceholder_CR8?
    var stateLabel: UILabel?
    var stateField: UITextFieldWithPlaceholder_CR8?
    var cityLabel: UILabel?
    var cityField: UITextFieldWithPlaceholder_CR8?
    
    //otp verification
    var otpDetailsLabel: UILabel?
    var txtOTPView: DPOTPView?
    var resendOtp: LinksLabel?
    var timer = Timer()
    private var otpFromServer: String = ""
    
    var signupContinueButton: UIButtonVariableBackgroundVariableCR?
    var progressBarTopConstraint: NSLayoutConstraint?
    var signupContinueButtonTopConstraint: NSLayoutConstraint?
    var signupContinueButtonBottomConstraint: NSLayoutConstraint?
    
    
    var activeTextField : UITextField? = nil
    
    var isValidationError = true
    
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
        
        
        //activate view accordingly
        loginButtonPressed()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if PrefDataManager.currentApplicationMode() == .testing {
            emailTextFieldLogin?.text = "patient1@test.com"
            passwordTextField?.text = "patient1Pass@123"
            emailTextFieldSignUp?.text = "harshal.kulkarni14@nmims.edu.in"
            choosePasswordTextField?.text = "patient1Pass@123"
            confirmPasswordTextField?.text = "patient1Pass@123"
            firstNameField?.text = "Harshal"
            lastNameField?.text = "Kulkarni"
            weightField?.text = "50"
            bloodGroupDropdown?.text = "O+"
            phoneNumberField?.text = "9999999999"
            addressTextView?.text = "Some Address"
            stateField?.text = "MP"
            cityField?.text = "Indore"
        }
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
        pageTitle?.text = "welcome_to_medonapp".localized()
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
        
        emailLabelLogin = UILabel()
        emailLabelLogin?.text = "email_phone_number".localized()
        emailLabelLogin?.textColor = .black
        emailLabelLogin?.font = UIFont(name: "NunitoSans-ExtraBold", size: 18)
        loginScreenContentView?.addSubview(emailLabelLogin!)
        
        emailTextFieldLogin = UITextFieldWithPlaceholder_CR8()
        emailTextFieldLogin?.delegate = self
        emailTextFieldLogin?.setPlaceholder(placeholder: "email_phone_number".localized())
        emailTextFieldLogin?.autocapitalizationType = .none
        emailTextFieldLogin?.autocorrectionType = .no
        emailTextFieldLogin?.keyboardType = .emailAddress
        loginScreenContentView?.addSubview(emailTextFieldLogin!)
        
        passwordLabel = UILabel()
        passwordLabel?.text = "password".localized()
        passwordLabel?.textColor = .black
        passwordLabel?.font = UIFont(name: "NunitoSans-ExtraBold", size: 18)
        loginScreenContentView?.addSubview(passwordLabel!)
        
        passwordTextField = UITextFieldWithPlaceholder_CR8()
        passwordTextField?.delegate = self
        passwordTextField?.setPlaceholder(placeholder: "password".localized())
        passwordTextField?.autocapitalizationType = .none
        passwordTextField?.autocorrectionType = .no
        passwordTextField?.keyboardType = .default
        passwordTextField?.isSecureTextEntry = true
        loginScreenContentView?.addSubview(passwordTextField!)
        
        loginPasswordHint = UILabel()
        loginPasswordHint?.text = "password_hint".localized()
        loginPasswordHint?.textColor = .lightGray
        loginPasswordHint?.font = UIFont(name: "NunitoSans-Bold", size: 11)
        loginPasswordHint?.numberOfLines = 0
        loginScreenContentView?.addSubview(loginPasswordHint!)
        
        forgotPasswordButton = UIButton()
        let forgotPasswordButtonAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: "NunitoSans-Bold", size: 14)!,
            .foregroundColor: UIColor(red: 0.48, green: 0.55, blue: 0.62, alpha: 1.00),
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        forgotPasswordButton?.setAttributedTitle(NSMutableAttributedString(
            string: "forgot_password".localized(),
            attributes: forgotPasswordButtonAttributes), for: .normal)
        forgotPasswordButton?.contentHorizontalAlignment = .leading
        loginScreenContentView?.addSubview(forgotPasswordButton!)
        
        loginContinueButton = UIButtonVariableBackgroundVariableCR()
        loginContinueButton?.initButton(title: "continue".localized(), cornerRadius: 14, variant: .blueBack)
        loginScreenContentView?.addSubview(loginContinueButton!)
        loginContinueButton?.addTarget(self, action: #selector(loginContinueButtonPressed), for: .touchUpInside)
        
        
        //MARK: Initializing variables for signup view
        
        emailLabelSignUp = UILabel()
        emailLabelSignUp?.text = "email".localized()
        emailLabelSignUp?.textColor = .black
        emailLabelSignUp?.font = UIFont(name: "NunitoSans-ExtraBold", size: 18)
        signUpScreenContentView?.addSubview(emailLabelSignUp!)
        
        emailTextFieldSignUp = UITextFieldWithPlaceholder_CR8()
        emailTextFieldSignUp?.name = "emailSignUp"
        emailTextFieldSignUp?.delegate = self
        emailTextFieldSignUp?.setPlaceholder(placeholder: "email".localized())
        emailTextFieldSignUp?.autocapitalizationType = .none
        emailTextFieldSignUp?.autocorrectionType = .no
        emailTextFieldSignUp?.keyboardType = .emailAddress
        signUpScreenContentView?.addSubview(emailTextFieldSignUp!)
        
        emailAlreadyExistsLabel = UILabel()
        emailAlreadyExistsLabel?.text = "email_exists".localized()
        emailAlreadyExistsLabel?.textColor = UIColor(red: 0.86, green: 0.24, blue: 0.00, alpha: 1.00)
        emailAlreadyExistsLabel?.font = UIFont(name: "NunitoSans-Bold", size: 11)
        emailAlreadyExistsLabel?.numberOfLines = 0
        emailAlreadyExistsLabel?.alpha = 0
        signUpScreenContentView?.addSubview(emailAlreadyExistsLabel!)
        
        choosePasswordLabel = UILabel()
        choosePasswordLabel?.text = "choose_password".localized()
        choosePasswordLabel?.textColor = .black
        choosePasswordLabel?.font = UIFont(name: "NunitoSans-ExtraBold", size: 18)
        signUpScreenContentView?.addSubview(choosePasswordLabel!)
        
        choosePasswordTextField = UITextFieldWithPlaceholder_CR8()
        choosePasswordTextField?.delegate = self
        choosePasswordTextField?.setPlaceholder(placeholder: "password".localized())
        choosePasswordTextField?.autocapitalizationType = .none
        choosePasswordTextField?.autocorrectionType = .no
        choosePasswordTextField?.keyboardType = .default
        choosePasswordTextField?.isSecureTextEntry = true
        signUpScreenContentView?.addSubview(choosePasswordTextField!)
        
        passwordHint = UILabel()
        passwordHint?.text = "password_hint".localized()
        passwordHint?.textColor = .lightGray
        passwordHint?.font = UIFont(name: "NunitoSans-Bold", size: 11)
        passwordHint?.numberOfLines = 0
        signUpScreenContentView?.addSubview(passwordHint!)
        
        confirmPasswordLabel = UILabel()
        confirmPasswordLabel?.text = "conf_password".localized()
        confirmPasswordLabel?.textColor = .black
        confirmPasswordLabel?.font = UIFont(name: "NunitoSans-ExtraBold", size: 18)
        signUpScreenContentView?.addSubview(confirmPasswordLabel!)
        
        confirmPasswordTextField = UITextFieldWithPlaceholder_CR8()
        confirmPasswordTextField?.delegate = self
        confirmPasswordTextField?.setPlaceholder(placeholder: "conf_password".localized())
        confirmPasswordTextField?.autocapitalizationType = .none
        confirmPasswordTextField?.autocorrectionType = .no
        confirmPasswordTextField?.keyboardType = .default
        confirmPasswordTextField?.isSecureTextEntry = true
        signUpScreenContentView?.addSubview(confirmPasswordTextField!)
        
        firstNameLabel = UILabel()
        firstNameLabel?.text = "first_name".localized()
        firstNameLabel?.textColor = .black
        firstNameLabel?.font = UIFont(name: "NunitoSans-ExtraBold", size: 18)
        signUpScreenContentView?.addSubview(firstNameLabel!)
        firstNameLabel?.alpha = 0
        
        firstNameField = UITextFieldWithPlaceholder_CR8()
        firstNameField?.delegate = self
        firstNameField?.setPlaceholder(placeholder: "first_name".localized())
        firstNameField?.autocapitalizationType = .words
        firstNameField?.autocorrectionType = .no
        firstNameField?.keyboardType = .default
        signUpScreenContentView?.addSubview(firstNameField!)
        firstNameField?.alpha = 0
        
        lastNameLabel = UILabel()
        lastNameLabel?.text = "last_name".localized()
        lastNameLabel?.textColor = .black
        lastNameLabel?.font = UIFont(name: "NunitoSans-ExtraBold", size: 18)
        signUpScreenContentView?.addSubview(lastNameLabel!)
        lastNameLabel?.alpha = 0
        
        lastNameField = UITextFieldWithPlaceholder_CR8()
        lastNameField?.delegate = self
        lastNameField?.setPlaceholder(placeholder: "last_name".localized())
        lastNameField?.autocapitalizationType = .words
        lastNameField?.autocorrectionType = .no
        lastNameField?.keyboardType = .default
        signUpScreenContentView?.addSubview(lastNameField!)
        lastNameField?.alpha = 0
        
        dobLabel = UILabel()
        dobLabel?.text = "dob".localized()
        dobLabel?.textColor = .black
        dobLabel?.font = UIFont(name: "NunitoSans-ExtraBold", size: 18)
        signUpScreenContentView?.addSubview(dobLabel!)
        dobLabel?.alpha = 0
        
        dobPicker = UIDatePicker()
        dobPicker?.datePickerMode = .date
        dobPicker?.preferredDatePickerStyle = .compact
        dobPicker?.set18YearValidation()
        //        dobPicker?.maximumDate = Calendar.current.date(byAdding: .hour, value: 1, to: Date())
        signUpScreenContentView?.addSubview(dobPicker!)
        dobPicker?.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        dobPicker?.alpha = 0
        
        bloodGroupLabel = UILabel()
        bloodGroupLabel?.text = "blood_group".localized()
        bloodGroupLabel?.textColor = .black
        bloodGroupLabel?.font = UIFont(name: "NunitoSans-ExtraBold", size: 18)
        signUpScreenContentView?.addSubview(bloodGroupLabel!)
        bloodGroupLabel?.alpha = 0
        
        bloodGroupDropdown = DropDown(frame: CGRect(x: 0, y: 0, width: 148, height: 61))
        bloodGroupDropdown?.optionArray = ["A+", "A-", "B+", "B-", "O+", "O-", "AB+", "AB-"]
        bloodGroupDropdown?.borderWidth = 1
        bloodGroupDropdown?.layer.cornerRadius = 10
        bloodGroupDropdown?.layer.borderColor = UIColor(red: 0.75, green: 0.79, blue: 0.85, alpha: 1.00).cgColor
        bloodGroupDropdown?.font = UIFont(name: "NunitoSans-Bold", size: 16)
        bloodGroupDropdown?.selectedIndex = 0
        bloodGroupDropdown?.selectedRowColor = .lightGray
        bloodGroupDropdown?.checkMarkEnabled = false
        bloodGroupDropdown?.isSearchEnable = false
        let paddingView = UIView(frame: CGRectMake(0, 0, 15, bloodGroupDropdown!.frame.height))
        bloodGroupDropdown?.leftView = paddingView
        bloodGroupDropdown?.leftViewMode = .always
        signUpScreenContentView?.addSubview(bloodGroupDropdown!)
        bloodGroupDropdown?.alpha = 0
        
        weightLabel = UILabel()
        weightLabel?.text = "weight_kg".localized()
        weightLabel?.textColor = .black
        weightLabel?.font = UIFont(name: "NunitoSans-ExtraBold", size: 18)
        signUpScreenContentView?.addSubview(weightLabel!)
        weightLabel?.alpha = 0
        
        weightField = UITextFieldWithPlaceholder_CR8()
        weightField?.delegate = self
        weightField?.setPlaceholder(placeholder: "weight_kg".localized())
        weightField?.autocapitalizationType = .none
        weightField?.autocorrectionType = .no
        weightField?.keyboardType = .decimalPad
        signUpScreenContentView?.addSubview(weightField!)
        weightField?.alpha = 0
        
        phoneNumberLabel = UILabel()
        phoneNumberLabel?.text = "phone_number".localized()
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
        phoneNumberField?.setPlaceholder(placeholder: "phone_number".localized())
        phoneNumberField?.autocapitalizationType = .none
        phoneNumberField?.autocorrectionType = .no
        phoneNumberField?.keyboardType = .numberPad
        phoneNumberField?.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        signUpScreenContentView?.addSubview(phoneNumberField!)
        phoneNumberField?.alpha = 0
        
        addressLabel = UILabel()
        addressLabel?.text = "address".localized()
        addressLabel?.textColor = .black
        addressLabel?.font = UIFont(name: "NunitoSans-ExtraBold", size: 18)
        signUpScreenContentView?.addSubview(addressLabel!)
        addressLabel?.alpha = 0
        
        addressTextView = UITextViewWithPlaceholder_CR8()
        addressTextView?.autocapitalizationType = .words
        addressTextView?.autocorrectionType = .no
        addressTextView?.keyboardType = .default
        signUpScreenContentView?.addSubview(addressTextView!)
        addressTextView?.alpha = 0
        
        stateLabel = UILabel()
        stateLabel?.text = "state".localized()
        stateLabel?.textColor = .black
        stateLabel?.font = UIFont(name: "NunitoSans-ExtraBold", size: 18)
        signUpScreenContentView?.addSubview(stateLabel!)
        stateLabel?.alpha = 0
        
        stateField = UITextFieldWithPlaceholder_CR8()
        stateField?.delegate = self
        stateField?.setPlaceholder(placeholder: "state".localized())
        stateField?.autocapitalizationType = .words
        stateField?.autocorrectionType = .no
        stateField?.keyboardType = .default
        signUpScreenContentView?.addSubview(stateField!)
        stateField?.alpha = 0
        
        cityLabel = UILabel()
        cityLabel?.text = "city".localized()
        cityLabel?.textColor = .black
        cityLabel?.font = UIFont(name: "NunitoSans-ExtraBold", size: 18)
        signUpScreenContentView?.addSubview(cityLabel!)
        cityLabel?.alpha = 0
        
        cityField = UITextFieldWithPlaceholder_CR8()
        cityField?.delegate = self
        cityField?.setPlaceholder(placeholder: "city".localized())
        cityField?.autocapitalizationType = .words
        cityField?.autocorrectionType = .no
        cityField?.keyboardType = .default
        signUpScreenContentView?.addSubview(cityField!)
        cityField?.alpha = 0
        
        otpDetailsLabel = UILabel()
        otpDetailsLabel?.text = "enter_otp".localized()
        otpDetailsLabel?.textColor = .black
        otpDetailsLabel?.numberOfLines = 0
        otpDetailsLabel?.font = UIFont(name: "NunitoSans-ExtraBold", size: 18)
        signUpScreenContentView?.addSubview(otpDetailsLabel!)
        otpDetailsLabel?.alpha = 0
        
        txtOTPView = DPOTPView()
        txtOTPView?.placeholder = "...."
        txtOTPView?.dpOTPViewDelegate = self
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
        
        resendOtp = LinksLabel()
        resendOtp?.font = UIFont(name: "NunitoSans-Bold", size: CGFloat(15.0))!
        resendOtp?.textAlignment = .center
        resendOtp?.numberOfLines = 0
        resendOtp?.alpha = 0
        signUpScreenContentView?.addSubview(resendOtp!)
        
        progressBar = UIProgressView(progressViewStyle: .default)
        progressBar?.progress = 0.25
        progressBar?.progressTintColor = UIColor(red: 0.11, green: 0.42, blue: 0.64, alpha: 1.00)
        progressBar?.trackTintColor = UIColor(red: 0.75, green: 0.79, blue: 0.85, alpha: 1.00)
        signUpScreenContentView?.addSubview(progressBar!)
        
        signupContinueButton = UIButtonVariableBackgroundVariableCR()
        signupContinueButton?.initButton(title: "continue".localized(), cornerRadius: 14, variant: .blueBack)
        signUpScreenContentView?.addSubview(signupContinueButton!)
        signupContinueButton?.addTarget(self, action: #selector(signUpContinueButtonPressed), for: .touchUpInside)
    }
    
    
    private func setConstraints() {
        scrollView?.translatesAutoresizingMaskIntoConstraints = false
        pageTitle?.translatesAutoresizingMaskIntoConstraints = false
        loginButton?.translatesAutoresizingMaskIntoConstraints = false
        signUpButton?.translatesAutoresizingMaskIntoConstraints = false
        
        loginScreenContentView?.translatesAutoresizingMaskIntoConstraints = false
        emailLabelLogin?.translatesAutoresizingMaskIntoConstraints = false
        emailTextFieldLogin?.translatesAutoresizingMaskIntoConstraints = false
        passwordLabel?.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField?.translatesAutoresizingMaskIntoConstraints = false
        loginPasswordHint?.translatesAutoresizingMaskIntoConstraints = false
        forgotPasswordButton?.translatesAutoresizingMaskIntoConstraints = false
        loginContinueButton?.translatesAutoresizingMaskIntoConstraints = false
        
        
        signUpScreenContentView?.translatesAutoresizingMaskIntoConstraints = false
        emailLabelSignUp?.translatesAutoresizingMaskIntoConstraints = false
        emailTextFieldSignUp?.translatesAutoresizingMaskIntoConstraints = false
        emailAlreadyExistsLabel?.translatesAutoresizingMaskIntoConstraints = false
        choosePasswordLabel?.translatesAutoresizingMaskIntoConstraints = false
        choosePasswordTextField?.translatesAutoresizingMaskIntoConstraints = false
        confirmPasswordLabel?.translatesAutoresizingMaskIntoConstraints = false
        confirmPasswordTextField?.translatesAutoresizingMaskIntoConstraints = false
        passwordHint?.translatesAutoresizingMaskIntoConstraints = false
        
        firstNameLabel?.translatesAutoresizingMaskIntoConstraints = false
        firstNameField?.translatesAutoresizingMaskIntoConstraints = false
        lastNameLabel?.translatesAutoresizingMaskIntoConstraints = false
        lastNameField?.translatesAutoresizingMaskIntoConstraints = false
        dobLabel?.translatesAutoresizingMaskIntoConstraints = false
        dobPicker?.translatesAutoresizingMaskIntoConstraints = false
        bloodGroupLabel?.translatesAutoresizingMaskIntoConstraints = false
        bloodGroupDropdown?.translatesAutoresizingMaskIntoConstraints = false
        weightLabel?.translatesAutoresizingMaskIntoConstraints = false
        weightField?.translatesAutoresizingMaskIntoConstraints = false
        
        phoneNumberLabel?.translatesAutoresizingMaskIntoConstraints = false
        countryCodeLabel?.translatesAutoresizingMaskIntoConstraints = false
        phoneNumberField?.translatesAutoresizingMaskIntoConstraints = false
        addressLabel?.translatesAutoresizingMaskIntoConstraints = false
        addressTextView?.translatesAutoresizingMaskIntoConstraints = false
        stateLabel?.translatesAutoresizingMaskIntoConstraints = false
        stateField?.translatesAutoresizingMaskIntoConstraints = false
        cityLabel?.translatesAutoresizingMaskIntoConstraints = false
        cityField?.translatesAutoresizingMaskIntoConstraints = false
        
        otpDetailsLabel?.translatesAutoresizingMaskIntoConstraints = false
        txtOTPView?.translatesAutoresizingMaskIntoConstraints = false
        resendOtp?.translatesAutoresizingMaskIntoConstraints = false
        
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
        emailLabelLogin?.topAnchor.constraint(equalTo: loginButton!.bottomAnchor, constant: 22).isActive = true
        emailLabelLogin?.leadingAnchor.constraint(equalTo: loginScreenContentView!.leadingAnchor, constant: 28).isActive = true
        emailLabelLogin?.trailingAnchor.constraint(equalTo: loginScreenContentView!.trailingAnchor, constant: -28).isActive = true
        
        emailTextFieldLogin?.topAnchor.constraint(equalTo: emailLabelLogin!.bottomAnchor, constant: 5).isActive = true
        emailTextFieldLogin?.leadingAnchor.constraint(equalTo: loginScreenContentView!.leadingAnchor, constant: 28).isActive = true
        emailTextFieldLogin?.trailingAnchor.constraint(equalTo: loginScreenContentView!.trailingAnchor, constant: -28).isActive = true
        emailTextFieldLogin?.heightAnchor.constraint(equalToConstant: 61).isActive = true
        
        passwordLabel?.topAnchor.constraint(equalTo: emailTextFieldLogin!.bottomAnchor, constant: 15).isActive = true
        passwordLabel?.leadingAnchor.constraint(equalTo: emailLabelLogin!.leadingAnchor).isActive = true
        passwordLabel?.trailingAnchor.constraint(equalTo: emailLabelLogin!.trailingAnchor).isActive = true
        
        passwordTextField?.topAnchor.constraint(equalTo: passwordLabel!.bottomAnchor, constant: 5).isActive = true
        passwordTextField?.leadingAnchor.constraint(equalTo: emailTextFieldLogin!.leadingAnchor).isActive = true
        passwordTextField?.trailingAnchor.constraint(equalTo: emailTextFieldLogin!.trailingAnchor).isActive = true
        passwordTextField?.widthAnchor.constraint(equalTo: emailTextFieldLogin!.widthAnchor).isActive = true
        passwordTextField?.heightAnchor.constraint(equalTo: emailTextFieldLogin!.heightAnchor).isActive = true
        
        loginPasswordHint?.topAnchor.constraint(equalTo: passwordTextField!.bottomAnchor, constant: 5).isActive = true
        loginPasswordHint?.leadingAnchor.constraint(equalTo: emailTextFieldLogin!.leadingAnchor, constant: 5).isActive = true
        loginPasswordHint?.trailingAnchor.constraint(equalTo: emailTextFieldLogin!.trailingAnchor, constant: -5).isActive = true
        
        forgotPasswordButton?.topAnchor.constraint(equalTo: loginPasswordHint!.bottomAnchor, constant: 10).isActive = true
        forgotPasswordButton?.leadingAnchor.constraint(equalTo: emailTextFieldLogin!.leadingAnchor).isActive = true
        forgotPasswordButton?.trailingAnchor.constraint(equalTo: emailTextFieldLogin!.trailingAnchor).isActive = true
        
        loginContinueButton?.topAnchor.constraint(equalTo: forgotPasswordButton!.bottomAnchor, constant: 25).isActive = true
        
        loginContinueButton?.leadingAnchor.constraint(equalTo: emailTextFieldLogin!.leadingAnchor).isActive = true
        loginContinueButton?.trailingAnchor.constraint(equalTo: emailTextFieldLogin!.trailingAnchor).isActive = true
        loginContinueButton?.heightAnchor.constraint(equalToConstant: 56).isActive = true
        
        loginContinueButtonBottomConstraint = loginContinueButton?.bottomAnchor.constraint(equalTo: loginScreenContentView!.bottomAnchor, constant: -10)
        
        
        
        //MARK: Constraints for signup view
        
        initializeAndActivateViewConstraints(view: .signupInitialDetails)
        
        progressBar?.leadingAnchor.constraint(equalTo: emailTextFieldSignUp!.leadingAnchor).isActive = true
        progressBar?.trailingAnchor.constraint(equalTo: emailTextFieldSignUp!.trailingAnchor).isActive = true
        progressBar?.widthAnchor.constraint(equalTo: emailTextFieldSignUp!.widthAnchor).isActive = true
        progressBar?.heightAnchor.constraint(equalToConstant: 5).isActive = true
        
        signupContinueButton?.topAnchor.constraint(equalTo: progressBar!.bottomAnchor, constant: 22).isActive = true
        signupContinueButton?.leadingAnchor.constraint(equalTo: confirmPasswordTextField!.leadingAnchor).isActive = true
        signupContinueButton?.trailingAnchor.constraint(equalTo: confirmPasswordTextField!.trailingAnchor).isActive = true
        signupContinueButton?.heightAnchor.constraint(equalToConstant: 56).isActive = true
        
        signupContinueButtonBottomConstraint = signupContinueButton?.bottomAnchor.constraint(equalTo: signUpScreenContentView!.bottomAnchor, constant: -10)
    }
    
    @objc func loginButtonPressed() {
        if activeView == .login {
            return
        }

        UIView.animate(withDuration: 0.2, delay: 0.0, options: UIView.AnimationOptions.transitionCurlUp, animations: {
            //change active button colors
            self.signUpButton?.initButton(title: "signup".localized(), cornerRadius: 8, variant: .whiteBack)
            self.loginButton?.initButton(title: "login".localized(), cornerRadius: 8, variant: .blueBack)
            
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
        
        validator.unregisterField(emailTextFieldSignUp!)
        validator.unregisterField(choosePasswordTextField!)
        validator.unregisterField(confirmPasswordTextField!)
        validator.unregisterField(firstNameField!)
        validator.unregisterField(lastNameField!)
        validator.unregisterField(weightField!)
        validator.unregisterField(phoneNumberField!)
        validator.unregisterField(addressTextView!)
        validator.unregisterField(stateField!)
        validator.unregisterField(cityField!)
        
        validator.registerField(emailTextFieldLogin!, rules: [RequiredRule(), EmailRule()])
        validator.registerField(passwordTextField!, rules: [RequiredRule(), PasswordRule()])
    }
    
    @objc func signUpButtonPressed() {
        if activeView == .signupInitialDetails {
            return
        }
        
        if let presentationController = presentationController as? UISheetPresentationController {
            presentationController.animateChanges {
                presentationController.selectedDetentIdentifier = .large
            }
        }
        UIView.animate(withDuration: 0.2, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {
            //change active button colors
            self.loginButton?.initButton(title: "login".localized(), cornerRadius: 8, variant: .whiteBack)
            self.signUpButton?.initButton(title: "signup".localized(), cornerRadius: 8, variant: .blueBack)
            
            self.signupContinueButton?.isDisabled = true
            
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
        
        validator.unregisterField(emailTextFieldLogin!)
        validator.unregisterField(passwordTextField!)
        
        validator.registerField(emailTextFieldSignUp!, rules: [RequiredRule(), EmailRule()])
        validator.registerField(choosePasswordTextField!, rules: [RequiredRule(), PasswordRule()])
        validator.registerField(confirmPasswordTextField!, rules: [RequiredRule(), ConfirmationRule(confirmField: choosePasswordTextField!)])
    }
    
    @objc func loginContinueButtonPressed() {
        clearAllErrors()
        validator.validate(self)
        if !isValidationError {
            self.view.hideAllToasts()
            self.view.makeToastActivity(.center)
            let hashedPassword = SHA512.hash(data: Data(passwordTextField!.trim().utf8))
            APIService(data: ["username": emailTextFieldLogin!.trim(),
                              "password": hashedPassword.compactMap { String(format: "%02x", $0) }.joined(),
                              "isDoctor": false],
                       url: nil,
                       service: .login,
                       method: .post,
                       isJSONRequest: true).executeQuery() { (result: Result<User, Error>) in
                switch result{
                case .success:
                    try? User.setUserDetails(userDetails: result.get())
                    self.view.hideToastActivity()
                    UIView.animate(withDuration: 0.2, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, animations: {
                        self.dismiss(animated: true) {
                            NotificationCenter.default.post(name: Notification.Name("goToDashboard"), object: nil)
                        }
                    }, completion: nil)
                case .failure(let error):
                    print(error)
                    self.view.hideToastActivity()
                    Utils.displaySPIndicatorNotifWithMessage(title: "incorrect_details".localized(), message: "enter_correct_credentials".localized(), iconPreset: .error, hapticPreset: .error, duration: 6)
                }
            }
        }
    }
    
    @objc func signUpContinueButtonPressed() {
        clearAllErrors()
        validator.validate(self)
        
        if !isValidationError && activeView == .signupInitialDetails {
            UIView.animate(withDuration: 0.2, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {
                self.pageTitle?.alpha = 0
                self.loginButton?.alpha = 0
                self.signUpButton?.alpha = 0
                self.emailLabelSignUp?.alpha = 0
                self.emailTextFieldSignUp?.alpha = 0
                self.emailAlreadyExistsLabel?.alpha = 0
                self.choosePasswordLabel?.alpha = 0
                self.choosePasswordTextField?.alpha = 0
                self.confirmPasswordLabel?.alpha = 0
                self.confirmPasswordTextField?.alpha = 0
                self.passwordHint?.alpha = 0
            }, completion: {
                (finished: Bool) -> Void in
                self.pageTitle?.text = "enter_details".localized()
                UIView.animate(withDuration: 0.2, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, animations: {
                    self.pageTitle?.alpha = 1
                    self.initializeAndActivateViewConstraints(view: .signupPersonalDetails)
                    self.progressBar?.setProgress(0.50, animated: true)
                    self.signupContinueButton?.isDisabled = true
                }, completion: nil)
            })
            
            validator.unregisterField(emailTextFieldSignUp!)
            validator.unregisterField(choosePasswordTextField!)
            validator.unregisterField(confirmPasswordTextField!)
            
            validator.registerField(firstNameField!, rules: [RequiredRule()])
            validator.registerField(lastNameField!, rules: [RequiredRule()])
            validator.registerField(weightField!, rules: [RequiredRule(), FloatRule()])
        } else if !isValidationError && activeView == .signupPersonalDetails {
            if Double((self.weightField?.text)!)! <= 0.0 || Double((self.weightField?.text)!)! > 1000.0 {
                Utils.displaySPIndicatorNotifWithMessage(title: "incorrect_details".localized(), message: "enter_valid_weight".localized(), iconPreset: .error, hapticPreset: .error, duration: 6)
                return
            }
            UIView.animate(withDuration: 0.2, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {
                self.firstNameLabel?.alpha = 0
                self.firstNameField?.alpha = 0
                self.lastNameLabel?.alpha = 0
                self.lastNameField?.alpha = 0
                self.dobLabel?.alpha = 0
                self.dobPicker?.alpha = 0
                self.bloodGroupLabel?.alpha = 0
                self.bloodGroupDropdown?.alpha = 0
                self.weightLabel?.alpha = 0
                self.weightField?.alpha = 0
            }, completion: {
                (finished: Bool) -> Void in
                UIView.animate(withDuration: 0.2, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, animations: {
                    self.initializeAndActivateViewConstraints(view: .signupAddressDetails)
                    self.progressBar?.setProgress(0.75, animated: true)
                    self.signupContinueButton?.isDisabled = true
                }, completion: nil)
            })
            
            validator.unregisterField(firstNameField!)
            validator.unregisterField(lastNameField!)
            validator.unregisterField(weightField!)
            
            validator.registerField(phoneNumberField!, rules: [RequiredRule(), ExactLengthRule(length: 10)])
            validator.registerField(addressTextView!, rules: [RequiredRule()])
            validator.registerField(stateField!, rules: [RequiredRule()])
            validator.registerField(cityField!, rules: [RequiredRule()])
        } else if !isValidationError && activeView == .signupAddressDetails {
            UIView.animate(withDuration: 0.2, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {
                self.pageTitle?.alpha = 0
                self.phoneNumberLabel?.alpha = 0
                self.countryCodeLabel?.alpha = 0
                self.phoneNumberField?.alpha = 0
                self.addressLabel?.alpha = 0
                self.addressTextView?.alpha = 0
                self.stateLabel?.alpha = 0
                self.stateField?.alpha = 0
                self.cityLabel?.alpha = 0
                self.cityField?.alpha = 0
                self.signupContinueButton?.alpha = 0
            }, completion: {
                (finished: Bool) -> Void in
                self.pageTitle?.text = "all_set".localized()
                UIView.animate(withDuration: 0.2, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, animations: {
                    self.pageTitle?.alpha = 1
                    self.initializeAndActivateViewConstraints(view: .signupOtpVerification)
                    self.progressBar?.setProgress(0.87, animated: true)
                }, completion: nil)
            })
            
            validator.unregisterField(phoneNumberField!)
            validator.unregisterField(addressTextView!)
            validator.unregisterField(stateField!)
            validator.unregisterField(cityField!)
        }
        
    }
    
    func initializeAndActivateViewConstraints(view: views) {
        switch view {
        case .login:
            break
        case .signupInitialDetails:
            emailLabelSignUp?.topAnchor.constraint(equalTo: loginButton!.bottomAnchor, constant: 22).isActive = true
            emailLabelSignUp?.leadingAnchor.constraint(equalTo: signUpScreenContentView!.leadingAnchor, constant: 28).isActive = true
            emailLabelSignUp?.trailingAnchor.constraint(equalTo: signUpScreenContentView!.trailingAnchor, constant: -28).isActive = true
            
            emailTextFieldSignUp?.topAnchor.constraint(equalTo: emailLabelSignUp!.bottomAnchor, constant: 5).isActive = true
            emailTextFieldSignUp?.leadingAnchor.constraint(equalTo: signUpScreenContentView!.leadingAnchor, constant: 28).isActive = true
            emailTextFieldSignUp?.trailingAnchor.constraint(equalTo: signUpScreenContentView!.trailingAnchor, constant: -28).isActive = true
            emailTextFieldSignUp?.heightAnchor.constraint(equalToConstant: 61).isActive = true
            
            emailAlreadyExistsLabel?.topAnchor.constraint(equalTo: emailTextFieldSignUp!.bottomAnchor, constant: 5).isActive = true
            emailAlreadyExistsLabel?.leadingAnchor.constraint(equalTo: emailTextFieldSignUp!.leadingAnchor, constant: 5).isActive = true
            emailAlreadyExistsLabel?.trailingAnchor.constraint(equalTo: emailTextFieldSignUp!.trailingAnchor, constant: -5).isActive = true
            
            choosePasswordLabel?.topAnchor.constraint(equalTo: emailAlreadyExistsLabel!.bottomAnchor, constant: 10).isActive = true
            choosePasswordLabel?.leadingAnchor.constraint(equalTo: emailLabelSignUp!.leadingAnchor).isActive = true
            choosePasswordLabel?.trailingAnchor.constraint(equalTo: emailLabelSignUp!.trailingAnchor).isActive = true
            
            choosePasswordTextField?.topAnchor.constraint(equalTo: choosePasswordLabel!.bottomAnchor, constant: 5).isActive = true
            choosePasswordTextField?.leadingAnchor.constraint(equalTo: emailTextFieldSignUp!.leadingAnchor).isActive = true
            choosePasswordTextField?.trailingAnchor.constraint(equalTo: emailTextFieldSignUp!.trailingAnchor).isActive = true
            choosePasswordTextField?.widthAnchor.constraint(equalTo: emailTextFieldSignUp!.widthAnchor).isActive = true
            choosePasswordTextField?.heightAnchor.constraint(equalTo: emailTextFieldSignUp!.heightAnchor).isActive = true
            
            passwordHint?.topAnchor.constraint(equalTo: choosePasswordTextField!.bottomAnchor, constant: 5).isActive = true
            passwordHint?.leadingAnchor.constraint(equalTo: emailTextFieldSignUp!.leadingAnchor, constant: 5).isActive = true
            passwordHint?.trailingAnchor.constraint(equalTo: emailTextFieldSignUp!.trailingAnchor, constant: -5).isActive = true
            
            confirmPasswordLabel?.topAnchor.constraint(equalTo: passwordHint!.bottomAnchor, constant: 15).isActive = true
            confirmPasswordLabel?.leadingAnchor.constraint(equalTo: emailLabelSignUp!.leadingAnchor).isActive = true
            confirmPasswordLabel?.trailingAnchor.constraint(equalTo: emailLabelSignUp!.trailingAnchor).isActive = true
            
            confirmPasswordTextField?.topAnchor.constraint(equalTo: confirmPasswordLabel!.bottomAnchor, constant: 5).isActive = true
            confirmPasswordTextField?.leadingAnchor.constraint(equalTo: emailTextFieldSignUp!.leadingAnchor).isActive = true
            confirmPasswordTextField?.trailingAnchor.constraint(equalTo: emailTextFieldSignUp!.trailingAnchor).isActive = true
            confirmPasswordTextField?.widthAnchor.constraint(equalTo: emailTextFieldSignUp!.widthAnchor).isActive = true
            confirmPasswordTextField?.heightAnchor.constraint(equalTo: emailTextFieldSignUp!.heightAnchor).isActive = true
            
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
            
            dobLabel?.topAnchor.constraint(equalTo: lastNameField!.bottomAnchor, constant: 22).isActive = true
            dobLabel?.leadingAnchor.constraint(equalTo: signUpScreenContentView!.leadingAnchor, constant: 28).isActive = true
            dobLabel?.trailingAnchor.constraint(equalTo: signUpScreenContentView!.trailingAnchor, constant: -28).isActive = true
            
            dobPicker?.topAnchor.constraint(equalTo: dobLabel!.bottomAnchor, constant: 5).isActive = true
            dobPicker?.leadingAnchor.constraint(equalTo: signUpScreenContentView!.leadingAnchor, constant: 28).isActive = true
            dobPicker?.widthAnchor.constraint(equalToConstant: 130).isActive = true
            dobPicker?.heightAnchor.constraint(equalToConstant: 61).isActive = true
            
            bloodGroupLabel?.topAnchor.constraint(equalTo: dobPicker!.bottomAnchor, constant: 15).isActive = true
            bloodGroupLabel?.leadingAnchor.constraint(equalTo: signUpScreenContentView!.leadingAnchor, constant: 28).isActive = true
            
            bloodGroupDropdown?.topAnchor.constraint(equalTo: bloodGroupLabel!.bottomAnchor, constant: 5).isActive = true
            bloodGroupDropdown?.leadingAnchor.constraint(equalTo: signUpScreenContentView!.leadingAnchor, constant: 28).isActive = true
            bloodGroupDropdown?.widthAnchor.constraint(equalToConstant: 148).isActive = true
            bloodGroupDropdown?.heightAnchor.constraint(equalToConstant: 61).isActive = true
            
            weightLabel?.topAnchor.constraint(equalTo: bloodGroupLabel!.topAnchor).isActive = true
            weightLabel?.trailingAnchor.constraint(equalTo: signUpScreenContentView!.trailingAnchor, constant: -28).isActive = true
            
            weightField?.topAnchor.constraint(equalTo: weightLabel!.bottomAnchor, constant: 5).isActive = true
            weightField?.trailingAnchor.constraint(equalTo: signUpScreenContentView!.trailingAnchor, constant: -28).isActive = true
            weightField?.widthAnchor.constraint(equalToConstant: 148).isActive = true
            weightField?.heightAnchor.constraint(equalToConstant: 61).isActive = true
            weightField?.leadingAnchor.constraint(greaterThanOrEqualTo: bloodGroupDropdown!.trailingAnchor, constant: 10).isActive = true
            
            weightLabel?.leadingAnchor.constraint(equalTo: weightField!.leadingAnchor).isActive = true
            bloodGroupLabel?.trailingAnchor.constraint(equalTo: weightLabel!.leadingAnchor, constant: -10).isActive = true
            
            firstNameLabel?.alpha = 1
            firstNameField?.alpha = 1
            lastNameLabel?.alpha = 1
            lastNameField?.alpha = 1
            dobLabel?.alpha = 1
            dobPicker?.alpha = 1
            bloodGroupLabel?.alpha = 1
            bloodGroupDropdown?.alpha = 1
            weightLabel?.alpha = 1
            weightField?.alpha = 1
            
            progressBarTopConstraint?.isActive = false
            progressBarTopConstraint = progressBar?.topAnchor.constraint(equalTo: bloodGroupDropdown!.bottomAnchor, constant: 29)
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
            
            addressLabel?.topAnchor.constraint(equalTo: phoneNumberField!.bottomAnchor, constant: 22).isActive = true
            addressLabel?.leadingAnchor.constraint(equalTo: signUpScreenContentView!.leadingAnchor, constant: 28).isActive = true
            addressLabel?.trailingAnchor.constraint(equalTo: signUpScreenContentView!.trailingAnchor, constant: -28).isActive = true
            
            addressTextView?.topAnchor.constraint(equalTo: addressLabel!.bottomAnchor, constant: 7).isActive = true
            addressTextView?.leadingAnchor.constraint(equalTo: signUpScreenContentView!.leadingAnchor, constant: 28).isActive = true
            addressTextView?.trailingAnchor.constraint(equalTo: signUpScreenContentView!.trailingAnchor, constant: -28).isActive = true
            addressTextView?.heightAnchor.constraint(equalToConstant: 150).isActive = true
            
            stateLabel?.topAnchor.constraint(equalTo: addressTextView!.bottomAnchor, constant: 15).isActive = true
            stateLabel?.leadingAnchor.constraint(equalTo: signUpScreenContentView!.leadingAnchor, constant: 28).isActive = true
            
            stateField?.topAnchor.constraint(equalTo: stateLabel!.bottomAnchor, constant: 5).isActive = true
            stateField?.leadingAnchor.constraint(equalTo: signUpScreenContentView!.leadingAnchor, constant: 28).isActive = true
            stateField?.widthAnchor.constraint(equalToConstant: 148).isActive = true
            stateField?.heightAnchor.constraint(equalToConstant: 61).isActive = true
            
            cityLabel?.topAnchor.constraint(equalTo: stateLabel!.topAnchor).isActive = true
            cityLabel?.trailingAnchor.constraint(equalTo: signUpScreenContentView!.trailingAnchor, constant: -28).isActive = true
            
            cityField?.topAnchor.constraint(equalTo: cityLabel!.bottomAnchor, constant: 5).isActive = true
            cityField?.trailingAnchor.constraint(equalTo: signUpScreenContentView!.trailingAnchor, constant: -28).isActive = true
            cityField?.widthAnchor.constraint(equalToConstant: 148).isActive = true
            cityField?.heightAnchor.constraint(equalToConstant: 61).isActive = true
            cityField?.leadingAnchor.constraint(greaterThanOrEqualTo: stateField!.trailingAnchor, constant: 10).isActive = true
            
            cityLabel?.leadingAnchor.constraint(equalTo: cityField!.leadingAnchor).isActive = true
            stateLabel?.trailingAnchor.constraint(equalTo: cityLabel!.leadingAnchor, constant: -10).isActive = true
            
            phoneNumberLabel?.alpha = 1
            countryCodeLabel?.alpha = 1
            phoneNumberField?.alpha = 1
            addressLabel?.alpha = 1
            addressTextView?.alpha = 1
            stateLabel?.alpha = 1
            stateField?.alpha = 1
            cityLabel?.alpha = 1
            cityField?.alpha = 1
            
            progressBarTopConstraint?.isActive = false
            progressBarTopConstraint = progressBar?.topAnchor.constraint(equalTo: stateField!.bottomAnchor, constant: 29)
            progressBarTopConstraint?.isActive = true
            
            self.activeView = .signupAddressDetails
            break
        case .signupOtpVerification:
            otpDetailsLabel?.topAnchor.constraint(equalTo: pageTitle!.bottomAnchor, constant: 22).isActive = true
            otpDetailsLabel?.leadingAnchor.constraint(equalTo: signUpScreenContentView!.leadingAnchor, constant: 28).isActive = true
            otpDetailsLabel?.trailingAnchor.constraint(equalTo: signUpScreenContentView!.trailingAnchor, constant: -28).isActive = true
            otpDetailsLabel?.heightAnchor.constraint(equalToConstant: 90).isActive = true
            otpDetailsLabel?.text = "enter_otp".localized() + " \(Utils.getObscuredEmail(email: emailTextFieldSignUp!.text!))"
            
            txtOTPView?.topAnchor.constraint(equalTo: otpDetailsLabel!.bottomAnchor, constant: 28).isActive = true
            txtOTPView?.leadingAnchor.constraint(equalTo: signUpScreenContentView!.leadingAnchor, constant: 28).isActive = true
            txtOTPView?.trailingAnchor.constraint(equalTo: signUpScreenContentView!.trailingAnchor, constant: -28).isActive = true
            txtOTPView?.centerXAnchor.constraint(equalTo: signUpScreenContentView!.centerXAnchor).isActive = true
            txtOTPView?.heightAnchor.constraint(equalToConstant: 60).isActive = true
            
            resendOtp?.topAnchor.constraint(equalTo: txtOTPView!.bottomAnchor, constant: 50).isActive = true
            resendOtp?.leadingAnchor.constraint(equalTo: signUpScreenContentView!.leadingAnchor, constant: 28).isActive = true
            resendOtp?.trailingAnchor.constraint(equalTo: signUpScreenContentView!.trailingAnchor, constant: -28).isActive = true
            
            otpDetailsLabel?.alpha = 1
            txtOTPView?.alpha = 1
            resendOtp?.alpha = 1
            
            progressBarTopConstraint?.isActive = false
            progressBarTopConstraint = progressBar?.topAnchor.constraint(equalTo: resendOtp!.bottomAnchor, constant: 40)
            progressBarTopConstraint?.isActive = true
            
            self.activeView = .signupOtpVerification
            
            sendOTP()
            
            break
        }
    }
    var counter = 0
    
    @objc func timerAction() {
        if counter < 1 {
            timer.invalidate()
            let mainString = "didnt_receive".localized()
            let stringOne = "resend_otp".localized()
            
            var range = (mainString as NSString).range(of: stringOne)
            let temp = NSMutableAttributedString.init(string: mainString)
            temp.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(red: 0.00, green: 0.75, blue: 1.00, alpha: 1.00), range: range)
            //        resendOtp?.setAttribute(link: Constants.BASE_SERVER_HOST + "/site/cc_terms.html", range: range)
            
            resendOtp?.attributedText = temp
            resendOtp?.alpha = 1
            resendOtp?.isUserInteractionEnabled = true
            resendOtp?.isTappable = true
            resendOtp?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(sendOTP)))
        } else {
            counter -= 1
            resendOtp?.alpha = 0.4
            resendOtp?.text = String(format: NSLocalizedString("resend_in_secs %@", comment: ""), "\(counter)")
            resendOtp?.isUserInteractionEnabled = false
            resendOtp?.isTappable = false
        }
    }
    
    @objc func sendOTP() {
        self.view.isUserInteractionEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.view.makeToastActivity(.center)
        }
        APIService(data: ["username": emailTextFieldSignUp!.trim(), "password": ""], url: nil, service: .sendOtp, method: .post, isJSONRequest: true).executeQuery() { (result: Result<Int, Error>) in
            switch result{
            case .success(_):
                try? print(result.get())
                try? self.otpFromServer = "\(result.get())"
                Utils.displaySPIndicatorNotifWithMessage(title: "otp_sent".localized(), message: "otp_sent_successfully".localized(), iconPreset: .done, hapticPreset: .success, duration: 6)
                
                self.timer.invalidate() // just in case this button is tapped multiple times
                self.counter = 30
                
                // start the timer
                self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.timerAction), userInfo: nil, repeats: true)
            case .failure(let error):
                print(error)
            }
            self.view.hideToastActivity()
            self.view.isUserInteractionEnabled = true
        }
    }
    
    func checkEmailExists() {
        APIService(data: ["username": emailTextFieldSignUp!.trim(), "isDoctor": false], url: nil, service: .checkEmailExists, method: .post, isJSONRequest: true).executeQuery() { (result: Result<Bool, Error>) in
            var emailAlreadyExists = true
            
            switch result{
            case .success(_):
                try? emailAlreadyExists = result.get()
            case .failure(let error):
                print(error)
            }
            
            if emailAlreadyExists {
                UIView.animate(withDuration: 0.2, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {
                    self.emailTextFieldSignUp!.layer.borderWidth = 2
                    self.emailTextFieldSignUp!.layer.borderColor = UIColor(red: 0.86, green: 0.24, blue: 0.00, alpha: 1.00).cgColor
                    self.emailAlreadyExistsLabel?.alpha = 1
                })
                self.isValidationError = true
                self.signupContinueButton?.isDisabled = true
            } else {
                UIView.animate(withDuration: 0.2, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {
                    self.emailTextFieldSignUp!.layer.borderWidth = 2
                    self.emailTextFieldSignUp!.layer.borderColor = UIColor(red: 0.00, green: 0.55, blue: 0.01, alpha: 0.80).cgColor
                    self.emailAlreadyExistsLabel?.alpha = 0
                })
                self.isValidationError = false
                self.signupContinueButton?.isDisabled = false
            }
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
    
    @objc func dateChanged(_ sender: UIDatePicker) {
        print(Date.ISOStringFromDate(date: sender.date))
    }
    
    func clearAllErrors() {
        emailTextFieldLogin?.layer.borderColor = UIColor(red: 0.75, green: 0.79, blue: 0.85, alpha: 1.00).cgColor
        passwordTextField?.layer.borderColor = UIColor(red: 0.75, green: 0.79, blue: 0.85, alpha: 1.00).cgColor
        emailTextFieldSignUp?.layer.borderColor = UIColor(red: 0.75, green: 0.79, blue: 0.85, alpha: 1.00).cgColor
        choosePasswordTextField?.layer.borderColor = UIColor(red: 0.75, green: 0.79, blue: 0.85, alpha: 1.00).cgColor
        confirmPasswordTextField?.layer.borderColor = UIColor(red: 0.75, green: 0.79, blue: 0.85, alpha: 1.00).cgColor
        firstNameField?.layer.borderColor = UIColor(red: 0.75, green: 0.79, blue: 0.85, alpha: 1.00).cgColor
        lastNameField?.layer.borderColor = UIColor(red: 0.75, green: 0.79, blue: 0.85, alpha: 1.00).cgColor
        weightField?.layer.borderColor = UIColor(red: 0.75, green: 0.79, blue: 0.85, alpha: 1.00).cgColor
        phoneNumberField?.layer.borderColor = UIColor(red: 0.75, green: 0.79, blue: 0.85, alpha: 1.00).cgColor
        addressTextView?.layer.borderColor = UIColor(red: 0.75, green: 0.79, blue: 0.85, alpha: 1.00).cgColor
        stateField?.layer.borderColor = UIColor(red: 0.75, green: 0.79, blue: 0.85, alpha: 1.00).cgColor
        cityField?.layer.borderColor = UIColor(red: 0.75, green: 0.79, blue: 0.85, alpha: 1.00).cgColor
    }
}

extension LoginSignUpViewController : UITextFieldDelegate, DPOTPViewDelegate, ValidationDelegate {
    // when user select a textfield, this method will be called
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // set the activeTextField to the selected textfield
        self.activeTextField = textField
        UIView.animate(withDuration: 0.2, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {
            textField.layer.borderWidth = 2
            textField.layer.borderColor = UIColor(red: 0.11, green: 0.42, blue: 0.64, alpha: 1.00).cgColor
        })
    }
    
    // when user click 'done' or dismiss the keyboard
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.2, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {
            textField.layer.borderWidth = 1
            textField.layer.borderColor = UIColor(red: 0.75, green: 0.79, blue: 0.85, alpha: 1.00).cgColor
        })
        
        self.activeTextField = nil
        
        clearAllErrors()
        validator.validate(self)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func dpOTPViewAddText(_ text: String, at position: Int) {
        if text == otpFromServer {
            self.view.hideAllToasts()
            self.view.makeToastActivity(.center)
            UIView.animate(withDuration: 0.2, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, animations: {
                self.progressBar?.setProgress(0.1, animated: true)
            }, completion: {
                (finished: Bool) -> Void in
            })
            let dob = dobPicker!.date
            let hashedPassword = SHA512.hash(data: Data(choosePasswordTextField!.trim().utf8))
            // Convert model to JSON data
            var day = Date.getDayFromDate(date: dob)
            if Int(Date.getDayFromDate(date: dob))! < 10 {
                day = "0" + day
            }
            var month = Date.getMonthFromDate(date: dob)
            if Int(Date.getMonthFromDate(date: dob))! < 10 {
                month = "0" + month
            }
            let model = SignUpModel(credential:
                                        CredentialShort(email: "\(emailTextFieldSignUp!.trim())",
                                                        password: hashedPassword.compactMap { String(format: "%02x", $0) }.joined()),
                                    name:
                                        NameExclMiddleName(firstName: firstNameField!.trim(),
                                                           lastName: lastNameField!.trim()),
                                    address: Address(address: addressTextView!.trimmedWhitespaces(),
                                                     state: stateField!.trim(),
                                                     city: cityField!.trim(),
                                                     postalCode: ""),
                                    gender: "male",
                                    mobile: MobileNumberShort(contactNumber: phoneNumberField!.trim(),
                                                              countryCode: countryCodeLabel!.text!),
                                    dob: "\(Date.getYearFromDate(date: dob))-\(month)-\(day)",
                                    bloodGroup: bloodGroupDropdown!.text!,
                                    height: 0.0,
                                    weight: Double(weightField!.trim()) ?? 0.0)
            APIService(data: try! model.toDictionary(), url: nil, service: .signUp, method: .post, isJSONRequest: true).executeQuery() { (result: Result<User, Error>) in
                switch result{
                case .success(_):
                    try? User.setUserDetails(userDetails: result.get())
                    self.pageTitle?.text = "all_set".localized()
                    self.view.hideToastActivity()
                    UIView.animate(withDuration: 0.0, delay: 0.3, options: UIView.AnimationOptions.curveEaseIn, animations: {
                        self.dismiss(animated: true) {
                            NotificationCenter.default.post(name: Notification.Name("goToDashboard"), object: nil)
                        }
                    }, completion: nil)
                case .failure(let error):
                    print(error)
                    UIView.animate(withDuration: 0.1, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {
                        self.progressBar?.setProgress(0.87, animated: true)
                    }, completion: {
                        (finished: Bool) -> Void in
                        
                    })
                    self.view.hideToastActivity()
                    Utils.displaySPIndicatorNotifWithMessage(title: "unknown_error".localized(), message: "error_has_occured".localized(), iconPreset: .error, hapticPreset: .error, duration: 6)
                }
            }
            
        } else {
            if text.count == 4 {
                UIView.animate(withDuration: 0.1, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {
                    self.progressBar?.setProgress(0.1, animated: true)
                }, completion: {
                    (finished: Bool) -> Void in
                    self.progressBar?.setProgress(0.87, animated: true)
                })
                Utils.displaySPIndicatorNotifWithMessage(title: "otp_incorrect".localized(), message: "enter_correct_otp".localized(), iconPreset: .error, hapticPreset: .error, duration: 6)
            }
        }
    }
    
    func dpOTPViewRemoveText(_ text: String, at position: Int) {
    }
    
    func dpOTPViewChangePositionAt(_ position: Int) {
    }
    func dpOTPViewBecomeFirstResponder() {
    }
    func dpOTPViewResignFirstResponder() {
    }
    
    func validationSuccessful() {
        if activeView == .signupInitialDetails {
            checkEmailExists()
        } else {
            self.isValidationError = false
            self.signupContinueButton?.isDisabled = false
        }
    }
    
    func validationFailed(_ errors: [(SwiftValidator.Validatable, SwiftValidator.ValidationError)]) {
        isValidationError = true
        self.signupContinueButton?.isDisabled = true
        for (field, _) in errors {
            if let field = field as? UITextField {
                field.layer.borderColor = UIColor.red.cgColor
                field.layer.borderWidth = 1.0
            } else if let field = field as? UITextView {
                field.layer.borderColor = UIColor.red.cgColor
                field.layer.borderWidth = 1.0
            }
        }
    }
}
