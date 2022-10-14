//
//  ContactDoctorViewController.swift
//  Medonapp iOS
//
//  Created by Harshal Kulkarni on 13/10/22.
//

import UIKit
import MessageUI

class ContactDoctorViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    private var contentView: UIView?
    private var navTitle: UILabel?
    private var callTab: TabViewInContactScreen?
    private var mailTab: TabViewInContactScreen?
    private var whatsappTab: TabViewInContactScreen?
    private var shareButton: UIButtonVariableBackgroundVariableCR?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let presentationController = presentationController as? UISheetPresentationController {
            presentationController.detents = [
                .medium()
            ]
            presentationController.prefersGrabberVisible = true
            presentationController.preferredCornerRadius = 35
            presentationController.largestUndimmedDetentIdentifier = .none
        }
        
        initialise()
        setupUI()
        setConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    func initialise() {
    }
    
    func setupUI() {
        contentView = UIView()
        view.addSubview(contentView!)
        contentView?.backgroundColor = .white
        
        navTitle = UILabel()
        navTitle?.text = "Contact"
        navTitle?.textColor = .black
        navTitle!.font = UIFont(name: "NunitoSans-ExtraBold", size: 24)
        contentView?.addSubview(navTitle!)
        
        callTab = TabViewInContactScreen.instantiate(icon: UIImage(systemName: "phone")!, title: "Call")
        contentView?.addSubview(callTab!)
        let callTap = UITapGestureRecognizer(target: self, action: #selector(self.handleCallAction))
        callTab?.addGestureRecognizer(callTap)
        callTab?.isUserInteractionEnabled = true
        
        mailTab = TabViewInContactScreen.instantiate(icon: UIImage(named: "mailIcon")!.resizeImageTo(size: CGSize(width: 38, height: 28))!, title: "Email")
        contentView?.addSubview(mailTab!)
        let mailTap = UITapGestureRecognizer(target: self, action: #selector(self.handleMailAction))
        mailTab?.addGestureRecognizer(mailTap)
        mailTab?.isUserInteractionEnabled = true
        
        whatsappTab = TabViewInContactScreen.instantiate(icon: UIImage(named: "whatsappIcon")!.resizeImageTo(size: CGSize(width: 36, height: 36))!, title: "WhatsApp")
        contentView?.addSubview(whatsappTab!)
        let whatsappTap = UITapGestureRecognizer(target: self, action: #selector(self.handleWhatsAppAction))
        whatsappTab?.addGestureRecognizer(whatsappTap)
        whatsappTab?.isUserInteractionEnabled = true
        
        shareButton = UIButtonVariableBackgroundVariableCR()
        shareButton?.initButton(title: "Share Doctor Profile", cornerRadius: 14, variant: .blueBack)
        contentView?.addSubview(shareButton!)
        shareButton?.addTarget(self, action:#selector(openShareSheet), for: .touchUpInside)
    }
    
    func setConstraints() {
        contentView?.translatesAutoresizingMaskIntoConstraints = false
        navTitle?.translatesAutoresizingMaskIntoConstraints = false
        callTab?.translatesAutoresizingMaskIntoConstraints = false
        mailTab?.translatesAutoresizingMaskIntoConstraints = false
        whatsappTab?.translatesAutoresizingMaskIntoConstraints = false
        shareButton?.translatesAutoresizingMaskIntoConstraints = false
        
        
        contentView?.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        contentView?.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        contentView?.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        contentView?.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        navTitle?.topAnchor.constraint(equalTo: contentView!.topAnchor, constant: 35).isActive = true
        navTitle?.leadingAnchor.constraint(equalTo: contentView!.leadingAnchor, constant: 27).isActive = true
        navTitle?.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        callTab?.topAnchor.constraint(equalTo: navTitle!.bottomAnchor, constant: 20).isActive = true
        callTab?.leadingAnchor.constraint(equalTo: contentView!.leadingAnchor, constant: 27).isActive = true
        
        mailTab?.topAnchor.constraint(equalTo: callTab!.topAnchor).isActive = true
        mailTab?.leadingAnchor.constraint(equalTo: callTab!.trailingAnchor, constant: 20).isActive = true
        
        whatsappTab?.topAnchor.constraint(equalTo: callTab!.topAnchor).isActive = true
        whatsappTab?.leadingAnchor.constraint(equalTo: mailTab!.trailingAnchor, constant: 20).isActive = true
        whatsappTab?.trailingAnchor.constraint(equalTo: contentView!.trailingAnchor, constant: -27).isActive = true
        
        mailTab?.widthAnchor.constraint(equalTo: callTab!.widthAnchor).isActive = true
        whatsappTab?.widthAnchor.constraint(equalTo: mailTab!.widthAnchor).isActive = true
        
        callTab?.heightAnchor.constraint(equalToConstant: 130).isActive = true
        mailTab?.heightAnchor.constraint(equalTo: callTab!.heightAnchor).isActive = true
        whatsappTab?.heightAnchor.constraint(equalTo: mailTab!.heightAnchor).isActive = true
        
        shareButton?.topAnchor.constraint(equalTo: callTab!.bottomAnchor, constant: 40).isActive = true
        shareButton?.leadingAnchor.constraint(equalTo: contentView!.leadingAnchor, constant: 27).isActive = true
        shareButton?.trailingAnchor.constraint(equalTo: contentView!.trailingAnchor, constant: -27).isActive = true
        shareButton?.bottomAnchor.constraint(lessThanOrEqualTo: contentView!.bottomAnchor, constant: -15).isActive = true
        shareButton?.heightAnchor.constraint(equalToConstant: 56).isActive = true
    }
    
    @objc func openShareSheet() {
        // text to share
        let text = "This is some text that I want to share."
        
        // set up activity view controller
        let textToShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ ]
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    @objc func handleCallAction() {
        Utils.dialNumber(number: "+919993299444")
    }
    
    @objc func handleMailAction() {
        // Modify following variables with your text / recipient
        let recipientEmail = "test@email.com"
        let subject = "Send Email to Doctor"
        let body = """
        Greetings Doctor,
        
        List of Symptoms
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
    
    @objc func handleWhatsAppAction() {
        Utils.openWhatsApp(numberWithCountryCode: "+918982092922")
    }
}
