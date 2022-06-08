//
//  Scan.swift
//  Nutriboom
//
//  Created by Louis Collin on 07/06/2022.
//

import Foundation

class Scan {
     var nom : String
     var score : String
    
    init(nom: String, score: String){
        self.nom = nom
        self.score = score
    }
    
    var scans: [Scan] = []
    
    func ajout(scan: Scan){
        scans.append(scan)
    }
    
}
