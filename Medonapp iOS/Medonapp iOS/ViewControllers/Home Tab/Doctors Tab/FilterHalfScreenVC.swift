//
//  FilterHalfScreenVC.swift
//  Medonapp iOS
//
//  Created by Harshal Kulkarni on 14/11/22.
//

import Foundation
import UIKit

protocol FilterHalfScreenDelegate {
    func filderDidEndSelecting()
    //TODO: Return filter enum
}

class FilterHalfScreenVC: UIViewController {
    
    var scrollView: UIScrollView?
    var contentView: UIView?
    var pageTitle: UILabel?
    var onlineSort: UIButton?
    
    var delegate: FilterHalfScreenDelegate!

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
    
    func initialise() {
    }
    
    func setupUI() {
        view.backgroundColor = .white
        scrollView = UIScrollView()
        contentView = UIView()
        
        view.addSubview(scrollView!)
        scrollView?.addSubview(contentView!)
        
        pageTitle = UILabel()
        pageTitle?.text = "Filter"
        pageTitle?.textColor = .black
        pageTitle?.font = UIFont(name: "NunitoSans-ExtraBold", size: 24)
        scrollView?.addSubview(pageTitle!)
        
        onlineSort = UIButton()
        onlineSort?.setTitle("Follow", for: .normal)
        onlineSort?.setTitle("Following", for: .selected)
        onlineSort?.tintColor = .green
        contentView?.addSubview(onlineSort!)
    }
    
    func setConstraints() {
        scrollView?.translatesAutoresizingMaskIntoConstraints = false
        contentView?.translatesAutoresizingMaskIntoConstraints = false
        pageTitle?.translatesAutoresizingMaskIntoConstraints = false
        onlineSort?.translatesAutoresizingMaskIntoConstraints = false

        
        scrollView?.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        scrollView?.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        scrollView?.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        scrollView?.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        
        contentView?.topAnchor.constraint(equalTo: pageTitle!.bottomAnchor).isActive = true
        contentView?.leadingAnchor.constraint(equalTo: scrollView!.leadingAnchor).isActive = true
        contentView?.trailingAnchor.constraint(equalTo: scrollView!.trailingAnchor).isActive = true
        contentView?.bottomAnchor.constraint(equalTo: scrollView!.bottomAnchor).isActive = true
        contentView?.widthAnchor.constraint(equalTo: scrollView!.widthAnchor).isActive = true
        
        
        pageTitle?.topAnchor.constraint(equalTo: scrollView!.topAnchor, constant: 39).isActive = true
        pageTitle?.leadingAnchor.constraint(equalTo: scrollView!.leadingAnchor, constant: 28).isActive = true
        pageTitle?.trailingAnchor.constraint(greaterThanOrEqualTo: scrollView!.trailingAnchor, constant: -30).isActive = true
        
        onlineSort?.topAnchor.constraint(equalTo: contentView!.topAnchor, constant: 10).isActive = true
        onlineSort?.leadingAnchor.constraint(equalTo: contentView!.leadingAnchor, constant: 27).isActive = true
        onlineSort?.trailingAnchor.constraint(equalTo: contentView!.trailingAnchor, constant: -27).isActive = true
        onlineSort?.heightAnchor.constraint(equalToConstant: 56).isActive = true
    }
    
    @objc func applyFilterButtonClicked() {
        delegate.filderDidEndSelecting() //TODO: Return filter enum
    }
}
