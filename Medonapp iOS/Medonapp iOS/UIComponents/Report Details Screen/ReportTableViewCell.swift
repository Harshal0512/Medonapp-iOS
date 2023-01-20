//
//  ReportTableViewCell.swift
//  Medonapp iOS
//
//  Created by Harshal Kulkarni on 18/10/22.
//

import UIKit

protocol ReportTableViewCellProtocol {
    func viewDownloadedFile(file: FileModel)
    func downloadButtonDidClick(file: FileModel, cellProgressBar: CircularProgressBar)
    func deleteFileButtonDidClick(file: FileModel)
    func shareButtonDidClick(file: FileModel)
}

class ReportTableViewCell: UITableViewCell {
    
    static let identifier = "ReportTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "ReportTableViewCell", bundle: nil)
    }
    
    @IBOutlet private var cellContentView: UIView!
    @IBOutlet private var iconView: UIView!
    @IBOutlet private var iconImage: UIImageView!
    @IBOutlet private var reportTitle: UILabel!
    @IBOutlet private var progressBar: CircularProgressBar!
    @IBOutlet private var downloadIcon: UIImageView!
    
    var delegate: ReportTableViewCellProtocol!
    var optionsMenu: UIMenu?
    var medicalFile: FileModel?
    
    public func configure(icon: UIImage, medicalFile: FileModel, reportCellVariant: reportVariant, isDownloaded: Bool) {
        self.medicalFile = medicalFile
        progressBar.labelSize = 0
        progressBar.safePercent = 100
        
        cellContentView.layer.cornerRadius = 28
        self.iconImage.image = icon
        
        self.iconView.backgroundColor = .clear
        self.iconView.layer.cornerRadius = 20
        
        self.reportTitle.text = medicalFile.fileName
        
        self.reportTitle.textColor = .black
        
        switch reportCellVariant {
        case .user:
            cellContentView.backgroundColor = UIColor(red: 0.86, green: 0.93, blue: 0.98, alpha: 1.00)
            iconView.layer.borderColor = UIColor(red: 0.11, green: 0.42, blue: 0.64, alpha: 1.00).cgColor
            iconView.layer.borderWidth = 2
            iconImage.image = iconImage.image!.withTintColor(UIColor(red: 0.11, green: 0.42, blue: 0.64, alpha: 1.00))
        case .family:
            cellContentView.backgroundColor = UIColor(red: 0.84, green: 1.00, blue: 0.95, alpha: 1.00)
            iconView.layer.borderColor = UIColor(red: 0.00, green: 0.54, blue: 0.37, alpha: 1.00).cgColor
            iconView.layer.borderWidth = 2
            iconImage.image = iconImage.image!.withTintColor(UIColor(red: 0.00, green: 0.54, blue: 0.37, alpha: 1.00))
        }
        
        downloadIcon.alpha = isDownloaded ? 0 : 1
        progressBar.alpha = 0
        
        if isDownloaded {
            
            let viewFile = UIAction(title: "View Downloaded File", image: UIImage(systemName: "doc.text.below.ecg.fill")) { action in
                self.delegate.viewDownloadedFile(file: medicalFile)
            }
            let reDownload = UIAction(title: "Re-Download File", image: UIImage(systemName: "arrow.down.circle.fill")) { action in
                self.progressBar.alpha = 1
                self.downloadIcon.alpha = 1
                self.delegate.downloadButtonDidClick(file: medicalFile, cellProgressBar: self.progressBar)
            }
            let deleteDownload = UIAction(title: "Delete Downloaded File", image: UIImage(systemName: "trash"), attributes: .destructive) { action in
                self.delegate.deleteFileButtonDidClick(file: medicalFile)
            }
            let shareFile = UIAction(title: "Share", image: UIImage(systemName: "square.and.arrow.up")) { action in
                self.delegate.shareButtonDidClick(file: medicalFile)
            }
            optionsMenu = UIMenu(children: [viewFile, reDownload, deleteDownload, shareFile])
        } else {
            let download = UIAction(title: "Download File", image: UIImage(systemName: "arrow.down.circle.fill")) { action in
                self.progressBar.alpha = 1
                self.downloadIcon.alpha = 1
                self.delegate.downloadButtonDidClick(file: medicalFile, cellProgressBar: self.progressBar)
            }
            optionsMenu = UIMenu(children: [download])
        }
    }
    
    func download() {
        self.progressBar.alpha = 1
        self.downloadIcon.alpha = 1
        self.delegate.downloadButtonDidClick(file: medicalFile!, cellProgressBar: self.progressBar)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
