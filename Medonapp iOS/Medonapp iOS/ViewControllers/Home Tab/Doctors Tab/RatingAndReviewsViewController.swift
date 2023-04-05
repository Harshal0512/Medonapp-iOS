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
    
    public var doctor: Doctor?
    public var reviews: Reviews = []

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationItem.largeTitleDisplayMode = .never
        navigationController?.isNavigationBarHidden = true
        
        initialise()
        setupUI()
        setConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        populateRatingsWithStarsView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        ratingsWithStarsView?.oneStarProgressBar.progress = 0.25
        ratingsWithStarsView?.twoStarProgressBar.progress = 0.25
        ratingsWithStarsView?.threeStarProgressBar.progress = 0.25
        ratingsWithStarsView?.fourStarProgressBar.progress = 0.25
        ratingsWithStarsView?.fiveStarProgressBar.progress = 0.25
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
//        ratingsWithStarsView?.ratingLabel.text = String(format: "%.1f", doctor?.avgRating ?? 0)
        ratingsWithStarsView?.numberOfRatingsLabel.text = "\(reviews.count) ratings"
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
    
    func populateRatingsWithStarsView() {
        var oneStarCount, twoStarCount, threeStarCount, fourStarCount, fiveStarCount: Int
        oneStarCount = 0; twoStarCount = 0; threeStarCount = 0; fourStarCount = 0; fiveStarCount = 0
    
        for review in reviews {
            switch review.rating {
            case 0.5, 1:
                oneStarCount+=1
            case 1.5, 2:
                twoStarCount+=1
            case 2.5, 3:
                threeStarCount+=1
            case 3.5, 4:
                fourStarCount+=1
            case 4.5, 5:
                fiveStarCount+=1
            default:
                break
            }
        }
        
        ratingsWithStarsView?.ratingLabel.countFromZero(to: CGFloat(doctor!.avgRating!))
        
        ratingsWithStarsView?.oneStarProgressBar.setProgress(Float(oneStarCount)/Float(reviews.count), animated: true)
        ratingsWithStarsView?.twoStarProgressBar.setProgress(Float(twoStarCount)/Float(reviews.count), animated: true)
        ratingsWithStarsView?.threeStarProgressBar.setProgress(Float(threeStarCount)/Float(reviews.count), animated: true)
        ratingsWithStarsView?.fourStarProgressBar.setProgress(Float(fourStarCount)/Float(reviews.count), animated: true)
        ratingsWithStarsView?.fiveStarProgressBar.setProgress(Float(fiveStarCount)/Float(reviews.count), animated: true)
    }
}
