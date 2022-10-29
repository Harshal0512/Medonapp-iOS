//
//  AppointmentDetailsViewController.swift
//  Medonapp iOS
//
//  Created by Harshal Kulkarni on 14/10/22.
//

import UIKit
import Kingfisher

class AppointmentDetailsViewController: UIViewController, UITextViewDelegate {
    
    private var backButton: UIImageView?
    private var priceLabel: PriceDisplayViewAppointmentDetails?
    private var scrollView: UIScrollView?
    private var contentView: UIView?
    private var doctorImage: UIImageView?
    private var doctorName: UILabel?
    private var designation: UILabel?
    private var starIcon: UIImageView?
    private var ratingLabel: UILabel?
    private var numberOfReviews: UILabel?
    private var symptomsLabel: UILabel?
    private var symptomsTextView: UITextViewWithPlaceholder_CR8?
    private var bookNowButton: UIButtonVariableBackgroundVariableCR?
    
    public var doctor: Doctor?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dismissKeyboard()

        initialise()
        setupUI()
        setConstraints()
    }
    
    func initialise() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func setupUI() {
        backButton = UIImageView()
        backButton?.image = UIImage(named: "backIcon_White")?.resizeImageTo(size: CGSize(width: 50, height: 50))
        backButton?.contentMode = .scaleAspectFit
        view.addSubview(backButton!)
        let backTap = UITapGestureRecognizer(target: self, action: #selector(self.handleBackAction(_:)))
        backButton?.addGestureRecognizer(backTap)
        backButton?.isUserInteractionEnabled = true
        
        priceLabel = PriceDisplayViewAppointmentDetails.instantiate(price: "\(doctor!.fees ?? 0)")
        view?.addSubview(priceLabel!)
        
        scrollView = UIScrollView()
        contentView = UIView()
        
        view.addSubview(scrollView!)
        scrollView?.addSubview(contentView!)
        
        doctorImage = UIImageView()
        KF.url(URL(string: (doctor?.profileImage?.fileDownloadURI ?? "https://i.ibb.co/jHvKxC3/broken-1.jpg")))
            .placeholder(UIImage(named: (doctor?.gender!.lowercased() == "male") ? "userPlaceholder-male" : "userPlaceholder-female"))
            .loadDiskFileSynchronously()
            .cacheMemoryOnly()
            .fade(duration: 0.25)
            .onProgress { receivedSize, totalSize in  }
            .onSuccess { result in  }
            .onFailure { error in }
            .set(to: self.doctorImage!)
        doctorImage?.contentMode = .scaleAspectFill
        doctorImage?.makeRoundCorners(byRadius: 26)
        contentView?.addSubview(doctorImage!)
        
        doctorName = UILabel()
        doctorName?.text = (doctor?.name?.firstName ?? "") + " " + (doctor?.name?.lastName ?? "")
        doctorName?.numberOfLines = 1
        doctorName?.font = UIFont(name: "NunitoSans-Bold", size: 22)
        doctorName?.textColor = .black
        doctorName?.textAlignment = .center
        contentView?.addSubview(doctorName!)
        
        designation = UILabel()
        designation?.text = doctor!.specialization!
        designation?.numberOfLines = 1
        designation?.font = UIFont(name: "NunitoSans-Regular", size: 14)
        designation?.textColor = UIColor(red: 0.48, green: 0.55, blue: 0.62, alpha: 1.00)
        designation?.textAlignment = .center
        contentView?.addSubview(designation!)
        
        starIcon = UIImageView()
        starIcon?.image = UIImage(named: "starIcon")
        starIcon?.contentMode = .scaleAspectFit
        contentView?.addSubview(starIcon!)
        
        ratingLabel = UILabel()
        ratingLabel?.text = "\(doctor?.avgRating ?? 0)"
        ratingLabel?.textColor = .black
        ratingLabel?.textAlignment = .center
        ratingLabel?.font = UIFont(name: "NunitoSans-Bold", size: 16)
        contentView?.addSubview(ratingLabel!)
        
        numberOfReviews = UILabel()
        numberOfReviews?.text = "(\(doctor?.reviewCount ?? 0) reviews)"
        numberOfReviews?.textColor = UIColor(red: 0.29, green: 0.33, blue: 0.37, alpha: 1.00)
        numberOfReviews?.font = UIFont(name: "NunitoSans-Regular", size: 14)
        contentView?.addSubview(numberOfReviews!)
        
        symptomsLabel = UILabel()
        symptomsLabel?.text = "Enter your Symptoms"
        symptomsLabel?.textColor = .black
        symptomsLabel?.font = UIFont(name: "NunitoSans-ExtraBold", size: 16)
        contentView?.addSubview(symptomsLabel!)
        
        symptomsTextView = UITextViewWithPlaceholder_CR8()
        symptomsTextView?.setupUI(backgroundColor: UIColor(red: 0.93, green: 0.96, blue: 0.99, alpha: 1.00))
        symptomsTextView?.delegate = self
        contentView?.addSubview(symptomsTextView!)
        
        bookNowButton = UIButtonVariableBackgroundVariableCR()
        bookNowButton?.initButton(title: "Book Now", cornerRadius: 14, variant: .blueBack)
        contentView?.addSubview(bookNowButton!)
        bookNowButton?.addTarget(self, action: #selector(bookNowButtonPressed), for: .touchUpInside)
    }
    
    func setConstraints() {
        backButton?.translatesAutoresizingMaskIntoConstraints = false
        priceLabel?.translatesAutoresizingMaskIntoConstraints = false
        scrollView?.translatesAutoresizingMaskIntoConstraints = false
        contentView?.translatesAutoresizingMaskIntoConstraints = false
        doctorImage?.translatesAutoresizingMaskIntoConstraints = false
        doctorName?.translatesAutoresizingMaskIntoConstraints = false
        designation?.translatesAutoresizingMaskIntoConstraints = false
        starIcon?.translatesAutoresizingMaskIntoConstraints = false
        ratingLabel?.translatesAutoresizingMaskIntoConstraints = false
        numberOfReviews?.translatesAutoresizingMaskIntoConstraints = false
        symptomsLabel?.translatesAutoresizingMaskIntoConstraints = false
        symptomsTextView?.translatesAutoresizingMaskIntoConstraints = false
        bookNowButton?.translatesAutoresizingMaskIntoConstraints = false
        
        
        backButton?.topAnchor.constraint(equalTo: view.topAnchor, constant: 65).isActive = true
        backButton?.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 28).isActive = true
        backButton?.widthAnchor.constraint(equalToConstant: 50).isActive = true
        backButton?.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        priceLabel?.topAnchor.constraint(equalTo: view.topAnchor, constant: 70).isActive = true
        priceLabel?.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -28).isActive = true
        priceLabel?.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
        
        scrollView?.topAnchor.constraint(equalTo: backButton!.bottomAnchor, constant: 10).isActive = true
        scrollView?.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        scrollView?.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        scrollView?.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        
        contentView?.topAnchor.constraint(equalTo: scrollView!.topAnchor).isActive = true
        contentView?.leadingAnchor.constraint(equalTo: scrollView!.leadingAnchor).isActive = true
        contentView?.trailingAnchor.constraint(equalTo: scrollView!.trailingAnchor).isActive = true
        contentView?.bottomAnchor.constraint(equalTo: scrollView!.bottomAnchor).isActive = true
        contentView?.widthAnchor.constraint(equalTo: scrollView!.widthAnchor).isActive = true
        
        doctorImage?.topAnchor.constraint(equalTo: contentView!.topAnchor, constant: 43).isActive = true
        doctorImage?.centerXAnchor.constraint(equalTo: contentView!.centerXAnchor).isActive = true
        doctorImage?.widthAnchor.constraint(equalToConstant: 104).isActive = true
        doctorImage?.heightAnchor.constraint(equalToConstant: 104).isActive = true
        
        doctorName?.topAnchor.constraint(equalTo: doctorImage!.bottomAnchor, constant: 22).isActive = true
        doctorName?.leadingAnchor.constraint(equalTo: contentView!.leadingAnchor, constant: 27).isActive = true
        doctorName?.trailingAnchor.constraint(equalTo: contentView!.trailingAnchor, constant: -27).isActive = true
        
        designation?.topAnchor.constraint(equalTo: doctorName!.bottomAnchor, constant: 6).isActive = true
        designation?.leadingAnchor.constraint(equalTo: contentView!.leadingAnchor, constant: 27).isActive = true
        designation?.trailingAnchor.constraint(equalTo: contentView!.trailingAnchor, constant: -27).isActive = true
        
        starIcon?.topAnchor.constraint(equalTo: designation!.bottomAnchor, constant: 13.5).isActive = true
        starIcon?.centerXAnchor.constraint(equalTo: contentView!.centerXAnchor, constant: -60).isActive = true
        starIcon?.widthAnchor.constraint(equalToConstant: 15).isActive = true
        starIcon?.heightAnchor.constraint(equalToConstant: 15).isActive = true
        
        ratingLabel?.topAnchor.constraint(equalTo: designation!.bottomAnchor, constant: 11).isActive = true
        ratingLabel?.leadingAnchor.constraint(equalTo: starIcon!.trailingAnchor, constant: 8).isActive = true
        
        numberOfReviews?.topAnchor.constraint(equalTo: designation!.bottomAnchor, constant: 12).isActive = true
        numberOfReviews?.leadingAnchor.constraint(equalTo: ratingLabel!.trailingAnchor, constant: 5).isActive = true
        
        symptomsLabel?.topAnchor.constraint(equalTo: starIcon!.bottomAnchor, constant: 35).isActive = true
        symptomsLabel?.leadingAnchor.constraint(equalTo: contentView!.leadingAnchor, constant: 27).isActive = true
        symptomsLabel?.trailingAnchor.constraint(equalTo: contentView!.trailingAnchor, constant: -27).isActive = true
        
        symptomsTextView?.topAnchor.constraint(equalTo: symptomsLabel!.bottomAnchor, constant: 10).isActive = true
        symptomsTextView?.leadingAnchor.constraint(equalTo: contentView!.leadingAnchor, constant: 27).isActive = true
        symptomsTextView?.trailingAnchor.constraint(equalTo: contentView!.trailingAnchor, constant: -27).isActive = true
        symptomsTextView?.heightAnchor.constraint(equalToConstant: 152).isActive = true
        
        bookNowButton?.topAnchor.constraint(equalTo: symptomsTextView!.bottomAnchor, constant: 49).isActive = true
        bookNowButton?.leadingAnchor.constraint(equalTo: contentView!.leadingAnchor, constant: 27).isActive = true
        bookNowButton?.trailingAnchor.constraint(equalTo: contentView!.trailingAnchor, constant: -27).isActive = true
        bookNowButton?.heightAnchor.constraint(equalToConstant: 56).isActive = true
        bookNowButton?.bottomAnchor.constraint(equalTo: contentView!.bottomAnchor, constant: -20).isActive = true
    }
    
    @objc func handleBackAction(_ sender: UITapGestureRecognizer? = nil) {
        navigationController?.popViewController(animated: true)
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

    @objc func bookNowButtonPressed() {
        let bookAppointmentVC = UIStoryboard.init(name: "HomeTab", bundle: Bundle.main).instantiateViewController(withIdentifier: "bookAppointmentVC") as? BookAppointmentViewController
        bookAppointmentVC?.symptoms = symptomsTextView?.text ?? ""
        bookAppointmentVC?.doctor = self.doctor
        self.navigationController?.pushViewController(bookAppointmentVC!, animated: true)
    }
}
