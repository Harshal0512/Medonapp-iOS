//
//  AddFamilyMemberViewController.swift
//  Medonapp iOS
//
//  Created by Harshal Kulkarni on 09/02/23.
//

import UIKit
import SwiftValidator

class AddFamilyMemberViewController: UIViewController {
    
    let validator = Validator()
    private var backButton: UIImageView?
    private var navTitle: UILabel?
    private var emailLabel: UILabel?
    private var emailTextField: UITextFieldWithPlaceholder_CR8?
    private var emailDoesNotExistLabel: UILabel?
    private var addMemberButton: UIButtonVariableBackgroundVariableCR?
    
    var activeTextField : UITextField? = nil
    var isValidationError = true
    
    private var userDetails = User.getUserDetails()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dismissKeyboard()

        initialise()
        setupUI()
        setConstraints()
    }

    private func initialise() {
    }
    
    private func setupUI() {
        backButton = UIImageView()
        backButton?.image = UIImage(named: "backIcon_White")?.resizeImageTo(size: CGSize(width: 50, height: 50))
        backButton?.contentMode = .scaleAspectFit
        view.addSubview(backButton!)
        let backTap = UITapGestureRecognizer(target: self, action: #selector(self.handleBackAction(_:)))
        backButton?.addGestureRecognizer(backTap)
        backButton?.isUserInteractionEnabled = true
        
        navTitle = UILabel()
        navTitle?.text = "Add Family Member"
        navTitle?.textAlignment = .left
        navTitle?.textColor = .black
        navTitle?.font = UIFont(name: "NunitoSans-Bold", size: 27)
        view.addSubview(navTitle!)
        
        emailLabel = UILabel()
        emailLabel?.text = "Email"
        emailLabel?.textColor = .black
        emailLabel?.font = UIFont(name: "NunitoSans-ExtraBold", size: 18)
        view.addSubview(emailLabel!)
        
        emailTextField = UITextFieldWithPlaceholder_CR8()
        emailTextField?.name = "emailSignUp"
        emailTextField?.delegate = self
        emailTextField?.setPlaceholder(placeholder: "Email")
        emailTextField?.autocapitalizationType = .none
        emailTextField?.autocorrectionType = .no
        emailTextField?.keyboardType = .emailAddress
        view.addSubview(emailTextField!)
        validator.registerField(emailTextField!, rules: [RequiredRule(), EmailRule()])
        
        emailDoesNotExistLabel = UILabel()
        emailDoesNotExistLabel?.text = "This user does not exist, please share the app or try with a different email"
        emailDoesNotExistLabel?.textColor = UIColor(red: 0.86, green: 0.24, blue: 0.00, alpha: 1.00)
        emailDoesNotExistLabel?.font = UIFont(name: "NunitoSans-Bold", size: 11)
        emailDoesNotExistLabel?.numberOfLines = 0
        emailDoesNotExistLabel?.alpha = 0
        view.addSubview(emailDoesNotExistLabel!)
        
        addMemberButton = UIButtonVariableBackgroundVariableCR()
        addMemberButton?.initButton(title: "Continue", cornerRadius: 14, variant: .blueBack)
        addMemberButton?.isDisabled = true
        view.addSubview(addMemberButton!)
        addMemberButton?.addTarget(self, action: #selector(addMemberButtonPressed), for: .touchUpInside)
    }
    
    private func setConstraints() {
        backButton?.translatesAutoresizingMaskIntoConstraints = false
        navTitle?.translatesAutoresizingMaskIntoConstraints = false
        emailLabel?.translatesAutoresizingMaskIntoConstraints = false
        emailTextField?.translatesAutoresizingMaskIntoConstraints = false
        emailDoesNotExistLabel?.translatesAutoresizingMaskIntoConstraints = false
        addMemberButton?.translatesAutoresizingMaskIntoConstraints = false
        
        
        backButton?.topAnchor.constraint(equalTo: view.topAnchor, constant: 35).isActive = true
        backButton?.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 28).isActive = true
        backButton?.widthAnchor.constraint(equalToConstant: 50).isActive = true
        backButton?.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        navTitle?.topAnchor.constraint(equalTo: backButton!.bottomAnchor, constant: 30).isActive = true
        navTitle?.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 28).isActive = true
        navTitle?.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -28).isActive = true
        
        emailLabel?.topAnchor.constraint(equalTo: navTitle!.topAnchor, constant: 60).isActive = true
        emailLabel?.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 28).isActive = true
        emailLabel?.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -28).isActive = true
        
        emailTextField?.topAnchor.constraint(equalTo: emailLabel!.bottomAnchor, constant: 15).isActive = true
        emailTextField?.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 28).isActive = true
        emailTextField?.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -28).isActive = true
        emailTextField?.heightAnchor.constraint(equalToConstant: 61).isActive = true
        
        emailDoesNotExistLabel?.topAnchor.constraint(equalTo: emailTextField!.bottomAnchor, constant: 5).isActive = true
        emailDoesNotExistLabel?.leadingAnchor.constraint(equalTo: emailTextField!.leadingAnchor, constant: 5).isActive = true
        emailDoesNotExistLabel?.trailingAnchor.constraint(equalTo: emailTextField!.trailingAnchor, constant: -5).isActive = true
        
        addMemberButton?.topAnchor.constraint(equalTo: emailDoesNotExistLabel!.bottomAnchor, constant: 20).isActive = true
        addMemberButton?.leadingAnchor.constraint(equalTo: emailTextField!.leadingAnchor).isActive = true
        addMemberButton?.trailingAnchor.constraint(equalTo: emailTextField!.trailingAnchor).isActive = true
        addMemberButton?.heightAnchor.constraint(equalToConstant: 56).isActive = true

    }
    
    @objc func handleBackAction(_ sender: UITapGestureRecognizer? = nil) {
        self.dismiss(animated: true)
    }
    
    func clearAllErrors() {
        addMemberButton?.isDisabled = true
        emailTextField?.layer.borderColor = UIColor(red: 0.75, green: 0.79, blue: 0.85, alpha: 1.00).cgColor
    }
    
    func checkEmailExists() {
        APIService(data: ["username": emailTextField!.trim(), "isDoctor": false], url: nil, service: .checkEmailExists, method: .post, isJSONRequest: true).executeQuery() { (result: Result<Bool, Error>) in
            var emailAlreadyExists = false
            
            switch result{
            case .success(_):
                try? emailAlreadyExists = result.get()
            case .failure(let error):
                print(error)
            }
            
            if emailAlreadyExists {
                UIView.animate(withDuration: 0.2, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {
                    self.emailTextField!.layer.borderWidth = 2
                    self.emailTextField!.layer.borderColor = UIColor(red: 0.00, green: 0.55, blue: 0.01, alpha: 0.80).cgColor
                    self.emailDoesNotExistLabel?.alpha = 0
                })
                self.isValidationError = false
                self.addMemberButton?.isDisabled = false
            } else {
                UIView.animate(withDuration: 0.2, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {
                    self.emailTextField!.layer.borderWidth = 2
                    self.emailTextField!.layer.borderColor = UIColor(red: 0.86, green: 0.24, blue: 0.00, alpha: 1.00).cgColor
                    self.emailDoesNotExistLabel?.alpha = 1
                })
                self.isValidationError = true
                self.addMemberButton?.isDisabled = true
                
                let shareAppAlert = UIAlertController(title: "Share App",
                                                          message: "This user does not exist, share the app with them in order to add them to you family.",
                                                      preferredStyle: .actionSheet)
                
                let saveAction = UIAlertAction(title: "Share",
                                               style: .default) { _ in
                    Utils.openShareAppSheet(on: self)
                }
                
                let cancelAction = UIAlertAction(title: "Cancel",
                                                 style: .destructive) { (action: UIAlertAction!) -> Void in
                }
                
                shareAppAlert.addAction(saveAction)
                shareAppAlert.addAction(cancelAction)
                self.present(shareAppAlert, animated: true, completion: nil)
            }
        }
    }
    
    @objc func addMemberButtonPressed() {
        APIService(data: ["username": emailTextField!.trim()], headers: ["Authorization" : "Bearer \(User.getUserDetails().token ?? "")"], url: nil, service: .addFamilyMember(userDetails.patient!.id!), method: .post, isJSONRequest: true).executeQuery() { (result: Result<User, Error>) in
            
            switch result{
            case .success(_):
                try? User.setUserDetails(userDetails: result.get())
                Utils.displaySPIndicatorNotifWithoutMessage(title: "Family Request Sent", iconPreset: .done, hapticPreset: .success, duration: 2.0)
            case .failure(let error):
                print(error)
                if error.localizedDescription.contains("already has join request") {
                    Utils.displaySPIndicatorNotifWithoutMessage(title: "Join Request Pending with User", iconPreset: .error, hapticPreset: .warning, duration: 3.0)
                } else {
                    Utils.displaySPIndicatorNotifWithoutMessage(title: "Could not send Family Request", iconPreset: .error, hapticPreset: .error, duration: 2.0)
                }
            }
            self.dismiss(animated: true)
        }
    }
}

extension AddFamilyMemberViewController : UITextFieldDelegate, ValidationDelegate {
    // when user select a textfield, this method will be called
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // set the activeTextField to the selected textfield
        self.activeTextField = textField
        self.addMemberButton?.isDisabled = true
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
        self.addMemberButton?.isDisabled = true
        
        clearAllErrors()
        validator.validate(self)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func validationSuccessful() {
        checkEmailExists()
    }
    
    func validationFailed(_ errors: [(SwiftValidator.Validatable, SwiftValidator.ValidationError)]) {
        checkEmailExists()
        isValidationError = true
        self.addMemberButton?.isDisabled = true
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
