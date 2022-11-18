//
//  DoctorsScreenViewController.swift
//  Medonapp iOS
//
//  Created by Harshal Kulkarni on 10/10/22.
//

import UIKit
import CoreLocation
import MobileCoreServices

class DoctorsScreenViewController: UIViewController {
    
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation = CLLocation()
    
    public var doctors: [Doctor] = []
    private var doctorsSet: Set<Doctor> = []
    
    private var backButton: UIImageView?
    private var navTitle: UILabel?
    private var searchField: SearchBarWithSearchAndFilterIcon?
    private var filterIcon: UIImageView?
    var doctorsTable: UITableView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Doctors"
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationItem.largeTitleDisplayMode = .never
        navigationController?.isNavigationBarHidden = true
        
        self.dismissKeyboard()
        
        initialise()
        setupUI()
        setConstraints()
        
        doctorsTable?.register(DoctorInfoTableViewCell.nib(), forCellReuseIdentifier: DoctorInfoTableViewCell.identifier)
        doctorsTable?.delegate = self
        doctorsTable?.dataSource = self
        doctorsTable?.dragInteractionEnabled = true
        doctorsTable?.dragDelegate = self
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let selectedIndexPath = doctorsTable?.indexPathForSelectedRow {
            doctorsTable?.deselectRow(at: selectedIndexPath, animated: animated)
        }
        
        refreshData()
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
        navTitle?.text = "Doctors"
        navTitle?.textAlignment = .center
        navTitle?.textColor = .black
        navTitle?.font = UIFont(name: "NunitoSans-Bold", size: 18)
        view.addSubview(navTitle!)
        
        searchField = SearchBarWithSearchAndFilterIcon()
        searchField?.setupUI()
        searchField?.delegate = self
        searchField?.setPlaceholder(placeholder: "Search Doctor")
        view.addSubview(searchField!)
        searchField?.addTarget(self, action: #selector(searchFieldDidChange(_:)), for: .allEditingEvents)
        
        filterIcon = UIImageView()
        filterIcon?.image = UIImage(systemName: "slider.horizontal.3")
        filterIcon?.tintColor = .black
        filterIcon?.contentMode = .scaleAspectFit
        filterIcon?.alpha = 0.7
        view.addSubview(filterIcon!)
        let filterTap = UITapGestureRecognizer(target: self, action: #selector(self.handleFilterClick(_:)))
        filterIcon?.addGestureRecognizer(filterTap)
        filterIcon?.isUserInteractionEnabled = true
        
        doctorsTable = UITableView()
        doctorsTable?.separatorStyle = .none
        doctorsTable?.showsVerticalScrollIndicator = false
        view.addSubview(doctorsTable!)
    }
    
    func setConstraints() {
        backButton?.translatesAutoresizingMaskIntoConstraints = false
        navTitle?.translatesAutoresizingMaskIntoConstraints = false
        searchField?.translatesAutoresizingMaskIntoConstraints = false
        filterIcon?.translatesAutoresizingMaskIntoConstraints = false
        doctorsTable?.translatesAutoresizingMaskIntoConstraints = false
        
        
        backButton?.topAnchor.constraint(equalTo: view.topAnchor, constant: 65).isActive = true
        backButton?.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 28).isActive = true
        backButton?.widthAnchor.constraint(equalToConstant: 50).isActive = true
        backButton?.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        navTitle?.topAnchor.constraint(equalTo: view.topAnchor, constant: 78).isActive = true
        navTitle?.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        navTitle?.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        searchField?.topAnchor.constraint(equalTo: navTitle!.bottomAnchor, constant: 25).isActive = true
        searchField?.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 27).isActive = true
//        searchField?.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -27).isActive = true
        searchField?.heightAnchor.constraint(equalToConstant: 56).isActive = true
        searchField?.widthAnchor.constraint(equalTo: filterIcon!.widthAnchor, multiplier: 5).isActive = true
        
