//
//  StoryboardUtils.swift
//  Medonapp iOS
//
//  Created by Harshal Kulkarni on 10/10/22.
//

import UIKit

// Keep this as it is
// Only change the enum case names
enum StoryboardUtils : String {
    
    // Remove or add your own names here based on Storyboard file names
    // The logic is:
    // 1. You create a new Storyboard file which contains a blank UIViewController
    // 2. Give it a storyboard Id eg: mobileNumberVC
    // 3. Put the Storyboard file name in this enum case exactly as it is
    // 4. Create a func in StoryboardUtils' extension below to return the view controller with hard-coded storyboard Id (like: mobileNumberVC)

    case Main
    case HomeTab
    
    var instance: UIStoryboard {
        return UIStoryboard(name: self.rawValue, bundle: Bundle.main)
    }
    
    func viewController<T : UIViewController>(viewControllerClass : T.Type, function : String = #function, line : Int = #line, file : String = #file) -> T {
        let storyboardID = (viewControllerClass as UIViewController.Type).storyboardID
        guard let scene = instance.instantiateViewController(withIdentifier: storyboardID) as? T else {
            fatalError("ViewController with identifier \(storyboardID), not found in \(self.rawValue) Storyboard.\nFile : \(file) \nLine Number : \(line) \nFunction : \(function)")
        }
        return scene
    }
    
    func initialViewController() -> UIViewController? {
        return instance.instantiateInitialViewController()
    }
}
extension UIViewController{
    
    class var storyboardID : String {
        return "\(self)"
    }
    
    static func instantiate(fromAppStoryboard appStoryboard: StoryboardUtils) -> Self {
        return appStoryboard.viewController(viewControllerClass: self)
    }
}

extension StoryboardUtils{
    static func getDoctorsScreenVC() -> UIViewController {
        return HomeTab.instance.instantiateViewController(withIdentifier: "doctorsScreenVC")
    }
    
    static func getDoctorsDetailsVC() -> UIViewController {
        return HomeTab.instance.instantiateViewController(withIdentifier: "doctorsDetailsVC")
    }
    
    static func getProfileVC() -> UIViewController {
        return HomeTab.instance.instantiateViewController(withIdentifier: "profileVC")
    }
    
    static func getBookAppointmentVC() -> UIViewController {
        return HomeTab.instance.instantiateViewController(withIdentifier: "bookAppointmentVC")
    }
}

