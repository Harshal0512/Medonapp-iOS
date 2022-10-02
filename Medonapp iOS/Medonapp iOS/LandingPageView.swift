//
//  ViewController.swift
//  Medonapp iOS
//
//  Created by Harshal Kulkarni on 17/09/22.
//

import UIKit
import Foundation

class LandingPageView: UIViewController {
    private var imageView: UIImageView?
    private var imageViewTop: NSLayoutConstraint?
    private var imageViewBottom: NSLayoutConstraint?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialise()
        setupUI()
        setConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Create the view controller.
        let sheetViewController = LoginSignUpViewController()
        
        // Present it w/o any adjustments so it uses the default sheet presentation.
        present(sheetViewController, animated: true) {
            sheetViewController.isModalInPresentation = true
        }
    }
    
    private func initialise() {
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor(red: 0.86, green: 0.93, blue: 0.98, alpha: 1.00)
        
//        title = "My Verified Docs"
//        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.setNavigationBarHidden(true, animated: false)
        navigationController?.isNavigationBarHidden = true
        
        
        imageView = UIImageView()
        imageView?.image = UIImage(named: "static-loginpage")
        imageView?.contentMode = .scaleAspectFit
        view.addSubview(imageView!)
        
    }
    
    
    
    
    private func setConstraints() {
        imageView?.translatesAutoresizingMaskIntoConstraints = false
        
        
        imageViewTop = imageView?.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -120)
        imageViewTop?.isActive = true
        imageViewBottom = imageView?.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -100)
//        imageViewBottom?.isActive = true
        imageView?.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        imageView?.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
    }


}

