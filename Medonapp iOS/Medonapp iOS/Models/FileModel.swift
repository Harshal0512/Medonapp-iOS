//
//  MedicalFile.swift
//  Medonapp iOS
//
//  Created by Harshal Kulkarni on 17/01/23.
//

import Foundation

class FileModel: Codable {
    var fileName: String?
    var fileDownloadURI: String?
    var fileType, uploadedOn: String?
    
    enum CodingKeys: String, CodingKey {
        case fileName
        case fileDownloadURI = "fileDownloadUri"
        case fileType, uploadedOn
    }
    
    init(fileName: String?, fileDownloadURI: String?, fileType: String?, uploadedOn: String?) {
        self.fileName = fileName
        self.fileDownloadURI = fileDownloadURI
        self.fileType = fileType
        self.uploadedOn = uploadedOn
    }
    
    func checkIfFileAlreadyExists() -> (Bool, URL?) {
        let docsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        
        let destinationUrl = docsUrl?.appendingPathComponent(fileName!)
        if let destinationUrl = destinationUrl {
            if (FileManager().fileExists(atPath: destinationUrl.path)) {
                return (true, destinationUrl)
            }
        }
        return (false, nil)
    }
}
