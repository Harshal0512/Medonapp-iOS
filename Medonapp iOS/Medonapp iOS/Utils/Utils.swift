//
//  Utils.swift
//  Medonapp iOS
//
//  Created by Harshal Kulkarni on 02/10/22.
//

import Foundation
import UIKit
import NotificationBannerSwift
import CoreLocation
import SPIndicator

class Utils {
    
    internal class func initiateLogoutSequence() {
        User.clearUserDetails()
        PrefDataManager.clearAllPrefs()
    }
    
    internal class func checkForReachability() {
        if Reachability.isConnectedToNetwork() {
            print("We're connected!")
            Prefs.isNetworkAvailable = true
        } else {
            print("No connection.")
            Prefs.isNetworkAvailable = false
        }
    }
    
    @objc internal class func openShareAppSheet(on vc: UIViewController) {
        // text to share
        let text = "Hey! I found an amazing app where you can meet top doctors, schedule appointments, get reports and many more.\n\nDownload & Register on Medonapp now!!"
        
        // set up activity view controller
        let textToShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = vc.view // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ ]
        
        // present the view controller
        vc.present(activityViewController, animated: true, completion: nil)
    }
    
    internal class func displayNoNetworkBanner(_ vc: UIViewController) -> GrowingNotificationBanner {
        let networkWarningBanner = GrowingNotificationBanner(title: "Connection Error", subtitle: "Limited features available", style: .danger)
        networkWarningBanner.autoDismiss = false
        networkWarningBanner.bannerHeight = 95
        networkWarningBanner.dismissOnTap = true
        networkWarningBanner.dismissOnSwipeUp = true
        networkWarningBanner.haptic = .heavy
        DispatchQueue.main.async {
            networkWarningBanner.show(bannerPosition: .top)
        }
        return networkWarningBanner
    }
    
    internal class func displaySPIndicatorNotifWithMessage(title: String, message: String, iconPreset: SPIndicatorIconPreset, hapticPreset: SPIndicatorHaptic, duration: TimeInterval) {
        let indicatorView = SPIndicatorView(title: title, message: message, preset: iconPreset)
        indicatorView.presentSide = .bottom
        indicatorView.offset = 50.0
        indicatorView.dismissByDrag = false
        indicatorView.present(duration: duration, haptic: hapticPreset)
    }
    
    internal class func displaySPIndicatorNotifWithoutMessage(title: String, iconPreset: SPIndicatorIconPreset, hapticPreset: SPIndicatorHaptic, duration: TimeInterval) {
        let indicatorView = SPIndicatorView(title: title, preset: iconPreset)
        indicatorView.presentSide = .bottom
        indicatorView.offset = 50.0
        indicatorView.dismissByDrag = false
        indicatorView.present(duration: duration, haptic: hapticPreset)
    }
    
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
    
    internal class func displayAlertWithHandler(_ title: String, _ displayText: String, viewController: UIViewController?, handler: ((UIAlertAction)->Void)?){
        
        let alertController = UIAlertController(title: title, message:
                                                    displayText, preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: handler))
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
    
    internal class func displayYesREDNoAlertWithHandler(_ displayText: String, viewController: UIViewController?, style: UIAlertController.Style = .alert, noHandler: ((UIAlertAction)->Void)?,  yesHandler: ( (UIAlertAction)->Void)?){
        
        let alertController = UIAlertController(title: "Medonapp", message:
                                                    displayText, preferredStyle: style)
        alertController.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.cancel, handler: noHandler))
        alertController.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.destructive, handler: yesHandler))
        
        viewController?.present(alertController, animated: true, completion: nil)
        
    }
    
    //        /** Degrees to Radian **/
    class func degreeToRadian(angle:CLLocationDegrees) -> CGFloat {
        return (  (CGFloat(angle)) / 180.0 * CGFloat(Double.pi)  )
    }

    //        /** Radians to Degrees **/
    class func radianToDegree(radian:CGFloat) -> CLLocationDegrees {
        return CLLocationDegrees(  radian * CGFloat(180.0 / Double.pi)  )
    }
    
    class func geographicMidpoint(betweenCoordinates coordinates: [CLLocationCoordinate2D]) -> CLLocationCoordinate2D {
        
        guard coordinates.count > 1 else {
            return coordinates.first ?? // return the only coordinate
            CLLocationCoordinate2D(latitude: 0, longitude: 0) // return null island if no coordinates were given
        }
        
        var x = Double(0)
        var y = Double(0)
        var z = Double(0)
        
        for coordinate in coordinates {
            let lat = Utils.degreeToRadian(angle: coordinate.latitude)
            let lon = Utils.degreeToRadian(angle: coordinate.longitude)
            x += cos(lat) * cos(lon)
            y += cos(lat) * sin(lon)
            z += CoreGraphics.sin(lat)
        }
        
        x /= Double(coordinates.count)
        y /= Double(coordinates.count)
        z /= Double(coordinates.count)
        
        let lon = atan2(y, x)
        let hyp = sqrt(x * x + y * y)
        let lat = atan2(z, hyp)
        
        return CLLocationCoordinate2D(latitude: Utils.radianToDegree(radian: lat), longitude: Utils.radianToDegree(radian: lon))
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
    
    class func getObscuredEmail(email: String) -> String {
        return email[email.startIndex..<email.index(email.startIndex, offsetBy: 3)] + String(repeating: "*", count: 12) + email[email.index(email.endIndex, offsetBy: -3)..<email.endIndex]
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

