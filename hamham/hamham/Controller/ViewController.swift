//
//  ViewController.swift
//  HamHamtest
//
//  Created by Ibram on 11/11/19.
//  Copyright © 2019 Ibram. All rights reserved.
//

import UIKit
import Kingfisher
class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UITextFieldDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, PresenterDelegate{

    func SuccessLoadData(Recipe: RecipeModel) {
        RecipeList = Recipe
        if RecipeList.hits?.count ?? 0 > 0{
            from = RecipeList.from ?? 0
            to = RecipeList.to ?? 10
            totalRecipeCounter = RecipeList.count ?? 0
            tableCounter = (RecipeList.hits?.count ?? 0)
            DispatchQueue.main.async {
                self.logoAfterLoading.isHidden = false
                self.logo.isHidden = true
                self.mainLbl.isHidden = true
            }
        }else{
            tableCounter = 0
            DispatchQueue.main.async {
                self.logoAfterLoading.isHidden = true
                self.logo.isHidden = false
                self.mainLbl.isHidden = false
                self.mainLbl.text = " No recipe matches your search word ! "
            }
        }
        DispatchQueue.main.async {
            self.TV.reloadData()
        }
    }
    func FailedLoadData(Error: ServiceError) {
           DispatchQueue.main.async {
               self.TV.isScrollEnabled = false
               self.TV.isHidden = true
               self.CV.isHidden = true
               self.logoAfterLoading.isHidden = true
               self.logo.isHidden = false
               self.mainLbl.isHidden = false
               self.mainLbl.text = " Many requests try again later ! "
           }
       }
    var searchHistory : [String] = []
    let defaults = UserDefaults.standard
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var logoAfterLoading: UIImageView!
    @IBOutlet weak var mainLbl: UILabel!
    @IBOutlet weak var TV: UITableView!
    @IBOutlet weak var CV: UICollectionView!
    @IBOutlet weak var CVHeight: NSLayoutConstraint!
    @IBOutlet weak var searchBar: UISearchBar!
    var RecipeList = RecipeModel()
    var from : Int = 0
    var to : Int = 10
    var tableCounter : Int = 0
    var totalRecipeCounter : Int = 0
    var fetchMargin : Bool = false
    var PresenterObject = Presenter()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        logoAfterLoading.isHidden = true
        CV.isHidden = true
        CV.layer.cornerRadius = 10
        searchBar.backgroundImage = UIImage()
        let verison = UIDevice.current.systemVersion
        if verison == "13.0" || verison == "13.1" || verison == "13.2"{
            searchBar.searchTextField.backgroundColor = .white
        }
        PresenterObject.DelegateObject = self
        self.hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view.
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        CV.isHidden = false
        logoAfterLoading.isHidden = true
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        CV.isHidden = true
        logoAfterLoading.isHidden = false
    }
    func searchBarSearchButtonClicked( _ searchBar: UISearchBar)
    {
        tableCounter = 0
        CV.isHidden = true
        logoAfterLoading.isHidden = false
        let historyUserDefaults = defaults.stringArray(forKey: "searchHistory") ?? [String]()
        searchHistory = historyUserDefaults
        searchHistory.append(searchBar.text ?? "")
        defaults.set(searchHistory, forKey: "searchHistory")
        CV.reloadData()
        dismissKeyboard()
        PresenterObject.getRecipeSearchData(RecipeSearchWord: "\(searchBar.text ?? "")",From: from,To: to)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableCounter > 0 {
            return tableCounter
        }else{
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        TV.register(UINib(nibName: "tableCell", bundle: nil), forCellReuseIdentifier: "tableCell")
        let cell = TV.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath) as! tableCell
        if tableCounter > 0{
            let img = RecipeList.hits?[indexPath.row].recipe?.image ?? ""
            let imageWithOutSpace = img.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            cell.recipeTitle.text = RecipeList.hits?[indexPath.row].recipe?.label ?? ""
            cell.recipeImage.kf.setImage(with: URL(string: imageWithOutSpace))
            cell.recipeSource.text = RecipeList.hits?[indexPath.row]
                .recipe?.source ?? ""
            var healthLbls : [String] = []
            var healthLblsShow = ""
            if RecipeList.hits?[indexPath.row].recipe?.healthLabels?.count ?? 0 > 0{
                let counterLoop = (RecipeList.hits?[indexPath.row].recipe?.healthLabels?.count ?? 0) - 1
                if counterLoop > 0 {
                    for n in 0 ... counterLoop{
                        healthLbls.append(RecipeList.hits?[indexPath.row].recipe?.healthLabels?[n] ?? "")
                    }
                }
            }
            if healthLbls.count > 0{
                for n in 0 ... (healthLbls.count - 1){
                    if healthLblsShow == "" {
                        healthLblsShow = healthLbls[n]
                    }else{
                        healthLblsShow = healthLblsShow + " , " + healthLbls[n]
                    }
                }
            }
            cell.recipeHealthLbl.text = healthLblsShow
        }
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == tableCounter {
            if tableCounter < totalRecipeCounter{
                //call more items
                to += 30
                print("END")
                PresenterObject.getRecipeSearchData(RecipeSearchWord: "\(searchBar.text ?? "")", From: from,To: to)
            }
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DetailsViewController.RecipeSelect.title = RecipeList.hits?[indexPath.row].recipe?.label ?? ""
        DetailsViewController.RecipeSelect.img = RecipeList.hits?[indexPath.row].recipe?.image ?? ""
        DetailsViewController.RecipeSelect.url = RecipeList.hits?[indexPath.row].recipe?.url ?? ""
        DetailsViewController.RecipeSelect.ingredients = RecipeList.hits?[indexPath.row].recipe?.ingredientLines ?? []
        performSegue(withIdentifier: "recipeDetails", sender: nil)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let historyUserDefaults = defaults.stringArray(forKey: "searchHistory") ?? [String]()
        if historyUserDefaults.count > 0{
            CVHeight.constant = 110
            return historyUserDefaults.count
        }else{
            CVHeight.constant = 50
            return 1
        }
      }
      
      func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var historyUserDefaults = defaults.stringArray(forKey: "searchHistory") ?? [String]()
        historyUserDefaults = historyUserDefaults.reversed()
        let cell = CV.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as! collectionCell
        if historyUserDefaults.count > 0{
            cell.searchLbl.text = historyUserDefaults[indexPath.row]
        }else{
            cell.searchLbl.text = "Search history"
        }
        return cell
      }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: CV.frame.width / 2.1 , height: CV.frame.height / 3)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        tableCounter = 0
        var historyUserDefaults = defaults.stringArray(forKey: "searchHistory") ?? [String]()
        historyUserDefaults = historyUserDefaults.reversed()
        searchBar.text = historyUserDefaults[indexPath.row]
        PresenterObject.getRecipeSearchData(RecipeSearchWord: historyUserDefaults[indexPath.row],From: from,To: to)
    }
}
