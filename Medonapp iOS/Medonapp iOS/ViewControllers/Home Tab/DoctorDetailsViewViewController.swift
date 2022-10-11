//
//  DoctorDetailsViewViewController.swift
//  Medonapp iOS
//
//  Created by Harshal Kulkarni on 11/10/22.
//

import UIKit

class DoctorDetailsViewViewController: UIViewController {
    
    private var topView: DoctorDetailsScreenTopView?
    private var backButton: UIImageView?
    private var navTitle: UILabel?
    private var anchorButton: UIImageView?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Details"
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
        topView = DoctorDetailsScreenTopView.instantiate(doctorImage: UIImage(named: "cat")!, doctorName: "Dr. Suryansh Sharma", doctorDesignation: "Cardiologist at Apollo Hospital")
        view.addSubview(topView!)
        
        backButton = UIImageView()
        backButton?.image = UIImage(named: "backIcon_Transparent")?.resizeImageTo(size: CGSize(width: 50, height: 50))
        backButton?.contentMode = .scaleAspectFit
        view.addSubview(backButton!)
        let backTap = UITapGestureRecognizer(target: self, action: #selector(self.handleBackAction(_:)))
        backButton?.addGestureRecognizer(backTap)
        backButton?.isUserInteractionEnabled = true
        
        navTitle = UILabel()
        navTitle?.text = "Doctors"
        navTitle?.textAlignment = .center
        navTitle?.textColor = .white
        navTitle?.font = UIFont(name: "NunitoSans-Bold", size: 18)
        view.addSubview(navTitle!)
        
        anchorButton = UIImageView()
        anchorButton?.image = UIImage(named: "anchorLinkIcon_Transparent")?.resizeImageTo(size: CGSize(width: 50, height: 50))
        anchorButton?.contentMode = .scaleAspectFit
        view.addSubview(anchorButton!)
        let anchorTap = UITapGestureRecognizer(target: self, action: #selector(self.handleAnchorTapAction(_:)))
        anchorButton?.addGestureRecognizer(anchorTap)
        anchorButton?.isUserInteractionEnabled = true
    }
    
    func setConstraints() {
        topView?.translatesAutoresizingMaskIntoConstraints = false
        backButton?.translatesAutoresizingMaskIntoConstraints = false
        navTitle?.translatesAutoresizingMaskIntoConstraints = false
        anchorButton?.translatesAutoresizingMaskIntoConstraints = false
        
        topView?.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        topView?.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        topView?.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        topView?.heightAnchor.constraint(equalToConstant: 280).isActive = true
        
        backButton?.topAnchor.constraint(equalTo: view.topAnchor, constant: 65).isActive = true
        backButton?.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 28).isActive = true
        backButton?.widthAnchor.constraint(equalToConstant: 50).isActive = true
        backButton?.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        navTitle?.topAnchor.constraint(equalTo: view.topAnchor, constant: 78).isActive = true
        navTitle?.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        navTitle?.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        anchorButton?.topAnchor.constraint(equalTo: view.topAnchor, constant: 65).isActive = true
        anchorButton?.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -28).isActive = true
        anchorButton?.widthAnchor.constraint(equalToConstant: 50).isActive = true
        anchorButton?.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    @objc func handleBackAction(_ sender: UITapGestureRecognizer? = nil) {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func handleAnchorTapAction(_ sender: UITapGestureRecognizer? = nil) {
    }
}
