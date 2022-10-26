//
//  ReportTabViewController.swift
//  Medonapp iOS
//
//  Created by Harshal Kulkarni on 09/10/22.
//

import UIKit

class ReportTabViewController: UIViewController {
    var scrollView: UIScrollView?
    var contentView: UIView?
    
    var healthStatus: UIView?
    var healthLabelHealthStatusView: UILabel?
    var healthStatusLabelHealthStatusView: UILabel?
    var healthStatusImageHealthStatusView: UIImageView?
    
    var bloodGroupView: UIView?
    var bloodImageLabel: UIImageView?
    var bloodGroupTitleLabel: UILabel?
    var bloodGroupStatusLabel: UILabel?
    
    var weightView: UIView?
    var weightImageLabel: UIImageView?
    var weightTitleLabel: UILabel?
    var weightStatusLabel: UILabel?
    
    var latestReportsLabel: UILabel?
    var userReports: ReportCellWithIconAndDescription?
    var constraintsUserReports: [String: NSLayoutConstraint] = [:]
    var familyReports: ReportCellWithIconAndDescription?
    
    private var userDetails = User.getUserDetails()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Report"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
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
        
        healthStatus = UIView()
        healthStatus?.layer.cornerRadius = 24
        healthStatus?.backgroundColor = UIColor(red: 0.86, green: 0.93, blue: 0.98, alpha: 1.00)
        contentView?.addSubview(healthStatus!)
        
        healthLabelHealthStatusView = UILabel()
        healthLabelHealthStatusView?.text = "Health Status"
        healthLabelHealthStatusView?.textColor = .black
        healthLabelHealthStatusView?.font = UIFont(name: "NunitoSans-Regular", size: 16)
        healthStatus?.addSubview(healthLabelHealthStatusView!)
        
        healthStatusLabelHealthStatusView = UILabel()
        healthStatusLabelHealthStatusView?.text = "Healthy"
        healthStatusLabelHealthStatusView?.textColor = .black
        healthStatusLabelHealthStatusView?.font = UIFont(name: "NunitoSans-Regular", size: 50)
        healthStatus?.addSubview(healthStatusLabelHealthStatusView!)
        
        healthStatusImageHealthStatusView = UIImageView()
        healthStatusImageHealthStatusView?.image = UIImage(named: "heartRateImage")
        healthStatusImageHealthStatusView?.contentMode = .scaleAspectFit
        healthStatus?.addSubview(healthStatusImageHealthStatusView!)
        
        
        bloodGroupView = UIView()
        bloodGroupView?.layer.cornerRadius = 24
        bloodGroupView?.backgroundColor = UIColor(red: 0.96, green: 0.88, blue: 0.91, alpha: 1.00)
        contentView?.addSubview(bloodGroupView!)
        
        bloodImageLabel = UIImageView()
        bloodImageLabel?.image = UIImage(named: "bloodImage")
        bloodImageLabel?.contentMode = .scaleAspectFit
        bloodGroupView?.addSubview(bloodImageLabel!)
        
        bloodGroupTitleLabel = UILabel()
        bloodGroupTitleLabel?.text = "Blood Group"
        bloodGroupTitleLabel?.textColor = .black
        bloodGroupTitleLabel?.font = UIFont(name: "NunitoSans-Regular", size: 14)
        bloodGroupView?.addSubview(bloodGroupTitleLabel!)
        
        bloodGroupStatusLabel = UILabel()
        bloodGroupStatusLabel?.text = userDetails.patient?.bloodGroup ?? ""
        bloodGroupStatusLabel?.textColor = .black
        bloodGroupStatusLabel?.font = UIFont(name: "NunitoSans-Bold", size: 28)
        bloodGroupView?.addSubview(bloodGroupStatusLabel!)
        
        
        weightView = UIView()
        weightView?.layer.cornerRadius = 24
        weightView?.backgroundColor = UIColor(red: 0.98, green: 0.94, blue: 0.86, alpha: 1.00)
        contentView?.addSubview(weightView!)
        
        weightImageLabel = UIImageView()
        weightImageLabel?.image = UIImage(named: "weightImage")
        weightImageLabel?.contentMode = .scaleAspectFit
        weightView?.addSubview(weightImageLabel!)
        
