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
        
        if Prefs.authToken.count > 0 {
            User.loadFromPrefs()
            self.performSegue(withIdentifier: "toDashboard", sender: nil) //directly to dashboard
        }
        
        // Create the view controller.
        let sheetViewController = LoginSignUpViewController()
        
        // Present it w/o any adjustments so it uses the default sheet presentation.
        present(sheetViewController, animated: true) {
            sheetViewController.isModalInPresentation = true
        }
        
        imageView?.isHidden = false
        UIView.animate(withDuration: 0.05) {
                self.view.layoutIfNeeded()
        }
        self.imageViewTop?.constant = -120
        UIView.animate(withDuration: 0.37) {
                self.view.layoutIfNeeded()
        }
    }
    
    private func initialise() {
        NotificationCenter.default.addObserver(self, selector: #selector(goToDashboard), name: Notification.Name("goToDashboard"), object: nil)
    }
    
    @objc func goToDashboard() {
        self.performSegue(withIdentifier: "toDashboard", sender: nil)
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor(red: 0.86, green: 0.93, blue: 0.98, alpha: 1.00)
        
        
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.setNavigationBarHidden(true, animated: false)
        navigationController?.isNavigationBarHidden = true
        
        
        imageView = UIImageView()
        imageView?.image = UIImage(named: "static-loginpage")
        imageView?.contentMode = .scaleAspectFit
        view.addSubview(imageView!)
        imageView?.isHidden = true
    }
    
    
    
    
    private func setConstraints() {
        imageView?.translatesAutoresizingMaskIntoConstraints = false
        
        
        imageViewTop = imageView?.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 90)
        imageViewTop?.isActive = true
        imageViewBottom = imageView?.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -100)
//        imageViewBottom?.isActive = true
        imageView?.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        imageView?.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        
        
    }


}

