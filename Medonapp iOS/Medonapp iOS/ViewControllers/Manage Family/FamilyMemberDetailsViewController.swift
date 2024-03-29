//
//  FamilyMemberDetailsViewController.swift
//  Medonapp iOS
//
//  Created by Harshal Kulkarni on 15/03/23.
//

import UIKit
import Toast_Swift

class FamilyMemberDetailsViewController: UIViewController {
    
    private var scrollView: UIScrollView?
    private var contentView: UIView?
    private var backButton: UIImageView?
    private var navTitle: UILabel?
    private var profileImageView: UIImageView?
    private var nameLabel: UILabel?
    private var ageAttributeLabel: UILabel?
    private var emailLabel: PaddingLabel?
    private var emailInfoLabel: UILabel?
    private var familyReports: ReportCellWithIconAndDescription?
    private var removeFromFamilyButton: PaddingLabel?
    
    public var member: FamilyMember?
    public var memberDetails: Patient?
    
    private let biometricAuth = BiometricAuthentication()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshMemberDetails()

        initialise()
        setupUI()
        setConstraints()
    }
    
    func initialise() {
        NotificationCenter.default.addObserver(self, selector: #selector(refreshMemberDetails), name: Notification.Name("refreshMemberDetails"), object: nil)
    }
    
    func setupUI() {
        scrollView = UIScrollView()
        contentView = UIView()
        
        view.addSubview(scrollView!)
        scrollView?.addSubview(contentView!)
        
        view.backgroundColor = .systemGroupedBackground
        
        backButton = UIImageView()
        backButton?.image = UIImage(named: "backIcon_White")?.resizeImageTo(size: CGSize(width: 50, height: 50))
        backButton?.contentMode = .scaleAspectFit
        view.addSubview(backButton!)
        let backTap = UITapGestureRecognizer(target: self, action: #selector(self.handleBackAction(_:)))
        backButton?.addGestureRecognizer(backTap)
        backButton?.isUserInteractionEnabled = true
        
        navTitle = UILabel()
        navTitle?.text = "Member Details"
        navTitle?.textAlignment = .center
        navTitle?.textColor = .black
        navTitle?.font = UIFont(name: "NunitoSans-Bold", size: 18)
        view.addSubview(navTitle!)
        
        profileImageView = UIImageView()
        profileImageView?.makeRoundCorners(byRadius: 26)
        profileImageView?.contentMode = .scaleAspectFill
        contentView?.addSubview(profileImageView!)
        profileImageView?.setKFImage(imageUrl: member?.url ?? "https://i.ibb.co/jHvKxC3/broken-1.jpg", placeholderImage: UIImage(named: "userPlaceholder-male")!)
        profileImageView?.layer.borderWidth = 3
        profileImageView?.layer.borderColor = UIColor.white.cgColor
        
        nameLabel = UILabel()
        nameLabel?.text = member?.name
        nameLabel?.textColor = .black
        nameLabel?.textAlignment = .center
        nameLabel?.font = UIFont(name: "NunitoSans-Bold", size: 18)
        contentView?.addSubview(nameLabel!)
        
        ageAttributeLabel = UILabel()
        ageAttributeLabel?.text = (member?.type == "ORGANIZER") ? "Organizer" : "Adult"
        ageAttributeLabel?.textColor = .black
        ageAttributeLabel?.alpha = 0.6
        ageAttributeLabel?.textAlignment = .center
        ageAttributeLabel?.font = UIFont(name: "NunitoSans-SemiBold", size: 12)
        contentView?.addSubview(ageAttributeLabel!)
        
        emailLabel = PaddingLabel()
        emailLabel?.text = ""
        emailLabel?.textColor = .black
        emailLabel?.textAlignment = .left
        emailLabel?.font = UIFont(name: "NunitoSans-Bold", size: 15)
        contentView?.addSubview(emailLabel!)
        emailLabel?.layer.cornerRadius = 14
        emailLabel?.layer.masksToBounds = true
        emailLabel?.backgroundColor = .white
        emailLabel?.paddingLeft = 15
        emailLabel?.paddingTop = 5
        emailLabel?.paddingRight = 15
        emailLabel?.paddingBottom = 5
        
        emailInfoLabel = UILabel()
        emailInfoLabel?.text = ""
        emailInfoLabel?.numberOfLines = 0
        emailInfoLabel?.textColor = .black
        emailInfoLabel?.alpha = 0.6
        emailInfoLabel?.textAlignment = .justified
        emailInfoLabel?.font = UIFont(name: "NunitoSans-SemiBold", size: 12)
        contentView?.addSubview(emailInfoLabel!)
        
        familyReports = ReportCellWithIconAndDescription.instantiate(viewBackgroundColor: .clear, icon: UIImage(named: "documentIcon")!.withTintColor(UIColor(red: 0.00, green: 0.54, blue: 0.37, alpha: 1.00)), iconBackgroundColor: UIColor(red: 0.84, green: 1.00, blue: 0.95, alpha: 1.00), title: "Medical Reports", numberOfFiles: 0)
        contentView?.addSubview(familyReports!)
        familyReports?.layer.cornerRadius = 28
        let familyReportsTap = UITapGestureRecognizer(target: self, action: #selector(self.expandFamilyReports))
        familyReports?.addGestureRecognizer(familyReportsTap)
        familyReports?.isUserInteractionEnabled = true
        
        removeFromFamilyButton = PaddingLabel()
        removeFromFamilyButton?.text = "Remove from Family"
        removeFromFamilyButton?.textColor = UIColor(red: 0.97, green: 0.22, blue: 0.35, alpha: 1.00)
        removeFromFamilyButton?.textAlignment = .left
        removeFromFamilyButton?.font = UIFont(name: "NunitoSans-Bold", size: 15)
        contentView?.addSubview(removeFromFamilyButton!)
        let removeFromFamilyTap = UITapGestureRecognizer(target: self, action: #selector(self.removeFromFamily))
        removeFromFamilyButton?.addGestureRecognizer(removeFromFamilyTap)
        removeFromFamilyButton?.isUserInteractionEnabled = true
        removeFromFamilyButton?.layer.cornerRadius = 14
        removeFromFamilyButton?.layer.masksToBounds = true
        removeFromFamilyButton?.backgroundColor = .white
        removeFromFamilyButton?.paddingLeft = 15
        removeFromFamilyButton?.paddingTop = 5
        removeFromFamilyButton?.paddingRight = 15
        removeFromFamilyButton?.paddingBottom = 5
        
        removeFromFamilyButton?.isHidden = !(User.getUserDetails().patient!.isFamilyOrganizer)
        
    }
    
    func setConstraints() {
        scrollView?.translatesAutoresizingMaskIntoConstraints = false
        contentView?.translatesAutoresizingMaskIntoConstraints = false
        backButton?.translatesAutoresizingMaskIntoConstraints = false
        navTitle?.translatesAutoresizingMaskIntoConstraints = false
        profileImageView?.translatesAutoresizingMaskIntoConstraints = false
        nameLabel?.translatesAutoresizingMaskIntoConstraints = false
        ageAttributeLabel?.translatesAutoresizingMaskIntoConstraints = false
        emailLabel?.translatesAutoresizingMaskIntoConstraints = false
        emailInfoLabel?.translatesAutoresizingMaskIntoConstraints = false
        familyReports?.translatesAutoresizingMaskIntoConstraints = false
        removeFromFamilyButton?.translatesAutoresizingMaskIntoConstraints = false
        
        
        scrollView?.topAnchor.constraint(equalTo: backButton!.bottomAnchor, constant: 0).isActive = true
        scrollView?.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        scrollView?.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        scrollView?.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        
        contentView?.topAnchor.constraint(equalTo: scrollView!.topAnchor).isActive = true
        contentView?.leadingAnchor.constraint(equalTo: scrollView!.leadingAnchor).isActive = true
        contentView?.trailingAnchor.constraint(equalTo: scrollView!.trailingAnchor).isActive = true
        contentView?.bottomAnchor.constraint(equalTo: scrollView!.bottomAnchor).isActive = true
        contentView?.widthAnchor.constraint(equalTo: scrollView!.widthAnchor).isActive = true
        
        
        backButton?.topAnchor.constraint(equalTo: view.topAnchor, constant: 65).isActive = true
        backButton?.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 28).isActive = true
        backButton?.widthAnchor.constraint(equalToConstant: 50).isActive = true
        backButton?.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        navTitle?.topAnchor.constraint(equalTo: view.topAnchor, constant: 79).isActive = true
        navTitle?.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        navTitle?.widthAnchor.constraint(equalToConstant: view.frame.width - 160).isActive = true
        
        profileImageView?.centerXAnchor.constraint(equalTo: contentView!.centerXAnchor).isActive = true
        profileImageView?.topAnchor.constraint(equalTo: contentView!.topAnchor, constant: 50).isActive = true
        profileImageView?.heightAnchor.constraint(equalToConstant: 77).isActive = true
        profileImageView?.widthAnchor.constraint(equalToConstant: 77).isActive = true
        
        nameLabel?.topAnchor.constraint(equalTo: profileImageView!.bottomAnchor, constant: 20).isActive = true
        nameLabel?.centerXAnchor.constraint(equalTo: contentView!.centerXAnchor).isActive = true
        nameLabel?.leadingAnchor.constraint(equalTo: contentView!.leadingAnchor, constant: 10).isActive = true
        nameLabel?.trailingAnchor.constraint(equalTo: contentView!.trailingAnchor, constant: -10).isActive = true
        
        ageAttributeLabel?.topAnchor.constraint(equalTo: nameLabel!.bottomAnchor, constant: 5).isActive = true
        ageAttributeLabel?.centerXAnchor.constraint(equalTo: contentView!.centerXAnchor).isActive = true
        ageAttributeLabel?.leadingAnchor.constraint(equalTo: contentView!.leadingAnchor, constant: 10).isActive = true
        ageAttributeLabel?.trailingAnchor.constraint(equalTo: contentView!.trailingAnchor, constant: -10).isActive = true
        
        emailLabel?.topAnchor.constraint(equalTo: ageAttributeLabel!.bottomAnchor, constant: 20).isActive = true
        emailLabel?.centerXAnchor.constraint(equalTo: contentView!.centerXAnchor).isActive = true
        emailLabel?.leadingAnchor.constraint(equalTo: contentView!.leadingAnchor, constant: 28).isActive = true
        emailLabel?.trailingAnchor.constraint(equalTo: contentView!.trailingAnchor, constant: -28).isActive = true
        emailLabel?.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        emailInfoLabel?.topAnchor.constraint(equalTo: emailLabel!.bottomAnchor, constant: 5).isActive = true
        emailInfoLabel?.centerXAnchor.constraint(equalTo: contentView!.centerXAnchor).isActive = true
        emailInfoLabel?.leadingAnchor.constraint(equalTo: contentView!.leadingAnchor, constant: 37).isActive = true
        emailInfoLabel?.trailingAnchor.constraint(equalTo: contentView!.trailingAnchor, constant: -37).isActive = true
        
        familyReports?.topAnchor.constraint(equalTo: emailInfoLabel!.bottomAnchor, constant: 40).isActive = true
        familyReports?.leadingAnchor.constraint(equalTo: contentView!.leadingAnchor, constant: 27).isActive = true
        familyReports?.trailingAnchor.constraint(equalTo: contentView!.trailingAnchor, constant: -27).isActive = true
        familyReports?.heightAnchor.constraint(equalToConstant: 93).isActive = true
        
        removeFromFamilyButton?.topAnchor.constraint(equalTo: familyReports!.bottomAnchor, constant: 40).isActive = true
        removeFromFamilyButton?.centerXAnchor.constraint(equalTo: contentView!.centerXAnchor).isActive = true
        removeFromFamilyButton?.leadingAnchor.constraint(equalTo: contentView!.leadingAnchor, constant: 28).isActive = true
        removeFromFamilyButton?.trailingAnchor.constraint(equalTo: contentView!.trailingAnchor, constant: -28).isActive = true
        removeFromFamilyButton?.heightAnchor.constraint(equalToConstant: 45).isActive = true
        removeFromFamilyButton?.bottomAnchor.constraint(equalTo: contentView!.bottomAnchor, constant: -20).isActive = true
    }
    
    @objc func refreshMemberDetails() {
        APIService(data: [:], headers: ["Authorization" : "Bearer \(User.getUserDetails().token ?? "")"], url: nil, service: .getPatientWithID((member?.id)!), method: .get, isJSONRequest: false).executeQuery() { (result: Result<Patient, Error>) in
            
            self.view.isUserInteractionEnabled = false
            self.view.makeToastActivity(.center)
            switch result{
            case .success(_):
                try? self.memberDetails = result.get()
                self.emailLabel?.text = self.memberDetails?.credential?.email
                self.emailInfoLabel?.text = "This is the email ID \(self.memberDetails!.name!.firstName!) uses for family and for sharing details, documents and medical reports with other members."
                self.profileImageView?.setKFImage(imageUrl: self.memberDetails?.profileImage?.fileDownloadURI ?? "https://i.ibb.co/jHvKxC3/broken-1.jpg", placeholderImage: UIImage(named: "userPlaceholder-male")!)
                self.nameLabel?.text = self.memberDetails?.name?.fullName
                self.familyReports?.setNumberOfFiles(self.memberDetails!.medicalFiles!.count)
                self.removeFromFamilyButton?.text = "Remove \(self.memberDetails!.name!.firstName!) from Family"
            case .failure(let error):
                print(error)
            }
            
            self.view.isUserInteractionEnabled = true
            self.view.hideToastActivity()
        }
    }
    
    @objc func expandFamilyReports() {
        biometricAuth.canEvaluate { (canEvaluate, _, canEvaluateError) in
            guard canEvaluate else {
                // Face ID/Touch ID may not be available or configured
                Utils.displaySPIndicatorNotifWithMessage(title: "Requires FaceID/TouchID", message: "Please enroll FaceID/TouchID.", iconPreset: .error, hapticPreset: .error, duration: 4)
                return
            }
            
            biometricAuth.evaluate { [weak self] (success, error) in
                guard success else {
                    // Face ID/Touch ID may not be configured
                    Utils.displaySPIndicatorNotifWithMessage(title: "Requires FaceID/TouchID", message: "Please enroll FaceID/TouchID.", iconPreset: .error, hapticPreset: .error, duration: 4)
                    return
                }
                
                // You are successfully verified
                let reportDetailsVC = UIStoryboard.init(name: "ReportTab", bundle: Bundle.main).instantiateViewController(withIdentifier: "reportDetails") as? ReportDetailsViewController
                reportDetailsVC?.modalPresentationStyle = .fullScreen
                reportDetailsVC?.familyMember = self?.memberDetails
                reportDetailsVC?.reportsVariant = .family
                self?.present(reportDetailsVC!, animated: true)
            }
        }
    }
    
    @objc func removeFromFamily() {
        Utils.displayYesREDNoAlertWithHandler("Do you want to remove \(memberDetails!.name!.firstName!) from your family?", viewController: self) { _ in
            
        } yesHandler: { _ in
            User.removeFamilyMember(withID: self.memberDetails!.id!) { isSuccess in
                if isSuccess {
                    Utils.displaySPIndicatorNotifWithoutMessage(title: "Member removed from family", iconPreset: .done, hapticPreset: .success, duration: 3.0)
                    self.navigationController?.popViewController(animated: true)
                    NotificationCenter.default.post(name: Notification.Name("refreshDataFromLocal"), object: nil)
                } else {
                    Utils.displaySPIndicatorNotifWithoutMessage(title: "An error occured", iconPreset: .error, hapticPreset: .error, duration: 2.0)
                }
            }
        }
    }

    @objc func handleBackAction(_ sender: UITapGestureRecognizer? = nil) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
