//
//  RatingAndReviewsViewController.swift
//  Medonapp iOS
//
//  Created by Harshal Kulkarni on 04/04/23.
//

import UIKit

class RatingAndReviewsViewController: UIViewController {
    
    private var backButton: UIImageView?
    private var navTitle: UILabel?
    
    private var ratingsWithStarsView: RatingsWithStarsView?
    private var reviewsTable: UITableView?
    private var reviewsTableHeightConstraint: NSLayoutConstraint?
    
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
        
        reviewsTable?.register(ReviewExpandedTableViewCell.nib(), forCellReuseIdentifier: ReviewExpandedTableViewCell.identifier)
        reviewsTable?.delegate = self
        reviewsTable?.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        populateReviewsTable()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        populateRatingsWithStarsView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        ratingsWithStarsView?.ratingLabel.text = "0.0"
        ratingsWithStarsView?.oneStarProgressBar.progress = 0.25
        ratingsWithStarsView?.twoStarProgressBar.progress = 0.25
        ratingsWithStarsView?.threeStarProgressBar.progress = 0.25
        ratingsWithStarsView?.fourStarProgressBar.progress = 0.25
        ratingsWithStarsView?.fiveStarProgressBar.progress = 0.25
    }
    
    func initialise() {
    }
    
    func setupUI() {
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
        view.addSubview(navTitle!)
        
        ratingsWithStarsView = RatingsWithStarsView.shared
//        ratingsWithStarsView?.ratingLabel.text = String(format: "%.1f", doctor?.avgRating ?? 0)
        ratingsWithStarsView?.numberOfRatingsLabel.text = "\(reviews.count) ratings"
        view.addSubview(ratingsWithStarsView!)
        
        reviewsTable = UITableView()
        reviewsTable?.separatorStyle = .none
        reviewsTable?.rowHeight = UITableView.automaticDimension
        reviewsTable?.estimatedRowHeight = 100
        reviewsTable?.showsVerticalScrollIndicator = false
        view.addSubview(reviewsTable!)
    }
    
    func setConstraints() {
        backButton?.translatesAutoresizingMaskIntoConstraints = false
        navTitle?.translatesAutoresizingMaskIntoConstraints = false
        ratingsWithStarsView?.translatesAutoresizingMaskIntoConstraints = false
        reviewsTable?.translatesAutoresizingMaskIntoConstraints = false
        
        
        backButton?.topAnchor.constraint(equalTo: view.topAnchor, constant: 65).isActive = true
        backButton?.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 28).isActive = true
        backButton?.widthAnchor.constraint(equalToConstant: 50).isActive = true
        backButton?.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        navTitle?.topAnchor.constraint(equalTo: backButton!.bottomAnchor, constant: 28).isActive = true
        navTitle?.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 28).isActive = true
        navTitle?.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -28).isActive = true
        
        ratingsWithStarsView?.topAnchor.constraint(equalTo: navTitle!.bottomAnchor, constant: 25).isActive = true
        ratingsWithStarsView?.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        ratingsWithStarsView?.widthAnchor.constraint(equalToConstant: view.frame.width - 40).isActive = true
        ratingsWithStarsView?.heightAnchor.constraint(equalToConstant: 110).isActive = true
        
        reviewsTable?.topAnchor.constraint(equalTo: ratingsWithStarsView!.bottomAnchor, constant: 0).isActive = true
        reviewsTable?.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15).isActive = true
        reviewsTable?.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15).isActive = true
        reviewsTable?.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true
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
    
    func populateReviewsTable() {
        self.reviewsTable?.reloadData()
    }
}

extension RatingAndReviewsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return reviews.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 3
    }
    
    // Make the background color show through
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell = tableView.dequeueReusableCell(withIdentifier: ReviewExpandedTableViewCell.identifier, for: indexPath) as! ReviewExpandedTableViewCell
        
        tableCell.configure(review: reviews[indexPath.section])
        tableCell.layer.cornerRadius = 15
        tableCell.clipsToBounds = true
        tableCell.backgroundColor = UIColor(red: 0.93, green: 0.96, blue: 0.99, alpha: 1.00)
        return tableCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        reviewsTable?.scrollToRow(at: indexPath, at: .middle, animated: true)
        reviewsTable?.deselectRow(at: indexPath, animated: true)
    }
    
    
}
