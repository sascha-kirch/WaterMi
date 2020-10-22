//
//  ControllerExtensions.swift
//  WaterMi
//
//  Created by Sascha on 22.10.20.
//

import UIKit
/**Extension to hide keyboard in any view Controller
 
 Add the following comand in viewDidLoad for each Controller that wants to adopt this behavior:
 self.hideKeyboardWhenTappedAround()
 */
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
