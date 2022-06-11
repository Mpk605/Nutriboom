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
    var quantity: String
    var score: String
    var image: String
    
    init(productName: String, brandName: String, quantity: String, score: String, image: String){
        self.productName = productName
        self.brandName = brandName
        self.quantity = quantity
        self.score = score
        self.image = image
    }
}
