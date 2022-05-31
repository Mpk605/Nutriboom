//
//  Scan.swift
//  Nutriboom
//
//  Created by Louis Collin on 24/05/2022.
//

import Foundation

struct Scan {
     var id : Int
     var nom : String
     var score : String
    
    init(id: Int, nom: String, score: String){
        self.id = id
        self.nom = nom
        self.score = score
    }
    
}
