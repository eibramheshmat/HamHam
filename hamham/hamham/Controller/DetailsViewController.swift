//
//  DetailsViewController.swift
//  HamHamtest
//
//  Created by Ibram on 11/12/19.
//  Copyright © 2019 Ibram. All rights reserved.
//

import UIKit
import Kingfisher
import SafariServices

class DetailsViewController: UIViewController {
    
    // struct to save data on it from sender ViewController
    struct RecipeSelect {
        static var url : String?
        static var img : String?
        static var title : String?
        static var ingredients : [String]?
    }
    
    @IBOutlet weak var recipeImg: UIImageView!
    @IBOutlet weak var recipeTitle: UILabel!
    @IBOutlet weak var recipeURL: UILabel!
    @IBOutlet weak var recipeIngredients: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recipeImg.kf.setImage(with: URL(string: RecipeSelect.img ?? ""))
        recipeTitle.text = RecipeSelect.title
        recipeURL.text = RecipeSelect.url
        var ingredientsShow = ""
        if RecipeSelect.ingredients?.count ?? 0 > 0{
            let loopCounter = (RecipeSelect.ingredients?.count ?? 0) - 1
            if loopCounter > 0 {
                for n in 0 ... loopCounter {
                    if ingredientsShow == "" {
                        ingredientsShow = " " + (RecipeSelect.ingredients?[n] ?? "")
                    }else{
                        ingredientsShow = ingredientsShow + " \n " + (RecipeSelect.ingredients?[n] ?? "")
                    }
                }// loop to fill all ingredients in on string
            }// if there no ingredients
        }
        recipeIngredients.text = ingredientsShow
        // Do any additional setup after loading the view.
    }
    
    // Edit view design
    override func viewWillAppear(_ animated: Bool) {
        // hide navigationBar when enter view
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
    }
    override func viewWillDisappear(_ animated: Bool) {
        // show navigationBar when exit view
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.view.backgroundColor = .white
        
    }
    
    @available(iOS 11.0, *)
    @IBAction func openSafariAction(_ sender: UIButton) {
        openSafari()
    }
    @available(iOS 11.0, *)
    // func to use SFSafariViewController
    func openSafari() {
        if let url = URL(string:"\(RecipeSelect.url ?? "")") {
            let config = SFSafariViewController.Configuration()
            config.entersReaderIfAvailable = true
            let vc = SFSafariViewController(url: url, configuration: config)
            present(vc, animated: true)
        }
    }
    
}
