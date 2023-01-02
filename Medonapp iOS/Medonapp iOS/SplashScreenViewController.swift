//
//  SplashScreenViewController.swift
//  Medonapp iOS
//
//  Created by Harshal Kulkarni on 31/10/22.
//

import UIKit
import Network
import NotificationBannerSwift

class SplashScreenViewController: UIViewController {
    
    var notifBanner: GrowingNotificationBanner?
    
    @IBOutlet private var appIcon: UIImageView!
    @IBOutlet private var nameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        OperationQueue.main.addOperation {
            UIView.animate(withDuration: 0.2, delay: 0.7, animations: {
                self.nameLabel.alpha = 0
                self.appIcon.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
            }) { _ in
                UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
                    self.appIcon.transform = CGAffineTransform(scaleX: 20, y: 20)
                    self.appIcon.alpha = 0
                }) { _ in
                    if Prefs.userDetails.token?.count ?? 0 > 0 {
                        User.loadFromPrefs()
                        self.performSegue(withIdentifier: "splashToDashboard", sender: nil) //directly to dashboard
                    } else {
                        self.performSegue(withIdentifier: "splashToLanding", sender: nil)
                    }
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        Utils.checkForReachability()
        
        if !Prefs.isNetworkAvailable {
            DispatchQueue.main.async {
                self.notifBanner = Utils.displayNoNetworkBanner(self)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        notifBanner?.dismiss()
    }
}
