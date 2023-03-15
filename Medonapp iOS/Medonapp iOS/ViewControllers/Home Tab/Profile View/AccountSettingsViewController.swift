//
//  AccountSettingsViewController.swift
//  Medonapp iOS
//
//  Created by Harshal Kulkarni on 10/03/23.
//

import UIKit
import SwiftValidator
import iOSDropDown

class AccountSettingsViewController: UIViewController {
    
    let validator = Validator()
    
    private var scrollView: UIScrollView?
    private var contentView: UIView?
    private var backButton: UIImageView?
    private var profileImageView: UIImageView?
    private var nameLabel: UILabel?
    private var emailLabel: UILabel?
    
    private var userDetails = User.getUserDetails()
    
    //personal details
    private var firstNameLabel: UILabel?
    private var firstNameField: UITextFieldWithPlaceholder_CR8?
    private var lastNameLabel: UILabel?
    private var lastNameField: UITextFieldWithPlaceholder_CR8?
    private var dobLabel: UILabel?
    private var dobPicker: UIDatePicker?
    private var bloodGroupLabel: UILabel?
    private var bloodGroupDropdown: DropDown?
    private var weightLabel: UILabel?
    private var weightField: UITextFieldWithPlaceholder_CR8?
    
    //address details
    private var phoneNumberLabel: UILabel?
    private var countryCodeLabel: UILabel?
    private var phoneNumberField: UITextFieldWithPlaceholder_CR8?
    private var addressLabel: UILabel?
    private var addressTextView: UITextViewWithPlaceholder_CR8?
    private var stateLabel: UILabel?
    private var stateField: UITextFieldWithPlaceholder_CR8?
    private var cityLabel: UILabel?
    private var cityField: UITextFieldWithPlaceholder_CR8?
    
    private var saveDetailsButton: UIButtonVariableBackgroundVariableCR?
    
    private var deleteAccountButton: UIImageView?
    
    var activeTextField : UITextField? = nil
    
    var isValidationError = true

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dismissKeyboard()

        initialise()
        setupUI()
        setConstraints()
        
