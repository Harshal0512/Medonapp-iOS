//
//  DoctorDetailsViewViewController.swift
//  Medonapp iOS
//
//  Created by Harshal Kulkarni on 11/10/22.
//

import UIKit
import MapKit
import CoreLocation
import FaveButton

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
    private var aboutLabel: UILabel?
    private var aboutDescription: UILabel?
    private var locationTextLabel: UILabel?
    private var locationView: UIView?
    private var locationMapView: MKMapView?
    private var bottomView: UIView?
    private var bookNowButton: UIButtonVariableBackgroundVariableCR?
    private var favoriteView: UIView?
    private var favoriteButton: FaveButton?
    
    public var doctor: Doctor?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Details"
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
        
        backButton = UIImageView()
        backButton?.image = UIImage(named: "backIcon_Transparent")?.resizeImageTo(size: CGSize(width: 50, height: 50))
        backButton?.contentMode = .scaleAspectFit
        view.addSubview(backButton!)
        let backTap = UITapGestureRecognizer(target: self, action: #selector(self.handleBackAction(_:)))
        backButton?.addGestureRecognizer(backTap)
        backButton?.isUserInteractionEnabled = true
        
        navTitle = UILabel()
        navTitle?.text = "Details"
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
        
        patientsGreyView = GreyViewDoctorDetails.instantiate(title: "Patients", metrics: "\(doctor?.patientCount ?? 0)")
        contentView?.addSubview(patientsGreyView!)
        
        experienceGreyView = GreyViewDoctorDetails.instantiate(title: "Exp.", metrics: String(format: "%d yr", Int(doctor?.experience ?? 0)))
        contentView?.addSubview(experienceGreyView!)
        
        ratingsGreyView = GreyViewDoctorDetails.instantiate(title: "Rating", metrics: String(format: "%.2f", doctor?.avgRating ?? 0))
        contentView?.addSubview(ratingsGreyView!)
        
        aboutLabel = UILabel()
        aboutLabel?.text = "About"
        aboutLabel?.textColor = .black
        aboutLabel?.font = UIFont(name: "NunitoSans-Bold", size: 17)
        contentView?.addSubview(aboutLabel!)
        
        aboutDescription = UILabel()
        aboutDescription?.text = ""
        aboutDescription?.textColor = UIColor(red: 0.29, green: 0.33, blue: 0.37, alpha: 1.00)
        aboutDescription?.numberOfLines = 0
        aboutDescription?.textColor = .black
        aboutDescription?.font = UIFont(name: "NunitoSans-Regular", size: 14)
        contentView?.addSubview(aboutDescription!)
        
        locationTextLabel = UILabel()
        locationTextLabel?.text = "Location"
        locationTextLabel?.textColor = .black
        locationTextLabel?.font = UIFont(name: "NunitoSans-Bold", size: 17)
        contentView?.addSubview(locationTextLabel!)
        
        locationView = UIView()
        locationView?.backgroundColor = .gray
        locationView?.layer.cornerRadius = 28
        contentView?.addSubview(locationView!)
        locationView?.isUserInteractionEnabled = true
        locationView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openGoogleMap)))
        
        locationMapView = MKMapView()
        locationMapView?.showsUserLocation = true
        locationMapView?.delegate = self
        locationMapView?.layer.cornerRadius = 28
        locationView?.addSubview(locationMapView!)
        
        bottomView = UIView()
        bottomView?.backgroundColor = .white
        view?.addSubview(bottomView!)
        
        bookNowButton = UIButtonVariableBackgroundVariableCR()
        bookNowButton?.initButton(title: "Book Now", cornerRadius: 14, variant: .blueBack)
        bottomView?.addSubview(bookNowButton!)
        bookNowButton?.addTarget(self, action: #selector(bookNowButtonPressed), for: .touchUpInside)
        
        favoriteView = UIView()
        favoriteView?.backgroundColor = .clear
        favoriteView?.layer.cornerRadius = 14
        bottomView?.addSubview(favoriteView!)
        
        favoriteButton = FaveButton(frame: CGRect(x:200, y:200, width: 44, height: 44), faveIconNormal: UIImage(named: "heart"))
//        favoriteButton?.selectedColor = UIColor(red: 0.11, green: 0.42, blue: 0.64, alpha: 1.00)
        favoriteView?.addSubview(favoriteButton!)
        favoriteButton?.setSelected(selected: doctor!.isFavorite, animated: false)
        favoriteButton?.delegate = self
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
        aboutLabel?.translatesAutoresizingMaskIntoConstraints = false
        aboutDescription?.translatesAutoresizingMaskIntoConstraints = false
        locationTextLabel?.translatesAutoresizingMaskIntoConstraints = false
        locationView?.translatesAutoresizingMaskIntoConstraints = false
        locationMapView?.translatesAutoresizingMaskIntoConstraints = false
        bottomView?.translatesAutoresizingMaskIntoConstraints = false
        bookNowButton?.translatesAutoresizingMaskIntoConstraints = false
        favoriteView?.translatesAutoresizingMaskIntoConstraints = false
        favoriteButton?.translatesAutoresizingMaskIntoConstraints = false
        
        
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
        
        aboutLabel?.topAnchor.constraint(equalTo: patientsGreyView!.bottomAnchor, constant: 30).isActive = true
        aboutLabel?.leadingAnchor.constraint(equalTo: contentView!.leadingAnchor, constant: 27).isActive = true
        aboutLabel?.trailingAnchor.constraint(equalTo: contentView!.trailingAnchor, constant: -27).isActive = true
        
        aboutDescription?.topAnchor.constraint(equalTo: aboutLabel!.bottomAnchor, constant: 10).isActive = true
        aboutDescription?.leadingAnchor.constraint(equalTo: aboutLabel!.leadingAnchor).isActive = true
        aboutDescription?.trailingAnchor.constraint(equalTo: aboutLabel!.trailingAnchor).isActive = true
        
        locationTextLabel?.topAnchor.constraint(equalTo: aboutDescription!.bottomAnchor, constant: 23).isActive = true
        locationTextLabel?.leadingAnchor.constraint(equalTo: contentView!.leadingAnchor, constant: 27).isActive = true
        locationTextLabel?.trailingAnchor.constraint(equalTo: contentView!.trailingAnchor, constant: -27).isActive = true
        
        locationView?.topAnchor.constraint(equalTo: locationTextLabel!.bottomAnchor, constant: 12).isActive = true
        locationView?.leadingAnchor.constraint(equalTo: contentView!.leadingAnchor, constant: 28).isActive = true
        locationView?.trailingAnchor.constraint(equalTo: contentView!.trailingAnchor, constant: -28).isActive = true
        locationView?.bottomAnchor.constraint(equalTo: contentView!.bottomAnchor, constant: -100).isActive = true
        locationView?.heightAnchor.constraint(equalToConstant: 180).isActive = true
        
        locationMapView?.topAnchor.constraint(equalTo: locationView!.topAnchor).isActive = true
        locationMapView?.leadingAnchor.constraint(equalTo: locationView!.leadingAnchor).isActive = true
        locationMapView?.trailingAnchor.constraint(equalTo: locationView!.trailingAnchor).isActive = true
        locationMapView?.bottomAnchor.constraint(equalTo: locationView!.bottomAnchor).isActive = true
        
        bottomView?.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        bottomView?.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        bottomView?.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        bookNowButton?.topAnchor.constraint(equalTo: bottomView!.topAnchor, constant: 13).isActive = true
        bookNowButton?.leadingAnchor.constraint(equalTo: bottomView!.leadingAnchor, constant: 27).isActive = true
        bookNowButton?.heightAnchor.constraint(equalToConstant: 56).isActive = true
        bookNowButton?.bottomAnchor.constraint(equalTo: bottomView!.bottomAnchor, constant: -23).isActive = true
        bookNowButton?.widthAnchor.constraint(equalTo: favoriteButton!.widthAnchor, multiplier: 5).isActive = true
        
        favoriteView?.leadingAnchor.constraint(equalTo: bookNowButton!.trailingAnchor, constant: 10).isActive = true
        favoriteView?.trailingAnchor.constraint(equalTo: bottomView!.trailingAnchor, constant: -27).isActive = true
        favoriteView?.bottomAnchor.constraint(equalTo: bookNowButton!.bottomAnchor).isActive = true
        favoriteView?.heightAnchor.constraint(equalToConstant: 56).isActive = true
        
        favoriteButton?.topAnchor.constraint(equalTo: favoriteView!.topAnchor, constant: 1).isActive = true
        favoriteButton?.leadingAnchor.constraint(equalTo: favoriteView!.leadingAnchor, constant: 1).isActive = true
        favoriteButton?.trailingAnchor.constraint(equalTo: favoriteView!.trailingAnchor, constant: -1).isActive = true
        favoriteButton?.bottomAnchor.constraint(equalTo: favoriteView!.bottomAnchor, constant: -1).isActive = true
    }
    
    @objc func handleBackAction(_ sender: UITapGestureRecognizer? = nil) {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func handleAnchorTapAction(_ sender: UITapGestureRecognizer? = nil) {
        // Create the view controller.
        let sheetViewController = ContactDoctorViewController()
        sheetViewController.doctor = self.doctor
        // Present it w/o any adjustments so it uses the default sheet presentation.
        present(sheetViewController, animated: true)
    }
    
    @objc func bookNowButtonPressed() {
        let appointmentDetailsVC = UIStoryboard.init(name: "HomeTab", bundle: Bundle.main).instantiateViewController(withIdentifier: "appointmentDetailsVC") as? AppointmentDetailsViewController
        appointmentDetailsVC?.doctor = self.doctor
//        doctorsScreenVC?.modalPresentationStyle = .fullScreen
//        self.present(doctorsScreenVC!, animated: true, completion: nil)
        self.navigationController?.pushViewController(appointmentDetailsVC!, animated: true)
    }
    
    func setAboutLabelText() {
        var text: String = ""
        for line in (doctor?.about ?? [""]) {
            text += line + "\n"
        }
        aboutDescription?.text = text
    }
    
    @objc func openGoogleMap() {
        if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {  //if phone has an app
            
            if let url = URL(string: "comgooglemaps-x-callback://?saddr=&daddr=\(doctor!.address!.latitude!),\(doctor!.address!.longitude!)&directionsmode=driving") {
                UIApplication.shared.open(url, options: [:])
            }}
        else {
            //Open in browser
            if let urlDestination = URL.init(string: "https://www.google.co.in/maps/dir/?saddr=&daddr=\(doctor!.address!.latitude!),\(doctor!.address!.longitude!)&directionsmode=driving") {
                UIApplication.shared.open(urlDestination)
            }
        }
    }
}

extension DoctorDetailsViewViewController: MKMapViewDelegate {
    
    func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: (doctor?.address!.latitude!)!, longitude: (doctor?.address!.longitude!)!)
        annotation.title = doctor?.fullNameWithTitle
        self.locationMapView?.addAnnotation(annotation)
        
        if Prefs.isLocationPerm {
            let midPoint = Utils.geographicMidpoint(betweenCoordinates: [CLLocationCoordinate2D(latitude: (doctor?.address!.latitude!)!, longitude: (doctor?.address!.longitude!)!), mapView.userLocation.coordinate])
            let coordinateRegion = MKCoordinateRegion(center: midPoint, latitudinalMeters: doctor!.distanceFromUser*2, longitudinalMeters: doctor!.distanceFromUser*2)
            self.locationMapView?.setRegion(coordinateRegion, animated: true)
        }
    }
}

extension DoctorDetailsViewViewController: FaveButtonDelegate {
    func faveButton(_ faveButton: FaveButton, didSelected selected: Bool) {
        let generator = UIImpactFeedbackGenerator(style: .light)
        self.doctor?.setFavorite(state: selected) { isSuccess in
            if isSuccess {
                generator.impactOccurred()
            }
        }
    }
}
