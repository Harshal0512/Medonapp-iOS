//
//  RatingHalfScreenViewController.swift
//  Medonapp iOS
//
//  Created by Harshal Kulkarni on 20/10/22.
//

import UIKit

protocol RatingHalfScreenDelegate {
    func feedbackClosed(isSuccess: Bool)
}

class RatingHalfScreenViewController: UIViewController {
    
    private var backButton: UIImageView?
    private var scrollView: UIScrollView?
    private var contentView: UIView?
    private var vcTitle: UILabel?
    private var ratingControl: JStarRatingView?
    private var feedbackTextView: UITextViewWithPlaceholder_CR8?
    private var submitButton: UIButton?

    public var appointment: AppointmentElement?
    
    var delegate: RatingHalfScreenDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dismissKeyboard()

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

    func initialise() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func setupUI() {
        view.backgroundColor = UIColor(red: 0.11, green: 0.42, blue: 0.64, alpha: 1.00)
        
        backButton = UIImageView()
        backButton?.image = UIImage(named: "backIcon_Transparent")?.resizeImageTo(size: CGSize(width: 50, height: 50))
        backButton?.contentMode = .scaleAspectFit
        view?.addSubview(backButton!)
        let backTap = UITapGestureRecognizer(target: self, action: #selector(self.handleBackAction(_:)))
        backButton?.addGestureRecognizer(backTap)
        backButton?.isUserInteractionEnabled = true
        
        scrollView = UIScrollView()
        contentView = UIView()
        
        view.addSubview(scrollView!)
        scrollView?.addSubview(contentView!)
        contentView?.backgroundColor = .clear
        
        vcTitle = UILabel()
        vcTitle?.text = "Rate Your Experience"
        vcTitle?.font = UIFont(name: "NunitoSans-ExtraBold", size: 24)
        vcTitle?.textColor = .white
        contentView?.addSubview(vcTitle!)
        
        ratingControl = JStarRatingView(frame: CGRect(origin: .zero, size: CGSize(width: 250, height: 50)), rating: 0.5, color: UIColor.systemOrange, starRounding: .roundToHalfStar)
        contentView?.addSubview(ratingControl!)
        
        feedbackTextView = UITextViewWithPlaceholder_CR8()
        feedbackTextView?.text = ""
        feedbackTextView?.autocapitalizationType = .sentences
        feedbackTextView?.autocorrectionType = .yes
        feedbackTextView?.keyboardType = .default
        feedbackTextView?.delegate = self
        contentView?.addSubview(feedbackTextView!)
        
        submitButton = UIButton()
        submitButton?.backgroundColor = .white
        submitButton?.titleLabel?.font = UIFont(name: "NunitoSans-Bold", size: 14)
        submitButton?.layer.cornerRadius = 14
        submitButton?.setTitle("Submit Feedback", for: .normal)
        submitButton?.layer.borderWidth = 0
        submitButton?.setTitleColor(UIColor(red: 0.11, green: 0.42, blue: 0.64, alpha: 1.00), for: .normal)
        submitButton?.setImage(nil, for: .normal)
        submitButton?.isUserInteractionEnabled = true
        contentView?.addSubview(submitButton!)
        submitButton?.addTarget(self, action: #selector(handleSubmitAction), for: .touchUpInside)
    }
    
    func setConstraints() {
        backButton?.translatesAutoresizingMaskIntoConstraints = false
        scrollView?.translatesAutoresizingMaskIntoConstraints = false
        contentView?.translatesAutoresizingMaskIntoConstraints = false
        vcTitle?.translatesAutoresizingMaskIntoConstraints = false
        ratingControl?.translatesAutoresizingMaskIntoConstraints = false
        feedbackTextView?.translatesAutoresizingMaskIntoConstraints = false
        submitButton?.translatesAutoresizingMaskIntoConstraints = false
        
        
        backButton?.topAnchor.constraint(equalTo: view.topAnchor, constant: 25).isActive = true
        backButton?.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 28).isActive = true
        backButton?.widthAnchor.constraint(equalToConstant: 50).isActive = true
        backButton?.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        scrollView?.topAnchor.constraint(equalTo: backButton!.bottomAnchor, constant: 0).isActive = true
        scrollView?.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        scrollView?.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        scrollView?.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        
        contentView?.topAnchor.constraint(equalTo: scrollView!.topAnchor).isActive = true
        contentView?.leadingAnchor.constraint(equalTo: scrollView!.leadingAnchor).isActive = true
        contentView?.trailingAnchor.constraint(equalTo: scrollView!.trailingAnchor).isActive = true
        contentView?.bottomAnchor.constraint(equalTo: scrollView!.bottomAnchor).isActive = true
        contentView?.widthAnchor.constraint(equalTo: scrollView!.widthAnchor).isActive = true
        
        vcTitle?.topAnchor.constraint(equalTo: contentView!.topAnchor, constant: 20).isActive = true
        vcTitle?.leadingAnchor.constraint(equalTo: contentView!.leadingAnchor, constant: 28).isActive = true
        vcTitle?.trailingAnchor.constraint(equalTo: contentView!.trailingAnchor, constant: -28).isActive = true
        
        ratingControl?.topAnchor.constraint(equalTo: vcTitle!.bottomAnchor, constant: 20).isActive = true
        ratingControl?.centerXAnchor.constraint(equalTo: contentView!.centerXAnchor).isActive = true
        ratingControl?.widthAnchor.constraint(equalToConstant: 250).isActive = true
        ratingControl?.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        feedbackTextView?.topAnchor.constraint(equalTo: ratingControl!.bottomAnchor, constant: 20).isActive = true
        feedbackTextView?.leadingAnchor.constraint(equalTo: contentView!.leadingAnchor, constant: 28).isActive = true
        feedbackTextView?.trailingAnchor.constraint(equalTo: contentView!.trailingAnchor, constant: -28).isActive = true
        feedbackTextView?.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        submitButton?.topAnchor.constraint(equalTo: feedbackTextView!.bottomAnchor, constant: 30).isActive = true
        submitButton?.leadingAnchor.constraint(equalTo: contentView!.leadingAnchor, constant: 28).isActive = true
        submitButton?.trailingAnchor.constraint(equalTo: contentView!.trailingAnchor, constant: -28).isActive = true
        submitButton?.bottomAnchor.constraint(equalTo: contentView!.bottomAnchor, constant: -10).isActive = true
        submitButton?.heightAnchor.constraint(equalToConstant: 56).isActive = true
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
    
    @objc func handleBackAction(_ sender: UITapGestureRecognizer? = nil) {
//        navigationController?.popViewController(animated: true)
        self.dismiss(animated: true)
    }
    
    @objc func handleSubmitAction() {
        view.isUserInteractionEnabled = false
        view.makeToastActivity(.center)
        
        var rating = ratingControl!.rating
        
        if rating <= 0.5 {
            rating = 0.5
        } else if rating > 5 {
            rating = 5
        }
        
        APIService(data: ["appointmentId": appointment!.id!,
                          "rating": rating,
                          "review": feedbackTextView!.text!],
                   headers: ["Authorization" : "Bearer \(User.getUserDetails().token ?? "")"],
                   url: nil,
                   service: .postReview,
                   method: .post,
                   isJSONRequest: true).executeQuery() { (result: Result<Review, Error>) in
            switch result{
            case .success(_):
                self.delegate.feedbackClosed(isSuccess: true)
                self.dismiss(animated: true)
            case .failure(let error):
                print(error)
                self.delegate.feedbackClosed(isSuccess: false)
                self.dismiss(animated: true)
            }
        }
    }
}

extension RatingHalfScreenViewController: UITextFieldDelegate, UITextViewDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
