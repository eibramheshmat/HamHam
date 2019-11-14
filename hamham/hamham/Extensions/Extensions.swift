//
//  Extensions.swift
//  testStructure
//
//  Created by Ibram on 11/14/19.
//  Copyright © 2019 Ibram. All rights reserved.
//

import UIKit

// MARK: -UIViewController extensions
extension UIViewController {
    // to hide keyboard when click anywhere view
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

// MARK: -Dictionary extensions
extension Dictionary {
    // to return parameter in queryParameters shape
    var queryString: String {
        var output: String = ""
        for (key,value) in self {
            if output == "" {
                output +=  "\(key)=\(value)"
            }else{
                output +=  "&\(key)=\(value)"
            }
        }
        return output
    }
}
