//
//  ProfileImage.swift
//  Medonapp iOS
//
//  Created by Harshal Kulkarni on 26/10/22.
//

import Foundation

class ProfileImage: Codable {
    var fileName, filePath: String?
    var fileDownloadURI: String?
    var fileType: String?
    var fileSize: Int?

    enum CodingKeys: String, CodingKey {
        case fileName, filePath
        case fileDownloadURI = "fileDownloadUri"
        case fileType, fileSize
    }

    init(fileName: String?, filePath: String?, fileDownloadURI: String?, fileType: String?, fileSize: Int?) {
        self.fileName = fileName
        self.filePath = filePath
        self.fileDownloadURI = fileDownloadURI
        self.fileType = fileType
        self.fileSize = fileSize
    }
}
