//
//  ManageFamilyViewController.swift
//  Medonapp iOS
//
//  Created by Harshal Kulkarni on 28/01/23.
//

import UIKit
import LGSegmentedControl
import Toast_Swift

enum FamilyTableState {
    case activeView
    case pendingView
}

class ManageFamilyViewController: UIViewController, UICollectionViewDelegateFlowLayout {
    
    private var backButton: UIImageView?
    private var navTitle: UILabel?
    private var addMemberButton: UIImageView?
    private var memberImagesCollectionView: UICollectionView?
    private var segmentedControl: LGSegmentedControl?
    private var membersTable: UITableView?
    private var membersTableHeightConstraint: NSLayoutConstraint?
    private var currentView: FamilyTableState = .activeView
    
    private var userDetails = User.getUserDetails()
    
    var totalMembersCount = 0 //Active + Pending
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationItem.largeTitleDisplayMode = .never
        navigationController?.isNavigationBarHidden = true
        
        totalMembersCount = userDetails.patient!.familyMembersActiveCount.0 + userDetails.patient!.familyRequestsPendingCountAsOrganizer.0
        
        initialise()
        setupUI()
        setConstraints()
        
        memberImagesCollectionView?.register(FamilyMemberCollectionViewCell.nib(), forCellWithReuseIdentifier: FamilyMemberCollectionViewCell.identifier)
        memberImagesCollectionView?.delegate = self
        memberImagesCollectionView?.dataSource = self
        
        membersTable?.register(MemberTableViewCell.nib(), forCellReuseIdentifier: MemberTableViewCell.identifier)
        membersTable?.delegate = self
        membersTable?.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        UIView.transition(with: membersTable!,
                          duration: 0.35,
                          options: .transitionCrossDissolve,
                          animations: { self.membersTable?.reloadData() })
        membersTable?.frame = CGRect(x: membersTable!.frame.origin.x, y: membersTable!.frame.origin.y, width: membersTable!.frame.size.width, height: membersTable!.contentSize.height)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        membersTable?.frame = CGRect(x: membersTable!.frame.origin.x, y: membersTable!.frame.origin.y, width: membersTable!.frame.size.width, height: membersTable!.contentSize.height)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        Utils.checkForReachability()
        
        centerCollectionViewItems()
        populateFamilyTable()
        
        if Prefs.isNetworkAvailable {
            refreshData()
        } else {
            //TODO: Add actions if network not available
        }
        
        //segmented control init
        segmentedControl?.selectedIndex = currentView == .activeView ? 0 : 1
        if userDetails.patient!.familyRequestsPendingCountAsOrganizer.0 > 0 {
            segmentedControl?.segments[1].badgeCount = userDetails.patient!.familyRequestsPendingCountAsOrganizer.0
            segmentedControl?.isHidden = false
        } else {
            segmentedControl?.isHidden = true
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    @objc func refreshData() {
        view.isUserInteractionEnabled = false
        self.view.makeToastActivity(.center)
        
        User.refreshUserDetails { isSuccess in
            if isSuccess {
                self.view.isUserInteractionEnabled = true
                self.userDetails = User.getUserDetails()
                self.view.hideToastActivity()
            } else {
                Utils.displaySPIndicatorNotifWithoutMessage(title: "Could not refresh data", iconPreset: .error, hapticPreset: .error, duration: 2)
            }
        }
    }
    
    func populateFamilyTable() {
    }
    
    func initialise() {
        NotificationCenter.default.addObserver(self, selector: #selector(refreshData), name: Notification.Name("refreshData"), object: nil)
    }
    
    func setupUI() {
        view.isSkeletonable = true
        view.backgroundColor = .systemGroupedBackground
        
        backButton = UIImageView()
        backButton?.image = UIImage(named: "backIcon_White")?.resizeImageTo(size: CGSize(width: 50, height: 50))
        backButton?.contentMode = .scaleAspectFit
        view.addSubview(backButton!)
        let backTap = UITapGestureRecognizer(target: self, action: #selector(self.handleBackAction(_:)))
        backButton?.addGestureRecognizer(backTap)
        backButton?.isUserInteractionEnabled = true
        
        navTitle = UILabel()
        navTitle?.text = "Manage Family"
        navTitle?.textAlignment = .center
        navTitle?.textColor = .black
        navTitle?.font = UIFont(name: "NunitoSans-Bold", size: 18)
        view.addSubview(navTitle!)
        
        addMemberButton = UIImageView()
        addMemberButton?.image = UIImage(systemName: "person.crop.circle.badge.plus")
        addMemberButton?.tintColor = .black
        view.addSubview(addMemberButton!)
        addMemberButton?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.handleAddMemberTapAction(_:))))
        addMemberButton?.isUserInteractionEnabled = true
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: 70, height: 70)
        //        layout.scrollDirection = .horizontal
        
        memberImagesCollectionView =  UICollectionView(frame: CGRect(x: 0, y: 0, width: view.frame.width-45, height: 100), collectionViewLayout: layout)
        memberImagesCollectionView?.backgroundColor = .clear
        view.addSubview(memberImagesCollectionView!)
        memberImagesCollectionView?.showsHorizontalScrollIndicator = false
        memberImagesCollectionView?.showsVerticalScrollIndicator = false
        
        segmentedControl = LGSegmentedControl(frame: CGRect(x: 20, y: 0, width: view.frame.width - 40, height: 30))
        view.addSubview(segmentedControl!)
        segmentedControl?.isHidden = true
        segmentedControl?.segments = [
            LGSegment(title: "Active"),
            LGSegment(title: "Pending", badgeCount: nil)
        ]
        segmentedControl?.addTarget(self, action: #selector(selectedSegment(_:)), for: .valueChanged)
        
        membersTable = UITableView()
        membersTable?.backgroundColor = .white
        membersTable?.layer.cornerRadius = 23
        membersTable?.isScrollEnabled = false
        view.addSubview(membersTable!)
    }
    
