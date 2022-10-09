//
//  HomeTabViewController.swift
//  Medonapp iOS
//
//  Created by Harshal Kulkarni on 06/10/22.
//

import UIKit

class HomeTabViewController: UIViewController {
    var scrollView: UIScrollView?
    var contentView: UIView?
    var helloTextLabel: UILabel?
    var welcomeWithNameLabel: UILabel?
    var profileImageView: UIImageView?
    var searchBar: SearchBarWithSearchAndFilterIcon?
    var servicesTextLabel: UILabel?
    var doctorsTab: TabForServices_VariableColor?
    var reportsTab: TabForServices_VariableColor?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        let tabBarItems = tabBarController?.tabBar.items!
//        tabBarItems![0].image = UIImage(named: "homeTabIcon")?.withTintColor(UIColor(red: 0.48, green: 0.55, blue: 0.62, alpha: 1.00))
//        tabBarItems![0].selectedImage = UIImage(named: "homeTabIcon")?.withTintColor(UIColor(red: 0.11, green: 0.42, blue: 0.64, alpha: 1.00))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialise()
        setupUI()
        setConstraints()
    }
    
    func initialise() {
    }
    
    func setupUI() {
        scrollView = UIScrollView()
        contentView = UIView()
        
        view.addSubview(scrollView!)
        scrollView?.addSubview(contentView!)
        
        helloTextLabel = UILabel()
        helloTextLabel?.text = "👋 Hello!"
        helloTextLabel?.textColor = .black
        helloTextLabel?.font = UIFont(name: "NunitoSans-SemiBold", size: 16)
        contentView?.addSubview(helloTextLabel!)
        
        welcomeWithNameLabel = UILabel()
        welcomeWithNameLabel?.text = "Harshal Kulkarni"
        welcomeWithNameLabel?.textColor = .black
        welcomeWithNameLabel?.font = UIFont(name: "NunitoSans-Bold", size: 27)
        contentView?.addSubview(welcomeWithNameLabel!)
        
        profileImageView = UIImageView()
        profileImageView?.image = UIImage(named: "cat")
        profileImageView?.contentMode = .scaleAspectFill
        profileImageView?.makeRoundCorners(byRadius: 18)
        contentView?.addSubview(profileImageView!)
        
        searchBar = SearchBarWithSearchAndFilterIcon()
        searchBar?.setPlaceholder(placeholder: " Search medical")
        contentView?.addSubview(searchBar!)
        
        servicesTextLabel = UILabel()
        servicesTextLabel?.text = "Services"
        servicesTextLabel?.textColor = .black
        servicesTextLabel?.font = UIFont(name: "NunitoSans-Bold", size: 17)
        contentView?.addSubview(servicesTextLabel!)
        
        doctorsTab = TabForServices_VariableColor()
        doctorsTab?.initTabButton(variant: .blue, tabImage: UIImage(systemName: "magnifyingglass")!)
        contentView?.addSubview(doctorsTab!)
        
        reportsTab = TabForServices_VariableColor()
        reportsTab?.initTabButton(variant: .sky, tabImage: UIImage(systemName: "magnifyingglass")!)
        contentView?.addSubview(reportsTab!)
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
        
        doctorsTab?.bottomAnchor.constraint(equalTo: contentView!.bottomAnchor, constant: -28).isActive = true
    }

}
