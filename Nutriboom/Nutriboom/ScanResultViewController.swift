//
//  ScanResultViewController.swift
//  Nutriboom
//
//  Created by Jules on 11/06/2022.
//

import UIKit

class ScanResultViewController: UIViewController {
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var brandNameLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    var productName: String = ""
    var brandName: String = ""
    var quantity: String = ""
    var score: String = ""
    var imageURL: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.productNameLabel.text = productName
        self.brandNameLabel.text = brandName
        self.quantityLabel.text = quantity
//        self.scoreLabel.text = score
            
        var urlString = imageURL

        if (urlString == "") {
            urlString = "https://fr.wiktionary.org/wiki/sheep"
        }

        let url = URL(string: urlString)

        let data = try? Data(contentsOf: url!) // make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
        self.imageView.image = UIImage(data: data!)
    }
}