    func setConstraints() {
        backButton?.translatesAutoresizingMaskIntoConstraints = false
        navTitle?.translatesAutoresizingMaskIntoConstraints = false
        addMemberButton?.translatesAutoresizingMaskIntoConstraints = false
        memberImagesCollectionView?.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl?.translatesAutoresizingMaskIntoConstraints = false
        membersTable?.translatesAutoresizingMaskIntoConstraints = false
        
        
        backButton?.topAnchor.constraint(equalTo: view.topAnchor, constant: 65).isActive = true
        backButton?.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 28).isActive = true
        backButton?.widthAnchor.constraint(equalToConstant: 50).isActive = true
        backButton?.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        navTitle?.topAnchor.constraint(equalTo: view.topAnchor, constant: 79).isActive = true
        navTitle?.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        navTitle?.widthAnchor.constraint(equalToConstant: view.frame.width - 160).isActive = true
        
        addMemberButton?.topAnchor.constraint(equalTo: view.topAnchor, constant: 75).isActive = true
        addMemberButton?.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -28).isActive = true
        addMemberButton?.widthAnchor.constraint(equalToConstant: 32).isActive = true
        addMemberButton?.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        memberImagesCollectionView?.topAnchor.constraint(equalTo: navTitle!.bottomAnchor, constant: 80).isActive = true
        memberImagesCollectionView?.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        memberImagesCollectionView?.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        memberImagesCollectionView?.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        segmentedControl?.topAnchor.constraint(equalTo: memberImagesCollectionView!.bottomAnchor, constant: 30).isActive = true
        segmentedControl?.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        membersTable?.topAnchor.constraint(equalTo: segmentedControl!.bottomAnchor, constant: 10).isActive = true
        membersTable?.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        membersTable?.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        membersTableHeightConstraint = membersTable?.heightAnchor.constraint(equalToConstant: 0)
        membersTableHeightConstraint?.isActive = true
//        membersTable?.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
    }
    
    @objc func handleBackAction(_ sender: UITapGestureRecognizer? = nil) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func handleAddMemberTapAction(_ sender: UITapGestureRecognizer? = nil) {
        let addFamilyMemberVC = UIStoryboard.init(name: "HomeTab", bundle: Bundle.main).instantiateViewController(withIdentifier: "addFamilyMemberVC") as? AddFamilyMemberViewController
        self.present(addFamilyMemberVC!, animated: true, completion: nil)
    }
    
    private func handleRemoveFromFamily() {
        print("Removed From Family")
    }
    
    func centerCollectionViewItems() {
        var insets = self.memberImagesCollectionView?.contentInset
        var leftInsets = (self.view.frame.size.width - (40 * CGFloat(totalMembersCount))) * 0.5 - (CGFloat(totalMembersCount-1) * 5)
        //leftInsets = (frameWidth! – (collectionViewWidth! * CGFloat(strImages.count))) * 0.5 – (CGFloat(strImages.count-1) * 5)
        if leftInsets <= 0 {
            leftInsets = 0
        }
        insets?.left = leftInsets
        self.memberImagesCollectionView?.contentInset = insets!
    }
    
    @objc func selectedSegment(_ segmentedControl: LGSegmentedControl) {
        // selectedSegment may be nil, if selectedIndex was set to nil (and hence none was selected)
        guard let segment = segmentedControl.selectedSegment else { return }
        let title = segment.title
        if segment.title == "Active" {
            currentView = .activeView
        } else {
            currentView = .pendingView
        }
        UIView.transition(with: membersTable!,
                          duration: 0.35,
                          options: .transitionCrossDissolve,
                          animations: { self.membersTable?.reloadData() })
        membersTable?.frame = CGRect(x: membersTable!.frame.origin.x, y: membersTable!.frame.origin.y, width: membersTable!.frame.size.width, height: membersTable!.contentSize.height)
    }
}

extension ManageFamilyViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return totalMembersCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FamilyMemberCollectionViewCell.identifier, for: indexPath) as! FamilyMemberCollectionViewCell
        
        cell.configure(imageURL: "http://34.100.156.30:8080/api/v1/doctor/image/QmeERDW4VrHaGTMaG676ZJEKEFd2KdSnHcjiKUmmiaTmaw")
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return -30
    }
}

extension ManageFamilyViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (currentView == .activeView ? userDetails.patient!.familyMembersActiveCount.0 : userDetails.patient!.familyRequestsPendingCountAsOrganizer.0)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = membersTable!.dequeueReusableCell(withIdentifier: MemberTableViewCell.identifier, for: indexPath) as! MemberTableViewCell
        
        cell.configure(name: "Harshal Kulkarni", age: "Adult", link: "http://34.100.156.30:8080/api/v1/doctor/image/QmeERDW4VrHaGTMaG676ZJEKEFd2KdSnHcjiKUmmiaTmaw")
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 86
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        membersTable?.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let removeFromFamily = UIContextualAction(style: .destructive,
                                       title: "Remove From Family") { [weak self] (action, view, completionHandler) in
                                        self?.handleRemoveFromFamily()
                                        completionHandler(true)
        }
        removeFromFamily.backgroundColor = .systemRed
        
        let configuration = UISwipeActionsConfiguration(actions: [removeFromFamily])

        return configuration
    }
}
