//
//  ViewController.swift
//  Nutriboom
//
//  Created by Yannis Amzal on 24/05/2022.
//

import UIKit
import Foundation

class ViewController: UIViewController {
    struct NutriScore: Decodable {
        let code: String
        let product: String
        let status: String
        let status_verbose: String
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = URL(string: "https://world.openfoodfacts.org/api/v0/product/737628064502.json")!
        
        let task = URLSession.shared.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            let json = try? JSONSerialization.jsonObject(with: data!, options: [])
            
            print(json["code"])
        }
        task.resume()
    }
}

