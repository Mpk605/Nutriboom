//
//  ViewController.swift
//  Nutriboom
//
//  Created by Yannis Amzal on 24/05/2022.
//

import UIKit
import Foundation

class ViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var barcode: UITextField!
    @IBOutlet weak var productNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        barcode.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //Check if there is any other text-field in the view whose tag is +1 greater than the current text-field on which the return key was pressed. If yes → then move the cursor to that next text-field. If No → Dismiss the keyboard
        if let nextField = self.view.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return false
    }
    
    @IBAction func fetchProduct(_ sender: Any) {
        let url = URL(string: "https://world.openfoodfacts.org/api/v0/product/" + (barcode.text ?? "0737628064502") + ".json")!
        
        let task = URLSession.shared.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            let json = try? JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any]
            
            DispatchQueue.main.async {
                self.productNameLabel.text = (json!["product"] as? [String: Any])!["generic_name"] as! String
            }
        }
        task.resume()
    }
}

