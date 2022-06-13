//
//  Scan.swift
//  Nutriboom
//
//  Created by Louis Collin on 07/06/2022.
//

import Foundation

class Scan {
    var productName: String
    var brandName: String
    var score: String
    var imageURL: String
    var calories: String
    var carbs: String
    var sugar: String
    var fibers: String
    var fat: String
    var saturatedFat: String
    var proteins: String
    var sodium: String
    
    init(productName: String, brandName: String, score: String, imageURL: String, calories: String, carbs: String, sugar: String, fibers: String, fat: String, saturatedFat: String, proteins: String, sodium: String){
        self.productName = productName
        self.brandName = brandName
        self.score = score
        self.imageURL = imageURL
        self.calories = calories
        self.carbs = carbs
        self.sugar = sugar
        self.fibers = fibers
        self.fat = fat
        self.saturatedFat = saturatedFat
        self.proteins = proteins
        self.sodium = sodium
    }
}
