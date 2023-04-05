//
//  ReviewCarouselCollectionViewCell.swift
//  Medonapp iOS
//
//  Created by Harshal Kulkarni on 04/04/23.
//

import UIKit

class ReviewCarouselCollectionViewCell: UICollectionViewCell {
    
    // MARK: - SubViews
    
    private lazy var userProfileImageView = UIImageView()
    private lazy var nameLabel = UILabel()
    private lazy var ratingControl = JStarRatingView(frame: CGRect(origin: .zero, size: CGSize(width: 75, height: 15)), rating: 0.5, color: UIColor.systemOrange, starRounding: .roundToHalfStar)
    private lazy var reviewLabel = UILabel()
    
    // MARK: - Properties
    
    static let cellId = "CarouselCell"
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
}

// MARK: - Setups
private extension ReviewCarouselCollectionViewCell {
    func setupUI() {
        backgroundColor = .clear
        
        addSubview(userProfileImageView)
        userProfileImageView.translatesAutoresizingMaskIntoConstraints = false
        userProfileImageView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        userProfileImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        userProfileImageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        userProfileImageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        userProfileImageView.contentMode = .scaleAspectFill
        userProfileImageView.clipsToBounds = true
        userProfileImageView.layer.cornerRadius = 16
        
        addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.leadingAnchor.constraint(equalTo: userProfileImageView.trailingAnchor, constant: 5).isActive = true
        nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -10).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -19).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 12).isActive = true
        nameLabel.numberOfLines = 1
        nameLabel.font = UIFont(name: "NunitoSans-Bold", size: 14)
        nameLabel.textColor = .black
        
        addSubview(ratingControl)
        ratingControl.translatesAutoresizingMaskIntoConstraints = false
        ratingControl.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 10).isActive = true
        ratingControl.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -20).isActive = true
        ratingControl.widthAnchor.constraint(equalToConstant: 75).isActive = true
        ratingControl.heightAnchor.constraint(equalToConstant: 15).isActive = true
        ratingControl.isUserInteractionEnabled = false

        addSubview(reviewLabel)
        reviewLabel.translatesAutoresizingMaskIntoConstraints = false
        reviewLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 2).isActive = true
        reviewLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor).isActive = true
        reviewLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
//        reviewLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 6).isActive = true
        reviewLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        reviewLabel.numberOfLines = 2
        reviewLabel.textAlignment = .justified
        reviewLabel.font = UIFont(name: "NunitoSans-Regular", size: 11)
        reviewLabel.textColor = .black
    }
}

// MARK: - Public
extension ReviewCarouselCollectionViewCell {
    public func configure(image: String, title: String, text: String, rating: Double) {
        self.userProfileImageView.setKFImage(imageUrl: image, placeholderImage: UIImage(named:"userPlaceholder-male")!)
        nameLabel.text = title
        reviewLabel.text = text
        ratingControl.rating = Float(rating)
    }
}
