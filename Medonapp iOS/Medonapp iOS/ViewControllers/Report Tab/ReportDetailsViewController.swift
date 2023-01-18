//
//  ReportDetailsViewController.swift
//  Medonapp iOS
//
//  Created by Harshal Kulkarni on 18/10/22.
//

import UIKit
import UniformTypeIdentifiers
import QuickLookThumbnailing
import WebKit

enum reportVariant {
    case user
    case family
}

class ReportDetailsViewController: UIViewController {
    
    private var backButton: UIImageView?
    private var navTitle: UILabel?
    private var reportsHistoryTable: UITableView?
    private var addReportsButton: UIButtonCircularWithLogo?
    
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
        
        addReportsButton = UIButtonCircularWithLogo()
        addReportsButton?.initButton(buttonIcon: UIImage(systemName: "plus")!, dimensions: 75, variant: reportsVariant == .user ? .blueBack : .greenBack)
        addReportsButton?.addTarget(self, action: #selector(addReportAction(_ :)), for: .touchUpInside)
        view.addSubview(addReportsButton!)
    }
    
    func setConstraints() {
        backButton?.translatesAutoresizingMaskIntoConstraints = false
        navTitle?.translatesAutoresizingMaskIntoConstraints = false
        reportsTopView?.translatesAutoresizingMaskIntoConstraints = false
        reportsHistoryTable?.translatesAutoresizingMaskIntoConstraints = false
        addReportsButton?.translatesAutoresizingMaskIntoConstraints = false
        
        
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
        reportsHistoryTable?.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50).isActive = true
        
        addReportsButton?.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -35).isActive = true
        addReportsButton?.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -25).isActive = true
        addReportsButton?.widthAnchor.constraint(equalToConstant: 75).isActive = true
        addReportsButton?.heightAnchor.constraint(equalToConstant: 75).isActive = true
    }
    
    func refreshData() {
        view.isUserInteractionEnabled = false
        self.view.makeToastActivity(.center)
        
        User.refreshUserDetails { isSuccess in
            if isSuccess {
                self.view.isUserInteractionEnabled = true
                let sections = NSIndexSet(indexesIn: NSMakeRange(0, self.reportsHistoryTable!.numberOfSections))
                self.reportsHistoryTable!.reloadSections(sections as IndexSet, with: .fade)
                self.view.hideToastActivity()
            }
        }
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
    
    @objc func addReportAction(_ sender: UIButtonCircularWithLogo) {
        UIView.animate(withDuration: 0.2, animations: ({
            sender.transform = sender.transform.rotated(by: CGFloat(Double.pi))
        }))
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
            let attachSheet = UIAlertController(title: nil, message: "Attach File", preferredStyle: .actionSheet)
            
            attachSheet.addAction(UIAlertAction(title: "File", style: .default,handler: { (action) in
                self.chooseDocument()
            }))
            
            attachSheet.addAction(UIAlertAction(title: "Photo", style: .default,handler: { (action) in
                self.chooseImage()
            }))
            
            
            attachSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            
            self.present(attachSheet, animated: true, completion: nil)
        })
    }
    
    func chooseDocument() {
        let supportedTypes: [UTType] = [UTType.png, UTType.jpeg, UTType.pdf]
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: supportedTypes)
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false
        documentPicker.shouldShowFileExtensions = true
        self.present(documentPicker, animated: true, completion: nil)
    }
    
    func chooseImage() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.mediaTypes = ["public.image"]
        imagePicker.sourceType = .photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
    }
}

extension ReportDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (User.getUserDetails().patient?.medicalFiles?.count)!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 133
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = reportsHistoryTable!.dequeueReusableCell(withIdentifier: ReportTableViewCell.identifier, for: indexPath) as! ReportTableViewCell
        if reportsVariant == .user {
            let fileExists: (Bool, URL?) = (User.getUserDetails().patient?.medicalFiles![indexPath.row].checkIfFileAlreadyExists())!
            cell.configure(icon: UIImage(named: "documentIcon")!, medicalFile: (User.getUserDetails().patient?.medicalFiles?[indexPath.row])!, reportCellVariant: .user, isDownloaded: fileExists.0)
        }
//        else if reportsVariant == .family {
//            cell.configure(icon: UIImage(named: "documentIcon")!, medicalFile: "X-Ray Report", reportCellVariant: .family, isDownloaded: false)
//        }
        
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        reportsHistoryTable?.scrollToRow(at: indexPath, at: .middle, animated: true)
        reportsHistoryTable?.deselectRow(at: indexPath, animated: true)
        
        viewDownloadedFile(file: (User.getUserDetails().patient?.medicalFiles![indexPath.row])!)
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let identifier = NSString(string: "\(indexPath.row)")
        
        let cell = reportsHistoryTable!.cellForRow(at: indexPath) as! ReportTableViewCell
        
        return UIContextMenuConfiguration(identifier: identifier, previewProvider: nil) { _ in
            return cell.optionsMenu
        }
    }
}

extension ReportDetailsViewController: ReportTableViewCellProtocol {
    func openPDFInWebView(data: Data, path: URL) {
        let webView = WKWebView(frame: self.view.frame)
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        webView.load(data, mimeType: "application/pdf", characterEncodingName: "", baseURL: path.deletingLastPathComponent())
        
        self.view.addSubview(webView)
    }
    
