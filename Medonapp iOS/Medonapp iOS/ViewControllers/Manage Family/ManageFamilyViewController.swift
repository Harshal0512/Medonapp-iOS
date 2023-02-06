//
//  ManageFamilyViewController.swift
//  Medonapp iOS
//
//  Created by Harshal Kulkarni on 28/01/23.
//

import UIKit

class ManageFamilyViewController: UIViewController, UICollectionViewDelegateFlowLayout {
    
    private var backButton: UIImageView?
    private var navTitle: UILabel?
    private var addMemberButton: UIImageView?
    private var memberImagesCollectionView: UICollectionView?
    private var membersTable: UITableView?
    private var membersTableHeightConstraint: NSLayoutConstraint?
    var membersCount = 5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationItem.largeTitleDisplayMode = .never
        navigationController?.isNavigationBarHidden = true
        
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
        membersTableHeightConstraint?.constant = membersTable!.contentSize.height + 41
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        Utils.checkForReachability()
        
        centerCollectionViewItems()
        populateFamilyTable()
        
        if Prefs.isNetworkAvailable {
            self.refreshData()
        }
        
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    @objc func refreshData() {
        AppointmentElement.refreshAppointments { isSuccess in
            self.centerCollectionViewItems()
            self.populateFamilyTable()
        }
    }
    
    func populateFamilyTable() {
    }
    
    func initialise() {
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
        membersTable?.translatesAutoresizingMaskIntoConstraints = false
        
        
        backButton?.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        backButton?.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 28).isActive = true
        backButton?.widthAnchor.constraint(equalToConstant: 50).isActive = true
        backButton?.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        navTitle?.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 13).isActive = true
        navTitle?.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        navTitle?.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        addMemberButton?.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        addMemberButton?.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -28).isActive = true
        addMemberButton?.widthAnchor.constraint(equalToConstant: 32).isActive = true
        addMemberButton?.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        memberImagesCollectionView?.topAnchor.constraint(equalTo: navTitle!.bottomAnchor, constant: 80).isActive = true
        memberImagesCollectionView?.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        memberImagesCollectionView?.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        memberImagesCollectionView?.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        membersTable?.topAnchor.constraint(equalTo: memberImagesCollectionView!.bottomAnchor, constant: 30).isActive = true
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
        
    }
    
    private func handleRemoveFromFamily() {
        print("Removed From Family")
    }
    
    func centerCollectionViewItems() {
        var insets = self.memberImagesCollectionView?.contentInset
        var leftInsets = (self.view.frame.size.width - (40 * CGFloat(membersCount))) * 0.5 - (CGFloat(membersCount-1) * 5)
        //leftInsets = (frameWidth! – (collectionViewWidth! * CGFloat(strImages.count))) * 0.5 – (CGFloat(strImages.count-1) * 5)
        if leftInsets <= 0 {
            leftInsets = 0
        }
        insets?.left = leftInsets
        self.memberImagesCollectionView?.contentInset = insets!
    }
}

extension ManageFamilyViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return membersCount
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
        return membersCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = membersTable!.dequeueReusableCell(withIdentifier: MemberTableViewCell.identifier, for: indexPath) as! MemberTableViewCell
        
//        cell.layer.cornerRadius = 30
        
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
