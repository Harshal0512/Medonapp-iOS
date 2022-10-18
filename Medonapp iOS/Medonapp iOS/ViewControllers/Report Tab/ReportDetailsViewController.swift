//
//  ReportDetailsViewController.swift
//  Medonapp iOS
//
//  Created by Harshal Kulkarni on 18/10/22.
//

import UIKit

enum reportVariant {
    case user
    case family
}

class ReportDetailsViewController: UIViewController {
    
    private var backButton: UIImageView?
    private var navTitle: UILabel?
    private var reportsHistoryTable: UITableView?
    
    private var reportsTopView: ReportCellWithIconAndDescription?
    
    var reportsVariant: reportVariant = .user
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationItem.largeTitleDisplayMode = .never
        navigationController?.isNavigationBarHidden = true
        
        initialise()
        setupUI()
        setConstraints()
        
        reportsHistoryTable?.register(ReportTableViewCell.nib(), forCellReuseIdentifier: ReportTableViewCell.identifier)
        reportsHistoryTable?.delegate = self
        reportsHistoryTable?.dataSource = self
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
        navTitle?.text = "Reports Details"
        navTitle?.textAlignment = .center
        navTitle?.textColor = .black
        navTitle?.font = UIFont(name: "NunitoSans-Bold", size: 18)
        view.addSubview(navTitle!)
        
        if reportsVariant == .user {
            setupUserReportsUIWithConstraints()
        } else if reportsVariant == .family {
            setupFamilyReportsUIWithConstraints()
        }
        
        reportsHistoryTable = UITableView()
        reportsHistoryTable?.separatorStyle = .none
        view.addSubview(reportsHistoryTable!)
    }
    
    func setConstraints() {
        backButton?.translatesAutoresizingMaskIntoConstraints = false
        navTitle?.translatesAutoresizingMaskIntoConstraints = false
        reportsTopView?.translatesAutoresizingMaskIntoConstraints = false
        reportsHistoryTable?.translatesAutoresizingMaskIntoConstraints = false
        
        
        backButton?.topAnchor.constraint(equalTo: view.topAnchor, constant: 65).isActive = true
        backButton?.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 28).isActive = true
        backButton?.widthAnchor.constraint(equalToConstant: 50).isActive = true
        backButton?.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        navTitle?.topAnchor.constraint(equalTo: view.topAnchor, constant: 78).isActive = true
        navTitle?.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        navTitle?.widthAnchor.constraint(equalToConstant: 160).isActive = true
        
        reportsTopView!.topAnchor.constraint(equalTo: navTitle!.bottomAnchor, constant: 40).isActive = true
        reportsTopView!.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 27).isActive = true
        reportsTopView!.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -27).isActive = true
        reportsTopView!.heightAnchor.constraint(equalToConstant: 93).isActive = true
        
        reportsHistoryTable?.topAnchor.constraint(equalTo: reportsTopView!.bottomAnchor, constant: 10).isActive = true
        reportsHistoryTable?.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10).isActive = true
        reportsHistoryTable?.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10).isActive = true
        reportsHistoryTable?.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true
    }
    
    func setupUserReportsUIWithConstraints() {
        reportsTopView = ReportCellWithIconAndDescription.instantiate(viewBackgroundColor: .white, icon: UIImage(named: "documentIcon")!.withTintColor(UIColor(red: 0.11, green: 0.42, blue: 0.64, alpha: 1.00)), iconBackgroundColor: UIColor(red: 0.86, green: 0.93, blue: 0.98, alpha: 1.00), title: "My Reports", numberOfFiles: 8, showOutline: false, showMoreIcon: false)
        view.addSubview(reportsTopView!)
        
        //future additions
    }
    
    func setupFamilyReportsUIWithConstraints() {
        reportsTopView = ReportCellWithIconAndDescription.instantiate(viewBackgroundColor: .white, icon: UIImage(named: "documentIcon")!.withTintColor(UIColor(red: 0.00, green: 0.54, blue: 0.37, alpha: 1.00)), iconBackgroundColor: UIColor(red: 0.84, green: 1.00, blue: 0.95, alpha: 1.00), title: "Family Reports", numberOfFiles: 8, showOutline: false, showMoreIcon: false)
        view.addSubview(reportsTopView!)
        
        //future additions
    }
    
    @objc func handleBackAction(_ sender: UITapGestureRecognizer? = nil) {
        self.dismiss(animated: true)
    }
}

extension ReportDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "6 Oct. 2022 -------------"
        } else if section == 1 {
            return "11 Oct. 2022 -------------"
        } else if section == 2 {
            return "12 Nov. 2022 -------------"
        } else {
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 133
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = reportsHistoryTable!.dequeueReusableCell(withIdentifier: ReportTableViewCell.identifier, for: indexPath) as! ReportTableViewCell
        if reportsVariant == .user {
            cell.configure(icon: UIImage(named: "documentIcon")!, reportTitle: "X-Ray Report", reportCellVariant: .user)
        } else if reportsVariant == .family {
            cell.configure(icon: UIImage(named: "documentIcon")!, reportTitle: "X-Ray Report", reportCellVariant: .family)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        reportsHistoryTable?.scrollToRow(at: indexPath, at: .middle, animated: true)
        reportsHistoryTable?.deselectRow(at: indexPath, animated: true)
    }
}
