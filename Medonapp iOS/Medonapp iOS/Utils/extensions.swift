//
//  extensions.swift
//  Medonapp iOS
//
//  Created by Harshal Kulkarni on 02/10/22.
//

import Foundation
import UIKit
import SkeletonView

extension UIViewController {
    func dismissKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer( target:     self, action:    #selector(UIViewController.dismissKeyboardTouchOutside))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyboardTouchOutside() {
        view.endEditing(true)
    }
}

extension UIImageView {
    func makeRoundCorners(byRadius rad: CGFloat) {
        self.layer.cornerRadius = rad
        self.clipsToBounds = true
    }
    
    func addSkeleton() {
        self.isSkeletonable = true
    }
}

extension UIImage {
    
    func resizeImageTo(size: CGSize) -> UIImage? {
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        self.draw(in: CGRect(origin: CGPoint.zero, size: size))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return resizedImage
    }
}

extension UILabel {
    func addSkeleton() {
        self.isSkeletonable = true
        self.linesCornerRadius = 7
    }
}

extension UIButton{
    
    func setImageTintColor(_ color: UIColor) {
        let tintedImage = self.imageView?.image?.withRenderingMode(.alwaysTemplate)
        self.setImage(tintedImage, for: .normal)
        self.tintColor = color
    }
    
}

extension UIView {
    class func initFromNib<T: UIView>() -> T {
        return Bundle.main.loadNibNamed(String(describing: self), owner: nil, options: nil)?[0] as! T
    }
    
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: -1, height: 1)
        layer.shadowRadius = 1
        
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true, cornerRadius: CGFloat) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
        layer.cornerRadius = cornerRadius
        
        layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: cornerRadius).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}

extension Date {
    static func ISOStringFromDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(abbreviation: "IST")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        
        var finalDate = dateFormatter.string(from: date)
        if finalDate == nil {
            dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            finalDate = dateFormatter.string(from: date)
        }
         return finalDate
    }
    
    static func stringFromDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(abbreviation: "IST")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        return dateFormatter.string(from: date)
    }
    
    static func dateFromISOString(string: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(abbreviation: "IST")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        
        var finalDate = dateFormatter.date(from: string)
        if finalDate == nil {
            dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            finalDate = dateFormatter.date(from: string)
        }
         return finalDate
    }
    
    static func getTimeFromDate(dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(abbreviation: "IST")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let temp = dateFormatter.date(from: dateString)!
        dateFormatter.dateFormat = "hh:mm a"
        return dateFormatter.string(from: temp)
    }
    
    static func getYearFromDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        return dateFormatter.string(from: date)
    }
    
    static func getMonthFromDate(date: Date) -> String {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.month], from: date)
        return "\(components.month!)"
    }
    
    static func getDayFromDate(date: Date) -> String {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: date)
        return "\(components.day!)"
    }
    
    static func getDayOfWeekFromDate(date: Date) -> String {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.weekday], from: date)
        return "\(components.weekday!)"
    }
    
    static func dateTimeChangeFormat(str stringWithDate: String, inDateFormat: String, outDateFormat: String) -> String {
        let inFormatter = DateFormatter()
        inFormatter.locale = Locale(identifier: "en_US_POSIX")
        inFormatter.dateFormat = inDateFormat

        let outFormatter = DateFormatter()
        outFormatter.locale = Locale(identifier: "en_US_POSIX")
        outFormatter.dateFormat = outDateFormat

        let inStr = stringWithDate
        let date = inFormatter.date(from: inStr)!
        return outFormatter.string(from: date)
    }
    
    static func combineDateWithTimeReturnISO(date: String, time: String) -> String {
        let string = date + " " + time
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let finalDate = dateFormatter.date(from: string)!
        return ISOStringFromDate(date: finalDate)
    }
    
    static func addMinutes(ISODateString: String, minutes: Double) -> String {
        var date = Date.dateFromISOString(string: ISODateString)
        print(date)
        date = date?.addingTimeInterval(minutes)
        print(date)
        return Date.ISOStringFromDate(date: date!)
    }
}

extension Encodable {

    /// Converting object to postable dictionary
    func toDictionary(_ encoder: JSONEncoder = JSONEncoder()) throws -> [String: Any] {
        let data = try encoder.encode(self)
        let object = try JSONSerialization.jsonObject(with: data)
        guard let json = object as? [String: Any] else {
            let context = DecodingError.Context(codingPath: [], debugDescription: "Deserialized object is not a dictionary")
            throw DecodingError.typeMismatch(type(of: object), context)
        }
        return json
    }
}
