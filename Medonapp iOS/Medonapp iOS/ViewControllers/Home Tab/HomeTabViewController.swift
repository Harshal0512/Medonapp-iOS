//
//  HomeTabViewController.swift
//  Medonapp iOS
//
//  Created by Harshal Kulkarni on 06/10/22.
//

import UIKit
import MapKit
import CoreLocation
import SkeletonView

class HomeTabViewController: UIViewController {
    
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation = CLLocation()
    
    var doctors: [Doctor] = []
    
    var scrollView: UIScrollView?
    var contentView: UIView?
    var helloTextLabel: UILabel?
    var welcomeWithNameLabel: UILabel?
    var profileImageView: UIImageView?
    var searchBar: SearchBarWithSearchAndFilterIcon?
    var servicesTextLabel: UILabel?
    var doctorsTab: TabForServices_VariableColor?
    var reportsTab: TabForServices_VariableColor?
    var banner: UIImageView?
    var nearbyTextLabel: UILabel?
    var nearbyView: UIView?
    var minimizeButton: UIButton?
    var nearbyMapView: MKMapView?
    var isMapExpanded: Bool = false
    var mapViewTopConstraint: NSLayoutConstraint?
    var mapViewLeadingConstraint: NSLayoutConstraint?
    var mapViewTrailingConstraint: NSLayoutConstraint?
    var mapViewBottomConstraint: NSLayoutConstraint?
    var mapViewHeightConstraint: NSLayoutConstraint?
    
    private var userDetails = User.getUserDetails()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let tabBarItems = tabBarController?.tabBar.items!
        tabBarItems![0].image = UIImage(named: "homeTabIcon")?.resizeImageTo(size: CGSize(width: 40, height: 40))?.withTintColor(UIColor(red: 0.48, green: 0.55, blue: 0.62, alpha: 1.00))
        tabBarItems![0].selectedImage = UIImage(named: "homeTabIcon")?.resizeImageTo(size: CGSize(width: 40, height: 40))?.withTintColor(UIColor(red: 0.11, green: 0.42, blue: 0.64, alpha: 1.00))
        tabBarItems![1].image = UIImage(named: "scheduleTabIcon")?.resizeImageTo(size: CGSize(width: 40, height: 40))?.withTintColor(UIColor(red: 0.48, green: 0.55, blue: 0.62, alpha: 1.00))
        tabBarItems![1].selectedImage = UIImage(named: "scheduleTabIcon")?.resizeImageTo(size: CGSize(width: 40, height: 40))?.withTintColor(UIColor(red: 0.11, green: 0.42, blue: 0.64, alpha: 1.00))
        tabBarItems![2].image = UIImage(named: "reportTabIcon")?.resizeImageTo(size: CGSize(width: 40, height: 40))?.withTintColor(UIColor(red: 0.48, green: 0.55, blue: 0.62, alpha: 1.00))
        tabBarItems![2].selectedImage = UIImage(named: "reportTabIcon")?.resizeImageTo(size: CGSize(width: 40, height: 40))?.withTintColor(UIColor(red: 0.11, green: 0.42, blue: 0.64, alpha: 1.00))
        tabBarItems![1].isEnabled = false
        
