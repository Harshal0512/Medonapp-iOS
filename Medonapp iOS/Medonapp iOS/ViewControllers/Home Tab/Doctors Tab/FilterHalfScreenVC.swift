//
//  FilterHalfScreenVC.swift
//  Medonapp iOS
//
//  Created by Harshal Kulkarni on 14/11/22.
//

import Foundation
import UIKit

protocol FilterHalfScreenDelegate {
    func filderDidEndSelecting(sortType: SortType)
}

class FilterHalfScreenVC: UIViewController {
    
    private var scrollView: UIScrollView?
    private var contentView: UIView?
    private var pageTitle: UILabel?
    private var sortSelectView: UIView?
    private var sortCollectionView: UICollectionView?
    private var applyFilterButton: UIButtonVariableBackgroundVariableCR?
    
    public var selectedSortValue: Int?
    
    var activeItem: Int = -1
    var animateIndex: Int = -1
    
    var delegate: FilterHalfScreenDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.isUserInteractionEnabled = false
        
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
        
        sortCollectionView?.register(SortOptionCollectionViewCell.nib(), forCellWithReuseIdentifier: SortOptionCollectionViewCell.identifier)
        sortCollectionView?.delegate = self
        sortCollectionView?.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        view.isUserInteractionEnabled = true
        
        guard let selectedVal = selectedSortValue else {
            return
        }
        activeItem = selectedVal
        animateIndex = selectedVal
        sortCollectionView?.reloadData()
        //do not write any code below this line
    }
    
    func initialise() {
    }
    
    func setupUI() {
        view.backgroundColor = .white
        scrollView = UIScrollView()
        contentView = UIView()
        
        view.addSubview(scrollView!)
        scrollView?.addSubview(contentView!)
        
        pageTitle = UILabel()
        pageTitle?.text = "Sort & Filter"
        pageTitle?.textColor = .black
        pageTitle?.font = UIFont(name: "NunitoSans-ExtraBold", size: 24)
        view?.addSubview(pageTitle!)
        
        sortSelectView = UIView()
        sortSelectView?.layer.cornerRadius = 32
        sortSelectView?.clipsToBounds = true
        sortSelectView?.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        contentView?.addSubview(sortSelectView!)
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: 110, height: 42)
        layout.minimumInteritemSpacing = 0
        //        layout.scrollDirection = .horizontal
        
        sortCollectionView =  UICollectionView(frame: CGRect(x: 0, y: 0, width: contentView!.frame.width-45, height: 200), collectionViewLayout: layout)
        sortCollectionView?.backgroundColor = .clear
        sortSelectView?.addSubview(sortCollectionView!)
        sortCollectionView?.showsHorizontalScrollIndicator = false
        
        applyFilterButton = UIButtonVariableBackgroundVariableCR()
        applyFilterButton?.initButton(title: "Continue", cornerRadius: 14, variant: .whiteBack, titleColor: UIColor(red: 0.11, green: 0.42, blue: 0.64, alpha: 1.00))
        sortSelectView?.addSubview(applyFilterButton!)
        applyFilterButton?.addTarget(self, action: #selector(applyFilterButtonClicked), for: .touchUpInside)
    }
    
    func setConstraints() {
        scrollView?.translatesAutoresizingMaskIntoConstraints = false
        contentView?.translatesAutoresizingMaskIntoConstraints = false
        pageTitle?.translatesAutoresizingMaskIntoConstraints = false
        sortSelectView?.translatesAutoresizingMaskIntoConstraints = false
        sortCollectionView?.translatesAutoresizingMaskIntoConstraints = false
        applyFilterButton?.translatesAutoresizingMaskIntoConstraints = false
        
        
        scrollView?.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 65).isActive = true
        scrollView?.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        scrollView?.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        scrollView?.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        
        pageTitle?.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 39).isActive = true
        pageTitle?.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 28).isActive = true
        pageTitle?.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30).isActive = true
        
        contentView?.topAnchor.constraint(equalTo: scrollView!.topAnchor).isActive = true
        contentView?.leadingAnchor.constraint(equalTo: scrollView!.leadingAnchor).isActive = true
        contentView?.trailingAnchor.constraint(equalTo: scrollView!.trailingAnchor).isActive = true
        contentView?.bottomAnchor.constraint(equalTo: scrollView!.bottomAnchor).isActive = true
        contentView?.widthAnchor.constraint(equalTo: scrollView!.widthAnchor).isActive = true
        
        sortSelectView?.topAnchor.constraint(equalTo: contentView!.topAnchor, constant: 10).isActive = true
        sortSelectView?.leadingAnchor.constraint(equalTo: contentView!.leadingAnchor).isActive = true
        sortSelectView?.trailingAnchor.constraint(equalTo: contentView!.trailingAnchor).isActive = true
        
        
        sortCollectionView?.topAnchor.constraint(equalTo: sortSelectView!.topAnchor, constant: 20).isActive = true
        sortCollectionView?.leadingAnchor.constraint(equalTo: sortSelectView!.leadingAnchor, constant: 30).isActive = true
        sortCollectionView?.trailingAnchor.constraint(equalTo: sortSelectView!.trailingAnchor, constant: -30).isActive = true
        sortCollectionView?.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        applyFilterButton?.topAnchor.constraint(equalTo: sortCollectionView!.bottomAnchor, constant: 20).isActive = true
        applyFilterButton?.leadingAnchor.constraint(equalTo: sortSelectView!.leadingAnchor, constant: 20).isActive = true
        applyFilterButton?.trailingAnchor.constraint(equalTo: sortSelectView!.trailingAnchor, constant: -20).isActive = true
        applyFilterButton?.bottomAnchor.constraint(equalTo: sortSelectView!.bottomAnchor, constant: -20).isActive = true
        applyFilterButton?.heightAnchor.constraint(equalToConstant: 56).isActive = true
        
        sortSelectView?.bottomAnchor.constraint(equalTo: contentView!.bottomAnchor).isActive = true
        
    }
    
    @objc func applyFilterButtonClicked() {
        guard activeItem != -1 else {
            return
        }
        
        delegate.filderDidEndSelecting(sortType: (sortCollectionView?.cellForItem(at: IndexPath(row: activeItem, section: 0)) as! SortOptionCollectionViewCell).sortType!)
        self.dismiss(animated: true)
    }
    
}

extension FilterHalfScreenVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return SortType.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SortOptionCollectionViewCell.identifier, for: indexPath) as! SortOptionCollectionViewCell
        
        cell.configure(type: SortType.allCases[indexPath.row], isActive: activeItem == indexPath.row, animateActive: indexPath.row == animateIndex)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 110, height: 42)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (collectionView.cellForItem(at: indexPath) as! SortOptionCollectionViewCell).isNotAvailable && (collectionView.cellForItem(at: indexPath) as! SortOptionCollectionViewCell).sortType == .distance {
            Utils.displaySPIndicatorNotifWithoutMessage(title: "Location permission needed for this feature.", iconPreset: .error, hapticPreset: .error, duration: 3)
        }
        else if activeItem == indexPath.row {
            return
//            animateIndex = -1
//            activeItem = -1
//            collectionView.reloadData()
        }
        else {
            animateIndex = indexPath.row
            activeItem = indexPath.row
            collectionView.reloadData()
        }
    }
}
