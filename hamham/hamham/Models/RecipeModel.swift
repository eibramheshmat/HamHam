//
//  RecipeModel.swift
//  HamHamtest
//
//  Created by Ibram on 11/11/19.
//  Copyright © 2019 Ibram. All rights reserved.
//

import UIKit
struct RecipeModel : Codable {
    var from : Int?
    var to : Int?
    var more : Bool?
    var count : Int?
    var hits : [RecipesArray]? = [RecipesArray]()
}
struct RecipesArray : Codable {
    var recipe : RecipesDataInto? = RecipesDataInto()
}
struct RecipesDataInto : Codable {
    var uri : String?
    var label : String?
    var image : String?
    var source : String?
    var url : String?
    var shareAs : String?
    var yield : Int?
    var healthLabels : [String]?
    var ingredientLines : [String]?
}