        if userDetails.patient?.name == nil {
            view.isUserInteractionEnabled = false
            self.view.makeToastActivity(.center)
            contentView?.showAnimatedGradientSkeleton(transition: .crossDissolve(0.25))
            tabBarItems![1].isEnabled = false
            tabBarItems![2].isEnabled = false
            
            refreshUserDetails { isSuccess in
                if isSuccess {
                    //                    tabBarItems![1].isEnabled = true
                    tabBarItems![2].isEnabled = true
                    self.view.isUserInteractionEnabled = true
                    self.contentView?.hideSkeleton(transition: .crossDissolve(0.25))
                    self.loadData()
                    self.fetchDoctors()
                    self.view.hideToastActivity()
                } else {
                    self.logout()
                }
            }
        }
    }
    
    func refreshUserDetails(completionHandler: @escaping(Bool) -> ()) {
        APIService(data: [:], headers: ["Authorization" : "Bearer \(User.getUserDetails().token ?? "")"], url: nil, service: .getPatientWithID(userDetails.patient!.id!), method: .get, isJSONRequest: false).executeQuery() { (result: Result<Patient, Error>) in
            switch result{
            case .success(_):
                try? User.setPatientDetails(patient: result.get())
                completionHandler(true)
            case .failure(let error):
                print(error)
                completionHandler(false)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dismissKeyboard()
        
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationItem.largeTitleDisplayMode = .never
        navigationController?.isNavigationBarHidden = true
        
        initialise()
        setupUI()
        setConstraints()
        
        loadData()
        fetchDoctors()
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        DispatchQueue.global().async { [self] in
            if CLLocationManager.locationServicesEnabled() {
                switch locationManager.authorizationStatus {
                case .notDetermined, .restricted, .denied:
                    Prefs.isLocationPerm = false
                    Prefs.showDistanceFromUser = false
                case .authorizedAlways, .authorizedWhenInUse:
                    locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                    locationManager.startUpdatingLocation()
                @unknown default:
                    break
                }
            } else {
                Prefs.isLocationPerm = false
                Prefs.showDistanceFromUser = false
            }
        }
    }
    
    func initialise() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(logout), name: Notification.Name("logout"), object: nil)
    }
    
    func setupUI() {
        scrollView = UIScrollView()
        contentView = UIView()
        contentView?.isSkeletonable = true
        
        view.addSubview(scrollView!)
        scrollView?.addSubview(contentView!)
        
        helloTextLabel = UILabel()
        helloTextLabel?.text = "👋 Hello!"
        helloTextLabel?.textColor = .black
        helloTextLabel?.font = UIFont(name: "NunitoSans-SemiBold", size: 16)
        contentView?.addSubview(helloTextLabel!)
        helloTextLabel?.addSkeleton()
        
        welcomeWithNameLabel = UILabel()
        welcomeWithNameLabel?.text = " "
        welcomeWithNameLabel?.textColor = .black
        welcomeWithNameLabel?.font = UIFont(name: "NunitoSans-Bold", size: 27)
        contentView?.addSubview(welcomeWithNameLabel!)
        welcomeWithNameLabel?.addSkeleton()
        
        profileImageView = UIImageView()
        profileImageView?.contentMode = .scaleAspectFill
        profileImageView?.makeRoundCorners(byRadius: 18)
        contentView?.addSubview(profileImageView!)
        let profileImageTap = UITapGestureRecognizer(target: self, action: #selector(self.goToProfileScreen(_:)))
        profileImageView?.addGestureRecognizer(profileImageTap)
        profileImageView?.isUserInteractionEnabled = true
        profileImageView?.addSkeleton()
        
        searchBar = SearchBarWithSearchAndFilterIcon()
        searchBar?.setPlaceholder(placeholder: "Search medical")
        searchBar?.delegate = self
        contentView?.addSubview(searchBar!)
        
        servicesTextLabel = UILabel()
        servicesTextLabel?.text = "Services"
        servicesTextLabel?.textColor = .black
        servicesTextLabel?.font = UIFont(name: "NunitoSans-Bold", size: 17)
        contentView?.addSubview(servicesTextLabel!)
        
        doctorsTab = TabForServices_VariableColor()
        doctorsTab?.initTabButton(variant: .blue, tabImage: UIImage(named: "doctorHomeTabIcon")!)
        contentView?.addSubview(doctorsTab!)
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.goToDoctorsScreen(_:)))
        doctorsTab?.addGestureRecognizer(tap)
        
        reportsTab = TabForServices_VariableColor()
        reportsTab?.initTabButton(variant: .sky, tabImage: UIImage(named: "reportHomeTabIcon")!)
        contentView?.addSubview(reportsTab!)
        
        banner = UIImageView()
        banner?.image = UIImage(named: "homeScreenBannerImage")
        banner?.contentMode = .scaleAspectFill
        contentView?.addSubview(banner!)
        
        nearbyTextLabel = UILabel()
        nearbyTextLabel?.text = "Nearby Doctors"
        nearbyTextLabel?.textColor = .black
        nearbyTextLabel?.font = UIFont(name: "NunitoSans-Bold", size: 17)
        contentView?.addSubview(nearbyTextLabel!)
        
        nearbyView = UIView()
        nearbyView?.backgroundColor = .gray
        nearbyView?.layer.cornerRadius = 28
        contentView?.addSubview(nearbyView!)
        
        nearbyMapView = MKMapView()
        nearbyMapView?.showsUserLocation = true
        nearbyMapView?.layer.cornerRadius = 28
        nearbyMapView?.delegate = self
        nearbyView?.addSubview(nearbyMapView!)
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(mapTouchAction(gestureRecognizer:)))
        nearbyMapView?.addGestureRecognizer(gestureRecognizer)
        
        minimizeButton = UIButton()
        minimizeButton?.setImage(UIImage(systemName: "x.circle.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 140, weight: .bold, scale: .large))?.withAlpha(0.75).withTintColor(.black), for: .normal)
        minimizeButton?.addTarget(self, action: #selector(mapDismissAction), for: .touchUpInside)
        minimizeButton?.alpha = 0
        nearbyView?.addSubview(minimizeButton!)
    }
    
    func setConstraints() {
        scrollView?.translatesAutoresizingMaskIntoConstraints = false
        contentView?.translatesAutoresizingMaskIntoConstraints = false
        helloTextLabel?.translatesAutoresizingMaskIntoConstraints = false
        welcomeWithNameLabel?.translatesAutoresizingMaskIntoConstraints = false
        profileImageView?.translatesAutoresizingMaskIntoConstraints = false
        searchBar?.translatesAutoresizingMaskIntoConstraints = false
        servicesTextLabel?.translatesAutoresizingMaskIntoConstraints = false
        doctorsTab?.translatesAutoresizingMaskIntoConstraints = false
        reportsTab?.translatesAutoresizingMaskIntoConstraints = false
        banner?.translatesAutoresizingMaskIntoConstraints = false
        nearbyTextLabel?.translatesAutoresizingMaskIntoConstraints = false
        nearbyView?.translatesAutoresizingMaskIntoConstraints = false
        minimizeButton?.translatesAutoresizingMaskIntoConstraints = false
        nearbyMapView?.translatesAutoresizingMaskIntoConstraints = false
        
        
        
        scrollView?.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        scrollView?.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        scrollView?.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        scrollView?.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        
        contentView?.topAnchor.constraint(equalTo: scrollView!.topAnchor).isActive = true
        contentView?.leadingAnchor.constraint(equalTo: scrollView!.leadingAnchor).isActive = true
        contentView?.trailingAnchor.constraint(equalTo: scrollView!.trailingAnchor).isActive = true
        contentView?.bottomAnchor.constraint(equalTo: scrollView!.bottomAnchor).isActive = true
        contentView?.widthAnchor.constraint(equalTo: scrollView!.widthAnchor).isActive = true
        
        
        helloTextLabel?.topAnchor.constraint(equalTo: contentView!.topAnchor, constant: 25).isActive = true
        helloTextLabel?.leadingAnchor.constraint(equalTo: contentView!.leadingAnchor, constant: 28).isActive = true
        helloTextLabel?.trailingAnchor.constraint(equalTo: profileImageView!.leadingAnchor, constant: -10).isActive = true
        
        welcomeWithNameLabel?.topAnchor.constraint(equalTo: helloTextLabel!.bottomAnchor, constant: 7).isActive = true
        welcomeWithNameLabel?.leadingAnchor.constraint(equalTo: helloTextLabel!.leadingAnchor).isActive = true
        welcomeWithNameLabel?.trailingAnchor.constraint(equalTo: helloTextLabel!.trailingAnchor).isActive = true
        
        profileImageView?.topAnchor.constraint(equalTo: helloTextLabel!.topAnchor).isActive = true
        profileImageView?.trailingAnchor.constraint(equalTo: contentView!.trailingAnchor, constant: -28).isActive = true
        profileImageView?.widthAnchor.constraint(equalToConstant: 55).isActive = true
        profileImageView?.heightAnchor.constraint(equalToConstant: 55).isActive = true
        
        searchBar?.topAnchor.constraint(equalTo: welcomeWithNameLabel!.bottomAnchor, constant: 24).isActive = true
        searchBar?.leadingAnchor.constraint(equalTo: contentView!.leadingAnchor, constant: 28).isActive = true
        searchBar?.trailingAnchor.constraint(equalTo: contentView!.trailingAnchor, constant: -28).isActive = true
        searchBar?.heightAnchor.constraint(equalToConstant: 61).isActive = true
        
        servicesTextLabel?.topAnchor.constraint(equalTo: searchBar!.bottomAnchor, constant: 23).isActive = true
        servicesTextLabel?.leadingAnchor.constraint(equalTo: searchBar!.leadingAnchor).isActive = true
        servicesTextLabel?.trailingAnchor.constraint(equalTo: searchBar!.trailingAnchor).isActive = true
        
        doctorsTab?.topAnchor.constraint(equalTo: servicesTextLabel!.bottomAnchor, constant: 12).isActive = true
        doctorsTab?.leadingAnchor.constraint(equalTo: contentView!.leadingAnchor, constant: 28).isActive = true
        doctorsTab?.widthAnchor.constraint(equalToConstant: 72).isActive = true
        doctorsTab?.heightAnchor.constraint(equalToConstant: 72).isActive = true
        
        reportsTab?.topAnchor.constraint(equalTo: doctorsTab!.topAnchor).isActive = true
        reportsTab?.leadingAnchor.constraint(equalTo: doctorsTab!.trailingAnchor, constant: 12).isActive = true
        reportsTab?.widthAnchor.constraint(equalTo: doctorsTab!.widthAnchor).isActive = true
        reportsTab?.heightAnchor.constraint(equalTo: doctorsTab!.heightAnchor).isActive = true
        
        banner?.topAnchor.constraint(equalTo: doctorsTab!.bottomAnchor, constant: 30).isActive = true
        banner?.leadingAnchor.constraint(equalTo: contentView!.leadingAnchor, constant: 28).isActive = true
        banner?.trailingAnchor.constraint(equalTo: contentView!.trailingAnchor, constant: -28).isActive = true
        banner?.heightAnchor.constraint(equalToConstant: 170).isActive = true
        
        nearbyTextLabel?.topAnchor.constraint(equalTo: banner!.bottomAnchor, constant: 23).isActive = true
        nearbyTextLabel?.leadingAnchor.constraint(equalTo: searchBar!.leadingAnchor).isActive = true
        nearbyTextLabel?.trailingAnchor.constraint(equalTo: searchBar!.trailingAnchor).isActive = true
        
        mapViewTopConstraint = nearbyView?.topAnchor.constraint(equalTo: nearbyTextLabel!.bottomAnchor, constant: 12)
        mapViewLeadingConstraint = nearbyView?.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 28)
        mapViewTrailingConstraint = nearbyView?.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -28)
        mapViewBottomConstraint = nearbyView?.bottomAnchor.constraint(equalTo: contentView!.bottomAnchor, constant: -30)
        mapViewHeightConstraint = nearbyView?.heightAnchor.constraint(equalToConstant: 180)
        
        mapViewTopConstraint?.isActive = true
        mapViewLeadingConstraint?.isActive = true
        mapViewTrailingConstraint?.isActive = true
        mapViewBottomConstraint?.isActive = true
        mapViewHeightConstraint?.isActive = true
        
        minimizeButton?.topAnchor.constraint(equalTo: nearbyView!.topAnchor, constant: 20).isActive = true
        minimizeButton?.trailingAnchor.constraint(equalTo: nearbyView!.trailingAnchor, constant: -20).isActive = true
        minimizeButton?.widthAnchor.constraint(equalToConstant: 40).isActive = true
        minimizeButton?.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        nearbyMapView?.topAnchor.constraint(equalTo: nearbyView!.topAnchor).isActive = true
        nearbyMapView?.leadingAnchor.constraint(equalTo: nearbyView!.leadingAnchor).isActive = true
        nearbyMapView?.trailingAnchor.constraint(equalTo: nearbyView!.trailingAnchor).isActive = true
        nearbyMapView?.bottomAnchor.constraint(equalTo: nearbyView!.bottomAnchor).isActive = true
    }
    
    func loadData() {
        userDetails = User.getUserDetails()
        welcomeWithNameLabel?.text = (userDetails.patient?.name?.firstName ?? "") + " " + (userDetails.patient?.name?.lastName ?? "")
        profileImageView?.setKFImage(imageUrl: userDetails.patient?.profileImage?.fileDownloadURI ?? "", placeholderImage: UIImage(named: (userDetails.patient?.gender?.lowercased() ?? "male" == "male") ? "userPlaceholder-male" : "userPlaceholder-female")!)
    }
    
    func fetchDoctors() {
        Doctor.refreshDoctors { isSuccess in
            self.doctors = Doctor.getDoctors()
            for doctor in self.doctors {
                let annotation = MKPointAnnotation()
                annotation.coordinate = CLLocationCoordinate2D(latitude: doctor.address!.latitude!, longitude: doctor.address!.longitude!)
                annotation.title = doctor.fullNameWithTitle
                self.nearbyMapView?.addAnnotation(annotation)
            }
            if Prefs.isLocationPerm {
                let coordinateRegion = MKCoordinateRegion(center: self.currentLocation.coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)
                self.nearbyMapView?.setRegion(coordinateRegion, animated: true)
            }
        }
    }
    
    @objc func goToDoctorsScreen(_ sender: UITapGestureRecognizer? = nil) {
        let doctorsScreenVC = UIStoryboard.init(name: "HomeTab", bundle: Bundle.main).instantiateViewController(withIdentifier: "doctorsScreenVC") as? DoctorsScreenViewController
        //        doctorsScreenVC?.modalPresentationStyle = .fullScreen
        //        self.present(doctorsScreenVC!, animated: true, completion: nil)
        self.navigationController?.pushViewController(doctorsScreenVC!, animated: true)
    }
    
    @objc func goToProfileScreen(_ sender: UITapGestureRecognizer? = nil) {
        let profileVC = UIStoryboard.init(name: "HomeTab", bundle: Bundle.main).instantiateViewController(withIdentifier: "profileVC") as? ProfileViewViewController
        profileVC?.modalPresentationStyle = .fullScreen
        profileVC?.modalTransitionStyle = .coverVertical
        self.present(profileVC!, animated: true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            
            // if keyboard size is not available for some reason, dont do anything
            return
        }
        
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height , right: 0.0)
        scrollView!.contentInset = contentInsets
        scrollView!.scrollIndicatorInsets = contentInsets
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        
        // reset back the content inset to zero after keyboard is gone
        scrollView!.contentInset = contentInsets
        scrollView!.scrollIndicatorInsets = contentInsets
    }
    
    @objc func mapTouchAction(gestureRecognizer: UITapGestureRecognizer) {
        if !isMapExpanded {
            self.view.isUserInteractionEnabled = false
            self.mapViewHeightConstraint?.isActive = false
            
            self.mapViewTopConstraint?.isActive = false
            self.mapViewTopConstraint = self.nearbyView?.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0)
            self.mapViewBottomConstraint = self.nearbyView?.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
            
            UIView.animate(withDuration: 0.5, animations: {
                self.mapViewLeadingConstraint?.constant = 0
                self.mapViewTrailingConstraint?.constant = 0
                
                
                self.mapViewTopConstraint?.isActive = true
                self.mapViewLeadingConstraint?.isActive = true
                self.mapViewTrailingConstraint?.isActive = true
                self.mapViewBottomConstraint?.isActive = true
                
                self.nearbyView?.layer.cornerRadius = 0
                self.nearbyMapView?.layer.cornerRadius = 0
                self.minimizeButton?.alpha = 1
                
                self.contentView?.layoutIfNeeded()
                self.view.isUserInteractionEnabled = true
            })
            isMapExpanded = true
        }
    }
    
    @objc func mapDismissAction() {
        if isMapExpanded {
            self.view.isUserInteractionEnabled = false
            self.mapViewTopConstraint?.isActive = false
            self.mapViewBottomConstraint?.isActive = false
            self.mapViewTopConstraint = self.nearbyView?.topAnchor.constraint(equalTo: nearbyTextLabel!.bottomAnchor, constant: 12)
            self.mapViewBottomConstraint = self.nearbyView?.bottomAnchor.constraint(equalTo: contentView!.bottomAnchor, constant: -30)
            self.mapViewHeightConstraint?.isActive = true
            
            UIView.animate(withDuration: 0.5, animations: {
                self.minimizeButton?.alpha = 0
                self.mapViewLeadingConstraint?.constant = 28
                self.mapViewTrailingConstraint?.constant = -28
                
                
                self.mapViewTopConstraint?.isActive = true
                self.mapViewLeadingConstraint?.isActive = true
                self.mapViewTrailingConstraint?.isActive = true
                self.mapViewBottomConstraint?.isActive = true
                
                self.nearbyView?.layer.cornerRadius = 28
                self.nearbyMapView?.layer.cornerRadius = 28
                
                self.contentView?.layoutIfNeeded()
                self.view.isUserInteractionEnabled = true
            })
            isMapExpanded = false
        }
    }
    
    @objc func logout() {
        User.clearUserDetails()
        self.performSegue(withIdentifier: "toLanding", sender: nil)
    }
    
}

extension HomeTabViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}

extension HomeTabViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location: CLLocation = manager.location else { return }
        self.locationManager.stopUpdatingLocation()
        self.currentLocation = location
        Prefs.isLocationPerm = true
        Prefs.showDistanceFromUser = true
    }
}

extension HomeTabViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let annotation = view.annotation {
            guard !(annotation is MKUserLocation) else { return }
            if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {  //if phone has an app
                
                if let url = URL(string: "comgooglemaps-x-callback://?saddr=&daddr=\(annotation.coordinate.latitude),\(annotation.coordinate.longitude)&directionsmode=driving") {
                    UIApplication.shared.open(url, options: [:])
                }}
            else {
                //Open in browser
                if let urlDestination = URL.init(string: "https://www.google.co.in/maps/dir/?saddr=&daddr=\(annotation.coordinate.latitude),\(annotation.coordinate.longitude)&directionsmode=driving") {
                    UIApplication.shared.open(urlDestination)
                }
            }
        }
    }
}
