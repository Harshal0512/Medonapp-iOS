//
//  HomeTabViewController.swift
//  Medonapp iOS
//
//  Created by Harshal Kulkarni on 06/10/22.
//

import UIKit
import SkeletonView

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
    var banner: UIImageView?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        contentView?.showAnimatedGradientSkeleton(transition: .crossDissolve(0.25))
//        contentView?.hideSkeleton(transition: .crossDissolve(0.25))
        
        let tabBarItems = tabBarController?.tabBar.items!
        tabBarItems![0].image = UIImage(named: "homeTabIcon")?.resizeImageTo(size: CGSize(width: 40, height: 40))?.withTintColor(UIColor(red: 0.48, green: 0.55, blue: 0.62, alpha: 1.00))
        tabBarItems![0].selectedImage = UIImage(named: "homeTabIcon")?.resizeImageTo(size: CGSize(width: 40, height: 40))?.withTintColor(UIColor(red: 0.11, green: 0.42, blue: 0.64, alpha: 1.00))
        tabBarItems![1].image = UIImage(named: "scheduleTabIcon")?.resizeImageTo(size: CGSize(width: 40, height: 40))?.withTintColor(UIColor(red: 0.48, green: 0.55, blue: 0.62, alpha: 1.00))
        tabBarItems![1].selectedImage = UIImage(named: "scheduleTabIcon")?.resizeImageTo(size: CGSize(width: 40, height: 40))?.withTintColor(UIColor(red: 0.11, green: 0.42, blue: 0.64, alpha: 1.00))
        tabBarItems![2].image = UIImage(named: "reportTabIcon")?.resizeImageTo(size: CGSize(width: 40, height: 40))?.withTintColor(UIColor(red: 0.48, green: 0.55, blue: 0.62, alpha: 1.00))
        tabBarItems![2].selectedImage = UIImage(named: "reportTabIcon")?.resizeImageTo(size: CGSize(width: 40, height: 40))?.withTintColor(UIColor(red: 0.11, green: 0.42, blue: 0.64, alpha: 1.00))
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
    }
    
    func initialise() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
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
        welcomeWithNameLabel?.text = "Harshal Kulkarni"
        welcomeWithNameLabel?.textColor = .black
        welcomeWithNameLabel?.font = UIFont(name: "NunitoSans-Bold", size: 27)
        contentView?.addSubview(welcomeWithNameLabel!)
        welcomeWithNameLabel?.addSkeleton()
        
        profileImageView = UIImageView()
        profileImageView?.image = UIImage(named: "cat")
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
        doctorsTab?.initTabButton(variant: .blue, tabImage: UIImage(named: "doctorHomeTabIcon")!.resizeImageTo(size: CGSize(width: 24, height: 30))!)
        contentView?.addSubview(doctorsTab!)
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.goToDoctorsScreen(_:)))
        doctorsTab?.addGestureRecognizer(tap)
        
        reportsTab = TabForServices_VariableColor()
        reportsTab?.initTabButton(variant: .sky, tabImage: UIImage(named: "reportHomeTabIcon")!.resizeImageTo(size: CGSize(width: 10, height: 14))!)
        contentView?.addSubview(reportsTab!)
        
        banner = UIImageView()
        banner?.image = UIImage(named: "homeScreenBannerImage")
        banner?.contentMode = .scaleAspectFill
        contentView?.addSubview(banner!)
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
        banner?.bottomAnchor.constraint(equalTo: contentView!.bottomAnchor, constant: -20).isActive = true
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

}

extension HomeTabViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
