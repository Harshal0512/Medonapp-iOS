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
    private var scrollView: UIScrollView?
    private var contentView: UIView?
    private var patientsGreyView: GreyViewDoctorDetails?
    private var experienceGreyView: GreyViewDoctorDetails?
    private var ratingsGreyView: GreyViewDoctorDetails?

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
        
        scrollView = UIScrollView()
        contentView = UIView()
        
        view.addSubview(scrollView!)
        scrollView?.addSubview(contentView!)
        
        patientsGreyView = GreyViewDoctorDetails.instantiate(title: "Patients", metrics: "100+")
        contentView?.addSubview(patientsGreyView!)
        
        experienceGreyView = GreyViewDoctorDetails.instantiate(title: "Exp.", metrics: "10 yr")
        contentView?.addSubview(experienceGreyView!)
        
        ratingsGreyView = GreyViewDoctorDetails.instantiate(title: "Rating", metrics: "4.67")
        contentView?.addSubview(ratingsGreyView!)
    }
    
    func setConstraints() {
        topView?.translatesAutoresizingMaskIntoConstraints = false
        backButton?.translatesAutoresizingMaskIntoConstraints = false
        navTitle?.translatesAutoresizingMaskIntoConstraints = false
        anchorButton?.translatesAutoresizingMaskIntoConstraints = false
        scrollView?.translatesAutoresizingMaskIntoConstraints = false
        contentView?.translatesAutoresizingMaskIntoConstraints = false
        patientsGreyView?.translatesAutoresizingMaskIntoConstraints = false
        experienceGreyView?.translatesAutoresizingMaskIntoConstraints = false
        ratingsGreyView?.translatesAutoresizingMaskIntoConstraints = false
        
        
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
        
        scrollView?.topAnchor.constraint(equalTo: topView!.bottomAnchor, constant: 20).isActive = true
        scrollView?.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        scrollView?.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        scrollView?.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        
        contentView?.topAnchor.constraint(equalTo: scrollView!.topAnchor).isActive = true
        contentView?.leadingAnchor.constraint(equalTo: scrollView!.leadingAnchor).isActive = true
        contentView?.trailingAnchor.constraint(equalTo: scrollView!.trailingAnchor).isActive = true
        contentView?.bottomAnchor.constraint(equalTo: scrollView!.bottomAnchor).isActive = true
        contentView?.widthAnchor.constraint(equalTo: scrollView!.widthAnchor).isActive = true
        
        patientsGreyView?.topAnchor.constraint(equalTo: contentView!.topAnchor, constant: 20).isActive = true
        patientsGreyView?.leadingAnchor.constraint(equalTo: contentView!.leadingAnchor, constant: 27).isActive = true
        patientsGreyView?.widthAnchor.constraint(greaterThanOrEqualToConstant: 80).isActive = true
        patientsGreyView?.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        experienceGreyView?.topAnchor.constraint(equalTo: patientsGreyView!.topAnchor).isActive = true
        experienceGreyView?.leadingAnchor.constraint(equalTo: patientsGreyView!.trailingAnchor, constant: 13).isActive = true
        
        ratingsGreyView?.topAnchor.constraint(equalTo: patientsGreyView!.topAnchor).isActive = true
        ratingsGreyView?.leadingAnchor.constraint(equalTo: experienceGreyView!.trailingAnchor, constant: 13).isActive = true
        ratingsGreyView?.trailingAnchor.constraint(equalTo: contentView!.trailingAnchor, constant: -27).isActive = true
        
        patientsGreyView?.widthAnchor.constraint(equalTo: experienceGreyView!.widthAnchor).isActive = true
        patientsGreyView?.heightAnchor.constraint(equalTo: experienceGreyView!.heightAnchor).isActive = true
        
        ratingsGreyView?.widthAnchor.constraint(equalTo: experienceGreyView!.widthAnchor).isActive = true
        ratingsGreyView?.heightAnchor.constraint(equalTo: experienceGreyView!.heightAnchor).isActive = true
    }
    
    @objc func handleBackAction(_ sender: UITapGestureRecognizer? = nil) {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func handleAnchorTapAction(_ sender: UITapGestureRecognizer? = nil) {
    }
}
