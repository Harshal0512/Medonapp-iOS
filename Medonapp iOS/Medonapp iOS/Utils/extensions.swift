//
//  extensions.swift
//  Medonapp iOS
//
//  Created by Harshal Kulkarni on 02/10/22.
//

import Foundation
import UIKit

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
}