    func viewDownloadedFile(file: FileModel) {
        let fileExists: (Bool, URL?) = file.checkIfFileAlreadyExists()
        
        if fileExists.0 {
            if let path = fileExists.1 {
                let data = try! Data(contentsOf: path)
                self.openPDFInWebView(data: data, path: path)
            }
        } else {
            APIService.downloadFile(fileUrl: URL(string: file.fileDownloadURI!)!, fileName: file.fileName!, headers: ["Authorization" : "Bearer \(User.getUserDetails().token ?? "")"]) { path in
                
                if let path = path {
                    let data = try! Data(contentsOf: path)
                    self.openPDFInWebView(data: data, path: path)
                }
            }
        }
    }
    
    func downloadButtonDidClick(file: FileModel) {
        APIService.downloadFile(fileUrl: URL(string: file.fileDownloadURI!)!, fileName: file.fileName!, headers: ["Authorization" : "Bearer \(User.getUserDetails().token ?? "")"]) { path in
            
            if let path = path {
                let data = try! Data(contentsOf: path)
                self.openPDFInWebView(data: data, path: path)
            }
        }
    }
    
    func deleteFileButtonDidClick(file: FileModel) {
        let fileExists: (Bool, URL?) = file.checkIfFileAlreadyExists()
        
        if fileExists.0 {
            do {
                try FileManager.default.removeItem(at: fileExists.1!)
                Utils.displayAlertWithHandler("File Deleted", "", viewController: self) { action in
                    self.refreshData()
                }
            } catch {
                print("Could not be deleted.")
            }
        }
    }
    
    func shareButtonDidClick(file: FileModel) {
        let fileExists: (Bool, URL?) = file.checkIfFileAlreadyExists()
        
        if fileExists.0 {
            if let path = fileExists.1 {
                let data = try! Data(contentsOf: path)
                let activityViewController: UIActivityViewController = UIActivityViewController(activityItems: [file.fileName!, data], applicationActivities: nil)
                present(activityViewController, animated: true, completion: nil)
            }
        }
        
    }
}

extension ReportDetailsViewController: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        var selectedFileData = [String:String]()
        let file = urls[0]
        do{
            let fileData = try Data.init(contentsOf: file.absoluteURL)
            
            selectedFileData["filename"] = file.lastPathComponent
            selectedFileData["data"] = fileData.base64EncodedString(options: .lineLength64Characters)
            
            let alert = UIAlertController(title: "Upload Document",
                                          message: "Are you sure you want to upload this document?",
                                          preferredStyle: .alert)
            
            let saveAction = UIAlertAction(title: "Upload",
                                           style: .default) { _ in
                APIService.uploadFile(file: fileData, fileName: selectedFileData["filename"] ?? "", params: ["Authorization" : "Bearer \(User.getUserDetails().token ?? "")"]) {
                    print("here")
                }
            }
            
            let cancelAction = UIAlertAction(title: "Cancel",
                                             style: .cancel) { (action: UIAlertAction!) -> Void in
            }
            
            alert.addAction(saveAction)
            alert.addAction(cancelAction)
            
            let imageView = UIImageView(frame: CGRect(x: 15, y: 80, width: 250, height: 230))
            
            let request = QLThumbnailGenerator
                .Request(fileAt: file, size: CGSize(width: 250, height: 230), scale: 1,
                         representationTypes: .thumbnail)
            
            QLThumbnailGenerator.shared.generateRepresentations(for: request)
            { (thumbnail, type, error) in
                DispatchQueue.main.async {
                    if thumbnail == nil || error != nil {
                        // Handle the error case gracefully.
                        fatalError()
                    } else {
                        // Display the thumbnail that you created.
                        imageView.image = thumbnail?.uiImage
                    }
                }
            }
            
            imageView.contentMode = .scaleAspectFit
            alert.view.addSubview(imageView)
            alert.view.addConstraint(NSLayoutConstraint(item: alert.view!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 380))
            alert.view.addConstraint(NSLayoutConstraint(item: alert.view!, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 280))

            self.present(alert, animated: true, completion: nil)
            
        }catch{
            print("contents could not be loaded")
        }
    }
}

extension ReportDetailsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var selectedImageData = [String:String]()
        
        
        guard let fileUrl = info[UIImagePickerController.InfoKey.imageURL] as? URL else { return }
        
        let alert = UIAlertController(title: "Upload Image",
                                      message: "Are you sure you want to upload this image?",
                                      preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Upload",
                                       style: .default) { (action: UIAlertAction!) -> Void in
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .cancel) { (action: UIAlertAction!) -> Void in
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        let imageView = UIImageView(frame: CGRect(x: 15, y: 80, width: 250, height: 230))
        
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            selectedImageData["filename"] = fileUrl.lastPathComponent
            selectedImageData["data"] = pickedImage.pngData()?.base64EncodedString(options: .lineLength64Characters)
            
            imageView.image = pickedImage
        }
        
        imageView.contentMode = .scaleAspectFit
        alert.view.addSubview(imageView)
        alert.view.addConstraint(NSLayoutConstraint(item: alert.view!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 380))
        alert.view.addConstraint(NSLayoutConstraint(item: alert.view!, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 280))
        
        dismiss(animated: true) {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
