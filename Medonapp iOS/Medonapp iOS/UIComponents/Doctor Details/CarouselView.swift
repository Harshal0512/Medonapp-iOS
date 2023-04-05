//
//  CarouselView.swift
//  Medonapp iOS
//
//  Created by Harshal Kulkarni on 04/04/23.
//

import UIKit

protocol CarouselViewDelegate: class {
    func currentPageDidChange(to page: Int)
}

class CarouselView: UIView {
    
    struct CarouselData {
        let image: String
        let title: String
        let text: String
        let rating: Double
    }
    
    // MARK: - Subviews
    private lazy var carouselCollectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collection.showsHorizontalScrollIndicator = false
        collection.isPagingEnabled = true
        collection.register(ReviewCarouselCollectionViewCell.self, forCellWithReuseIdentifier: ReviewCarouselCollectionViewCell.cellId)
        collection.dataSource = self
        collection.delegate = self
        collection.backgroundColor = UIColor(red: 0.93, green: 0.96, blue: 0.99, alpha: 1.00)
        collection.layer.cornerRadius = 20
        return collection
    }()
    
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.currentPageIndicatorTintColor = UIColor(red: 0.11, green: 0.42, blue: 0.64, alpha: 1.00)
        return pageControl
    }()
    
    // MARK: - Properties
    private var pages: Int
    private weak var delegate: CarouselViewDelegate?
    private var carouselData = [CarouselData]()
    private var currentPage = 0 {
        didSet {
            pageControl.currentPage = currentPage
            delegate?.currentPageDidChange(to: currentPage)
        }
    }
    
    init(pages: Int, delegate: CarouselViewDelegate?) {
        self.pages = pages
        self.delegate = delegate
        super.init(frame: .zero)
        setupUI()
    }
    
    func update(pages: Int) {
        self.pages = pages
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension CarouselView {
    func setupUI() {
        backgroundColor = .clear
        setupCollectionView()
        setupPageControl()
    }
    
    func setupCollectionView() {
        
        let cellPadding = (frame.width - 300) / 2
        let carouselLayout = UICollectionViewFlowLayout()
        carouselLayout.scrollDirection = .horizontal
        carouselLayout.itemSize = .init(width: 300, height: 100)
        carouselLayout.sectionInset = .init(top: 0, left: cellPadding, bottom: 0, right: cellPadding)
        carouselLayout.minimumLineSpacing = cellPadding * 2
        carouselCollectionView.collectionViewLayout = carouselLayout
        
        addSubview(carouselCollectionView)
        carouselCollectionView.translatesAutoresizingMaskIntoConstraints = false
        carouselCollectionView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        carouselCollectionView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        carouselCollectionView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        carouselCollectionView.heightAnchor.constraint(equalToConstant: 120).isActive = true
    }
    
    func setupPageControl() {
        addSubview(pageControl)
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.topAnchor.constraint(equalTo: carouselCollectionView.bottomAnchor, constant: 5).isActive = true
        pageControl.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        pageControl.widthAnchor.constraint(equalToConstant: 150).isActive = true
        pageControl.heightAnchor.constraint(equalToConstant: 50).isActive = true
        pageControl.numberOfPages = pages
    }
    
    func getCurrentPage() -> Int {
        
        let visibleRect = CGRect(origin: carouselCollectionView.contentOffset, size: carouselCollectionView.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        if let visibleIndexPath = carouselCollectionView.indexPathForItem(at: visiblePoint) {
            return visibleIndexPath.row
        }
        
        return currentPage
    }
}

// MARK: - UICollectionViewDataSource
extension CarouselView: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return carouselData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReviewCarouselCollectionViewCell.cellId, for: indexPath) as! ReviewCarouselCollectionViewCell
        
        let image = carouselData[indexPath.row].image
        let title = carouselData[indexPath.row].title
        let text = carouselData[indexPath.row].text
        let rating = carouselData[indexPath.row].rating
        
        cell.configure(image: image, title: title, text: text, rating: rating)
        
        return cell
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        currentPage = getCurrentPage()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        currentPage = getCurrentPage()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        currentPage = getCurrentPage()
    }
}

extension CarouselView {
    public func configureView(with data: [CarouselData]) {
        let cellPadding = (frame.width - 300) / 2
        let carouselLayout = UICollectionViewFlowLayout()
        carouselLayout.scrollDirection = .horizontal
        carouselLayout.itemSize = .init(width: 300, height: 400)
        carouselLayout.sectionInset = .init(top: 0, left: cellPadding, bottom: 0, right: cellPadding)
        carouselLayout.minimumLineSpacing = cellPadding * 2
        carouselCollectionView.collectionViewLayout = carouselLayout
        
        carouselData = data
        carouselCollectionView.reloadData()
    }
}