        filterIcon?.topAnchor.constraint(equalTo: searchField!.topAnchor, constant: 12).isActive = true
        filterIcon?.leadingAnchor.constraint(equalTo: searchField!.trailingAnchor, constant: 10).isActive = true
        filterIcon?.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -27).isActive = true
        filterIcon?.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
        doctorsTable?.topAnchor.constraint(equalTo: searchField!.bottomAnchor, constant: 10).isActive = true
        doctorsTable?.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10).isActive = true
        doctorsTable?.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10).isActive = true
        doctorsTable?.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true
    }
    
    @objc func handleBackAction(_ sender: UITapGestureRecognizer? = nil) {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func handleFilterClick(_ sender: UITapGestureRecognizer? = nil) {
        let sheetViewController = FilterHalfScreenVC()
        sheetViewController.delegate = self
        
        // Present it w/o any adjustments so it uses the default sheet presentation.
        present(sheetViewController, animated: true)
    }
    
    @objc func refreshData() {
        Doctor.refreshDoctors { isSuccess in
            self.doctors = Doctor.getDoctors()
            if Prefs.showDistanceFromUser == true {
                Doctor.getDistanceFromUser(userLocation: self.currentLocation)
            }
            self.doctorsSet = Set(self.doctors.map { $0 })
            Doctor.calculateLiveStatus() //Calculate doctor live status
            self.searchFieldDidChange(self.searchField!)
            let sections = NSIndexSet(indexesIn: NSMakeRange(0, self.doctorsTable!.numberOfSections))
            self.doctorsTable!.reloadSections(sections as IndexSet, with: .automatic)
        }
    }
    
    @objc func searchFieldDidChange(_ textField: UITextField) {
        doctorsSet = []
        let textToSearch: String = textField.text ?? ""
        if textToSearch.count < 1 {
            doctorsSet = Set(doctors.map { $0 })
            let range = NSMakeRange(0, self.doctorsTable!.numberOfSections)
            let sections = NSIndexSet(indexesIn: range)
            self.doctorsTable!.reloadSections(sections as IndexSet, with: .automatic)
            return
        }
        for doctor in self.doctors {
            if doctor.name!.fullName!.contains(textToSearch) {
                doctorsSet.insert(doctor)
            }
            if doctor.specialization!.contains(textToSearch) {
                doctorsSet.insert(doctor)
            }
        }
        
        let range = NSMakeRange(0, self.doctorsTable!.numberOfSections)
        let sections = NSIndexSet(indexesIn: range)
        self.doctorsTable!.reloadSections(sections as IndexSet, with: .automatic)
    }
    
}

extension DoctorsScreenViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location: CLLocation = manager.location else { return }
        self.locationManager.stopUpdatingLocation()
        self.currentLocation = location
        Prefs.isLocationPerm = true
        Prefs.showDistanceFromUser = true
    }
    
}

extension DoctorsScreenViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
}

extension DoctorsScreenViewController: UITableViewDelegate, UITableViewDataSource, UITableViewDragDelegate {
    
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let doctor = Doctor.sortDoctors(doctors: Array(doctorsSet))[indexPath.row]
        //text to share
        let text = "Hey! I met Dr. \((doctor.name?.firstName ?? "") + " " + (doctor.name?.lastName ?? "")) on Medonapp!\n\(doctor.gender?.lowercased() == "male" ? "He" : "She") is rated \(doctor.avgRating!.clean) stars and has \(doctor.experience!.clean)+ years of experience.\n\nYou can contact them through the following channels:\nNumber: \(doctor.mobile!.contactNumberWithCountryCode!)\nEmail: \(doctor.credential!.email!)\n\nDownload Medonapp now!!"
        
        let data = text.data(using: .utf8)
        let itemProvider = NSItemProvider()
        
        itemProvider.registerDataRepresentation(forTypeIdentifier: kUTTypePlainText as String, visibility: .all) { completion in
            completion(data, nil)
            return nil
        }
        
        return [
            UIDragItem(itemProvider: itemProvider)
        ]
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return doctorsSet.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell = tableView.dequeueReusableCell(withIdentifier: DoctorInfoTableViewCell.identifier, for: indexPath) as! DoctorInfoTableViewCell
        
        tableCell.configure(doctor: Doctor.sortDoctors(doctors: Array(doctorsSet))[indexPath.row])
        return tableCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        doctorsTable?.scrollToRow(at: indexPath, at: .middle, animated: true)
        refreshTableView()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            let doctorsDetailsVC = UIStoryboard.init(name: "HomeTab", bundle: Bundle.main).instantiateViewController(withIdentifier: "doctorsDetailsVC") as? DoctorDetailsViewViewController
            doctorsDetailsVC?.doctor = Doctor.sortDoctors(doctors: Array(self.doctorsSet))[indexPath.row]
            self.navigationController?.pushViewController(doctorsDetailsVC!, animated: true)
        }
    }
    
    func refreshTableView() {
        doctorsTable?.reloadData()
    }
}

extension DoctorsScreenViewController: FilterHalfScreenDelegate {
    func filderDidEndSelecting() {
        
    }
}
