//
//  DoctorsScreenViewController.swift
//  Medonapp iOS
//
//  Created by Harshal Kulkarni on 10/10/22.
//

import UIKit
import CoreLocation
import MobileCoreServices
import Toast_Swift
import Localize_Swift

class DoctorsScreenViewController: UIViewController {
    
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation = CLLocation()
    
    public var doctors: Doctors = []
    private var doctorsSet: Set<Doctor> = []
    
    private var backButton: UIImageView?
    private var navTitle: UILabel?
    private var searchField: SearchBarWithSearchAndFilterIcon?
    private var filterIcon: UIImageView?
    var doctorsTable: UITableView?
    var dropView: UIView?
    var dropImageView: UIImageView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "doctors".localized()
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
        
        populateDoctorsTable()
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
        navTitle?.text = "doctors".localized()
        navTitle?.textAlignment = .center
        navTitle?.textColor = .black
        navTitle?.font = UIFont(name: "NunitoSans-Bold", size: 18)
        view.addSubview(navTitle!)
        
        searchField = SearchBarWithSearchAndFilterIcon()
        searchField?.setupUI()
        searchField?.delegate = self
        searchField?.setPlaceholder(placeholder: "search_doctor".localized())
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
        
        dropView = UIView()
        dropView?.alpha = 0
        view.addSubview(dropView!)
        let dropInteractionDropView = UIDropInteraction(delegate: self)
        dropView?.addInteraction(dropInteractionDropView)
        
        dropImageView = UIImageView()
        dropImageView?.image = UIImage(named: "shareDocDesign")
        dropImageView?.contentMode = .scaleAspectFill
        dropView?.addSubview(dropImageView!)
    }
    
    func setConstraints() {
        backButton?.translatesAutoresizingMaskIntoConstraints = false
        navTitle?.translatesAutoresizingMaskIntoConstraints = false
        searchField?.translatesAutoresizingMaskIntoConstraints = false
        filterIcon?.translatesAutoresizingMaskIntoConstraints = false
        doctorsTable?.translatesAutoresizingMaskIntoConstraints = false
        dropView?.translatesAutoresizingMaskIntoConstraints = false
        dropImageView?.translatesAutoresizingMaskIntoConstraints = false
        
        
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
        
        dropView?.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        dropView?.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        dropView?.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        dropView?.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        dropImageView?.topAnchor.constraint(equalTo: dropView!.topAnchor).isActive = true
        dropImageView?.leadingAnchor.constraint(equalTo: dropView!.leadingAnchor).isActive = true
        dropImageView?.trailingAnchor.constraint(equalTo: dropView!.trailingAnchor).isActive = true
        dropImageView?.bottomAnchor.constraint(equalTo: dropView!.bottomAnchor).isActive = true
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
            self.populateDoctorsTable()
        }
    }
    
    func populateDoctorsTable() {
        self.doctors = Doctor.getDoctors()
        if Prefs.showDistanceFromUser == true {
            Doctor.getDistanceFromUser(userLocation: self.currentLocation)
        }
        self.doctorsSet = Set(self.doctors.map { $0 })
        Doctor.calculateLiveStatus() //Calculate doctor live status
        self.searchFieldDidChange(self.searchField!)
        let sections = NSIndexSet(indexesIn: NSMakeRange(0, self.doctorsTable!.numberOfSections))
        self.doctorsTable!.reloadSections(sections as IndexSet, with: .fade)
        self.view.isUserInteractionEnabled = true
        self.view.hideToastActivity()
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

extension DoctorsScreenViewController: UIContextMenuInteractionDelegate {
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        return nil
    }
}

extension DoctorsScreenViewController: UITableViewDelegate, UITableViewDataSource {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
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
        tableCell.layer.cornerRadius = 20
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
    
    func tableView(_ tableView: UITableView, willEndContextMenuInteraction configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionAnimating?) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            self.refreshData()
        }
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        // We have to create an NSString since the identifier must conform to NSCopying
        let identifier = NSString(string: "\(indexPath.row)")
        
        return UIContextMenuConfiguration(identifier: identifier, previewProvider: {
            let doctorPeekVC = UIStoryboard.init(name: "HomeTab", bundle: Bundle.main).instantiateViewController(withIdentifier: "doctorPeekVC") as? DoctorDetailsPeekViewViewController
            doctorPeekVC?.doctor = Doctor.sortDoctors(doctors: Array(self.doctorsSet))[indexPath.row]
            return doctorPeekVC
        }) { suggestedActions in
            
            //common init of doctorDetailsVC
            let doctorsDetailsVC = UIStoryboard.init(name: "HomeTab", bundle: Bundle.main).instantiateViewController(withIdentifier: "doctorsDetailsVC") as? DoctorDetailsViewViewController
            doctorsDetailsVC?.doctor = Doctor.sortDoctors(doctors: Array(self.doctorsSet))[indexPath.row]
            
            
            let bookAppt = UIAction(title: "book_appointment".localized(), image: UIImage(systemName: "clock.badge.checkmark")) { action in
                self.navigationController?.pushViewController(doctorsDetailsVC!, animated: true)
                doctorsDetailsVC!.bookNowButtonPressed()
            }
            
            let shareProfile = UIAction(title: "share_profile".localized(), image: UIImage(systemName: "square.and.arrow.up")) { action in
                // text to share
                let text = "Hey! I met \(doctorsDetailsVC!.doctor!.fullNameWithTitle) on Medonapp!\n\(doctorsDetailsVC!.doctor?.gender?.lowercased() == "male" ? "He" : "She") is rated \(doctorsDetailsVC!.doctor!.avgRating!.clean) stars and has \(doctorsDetailsVC!.doctor!.experience!.clean)+ years of experience.\n\nYou can contact them through the following channels:\nNumber: \(doctorsDetailsVC!.doctor!.mobile!.contactNumberWithCountryCode!)\nEmail: \(doctorsDetailsVC!.doctor!.credential!.email!)\n\nDownload Medonapp now!!"
                
                // set up activity view controller
                let textToShare = [ text ]
                let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
                activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
                
                // exclude some activity types from the list (optional)
                activityViewController.excludedActivityTypes = [ ]
                
                // present the view controller
                self.present(activityViewController, animated: true, completion: nil)
            }
            
            let favorite = UIAction(title: (doctorsDetailsVC?.doctor?.isFavorite)! ? "unfavorite".localized() : "favorite".localized(), image: UIImage(systemName: (doctorsDetailsVC?.doctor?.isFavorite)! ? "heart.slash" : "heart")) { action in
                let generator = UIImpactFeedbackGenerator(style: .light)
                doctorsDetailsVC?.doctor?.setFavorite(state: !(doctorsDetailsVC?.doctor?.isFavorite)!) { isSuccess in
                    if isSuccess {
                        generator.impactOccurred()
                    }
                }
            }
            
            //        // Here we specify the "destructive" attribute to show that it’s destructive in nature
            //        let delete = UIAction(title: "Favorite", image: UIImage(systemName: "trash"), attributes: .destructive) { action in
            //            // Perform delete
            //        }
            
            return UIMenu(children: [bookAppt, shareProfile, favorite])
        }
    }
    
    func refreshTableView() {
        doctorsTable?.reloadData()
    }
}

