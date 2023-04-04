//
//  RatingAndReviewsViewController.swift
//  Medonapp iOS
//
//  Created by Harshal Kulkarni on 04/04/23.
//

import UIKit

class RatingAndReviewsViewController: UIViewController {
    
    private var scrollView: UIScrollView?
    private var contentView: UIView?
    
    private var backButton: UIImageView?
    private var navTitle: UILabel?
    
    private var ratingsWithStarsView: RatingsWithStarsView?

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationItem.largeTitleDisplayMode = .never
        navigationController?.isNavigationBarHidden = true
        
        initialise()
        setupUI()
        setConstraints()
    }
    
    func initialise() {
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
        
        navTitle = UILabel()
        navTitle?.text = "Ratings & Reviews"
        navTitle?.textAlignment = .left
        navTitle?.textColor = .black
        navTitle?.font = UIFont(name: "NunitoSans-Bold", size: 27)
        contentView?.addSubview(navTitle!)
        
        ratingsWithStarsView = RatingsWithStarsView.shared
        contentView?.addSubview(ratingsWithStarsView!)
    }
    
    func setConstraints() {
        scrollView?.translatesAutoresizingMaskIntoConstraints = false
        contentView?.translatesAutoresizingMaskIntoConstraints = false
        
        backButton?.translatesAutoresizingMaskIntoConstraints = false
        navTitle?.translatesAutoresizingMaskIntoConstraints = false
        ratingsWithStarsView?.translatesAutoresizingMaskIntoConstraints = false
        
        
        backButton?.topAnchor.constraint(equalTo: view.topAnchor, constant: 65).isActive = true
        backButton?.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 28).isActive = true
        backButton?.widthAnchor.constraint(equalToConstant: 50).isActive = true
        backButton?.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        scrollView?.topAnchor.constraint(equalTo: backButton!.bottomAnchor, constant: 10).isActive = true
        scrollView?.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        scrollView?.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        scrollView?.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        
        contentView?.topAnchor.constraint(equalTo: scrollView!.topAnchor).isActive = true
        contentView?.leadingAnchor.constraint(equalTo: scrollView!.leadingAnchor).isActive = true
        contentView?.trailingAnchor.constraint(equalTo: scrollView!.trailingAnchor).isActive = true
        contentView?.bottomAnchor.constraint(equalTo: scrollView!.bottomAnchor).isActive = true
        contentView?.widthAnchor.constraint(equalTo: scrollView!.widthAnchor).isActive = true
        
        
        navTitle?.topAnchor.constraint(equalTo: contentView!.topAnchor, constant: 18).isActive = true
        navTitle?.leadingAnchor.constraint(equalTo: contentView!.leadingAnchor, constant: 28).isActive = true
        navTitle?.trailingAnchor.constraint(equalTo: contentView!.trailingAnchor, constant: -28).isActive = true
        
        ratingsWithStarsView?.topAnchor.constraint(equalTo: navTitle!.bottomAnchor, constant: 25).isActive = true
        ratingsWithStarsView?.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        ratingsWithStarsView?.widthAnchor.constraint(equalToConstant: 300).isActive = true
        ratingsWithStarsView?.heightAnchor.constraint(equalToConstant: 110).isActive = true
    }
    
    @objc func handleBackAction(_ sender: UITapGestureRecognizer? = nil) {
        navigationController?.popViewController(animated: true)
    }
}