        initDetails()
    }
    
    func initialise() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
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
        
        firstNameLabel = UILabel()
        firstNameLabel?.text = "first_name".localized()
        firstNameLabel?.textColor = .black
        firstNameLabel?.font = UIFont(name: "NunitoSans-ExtraBold", size: 18)
        contentView?.addSubview(firstNameLabel!)
        
        firstNameField = UITextFieldWithPlaceholder_CR8()
        firstNameField?.delegate = self
        firstNameField?.setPlaceholder(placeholder: "first_name".localized())
        firstNameField?.autocapitalizationType = .words
        firstNameField?.autocorrectionType = .no
        firstNameField?.keyboardType = .default
        contentView?.addSubview(firstNameField!)
        validator.registerField(firstNameField!, rules: [RequiredRule()])
        
        lastNameLabel = UILabel()
        lastNameLabel?.text = "last_name".localized()
        lastNameLabel?.textColor = .black
        lastNameLabel?.font = UIFont(name: "NunitoSans-ExtraBold", size: 18)
        contentView?.addSubview(lastNameLabel!)
        
        lastNameField = UITextFieldWithPlaceholder_CR8()
        lastNameField?.delegate = self
        lastNameField?.setPlaceholder(placeholder: "last_name".localized())
        lastNameField?.autocapitalizationType = .words
        lastNameField?.autocorrectionType = .no
        lastNameField?.keyboardType = .default
        contentView?.addSubview(lastNameField!)
        validator.registerField(lastNameField!, rules: [RequiredRule()])
        
        dobLabel = UILabel()
        dobLabel?.text = "dob".localized()
        dobLabel?.textColor = .black
        dobLabel?.font = UIFont(name: "NunitoSans-ExtraBold", size: 18)
        contentView?.addSubview(dobLabel!)
        
        dobPicker = UIDatePicker()
        dobPicker?.datePickerMode = .date
        dobPicker?.preferredDatePickerStyle = .compact
        dobPicker?.set18YearValidation()
        //        dobPicker?.maximumDate = Calendar.current.date(byAdding: .hour, value: 1, to: Date())
        contentView?.addSubview(dobPicker!)
        dobPicker?.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        
        bloodGroupLabel = UILabel()
        bloodGroupLabel?.text = "blood_group".localized()
        bloodGroupLabel?.textColor = .black
        bloodGroupLabel?.font = UIFont(name: "NunitoSans-ExtraBold", size: 18)
        contentView?.addSubview(bloodGroupLabel!)
        
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
        contentView?.addSubview(bloodGroupDropdown!)
        
        weightLabel = UILabel()
        weightLabel?.text = "weight_kg".localized()
        weightLabel?.textColor = .black
        weightLabel?.font = UIFont(name: "NunitoSans-ExtraBold", size: 18)
        contentView?.addSubview(weightLabel!)
        
        weightField = UITextFieldWithPlaceholder_CR8()
        weightField?.delegate = self
        weightField?.setPlaceholder(placeholder: "weight_kg".localized())
        weightField?.autocapitalizationType = .none
        weightField?.autocorrectionType = .no
        weightField?.keyboardType = .decimalPad
        contentView?.addSubview(weightField!)
        validator.registerField(weightField!, rules: [RequiredRule(), FloatRule()])
        
        phoneNumberLabel = UILabel()
        phoneNumberLabel?.text = "phone_number".localized()
        phoneNumberLabel?.textColor = .black
        phoneNumberLabel?.font = UIFont(name: "NunitoSans-ExtraBold", size: 18)
        contentView?.addSubview(phoneNumberLabel!)
        
        countryCodeLabel = UILabel()
        countryCodeLabel?.text = "+91"
        countryCodeLabel?.textColor = UIColor(red: 0.48, green: 0.55, blue: 0.62, alpha: 1.00)
        countryCodeLabel?.layer.borderColor = UIColor(red: 0.75, green: 0.79, blue: 0.85, alpha: 1.00).cgColor
        countryCodeLabel?.textAlignment = .center
        countryCodeLabel?.layer.borderWidth = 1
        countryCodeLabel?.layer.cornerRadius = 10
        countryCodeLabel?.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        countryCodeLabel?.font = UIFont(name: "NunitoSans-ExtraBold", size: 18)
        contentView?.addSubview(countryCodeLabel!)
        
        phoneNumberField = UITextFieldWithPlaceholder_CR8()
        phoneNumberField?.delegate = self
        phoneNumberField?.setPlaceholder(placeholder: "phone_number".localized())
        phoneNumberField?.autocapitalizationType = .none
        phoneNumberField?.autocorrectionType = .no
        phoneNumberField?.keyboardType = .numberPad
        phoneNumberField?.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        contentView?.addSubview(phoneNumberField!)
        validator.registerField(phoneNumberField!, rules: [RequiredRule(), ExactLengthRule(length: 10)])
        
        addressLabel = UILabel()
        addressLabel?.text = "address".localized()
        addressLabel?.textColor = .black
        addressLabel?.font = UIFont(name: "NunitoSans-ExtraBold", size: 18)
        contentView?.addSubview(addressLabel!)
        
        addressTextView = UITextViewWithPlaceholder_CR8()
        addressTextView?.autocapitalizationType = .words
        addressTextView?.autocorrectionType = .no
        addressTextView?.keyboardType = .default
        contentView?.addSubview(addressTextView!)
        validator.registerField(addressTextView!, rules: [RequiredRule()])
        
        stateLabel = UILabel()
        stateLabel?.text = "state".localized()
        stateLabel?.textColor = .black
        stateLabel?.font = UIFont(name: "NunitoSans-ExtraBold", size: 18)
        contentView?.addSubview(stateLabel!)
        
        stateField = UITextFieldWithPlaceholder_CR8()
        stateField?.delegate = self
        stateField?.setPlaceholder(placeholder: "state".localized())
        stateField?.autocapitalizationType = .words
        stateField?.autocorrectionType = .no
        stateField?.keyboardType = .default
        contentView?.addSubview(stateField!)
        validator.registerField(stateField!, rules: [RequiredRule()])
        
        cityLabel = UILabel()
        cityLabel?.text = "city".localized()
        cityLabel?.textColor = .black
        cityLabel?.font = UIFont(name: "NunitoSans-ExtraBold", size: 18)
        contentView?.addSubview(cityLabel!)
        
        cityField = UITextFieldWithPlaceholder_CR8()
        cityField?.delegate = self
        cityField?.setPlaceholder(placeholder: "city".localized())
        cityField?.autocapitalizationType = .words
        cityField?.autocorrectionType = .no
        cityField?.keyboardType = .default
        contentView?.addSubview(cityField!)
        validator.registerField(cityField!, rules: [RequiredRule()])
        
        saveDetailsButton = UIButtonVariableBackgroundVariableCR()
        saveDetailsButton?.initButton(title: "Save Details", cornerRadius: 14, variant: .blueBack)
        contentView?.addSubview(saveDetailsButton!)
        saveDetailsButton?.addTarget(self, action: #selector(saveDetailsButtonPressed), for: .touchUpInside)
        
        deleteAccountButton = UIImageView()
        deleteAccountButton?.image = UIImage(named: "deleteAccountPng")!
        deleteAccountButton?.contentMode = .scaleAspectFit
        contentView?.addSubview(deleteAccountButton!)
        let deleteAccountTap = UITapGestureRecognizer(target: self, action: #selector(self.handleDeleteAccountAction(_:)))
        deleteAccountButton?.addGestureRecognizer(deleteAccountTap)
        deleteAccountButton?.isUserInteractionEnabled = true
    }
    
    func setConstraints() {
        scrollView?.translatesAutoresizingMaskIntoConstraints = false
        contentView?.translatesAutoresizingMaskIntoConstraints = false
        backButton?.translatesAutoresizingMaskIntoConstraints = false
        profileImageView?.translatesAutoresizingMaskIntoConstraints = false
        nameLabel?.translatesAutoresizingMaskIntoConstraints = false
        emailLabel?.translatesAutoresizingMaskIntoConstraints = false
        
        
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
        
        saveDetailsButton?.translatesAutoresizingMaskIntoConstraints = false
        deleteAccountButton?.translatesAutoresizingMaskIntoConstraints = false
        
        
        scrollView?.topAnchor.constraint(equalTo: backButton!.bottomAnchor, constant: 0).isActive = true
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
        profileImageView?.topAnchor.constraint(equalTo: contentView!.topAnchor, constant: 50).isActive = true
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
        
        firstNameLabel?.topAnchor.constraint(equalTo: emailLabel!.bottomAnchor, constant: 22).isActive = true
        firstNameLabel?.leadingAnchor.constraint(equalTo: contentView!.leadingAnchor, constant: 28).isActive = true
        firstNameLabel?.trailingAnchor.constraint(equalTo: contentView!.trailingAnchor, constant: -28).isActive = true
        
        firstNameField?.topAnchor.constraint(equalTo: firstNameLabel!.bottomAnchor, constant: 5).isActive = true
        firstNameField?.leadingAnchor.constraint(equalTo: contentView!.leadingAnchor, constant: 28).isActive = true
        firstNameField?.trailingAnchor.constraint(equalTo: contentView!.trailingAnchor, constant: -28).isActive = true
        firstNameField?.heightAnchor.constraint(equalToConstant: 61).isActive = true
        
        lastNameLabel?.topAnchor.constraint(equalTo: firstNameField!.bottomAnchor, constant: 22).isActive = true
        lastNameLabel?.leadingAnchor.constraint(equalTo: contentView!.leadingAnchor, constant: 28).isActive = true
        lastNameLabel?.trailingAnchor.constraint(equalTo: contentView!.trailingAnchor, constant: -28).isActive = true
        
        lastNameField?.topAnchor.constraint(equalTo: lastNameLabel!.bottomAnchor, constant: 5).isActive = true
        lastNameField?.leadingAnchor.constraint(equalTo: contentView!.leadingAnchor, constant: 28).isActive = true
        lastNameField?.trailingAnchor.constraint(equalTo: contentView!.trailingAnchor, constant: -28).isActive = true
        lastNameField?.heightAnchor.constraint(equalToConstant: 61).isActive = true
        
        dobLabel?.topAnchor.constraint(equalTo: lastNameField!.bottomAnchor, constant: 22).isActive = true
        dobLabel?.leadingAnchor.constraint(equalTo: contentView!.leadingAnchor, constant: 28).isActive = true
        dobLabel?.trailingAnchor.constraint(equalTo: contentView!.trailingAnchor, constant: -28).isActive = true
        
        dobPicker?.topAnchor.constraint(equalTo: dobLabel!.bottomAnchor, constant: 5).isActive = true
        dobPicker?.leadingAnchor.constraint(equalTo: contentView!.leadingAnchor, constant: 28).isActive = true
        dobPicker?.widthAnchor.constraint(equalToConstant: 130).isActive = true
        dobPicker?.heightAnchor.constraint(equalToConstant: 61).isActive = true
        
        bloodGroupLabel?.topAnchor.constraint(equalTo: dobPicker!.bottomAnchor, constant: 15).isActive = true
        bloodGroupLabel?.leadingAnchor.constraint(equalTo: contentView!.leadingAnchor, constant: 28).isActive = true
        
        bloodGroupDropdown?.topAnchor.constraint(equalTo: bloodGroupLabel!.bottomAnchor, constant: 5).isActive = true
        bloodGroupDropdown?.leadingAnchor.constraint(equalTo: contentView!.leadingAnchor, constant: 28).isActive = true
        bloodGroupDropdown?.widthAnchor.constraint(equalToConstant: 148).isActive = true
        bloodGroupDropdown?.heightAnchor.constraint(equalToConstant: 61).isActive = true
        
        weightLabel?.topAnchor.constraint(equalTo: bloodGroupLabel!.topAnchor).isActive = true
        weightLabel?.trailingAnchor.constraint(equalTo: contentView!.trailingAnchor, constant: -28).isActive = true
        
        weightField?.topAnchor.constraint(equalTo: weightLabel!.bottomAnchor, constant: 5).isActive = true
        weightField?.trailingAnchor.constraint(equalTo: contentView!.trailingAnchor, constant: -28).isActive = true
        weightField?.widthAnchor.constraint(equalToConstant: 148).isActive = true
        weightField?.heightAnchor.constraint(equalToConstant: 61).isActive = true
        weightField?.leadingAnchor.constraint(greaterThanOrEqualTo: bloodGroupDropdown!.trailingAnchor, constant: 10).isActive = true
        
        weightLabel?.leadingAnchor.constraint(equalTo: weightField!.leadingAnchor).isActive = true
        bloodGroupLabel?.trailingAnchor.constraint(equalTo: weightLabel!.leadingAnchor, constant: -10).isActive = true
        
        phoneNumberLabel?.topAnchor.constraint(equalTo: weightField!.bottomAnchor, constant: 22).isActive = true
        phoneNumberLabel?.leadingAnchor.constraint(equalTo: contentView!.leadingAnchor, constant: 28).isActive = true
        phoneNumberLabel?.trailingAnchor.constraint(equalTo: contentView!.trailingAnchor, constant: -28).isActive = true
        
        countryCodeLabel?.topAnchor.constraint(equalTo: phoneNumberLabel!.bottomAnchor, constant: 22).isActive = true
        countryCodeLabel?.leadingAnchor.constraint(equalTo: contentView!.leadingAnchor, constant: 28).isActive = true
        countryCodeLabel?.widthAnchor.constraint(equalToConstant: 60).isActive = true
        countryCodeLabel?.heightAnchor.constraint(equalToConstant: 61).isActive = true
        
        phoneNumberField?.topAnchor.constraint(equalTo: countryCodeLabel!.topAnchor).isActive = true
        phoneNumberField?.leadingAnchor.constraint(equalTo: countryCodeLabel!.trailingAnchor, constant: 0).isActive = true
        phoneNumberField?.trailingAnchor.constraint(equalTo: contentView!.trailingAnchor, constant: -28).isActive = true
        phoneNumberField?.heightAnchor.constraint(equalToConstant: 61).isActive = true
        
        addressLabel?.topAnchor.constraint(equalTo: phoneNumberField!.bottomAnchor, constant: 22).isActive = true
        addressLabel?.leadingAnchor.constraint(equalTo: contentView!.leadingAnchor, constant: 28).isActive = true
        addressLabel?.trailingAnchor.constraint(equalTo: contentView!.trailingAnchor, constant: -28).isActive = true
        
        addressTextView?.topAnchor.constraint(equalTo: addressLabel!.bottomAnchor, constant: 7).isActive = true
        addressTextView?.leadingAnchor.constraint(equalTo: contentView!.leadingAnchor, constant: 28).isActive = true
        addressTextView?.trailingAnchor.constraint(equalTo: contentView!.trailingAnchor, constant: -28).isActive = true
        addressTextView?.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        stateLabel?.topAnchor.constraint(equalTo: addressTextView!.bottomAnchor, constant: 15).isActive = true
        stateLabel?.leadingAnchor.constraint(equalTo: contentView!.leadingAnchor, constant: 28).isActive = true
        
        stateField?.topAnchor.constraint(equalTo: stateLabel!.bottomAnchor, constant: 5).isActive = true
        stateField?.leadingAnchor.constraint(equalTo: contentView!.leadingAnchor, constant: 28).isActive = true
        stateField?.widthAnchor.constraint(equalToConstant: 148).isActive = true
        stateField?.heightAnchor.constraint(equalToConstant: 61).isActive = true
        
        cityLabel?.topAnchor.constraint(equalTo: stateLabel!.topAnchor).isActive = true
        cityLabel?.trailingAnchor.constraint(equalTo: contentView!.trailingAnchor, constant: -28).isActive = true
        
        cityField?.topAnchor.constraint(equalTo: cityLabel!.bottomAnchor, constant: 5).isActive = true
        cityField?.trailingAnchor.constraint(equalTo: contentView!.trailingAnchor, constant: -28).isActive = true
        cityField?.widthAnchor.constraint(equalToConstant: 148).isActive = true
        cityField?.heightAnchor.constraint(equalToConstant: 61).isActive = true
        cityField?.leadingAnchor.constraint(greaterThanOrEqualTo: stateField!.trailingAnchor, constant: 10).isActive = true
        
        cityLabel?.leadingAnchor.constraint(equalTo: cityField!.leadingAnchor).isActive = true
        stateLabel?.trailingAnchor.constraint(equalTo: cityLabel!.leadingAnchor, constant: -10).isActive = true
        
        saveDetailsButton?.topAnchor.constraint(equalTo: cityField!.bottomAnchor, constant: 35).isActive = true
        
        saveDetailsButton?.leadingAnchor.constraint(equalTo: firstNameField!.leadingAnchor).isActive = true
        saveDetailsButton?.trailingAnchor.constraint(equalTo: firstNameField!.trailingAnchor).isActive = true
        saveDetailsButton?.heightAnchor.constraint(equalToConstant: 56).isActive = true
        
        deleteAccountButton?.topAnchor.constraint(equalTo: saveDetailsButton!.bottomAnchor, constant: 40).isActive = true
        deleteAccountButton?.centerXAnchor.constraint(equalTo: contentView!.centerXAnchor).isActive = true
        deleteAccountButton?.heightAnchor.constraint(equalToConstant: 28).isActive = true
        deleteAccountButton?.bottomAnchor.constraint(equalTo: contentView!.bottomAnchor, constant: -40).isActive = true
    }
    
    func initDetails() {
        firstNameField?.text = userDetails.patient?.name?.firstName
        lastNameField?.text = userDetails.patient?.name?.lastName
        dobPicker?.setDate(Date.dateFromISOString(string: (userDetails.patient?.dob)! + "T01:01:01.000001", ending: ".SSSSSS")!, animated: true)
        for optionIndex in 0..<(bloodGroupDropdown?.optionArray.count)! {
            if bloodGroupDropdown?.optionArray[optionIndex] == userDetails.patient?.bloodGroup {
                bloodGroupDropdown?.selectedIndex = optionIndex
                bloodGroupDropdown?.text = bloodGroupDropdown?.optionArray[optionIndex]
                break
            }
        }
        weightField?.text = String(userDetails.patient?.weight ?? 0.0)
        phoneNumberField?.text = userDetails.patient?.mobile?.contactNumber
        addressTextView?.text = userDetails.patient?.address?.address
        stateField?.text = userDetails.patient?.address?.state
        cityField?.text = userDetails.patient?.address?.city
    }
    
    @objc func handleBackAction(_ sender: UITapGestureRecognizer? = nil) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func saveDetailsButtonPressed() {
    }
    
    @objc func handleDeleteAccountAction(_ sender: UITapGestureRecognizer? = nil) {
        Utils.displayYesREDNoAlertWithHandler("Are you sure you want to delete your Medonapp Account? \n This action cannot be undone.", viewController: self, style: .actionSheet) { _ in
            
        } yesHandler: { _ in
            
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
        firstNameField?.layer.borderColor = UIColor(red: 0.75, green: 0.79, blue: 0.85, alpha: 1.00).cgColor
        lastNameField?.layer.borderColor = UIColor(red: 0.75, green: 0.79, blue: 0.85, alpha: 1.00).cgColor
        weightField?.layer.borderColor = UIColor(red: 0.75, green: 0.79, blue: 0.85, alpha: 1.00).cgColor
        phoneNumberField?.layer.borderColor = UIColor(red: 0.75, green: 0.79, blue: 0.85, alpha: 1.00).cgColor
        addressTextView?.layer.borderColor = UIColor(red: 0.75, green: 0.79, blue: 0.85, alpha: 1.00).cgColor
        stateField?.layer.borderColor = UIColor(red: 0.75, green: 0.79, blue: 0.85, alpha: 1.00).cgColor
        cityField?.layer.borderColor = UIColor(red: 0.75, green: 0.79, blue: 0.85, alpha: 1.00).cgColor
    }
    
}

extension AccountSettingsViewController : UITextFieldDelegate, ValidationDelegate {
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
    
    func validationSuccessful() {
        self.isValidationError = false
//        self.signupContinueButton?.isDisabled = false
    }
    
    func validationFailed(_ errors: [(SwiftValidator.Validatable, SwiftValidator.ValidationError)]) {
        isValidationError = true
//        self.signupContinueButton?.isDisabled = true
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
