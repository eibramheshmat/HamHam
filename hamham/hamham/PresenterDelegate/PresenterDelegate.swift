//
//  PresenterDelegate.swift
//  HamHamtest
//
//  Created by Ibram on 11/11/19.
//  Copyright © 2019 Ibram. All rights reserved.
//
//  Presnter Delegate to implement his method in ViewController

import UIKit
protocol PresenterDelegate {
    func SuccessLoadData(Recipe:RecipeModel)
    func FailedLoadData(Error:ServiceError)
}
