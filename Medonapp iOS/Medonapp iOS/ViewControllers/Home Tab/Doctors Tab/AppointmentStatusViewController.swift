//
//  AppointmentStatusViewController.swift
//  Medonapp iOS
//
//  Created by Harshal Kulkarni on 14/10/22.
//

import UIKit
import Lottie

enum actionButtonTypes {
    case dashboard
    case previousScreen
}

class AppointmentStatusViewController: UIViewController {
    
    private var animationView: LottieAnimationView?
    var appointmentIsSuccess: Bool = false
    var reminderIsSet: Bool = false
    var actionButtonCommand: actionButtonTypes = .dashboard
    private var statusLabel: UILabel?
    private var subtitleLabel: UILabel?
    private var actionButton: UIButtonVariableBackgroundVariableCR?
    let generator = UINotificationFeedbackGenerator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialise()
        setupUI()
        setConstraints()
        
        animationView!.play() { (finished) in
            UIView.animate(withDuration: 0.7, delay: 0.0, options: UIView.AnimationOptions.transitionCrossDissolve, animations: {
                self.statusLabel?.alpha = 1
                self.subtitleLabel?.alpha = 1
                self.actionButton?.alpha = 1
                
            }, completion: {
                (finished: Bool) -> Void in
            })
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            self.appointmentIsSuccess ? self.generator.notificationOccurred(.success) : self.generator.notificationOccurred(.error)
        }
    }
    
    func initialise() {
    }
    
    func setupUI() {
        statusLabel = UILabel()
        statusLabel?.textColor = .black
        statusLabel?.textAlignment = .center
        statusLabel?.font = UIFont(name: "NunitoSans-ExtraBold", size: 20)
        statusLabel?.numberOfLines = 0
        statusLabel?.alpha = 0
        
        subtitleLabel = UILabel()
        subtitleLabel?.textColor = .black
        subtitleLabel?.textAlignment = .center
        subtitleLabel?.font = UIFont(name: "NunitoSans-Regular", size: 14)
        subtitleLabel?.numberOfLines = 0
        subtitleLabel?.alpha = 0
        
        if appointmentIsSuccess {
            animationView = .init(name: "checkMarkSuccess")
            animationView!.animationSpeed = 0.8
            statusLabel?.text = "Your appointment has been booked successfully!"
            subtitleLabel?.text = reminderIsSet ? "We've set a reminder in your default calendar app to remind you on the day of appointment." : "Thank you for choosing us."
        } else {
            animationView = .init(name: "errorFailure")
            animationView!.animationSpeed = 1.0
            statusLabel?.text = "Sorry! We couldn't confirm your appointment at this moment."
            subtitleLabel?.text = "Please try again after some time. We appreciate your patience."
        }
        animationView!.frame = view.bounds
        animationView!.contentMode = .scaleAspectFit
        animationView!.loopMode = .playOnce
        view.addSubview(animationView!)
        view.addSubview(statusLabel!)
        view.addSubview(subtitleLabel!)
            
        actionButton = UIButtonVariableBackgroundVariableCR()
        actionButton?.initButton(title: (actionButtonCommand == .dashboard) ? "Back to Dashboard" : "Go Back", cornerRadius: 10, variant: .blackBack)
        view.addSubview(actionButton!)
        actionButton?.addTarget(self, action: (actionButtonCommand == .dashboard) ? #selector(goToHome) : #selector(goBack), for: .touchUpInside)
        actionButton?.alpha = 0
    }
    
    func setConstraints() {
        animationView?.translatesAutoresizingMaskIntoConstraints = false
        statusLabel?.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel?.translatesAutoresizingMaskIntoConstraints = false
        actionButton?.translatesAutoresizingMaskIntoConstraints = false
        
        
        animationView?.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        animationView?.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100).isActive = true
        animationView?.heightAnchor.constraint(equalToConstant: view.frame.width/2).isActive = true
        animationView?.widthAnchor.constraint(equalToConstant: view.frame.width/2).isActive = true
        
        statusLabel?.topAnchor.constraint(equalTo: animationView!.bottomAnchor, constant: 15).isActive = true
        statusLabel?.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        statusLabel?.widthAnchor.constraint(equalToConstant: view.frame.width - 20).isActive = true
        
        subtitleLabel?.topAnchor.constraint(equalTo: statusLabel!.bottomAnchor, constant: 10).isActive = true
        subtitleLabel?.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        subtitleLabel?.widthAnchor.constraint(equalToConstant: view.frame.width - 20).isActive = true
        
        actionButton?.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        actionButton?.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 27).isActive = true
        actionButton?.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -27).isActive = true
        actionButton?.heightAnchor.constraint(equalToConstant: 56).isActive = true
    }
    
    @objc func goToHome() {
        self.dismiss(animated: true) {
            NotificationCenter.default.post(name: Notification.Name("goToDashboard"), object: nil)
        }
    }
    
    @objc func goBack() {
        self.dismiss(animated: true)
    }
    
}
