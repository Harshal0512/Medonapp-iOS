//
//  DoctorDetailsPeekViewViewController.swift
//  Medonapp iOS
//
//  Created by Ritul Raj Parmar on 04/12/22.
//

import UIKit

class DoctorDetailsPeekViewViewController: UIViewController {

    private var topView: DoctorDetailsScreenTopView?
    private var patientsGreyView: GreyViewDoctorDetails?
    private var experienceGreyView: GreyViewDoctorDetails?
    private var ratingsGreyView: GreyViewDoctorDetails?
    private var aboutLabel: UILabel?
    private var aboutDescription: UILabel?
    
    public var doctor: Doctor?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationItem.largeTitleDisplayMode = .never
        navigationController?.isNavigationBarHidden = true

        initialise()
        setupUI()
        setConstraints()
        
        setAboutLabelText()
    }
    
    func initialise() {
    }
    
    func setupUI() {
        topView = DoctorDetailsScreenTopView.instantiate(doctor: self.doctor!)
        view.addSubview(topView!)
        
        patientsGreyView = GreyViewDoctorDetails.instantiate(title: "Patients", metrics: "\(doctor?.patientCount ?? 0)")
        view.addSubview(patientsGreyView!)
        
        experienceGreyView = GreyViewDoctorDetails.instantiate(title: "Exp.", metrics: String(format: "%d yr", Int(doctor?.experience ?? 0)))
        view.addSubview(experienceGreyView!)
        
        ratingsGreyView = GreyViewDoctorDetails.instantiate(title: "Rating", metrics: String(format: "%.2f", doctor?.avgRating ?? 0))
        view.addSubview(ratingsGreyView!)
        
        aboutLabel = UILabel()
        aboutLabel?.text = "About"
        aboutLabel?.textColor = .black
        aboutLabel?.font = UIFont(name: "NunitoSans-Bold", size: 17)
        view.addSubview(aboutLabel!)
        
        aboutDescription = UILabel()
        aboutDescription?.text = ""
        aboutDescription?.textColor = UIColor(red: 0.29, green: 0.33, blue: 0.37, alpha: 1.00)
        aboutDescription?.numberOfLines = 0
        aboutDescription?.textColor = .black
        aboutDescription?.font = UIFont(name: "NunitoSans-Regular", size: 14)
        view.addSubview(aboutDescription!)
    }
    
    func setConstraints() {
        topView?.translatesAutoresizingMaskIntoConstraints = false
        patientsGreyView?.translatesAutoresizingMaskIntoConstraints = false
        experienceGreyView?.translatesAutoresizingMaskIntoConstraints = false
        ratingsGreyView?.translatesAutoresizingMaskIntoConstraints = false
        aboutLabel?.translatesAutoresizingMaskIntoConstraints = false
        aboutDescription?.translatesAutoresizingMaskIntoConstraints = false
        
        
        topView?.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        topView?.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        topView?.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        topView?.heightAnchor.constraint(equalToConstant: 280).isActive = true
        
        patientsGreyView?.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        patientsGreyView?.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 27).isActive = true
        patientsGreyView?.widthAnchor.constraint(greaterThanOrEqualToConstant: 80).isActive = true
        patientsGreyView?.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        experienceGreyView?.topAnchor.constraint(equalTo: patientsGreyView!.topAnchor).isActive = true
        experienceGreyView?.leadingAnchor.constraint(equalTo: patientsGreyView!.trailingAnchor, constant: 13).isActive = true
        
        ratingsGreyView?.topAnchor.constraint(equalTo: patientsGreyView!.topAnchor).isActive = true
        ratingsGreyView?.leadingAnchor.constraint(equalTo: experienceGreyView!.trailingAnchor, constant: 13).isActive = true
        ratingsGreyView?.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -27).isActive = true
        
        patientsGreyView?.widthAnchor.constraint(equalTo: experienceGreyView!.widthAnchor).isActive = true
        patientsGreyView?.heightAnchor.constraint(equalTo: experienceGreyView!.heightAnchor).isActive = true
        
        ratingsGreyView?.widthAnchor.constraint(equalTo: experienceGreyView!.widthAnchor).isActive = true
        ratingsGreyView?.heightAnchor.constraint(equalTo: experienceGreyView!.heightAnchor).isActive = true
        
        aboutLabel?.topAnchor.constraint(equalTo: patientsGreyView!.bottomAnchor, constant: 30).isActive = true
        aboutLabel?.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 27).isActive = true
        aboutLabel?.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -27).isActive = true
        
        aboutDescription?.topAnchor.constraint(equalTo: aboutLabel!.bottomAnchor, constant: 10).isActive = true
        aboutDescription?.leadingAnchor.constraint(equalTo: aboutLabel!.leadingAnchor).isActive = true
        aboutDescription?.trailingAnchor.constraint(equalTo: aboutLabel!.trailingAnchor).isActive = true
    }
    
    func setAboutLabelText() {
        var text: String = ""
        for line in (doctor?.about ?? [""]) {
            text += line + "\n"
        }
        aboutDescription?.text = text
    }
}
