//
//  extensions.swift
//  Medonapp iOS
//
//  Created by Harshal Kulkarni on 02/10/22.
//

import Foundation
import UIKit
import SkeletonView
import Kingfisher

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
    
    func setKFImage(imageUrl url: String, placeholderImage: UIImage, fadeDuration: TimeInterval = 0.25) {
        KF.url(URL(string: url))
            .placeholder(placeholderImage)
            .loadDiskFileSynchronously()
            .cacheMemoryOnly()
            .fade(duration: fadeDuration)
            .onProgress { receivedSize, totalSize in }
            .onSuccess { result in }
            .onFailure { error in }
            .set(to: self)
    }
}

extension UIImage {
    
    func withAlpha(_ a: CGFloat) -> UIImage {
        return UIGraphicsImageRenderer(size: size, format: imageRendererFormat).image { (_) in
            draw(in: CGRect(origin: .zero, size: size), blendMode: .normal, alpha: a)
        }
    }
    
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
    
    func set(text:String, leftIcon: UIImage? = nil, rightIcon: UIImage? = nil) {
        
        let leftAttachment = NSTextAttachment()
        leftAttachment.image = leftIcon
        leftAttachment.bounds = CGRect(x: 0, y: -2.5, width: 20, height: 20)
        if let leftIcon = leftIcon {
            leftAttachment.bounds = CGRect(x: 0, y: -2.5, width: leftIcon.size.width, height: leftIcon.size.height)
        }
        let leftAttachmentStr = NSAttributedString(attachment: leftAttachment)
        
        let myString = NSMutableAttributedString(string: "")
        
        let rightAttachment = NSTextAttachment()
        rightAttachment.image = rightIcon
        rightAttachment.bounds = CGRect(x: 0, y: -5, width: 20, height: 20)
        let rightAttachmentStr = NSAttributedString(attachment: rightAttachment)
        
        
        if semanticContentAttribute == .forceRightToLeft {
            if rightIcon != nil {
                myString.append(rightAttachmentStr)
                myString.append(NSAttributedString(string: " "))
            }
            myString.append(NSAttributedString(string: text))
            if leftIcon != nil {
                myString.append(NSAttributedString(string: " "))
                myString.append(leftAttachmentStr)
            }
        } else {
            if leftIcon != nil {
                myString.append(leftAttachmentStr)
                myString.append(NSAttributedString(string: " "))
            }
            myString.append(NSAttributedString(string: text))
            if rightIcon != nil {
                myString.append(NSAttributedString(string: " "))
                myString.append(rightAttachmentStr)
            }
        }
        attributedText = myString
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

extension UIDatePicker {
    func set18YearValidation() {
        let currentDate: Date = Date()
        var calendar: Calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        calendar.timeZone = TimeZone(identifier: "UTC")!
        var components: DateComponents = DateComponents()
        components.calendar = calendar
        components.year = -18
        let maxDate: Date = calendar.date(byAdding: components, to: currentDate)!
        components.year = -150
        let minDate: Date = calendar.date(byAdding: components, to: currentDate)!
        self.minimumDate = minDate
        self.maximumDate = maxDate
    } }

extension DispatchQueue {
    
    static func background(delay: Double = 0.0, background: (()->Void)? = nil, completion: (() -> Void)? = nil) {
        DispatchQueue.global(qos: .background).async {
            background?()
            if let completion = completion {
                DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
                    completion()
                })
            }
        }
    }
}