        weightTitleLabel = UILabel()
        weightTitleLabel?.text = "Weight"
        weightTitleLabel?.textColor = .black
        weightTitleLabel?.font = UIFont(name: "NunitoSans-Regular", size: 14)
        weightView?.addSubview(weightTitleLabel!)
        
        weightStatusLabel = UILabel()
        weightStatusLabel?.text = "\(userDetails.patient?.weight ?? 0.0) kg"
        weightStatusLabel?.textColor = .black
        weightStatusLabel?.font = UIFont(name: "NunitoSans-Bold", size: 28)
        weightView?.addSubview(weightStatusLabel!)
        
        
        latestReportsLabel = UILabel()
        latestReportsLabel?.text = "Latest Report"
        latestReportsLabel?.textColor = .black
        latestReportsLabel?.font = UIFont(name: "NunitoSans-Bold", size: 17)
        contentView?.addSubview(latestReportsLabel!)
        
        userReports = ReportCellWithIconAndDescription.instantiate(viewBackgroundColor: .white, icon: UIImage(named: "documentIcon")!.withTintColor(UIColor(red: 0.11, green: 0.42, blue: 0.64, alpha: 1.00)), iconBackgroundColor: UIColor(red: 0.86, green: 0.93, blue: 0.98, alpha: 1.00), title: "My Reports", numberOfFiles: 8)
        contentView?.addSubview(userReports!)
        let userReportsTap = UITapGestureRecognizer(target: self, action: #selector(self.expandUserReports))
        userReports?.addGestureRecognizer(userReportsTap)
        userReports?.isUserInteractionEnabled = true
        
        familyReports = ReportCellWithIconAndDescription.instantiate(viewBackgroundColor: .white, icon: UIImage(named: "documentIcon")!.withTintColor(UIColor(red: 0.00, green: 0.54, blue: 0.37, alpha: 1.00)), iconBackgroundColor: UIColor(red: 0.84, green: 1.00, blue: 0.95, alpha: 1.00), title: "Family Reports", numberOfFiles: 8)
        contentView?.addSubview(familyReports!)
        let familyReportsTap = UITapGestureRecognizer(target: self, action: #selector(self.expandFamilyReports))
        familyReports?.addGestureRecognizer(familyReportsTap)
        familyReports?.isUserInteractionEnabled = true
    }
    
    func setConstraints() {
        scrollView?.translatesAutoresizingMaskIntoConstraints = false
        contentView?.translatesAutoresizingMaskIntoConstraints = false
        
        healthStatus?.translatesAutoresizingMaskIntoConstraints = false
        healthLabelHealthStatusView?.translatesAutoresizingMaskIntoConstraints = false
        healthStatusLabelHealthStatusView?.translatesAutoresizingMaskIntoConstraints = false
        healthStatusImageHealthStatusView?.translatesAutoresizingMaskIntoConstraints = false
        
        bloodGroupView?.translatesAutoresizingMaskIntoConstraints = false
        bloodImageLabel?.translatesAutoresizingMaskIntoConstraints = false
        bloodGroupTitleLabel?.translatesAutoresizingMaskIntoConstraints = false
        bloodGroupStatusLabel?.translatesAutoresizingMaskIntoConstraints = false
        
        weightView?.translatesAutoresizingMaskIntoConstraints = false
        weightImageLabel?.translatesAutoresizingMaskIntoConstraints = false
        weightTitleLabel?.translatesAutoresizingMaskIntoConstraints = false
        weightStatusLabel?.translatesAutoresizingMaskIntoConstraints = false
        
        
        scrollView?.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        scrollView?.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        scrollView?.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        scrollView?.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        
        contentView?.topAnchor.constraint(equalTo: scrollView!.topAnchor).isActive = true
        contentView?.leadingAnchor.constraint(equalTo: scrollView!.leadingAnchor).isActive = true
        contentView?.trailingAnchor.constraint(equalTo: scrollView!.trailingAnchor).isActive = true
        contentView?.bottomAnchor.constraint(equalTo: scrollView!.bottomAnchor).isActive = true
        contentView?.widthAnchor.constraint(equalTo: scrollView!.widthAnchor).isActive = true
        
        
        healthStatus?.topAnchor.constraint(equalTo: contentView!.topAnchor, constant: 16).isActive = true
        healthStatus?.leadingAnchor.constraint(equalTo: contentView!.leadingAnchor, constant: 28).isActive = true
        healthStatus?.trailingAnchor.constraint(equalTo: contentView!.trailingAnchor, constant: -28).isActive = true
        healthStatus?.heightAnchor.constraint(equalToConstant: 175).isActive = true
        
        latestReportsLabel?.translatesAutoresizingMaskIntoConstraints = false
        userReports?.translatesAutoresizingMaskIntoConstraints = false
        familyReports?.translatesAutoresizingMaskIntoConstraints = false
        
        healthLabelHealthStatusView?.topAnchor.constraint(equalTo: healthStatus!.topAnchor, constant: 29).isActive = true
        healthLabelHealthStatusView?.leadingAnchor.constraint(equalTo: healthStatus!.leadingAnchor, constant: 22).isActive = true
        healthLabelHealthStatusView?.trailingAnchor.constraint(equalTo: healthStatus!.trailingAnchor, constant: -10).isActive = true
        
        healthStatusLabelHealthStatusView?.topAnchor.constraint(equalTo: healthLabelHealthStatusView!.bottomAnchor, constant: 8).isActive = true
        healthStatusLabelHealthStatusView?.leadingAnchor.constraint(equalTo: healthStatus!.leadingAnchor, constant: 22).isActive = true
        healthStatusLabelHealthStatusView?.bottomAnchor.constraint(equalTo: healthStatus!.bottomAnchor, constant: -39).isActive = true
        
        healthStatusImageHealthStatusView?.centerYAnchor.constraint(equalTo: healthStatus!.centerYAnchor).isActive = true
        healthStatusImageHealthStatusView?.leadingAnchor.constraint(equalTo: healthStatusLabelHealthStatusView!.trailingAnchor, constant: 21).isActive = true
        healthStatusImageHealthStatusView?.widthAnchor.constraint(equalToConstant: 72).isActive = true
        healthStatusImageHealthStatusView?.heightAnchor.constraint(equalToConstant: 72).isActive = true
        
        bloodGroupView?.topAnchor.constraint(equalTo: healthStatus!.bottomAnchor, constant: 16).isActive = true
        bloodGroupView?.leadingAnchor.constraint(equalTo: healthStatus!.leadingAnchor).isActive = true
        bloodGroupView?.heightAnchor.constraint(equalToConstant: 135).isActive = true
        
        bloodImageLabel?.topAnchor.constraint(equalTo: bloodGroupView!.topAnchor, constant: 24).isActive = true
        bloodImageLabel?.leadingAnchor.constraint(equalTo: bloodGroupView!.leadingAnchor, constant: 24).isActive = true
        bloodImageLabel?.widthAnchor.constraint(equalToConstant: 15).isActive = true
        bloodImageLabel?.heightAnchor.constraint(equalToConstant: 22).isActive = true
        
        bloodGroupTitleLabel?.topAnchor.constraint(equalTo: bloodImageLabel!.bottomAnchor, constant: 10).isActive = true
        bloodGroupTitleLabel?.leadingAnchor.constraint(equalTo: bloodImageLabel!.leadingAnchor).isActive = true
        bloodGroupTitleLabel?.trailingAnchor.constraint(equalTo: bloodGroupView!.trailingAnchor, constant: -10).isActive = true
        
        bloodGroupStatusLabel?.topAnchor.constraint(equalTo: bloodGroupTitleLabel!.bottomAnchor, constant: 4).isActive = true
        bloodGroupStatusLabel?.leadingAnchor.constraint(equalTo: bloodImageLabel!.leadingAnchor).isActive = true
        bloodGroupStatusLabel?.trailingAnchor.constraint(equalTo: bloodGroupView!.trailingAnchor, constant: -10).isActive = true
        bloodGroupStatusLabel?.bottomAnchor.constraint(equalTo: bloodGroupView!.bottomAnchor, constant: -15).isActive = true
        
        weightView?.topAnchor.constraint(equalTo: bloodGroupView!.topAnchor).isActive = true
        weightView?.trailingAnchor.constraint(equalTo: healthStatus!.trailingAnchor).isActive = true
        weightView?.leadingAnchor.constraint(equalTo: bloodGroupView!.trailingAnchor, constant: 12).isActive = true
        weightView?.widthAnchor.constraint(equalTo: bloodGroupView!.widthAnchor).isActive = true
        weightView?.heightAnchor.constraint(equalTo: bloodGroupView!.heightAnchor)
            .isActive = true
        
        weightImageLabel?.topAnchor.constraint(equalTo: weightView!.topAnchor, constant: 22).isActive = true
        weightImageLabel?.leadingAnchor.constraint(equalTo: weightView!.leadingAnchor, constant: 27).isActive = true
        weightImageLabel?.widthAnchor.constraint(equalToConstant: 22).isActive = true
        weightImageLabel?.heightAnchor.constraint(equalToConstant: 22).isActive = true
        
        weightTitleLabel?.topAnchor.constraint(equalTo: weightImageLabel!.bottomAnchor, constant: 10).isActive = true
        weightTitleLabel?.leadingAnchor.constraint(equalTo: weightImageLabel!.leadingAnchor).isActive = true
        weightTitleLabel?.trailingAnchor.constraint(equalTo: weightView!.trailingAnchor, constant: -10).isActive = true
        
        weightStatusLabel?.topAnchor.constraint(equalTo: weightTitleLabel!.bottomAnchor, constant: 4).isActive = true
        weightStatusLabel?.leadingAnchor.constraint(equalTo: weightImageLabel!.leadingAnchor).isActive = true
        weightStatusLabel?.trailingAnchor.constraint(equalTo: weightView!.trailingAnchor, constant: -10).isActive = true
        weightStatusLabel?.bottomAnchor.constraint(equalTo: weightView!.bottomAnchor, constant: -15).isActive = true
        
        
        latestReportsLabel?.topAnchor.constraint(equalTo: bloodGroupView!.bottomAnchor, constant: 27).isActive = true
        latestReportsLabel?.leadingAnchor.constraint(equalTo: contentView!.leadingAnchor, constant: 27).isActive = true
        latestReportsLabel?.trailingAnchor.constraint(equalTo: contentView!.trailingAnchor, constant: -27).isActive = true
        
        constraintsUserReports = ["top": userReports!.topAnchor.constraint(equalTo: latestReportsLabel!.bottomAnchor, constant: 16), "leading": userReports!.leadingAnchor.constraint(equalTo: contentView!.leadingAnchor, constant: 27), "trailing": userReports!.trailingAnchor.constraint(equalTo: contentView!.trailingAnchor, constant: -27), "height": userReports!.heightAnchor.constraint(equalToConstant: 93)]
        constraintsUserReports["top"]?.isActive = true
        constraintsUserReports["leading"]?.isActive = true
        constraintsUserReports["trailing"]?.isActive = true
        constraintsUserReports["height"]?.isActive = true
        
        
        familyReports?.topAnchor.constraint(equalTo: userReports!.bottomAnchor, constant: 18).isActive = true
        familyReports?.leadingAnchor.constraint(equalTo: contentView!.leadingAnchor, constant: 27).isActive = true
        familyReports?.trailingAnchor.constraint(equalTo: contentView!.trailingAnchor, constant: -27).isActive = true
        familyReports?.heightAnchor.constraint(equalToConstant: 93).isActive = true
        familyReports?.bottomAnchor.constraint(equalTo: contentView!.bottomAnchor, constant: -20).isActive = true
    }
    
    @objc func expandUserReports() {
        let reportDetailsVC = UIStoryboard.init(name: "ReportTab", bundle: Bundle.main).instantiateViewController(withIdentifier: "reportDetails") as? ReportDetailsViewController
        reportDetailsVC?.modalPresentationStyle = .fullScreen
        reportDetailsVC?.reportsVariant = .user
        self.present(reportDetailsVC!, animated: true)
    }
    
    @objc func expandFamilyReports() {
        let reportDetailsVC = UIStoryboard.init(name: "ReportTab", bundle: Bundle.main).instantiateViewController(withIdentifier: "reportDetails") as? ReportDetailsViewController
        reportDetailsVC?.modalPresentationStyle = .fullScreen
        reportDetailsVC?.reportsVariant = .family
        self.present(reportDetailsVC!, animated: true)
    }

}
