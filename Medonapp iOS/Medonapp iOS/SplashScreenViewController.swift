//
//  SplashScreenViewController.swift
//  Medonapp iOS
//
//  Created by Harshal Kulkarni on 31/10/22.
//

import UIKit

class SplashScreenViewController: UIViewController {
    
    @IBOutlet private var appIcon: UIImageView!
    @IBOutlet private var nameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIView.animate(withDuration: 0.3, delay: 0.7, animations: {
            self.nameLabel.alpha = 0
        })
        
        UIView.animate(withDuration: 0.5, delay: 0.9, animations: {
            self.nameLabel.alpha = 0
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
