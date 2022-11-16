//
//  SplashScreenViewController.swift
//  Medonapp iOS
//
//  Created by Harshal Kulkarni on 31/10/22.
//

import UIKit
import Network

class SplashScreenViewController: UIViewController {
    
    let monitor = NWPathMonitor()
    
    @IBOutlet private var appIcon: UIImageView!
    @IBOutlet private var nameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                print("We're connected!")
                
                OperationQueue.main.addOperation {
                    UIView.animate(withDuration: 0.2, delay: 0.7, animations: {
                        self.nameLabel.alpha = 0
                        self.appIcon.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
                    }) { _ in
                        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
                            self.appIcon.transform = CGAffineTransform(scaleX: 20, y: 20)
                            self.appIcon.alpha = 0
                        }) { _ in
                            if Prefs.authToken.count > 0 {
                                User.loadFromPrefs()
                                self.performSegue(withIdentifier: "splashToDashboard", sender: nil) //directly to dashboard
                            } else {
                                self.performSegue(withIdentifier: "splashToLanding", sender: nil)
                            }
                        }
                    }
                }
            } else {
                print("No connection.")
                
                OperationQueue.main.addOperation {
                    Utils.displayAlert("No Internet Connection Found. Please relaunch the app once the device is connected to the internet. Press OK to exit the app", viewController: self) { _ in
                        exit(0)
                    }
                }
            }
            
            print("Is Path Expensive: ", path.isExpensive)
        }
        let queue = DispatchQueue(label: "Monitor")
        monitor.start(queue: queue)
    }
}