extension Date {
    static var yesterday: Date { return Date().localDate().dayBefore }
    static var tomorrow:  Date { return Date().localDate().dayAfter }
    var dayBefore: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: noon)!
    }
    var dayAfter: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: noon)!
    }
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    var month: Int {
        return Calendar.current.component(.month,  from: self)
    }
    var isLastDayOfMonth: Bool {
        return dayAfter.month != month
    }
    func localDate() -> Date {
        let nowUTC = Date()
        let timeZoneOffset = Double(TimeZone.current.secondsFromGMT(for: nowUTC))
        guard let localDate = Calendar.current.date(byAdding: .second, value: Int(timeZoneOffset), to: nowUTC) else {return Date()}
        
        return localDate
    }
    
    static func ISOStringFromDate(date: Date, timezone: String = "IST", ending: String = "") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(abbreviation: timezone)
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss\(ending)"
        return dateFormatter.string(from: date)
    }
    
    static func stringFromDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(abbreviation: "IST")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        return dateFormatter.string(from: date)
    }
    
    static func dateFromISOString(string: String, timezone: String = "IST", ending: String = "") -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(abbreviation: timezone)
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss\(ending)"
        return dateFormatter.date(from: string)
    }
    
    static func getTimeFromDate(dateString: String, timezone: String = "IST") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(abbreviation: timezone)
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
        dateFormatter.timeZone = TimeZone(abbreviation: "IST")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let finalDate = dateFormatter.date(from: string)!
        return ISOStringFromDate(date: finalDate)
    }
    
    static func addMinutes(ISODateString: String, minutes: Double) -> String {
        var date = Date.dateFromISOString(string: ISODateString)
        date = date?.addingTimeInterval(minutes)
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

extension Double {
    var clean: String {
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(format: "%.2f", self)
    }
}

extension String {
    func isUrl() -> Bool {
        var url = self.lowercased()
        if(!url.hasPrefix("http://") && !url.hasPrefix("https://")) {
            url = "http://" + url
        }
        
        let urlRegEx = "^(https?://)?(www\\.)?([-a-z0-9]{1,63}\\.)*?[a-z0-9][-a-z0-9]{0,61}[a-z0-9]\\.[a-z]{2,6}(/[-\\w@\\+\\.~#\\?&/=%]*)?$"
        //        let urlRegEx = "((?:http|https)://)?(?:www\\.)?[\\w\\d\\-_]+\\.\\w{2,3}(\\.\\w{2})?(/(?<=/)(?:[\\w\\d\\-./_]+)?)?"
        return NSPredicate(format: "SELF MATCHES %@", urlRegEx).evaluate(with: url)
    }
}

extension StringProtocol {
    func index<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> Index? {
        range(of: string, options: options)?.lowerBound
    }
    func endIndex<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> Index? {
        range(of: string, options: options)?.upperBound
    }
    func indices<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> [Index] {
        ranges(of: string, options: options).map(\.lowerBound)
    }
    func ranges<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> [Range<Index>] {
        var result: [Range<Index>] = []
        var startIndex = self.startIndex
        while startIndex < endIndex,
              let range = self[startIndex...]
            .range(of: string, options: options) {
            result.append(range)
            startIndex = range.lowerBound < range.upperBound ? range.upperBound :
            index(range.lowerBound, offsetBy: 1, limitedBy: endIndex) ?? endIndex
        }
        return result
    }
    
    func distance(of element: Element) -> Int? {
        firstIndex(of: element)?.distance(in: self)
    }
    
    func distance<S: StringProtocol>(of string: S) -> Int? {
        range(of: string)?.lowerBound.distance(in: self)
    }
    
    func indexOf(_ str: String) -> Int {
        if let distance = distance(of: str) {
            return distance
        }
        return -1
    }
}

extension Collection {
    func distance(to index: Index) -> Int { distance(from: startIndex, to: index) }
}

extension String.Index {
    func distance<S: StringProtocol>(in string: S) -> Int { string.distance(to: self) }
}

extension UITapGestureRecognizer {
    
    func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
        // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        let textStorage = NSTextStorage(attributedString: label.attributedText!)
        
        // Configure layoutManager and textStorage
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        // Configure textContainer
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        let labelSize = label.bounds.size
        textContainer.size = labelSize
        
        // Find the tapped character location and compare it to the specified range
        let locationOfTouchInLabel = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        let textContainerOffset = CGPoint(
            x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x,
            y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y
        )
        let locationOfTouchInTextContainer = CGPoint(
            x: locationOfTouchInLabel.x + textContainerOffset.x*0,
            y: locationOfTouchInLabel.y + textContainerOffset.y*0
        )
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        
        let locInRange = NSLocationInRange(indexOfCharacter, targetRange)
        return locInRange
    }
    
}
