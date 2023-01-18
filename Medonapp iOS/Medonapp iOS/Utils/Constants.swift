//
//  Constants.swift
//
//

import Foundation
import UIKit

class Constants {
    
    static let BASE_SERVER_HOST = "http://34.100.156.30:8080"
    
    static let BASE_URI = "\(Constants.BASE_SERVER_HOST)/api/"
    
    static let SETTING_MAX_FILE_UPLOAD_SIZE = "MAX_FILE_UPLOAD_SIZE"
    static let SETTING_MAX_FILE_UPLOAD_COUNT = "MAX_FILE_UPLOAD_COUNT"
    
    
    // REGEX
    static let REGEX_YOUTUBE_URL = "^((?:https?:)?//)?((?:www|m)\\.)?((?:youtube\\.com|youtu.be|youtube-nocookie.com))(/(?:[\\w\\-]+\\?v=|feature=|watch\\?|e/|embed/|v/)?)([\\w\\-]+)(\\S+)?$"
    static let REGEX_YOUTUBE_PLAYLIST_URL = "(https?:\\/\\/)?(www\\.)?((?:youtube\\.com|youtu.be|youtube-nocookie.com))\\/(playlist)(.*)"
    static let REGEX_YOUTUBE_CHANNEL_URL = "(https?:\\/\\/)?(www\\.)?((?:youtube\\.com|youtu.be|youtube-nocookie.com))\\/(channel|user|c)\\/[\\w-]+"
    static let REGEX_EMAIL = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    
    
    
    static let PRIVACY_POLICY_URL = ""
    static let FAQ_URL = ""
    static let TERMS_URL = ""

}