extension DoctorsScreenViewController: UITableViewDragDelegate {
    
    func tableView(_ tableView: UITableView, dragSessionWillBegin session: UIDragSession) {
        UIView.animate(withDuration: 0.25, delay: 0.0, options: UIView.AnimationOptions.transitionCrossDissolve, animations: {
            self.dropView?.alpha = 1
        }, completion: {
            (finished: Bool) -> Void in
        })
    }
    
    func tableView(_ tableView: UITableView, dragSessionDidEnd session: UIDragSession) {
        UIView.animate(withDuration: 0.25, delay: 0.0, options: UIView.AnimationOptions.transitionCrossDissolve, animations: {
            self.dropView?.alpha = 0
        }, completion: {
            (finished: Bool) -> Void in
        })
    }
    
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let doctor = Doctor.sortDoctors(doctors: Array(doctorsSet))[indexPath.row]
        //text to share
        let text = "Hey! I met \(doctor.fullNameWithTitle) on Medonapp!\n\(doctor.gender?.lowercased() == "male" ? "He" : "She") is rated \(doctor.avgRating!.clean) stars and has \(doctor.experience!.clean)+ years of experience.\n\nYou can contact them through the following channels:\nNumber: \(doctor.mobile!.contactNumberWithCountryCode!)\nEmail: \(doctor.credential!.email!)\n\nDownload Medonapp now!!"
        
        let data = text.data(using: .utf8)
        let itemProvider = NSItemProvider()
        
        itemProvider.registerDataRepresentation(forTypeIdentifier: kUTTypePlainText as String, visibility: .all) { completion in
            completion(data, nil)
            return nil
        }
        
        let item = UIDragItem(itemProvider: itemProvider)
        
        item.previewProvider  = { () -> UIDragPreview? in
            let previewImageView = UIImageView()
            previewImageView.setKFImage(imageUrl: doctor.profileImage?.fileDownloadURI ?? "https://i.ibb.co/jHvKxC3/broken-1.jpg", placeholderImage: UIImage(named: (doctor.gender!.lowercased() == "male") ? "userPlaceholder-male" : "userPlaceholder-female")!)
            previewImageView.contentMode = .scaleAspectFill
            previewImageView.frame =  CGRect(x: 0, y: 0, width: 85, height: 85)
            previewImageView.layer.cornerRadius = previewImageView.bounds.maxX / 2
            return UIDragPreview(view: previewImageView)
        }
        
        return [
            item
        ]
    }
    
}

extension DoctorsScreenViewController: UIDropInteractionDelegate {
    
    func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
        return session.hasItemsConforming(toTypeIdentifiers: [kUTTypePlainText as String]) && session.items.count == 1
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        let dropLocation = session.location(in: view)
        //call update view function for displaying user is inside view
        
        let operation: UIDropOperation
        
        if dropView!.frame.contains(dropLocation) {
            /*
             If you add in-app drag-and-drop support for the .move operation,
             you must write code to coordinate between the drag interaction
             delegate and the drop interaction delegate.
             */
            operation = session.localDragSession == nil ? .copy : .move
        } else {
            // Do not allow dropping outside of the image view.
            operation = .cancel
        }
        
        return UIDropProposal(operation: operation)
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        session.items.first?.itemProvider.loadObject(ofClass: NSString.self, completionHandler: { strItem, err in
            if err == nil {
                // set up activity view controller
                
                OperationQueue.main.addOperation {
                    let textToShare = [ strItem! ]
                    let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
                    activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
                    
                    // exclude some activity types from the list (optional)
                    activityViewController.excludedActivityTypes = [ ]
                    
                    // present the view controller
                    self.present(activityViewController, animated: true, completion: nil)
                }
            } else {
                print(err)
            }
        })
    }
    
}

extension DoctorsScreenViewController: FilterHalfScreenDelegate {
    func filderDidEndSelecting() {
        
    }
}
