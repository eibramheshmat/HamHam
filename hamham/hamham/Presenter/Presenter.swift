//
//  Presenter.swift
//  HamHamtest
//
//  Created by Ibram on 11/11/19.
//  Copyright © 2019 Ibram. All rights reserved.
//

import UIKit
class Presenter {
    var DelegateObject : PresenterDelegate!
    func getRecipeSearchData(RecipeSearchWord:String,From:Int,To:Int){
        let RecipeSearchWordWithOutSpaces = RecipeSearchWord.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        Loading.shared.show()
        Network.shared.makeHttpRequest(model: RecipeModel(), method: .get, APIName: "", parameters: ["q":"\(RecipeSearchWordWithOutSpaces)","app_id":"\(Constants.app_id)","app_key":"\(Constants.app_key)","from":"\(From)","to":"\(To)"]) { (result) in
            DispatchQueue.main.async {
                Loading.shared.hide()
            }
            switch result {
            case .success(let response):
                self.DelegateObject.SuccessLoadData(Recipe: response)
            case .failure(let error):
                self.DelegateObject.FailedLoadData(Error : error)
            }
        }
    }
}
