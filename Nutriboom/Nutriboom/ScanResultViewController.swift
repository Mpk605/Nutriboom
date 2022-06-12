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
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var caloriesLabel: UILabel!
    @IBOutlet weak var carbsLabel: UILabel!
    @IBOutlet weak var sugarsLabel: UILabel!
    @IBOutlet weak var fibersLabel: UILabel!
    @IBOutlet weak var fatLabel: UILabel!
    @IBOutlet weak var saturatedFatLabel: UILabel!
    @IBOutlet weak var proteinsLabel: UILabel!
    @IBOutlet weak var sodiumLabel: UILabel!
    
    // Progress bars
    @IBOutlet weak var caloriesProgress: UIProgressView!
    @IBOutlet weak var carbsProgress: UIProgressView!
    @IBOutlet weak var sugarProgress: UIProgressView!
    @IBOutlet weak var fiberProgress: UIProgressView!
    @IBOutlet weak var fatProgress: UIProgressView!
    @IBOutlet weak var saturatedFatProgress: UIProgressView!
    @IBOutlet weak var proteinsProgress: UIProgressView!
    @IBOutlet weak var sodiumProgress: UIProgressView!
    
    var productName: String = ""
    var brandName: String = ""
    var score: String = ""
    var imageURL: String = ""
    var calories: String = ""
    var carbs: String = ""
    var sugar: String = ""
    var fibers: String = ""
    var fat: String = ""
    var saturatedFat: String = ""
    var proteins: String = ""
    var sodium: String = ""
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.preferredContentSize = self.view.systemLayoutSizeFitting(
            UIView.layoutFittingCompressedSize
        )
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // Labels
        productNameLabel.text = productName
        brandNameLabel.text = brandName
        caloriesLabel.text = calories + "kcal"
        carbsLabel.text = carbs + "g"
        sugarsLabel.text = sugar + "g"
        fibersLabel.text = fibers + "g"
        fatLabel.text = fat + "g"
        saturatedFatLabel.text = saturatedFat + "g"
        proteinsLabel.text = proteins + "g"
        sodiumLabel.text = sodium + "g"
            
        // Progress bars
        caloriesProgress.progress = 1
        carbsProgress.progress = Float(carbs)! / 100
        sugarProgress.progress = Float(sugar)! / 100
        fiberProgress.progress = Float(fibers)! / 100
        fatProgress.progress = Float(fat)! / 100
        saturatedFatProgress.progress = Float(saturatedFat)! / 100
        proteinsProgress.progress = Float(proteins)! / 100
        sodiumProgress.progress = Float(sodium)! / 100
        
        
        var urlString = imageURL

        if (urlString == "") {
            urlString = "https://fr.wiktionary.org/wiki/sheep"
        }

        let url = URL(string: urlString)

        let data = try? Data(contentsOf: url!) // make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
        imageView.image = UIImage(data: data!)
        imageView.layer.cornerRadius = 16
    }
}
