//
//  AppointmentHistoryViewController.swift
//  Medonapp iOS
//
//  Created by Harshal Kulkarni on 19/10/22.
//

import UIKit

class AppointmentHistoryViewController: UIViewController {
    
    private var backButton: UIImageView?
    private var navTitle: UILabel?
    private var monthView: MonthViewAppointmentHistory?

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
        backButton = UIImageView()
        backButton?.image = UIImage(named: "backIcon_White")?.resizeImageTo(size: CGSize(width: 50, height: 50))
        backButton?.contentMode = .scaleAspectFit
        view.addSubview(backButton!)
        let backTap = UITapGestureRecognizer(target: self, action: #selector(self.handleBackAction(_:)))
        backButton?.addGestureRecognizer(backTap)
        backButton?.isUserInteractionEnabled = true
        
        navTitle = UILabel()
        navTitle?.text = "Apppointment History"
        navTitle?.textAlignment = .center
        navTitle?.textColor = .black
        navTitle?.font = UIFont(name: "NunitoSans-Bold", size: 18)
        view.addSubview(navTitle!)
        
        monthView = MonthViewAppointmentHistory.shared
        view.addSubview(monthView!)
        monthView?.isUserInteractionEnabled = true
    }
    
    func setConstraints() {
        backButton?.translatesAutoresizingMaskIntoConstraints = false
        navTitle?.translatesAutoresizingMaskIntoConstraints = false
        monthView?.translatesAutoresizingMaskIntoConstraints = false
        
        
        backButton?.topAnchor.constraint(equalTo: view.topAnchor, constant: 30).isActive = true
        backButton?.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 28).isActive = true
        backButton?.widthAnchor.constraint(equalToConstant: 50).isActive = true
        backButton?.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        navTitle?.topAnchor.constraint(equalTo: view.topAnchor, constant: 43).isActive = true
        navTitle?.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        navTitle?.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        monthView?.topAnchor.constraint(equalTo: navTitle!.bottomAnchor, constant: 20).isActive = true
        monthView?.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        monthView?.widthAnchor.constraint(equalToConstant: 255).isActive = true
        monthView?.heightAnchor.constraint(equalToConstant: 80).isActive = true
    }
    
    @objc func handleBackAction(_ sender: UITapGestureRecognizer? = nil) {
        self.dismiss(animated: true)
    }

}
