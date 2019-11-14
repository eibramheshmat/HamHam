//
//  LoadingView.swift
//  Magix event
//
//  Created by Mina Mounir on 7/29/19.
//  Copyright © 2019 Mariam. All rights reserved.
//
// helper to make loading indicator
import UIKit

class Loading {
    static let shared = Loading()
    var loadingView : UIView = {
        let v = UIView()
        v.backgroundColor = UIColor(white: 0, alpha: 0.5)
        return v
    }()
    var activityIndicator : UIActivityIndicatorView = {
        let a = UIActivityIndicatorView()
        a.style = .white
        a.startAnimating()
        return a
    }()
    func show(){
        if let window = UIApplication.shared.keyWindow {
            window.addSubview(loadingView)
            loadingView.translatesAutoresizingMaskIntoConstraints = false
            loadingView.topAnchor.constraint(equalTo: window.topAnchor).isActive = true
            loadingView.leadingAnchor.constraint(equalTo: window.leadingAnchor).isActive = true
            loadingView.trailingAnchor.constraint(equalTo: window.trailingAnchor).isActive = true
            loadingView.bottomAnchor.constraint(equalTo: window.bottomAnchor).isActive = true
            activityIndicator.translatesAutoresizingMaskIntoConstraints = false
            loadingView.addSubview(activityIndicator)
            activityIndicator.centerXAnchor.constraint(equalTo: window.centerXAnchor).isActive = true
            activityIndicator.centerYAnchor.constraint(equalTo: window.centerYAnchor).isActive = true
            loadingView.alpha = 0
            UIView.animate(withDuration: 0.3) {
                self.loadingView.alpha = 1
            }
        }
    }
    func hide(){
        loadingView.removeFromSuperview()
    }
}

