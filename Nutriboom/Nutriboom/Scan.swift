//
//  Scan.swift
//  Nutriboom
//
//  Created by Louis Collin on 24/05/2022.
//

import Foundation

class Scan {
    public var id : Int
    public var nom : String
    public var score : Character
    public var image : 
    
    init (id : Int, nom : String, score : Character, image : Image){
        self.id = id
        self.nom = nom
        self.score  = score
        self.image = image
    }
    
}


