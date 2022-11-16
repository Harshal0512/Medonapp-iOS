//
//  Utils.swift
//  Medonapp iOS
//
//  Created by Harshal Kulkarni on 02/10/22.
//

import Foundation
import UIKit

class Utils {
    
    internal class func displayAlert(_ displayText: String?, viewController: UIViewController?) {
        guard let displayText = displayText else { return }
        let alertController = UIAlertController(title: "Message", message:
                                                    displayText, preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default,handler: nil))
        viewController?.present(alertController, animated: true, completion: nil)
        
    }
    
    internal class func displayAlert(_ displayText: String, viewController: UIViewController?, handler: @escaping (UIAlertAction) -> Void) {
        
        let alertController = UIAlertController(title: "Medonapp", message:
                                                    displayText, preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default,handler: handler))
        viewController?.present(alertController, animated: true, completion: nil)
        
    }
    
    internal class func displayAlert(_ title: String, _ displayText: String, viewController: UIViewController?){
        
        let alertController = UIAlertController(title: title, message:
                                                    displayText, preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default,handler: nil))
        viewController?.present(alertController, animated: true, completion: nil)
        
    }
    
    internal class func displayAlertWithCloseAction(_ displayText: String, viewController: UIViewController?){
        
        let alertController = UIAlertController(title: "Medonapp", message:
                                                    displayText, preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { action in
            
            viewController?.navigationController?.popViewController(animated: true);
            
        }))
        
        viewController?.present(alertController, animated: true, completion: nil)
        
    }
    
    internal class func displayAlertWithHandler(_ displayText: String, viewController: UIViewController?, handler: ((UIAlertAction)->Void)?){
        
        let alertController = UIAlertController(title: "Medonapp", message:
                                                    displayText, preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: handler))
        
        viewController?.present(alertController, animated: true, completion: nil)
        
    }
    
    internal class func displayAlertWithDismissAction(_ displayText: String, viewController: UIViewController?){
        
        let alertController = UIAlertController(title: "Medonapp", message:
                                                    displayText, preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default, handler: { action in
            
            viewController?.dismiss(animated: true, completion: nil)
            
        }))
        
        viewController?.present(alertController, animated: true, completion: nil)
        
    }
    
    internal class func displayYesNoAlert(_ displayText: String, viewController: UIViewController?){
        
        let alertController = UIAlertController(title: "Data not saved!", message:
                                                    displayText, preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: { action in
            
            viewController?.navigationController?.popViewController(animated: true);
            
        }))
        
        viewController?.present(alertController, animated: true, completion: nil)
        
    }
    
    internal class func displayYesNoAlertWithHandler(_ displayText: String, viewController: UIViewController?, noHandler: ((UIAlertAction)->Void)?,  yesHandler: ( (UIAlertAction)->Void)?){
        
        let alertController = UIAlertController(title: "Medonapp", message:
                                                    displayText, preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.cancel, handler: noHandler))
        alertController.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: yesHandler))
        
        viewController?.present(alertController, animated: true, completion: nil)
        
    }
    
    class func dialNumber(number: String) {
        
        if let url = URL(string: "tel://\(number)"),
           UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:], completionHandler:nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        } else {
            // add error message here
        }
    }
    
    class func createEmailUrl(to: String, subject: String, body: String) -> URL? {
        let subjectEncoded = subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let bodyEncoded = body.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        let gmailUrl = URL(string: "googlegmail://co?to=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
        let outlookUrl = URL(string: "ms-outlook://compose?to=\(to)&subject=\(subjectEncoded)")
        let yahooMail = URL(string: "ymail://mail/compose?to=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
        let sparkUrl = URL(string: "readdle-spark://compose?recipient=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
        let defaultUrl = URL(string: "mailto:\(to)?subject=\(subjectEncoded)&body=\(bodyEncoded)")
        
        if let gmailUrl = gmailUrl, UIApplication.shared.canOpenURL(gmailUrl) {
            return gmailUrl
        } else if let outlookUrl = outlookUrl, UIApplication.shared.canOpenURL(outlookUrl) {
            return outlookUrl
        } else if let yahooMail = yahooMail, UIApplication.shared.canOpenURL(yahooMail) {
            return yahooMail
        } else if let sparkUrl = sparkUrl, UIApplication.shared.canOpenURL(sparkUrl) {
            return sparkUrl
        }
        
        return defaultUrl
    }
    
    class func openWhatsApp(numberWithCountryCode: String) {
        let urlWhats = "whatsapp://send?phone=\(numberWithCountryCode)&abid=12354&text=Hello Doctor,"
        if let urlString = urlWhats.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) {
            if let whatsappURL = URL(string: urlString) {
                if UIApplication.shared.canOpenURL(whatsappURL) {
                    if #available(iOS 10, *) {
                        UIApplication.shared.open(whatsappURL, options: [:], completionHandler:nil)
                    } else {
                        UIApplication.shared.openURL(whatsappURL)
                    }
                } else {
                    
                }
            }
        }
    }
    
    class func openURL(_ string: String?){
        
        guard let val = string else {return}
        var formattedUrl = val
        if(!formattedUrl.hasPrefix("http")) {
            formattedUrl = "https://" + formattedUrl
        }
        guard let url = URL(string: formattedUrl) else { return }
        
        let application = UIApplication.shared
        
        if (application.canOpenURL(url)){
            if #available(iOS 10, *){
                application.open(url, options: [:], completionHandler: nil)
            }else{
                application.openURL(url)
            }
        }
    }
}


// MARK: - Helper functions for creating encoders and decoders

func newJSONDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        decoder.dateDecodingStrategy = .iso8601
    }
    return decoder
}

func newJSONEncoder() -> JSONEncoder {
    let encoder = JSONEncoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        encoder.dateEncodingStrategy = .iso8601
    }
    return encoder
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {
    
    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }
    
    public var hashValue: Int {
        return 0
    }
    
    public func hash(into hasher: inout Hasher) {
        // No-op
    }
    
    public init() {}
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}

