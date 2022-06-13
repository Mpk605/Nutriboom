//
//  ViewController.swift
//  Nutriboom
//
//  Created by Yannis Amzal on 24/05/2022.
//

import UIKit
import Foundation
import AVFoundation
import CoreData

class ViewController: UIViewController, UITextFieldDelegate, AVCaptureMetadataOutputObjectsDelegate {
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DisplayScanResult" {
            let destinationVC = segue.destination as! ScanResultViewController

            destinationVC.productName = productName
            destinationVC.brandName = brandName
            destinationVC.score = score
            destinationVC.imageURL = imageURL
            destinationVC.calories = calories
            destinationVC.carbs = carbs
            destinationVC.sugar = sugar
            destinationVC.fibers = fibers
            destinationVC.fat = fat
            destinationVC.saturatedFat = saturatedFat
            destinationVC.proteins = proteins
            destinationVC.sodium = sodium
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func launchScan() {
        captureSession = AVCaptureSession()

        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput

        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }

        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }

        let metadataOutput = AVCaptureMetadataOutput()

        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)

            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.ean8, .ean13, .pdf417]
        } else {
            failed()
            return
        }

        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)

        captureSession.startRunning()
    }
    
    func failed() {
        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        captureSession = nil
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if (captureSession?.isRunning == false) {
            captureSession.startRunning()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if (captureSession?.isRunning == true) {
            captureSession.stopRunning()
        }
    }
    
    func extractFieldFromJSON(json: [String: Any], fields: [String]) -> String {
        var newFields = fields
        let newJSON = (json[newFields.first!] as? [String: Any])!
        newFields.removeFirst()
        
        if (newFields.count > 1) {
            return extractFieldFromJSON(json: newJSON, fields: newFields)
        } else {
            if let value = newJSON[newFields.first!] as? String {
                return value as String
            } else if let value = newJSON[newFields.first!] as? Int {
                return String(value as Int)
            } else if let value = newJSON[newFields.first!] as? Double {
                return String(value as Double)
            } else {
                return "nil"
            }
        }
    }
    
    func computeNutriscore(json: [String: Any]) -> String {
        var nutriscore = "Désolé, nous ne connaissons pas le nutriscore de ce produit"
        
        //Ici on devrait calculer le nutriscore
        
        /* Pour afficher une erreur au lieu de le calculer
         nutriscore = (json!["product"] as? [String: AnyObject])!["nutrition_score_debug"] as! String + ""
         if(nutriscore == "no score when the product does not have a category"){
         nutriscore = "Désolé, la catégorie de ce produit n'est pas connue. Impossible de calculer le nutriscore"
         }
         */
        
        
        //On attribue des points en fonction des valeurs nutritionnelles du produit scanné
        let kcal = self.extractFieldFromJSON(json: json, fields: ["product", "nutriments", "energy-kcal_100g"])
        let pt_energie = pt_energie(number: Int(kcal) ?? -1)
        
        let sucres = self.extractFieldFromJSON(json: json, fields: ["product", "nutriments", "sugars_100g"])
        let pt_sucres = pt_sucres(number: Double(sucres) ?? 0)
        
        let graisses = self.extractFieldFromJSON(json: json, fields: ["product", "nutriments", "saturated-fat_100g"])
        let pt_graisses_sat = pt_graisses_sat(number: Double(graisses) ?? 0)
        
        let sels = self.extractFieldFromJSON(json: json, fields: ["product", "nutriments", "salt_100g"])
        let pt_sodium = pt_sodium(number: Double(sels) ?? 0)
        
        
        let fruits_legumes = self.extractFieldFromJSON(json: json, fields: ["product", "nutriments", "fruits-vegetables-nuts-estimate-from-ingredients_100g"])
        let pt_fruits_legumes = pt_fruits_legumes(number: Double(fruits_legumes) ?? 0)
        
        let fibres = self.extractFieldFromJSON(json: json, fields: ["product", "nutriments", "fiber_100g"])
        let pt_fibres = pt_fibres(number: Double(fibres) ?? 0)
        
        let proteines = self.extractFieldFromJSON(json: json, fields: ["product", "nutriments", "proteins_100g"])
        let pt_proteines = pt_proteines(number: Double(proteines) ?? 0)
        
        
        let PointsN = pt_sodium + pt_graisses_sat + pt_sucres + pt_energie
        let PointsP = pt_fruits_legumes + pt_fibres + pt_proteines
        
        //Calcul du score et de la lettre correspondante
        let score = Nutriboom.score(PointsP: PointsP, PointsN: PointsN, pt_fruits_legumes: pt_fruits_legumes, pt_fibres: pt_fibres)
        nutriscore = lettre(score_final: score)
        
        //Si on les calories ne sont pas renseignées dans openfoodfacts
        if(pt_energie == -1){
            nutriscore = "Données nutritionelles inconnues"
        }
        
        return nutriscore
    }
    
    func found(code: String) {
        captureSession.stopRunning()
        self.view.layer.sublayers = self.view.layer.sublayers?.filter { theLayer in
            !theLayer.isKind(of: AVCaptureVideoPreviewLayer.classForCoder())
        }
        
        let url = URL(string: "https://world.openfoodfacts.org/api/v0/product/" + code + ".json")!
                
        let task = URLSession.shared.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) -> Void in

            if (data != nil) {
                let json = try? JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any]
                                
                self.productName = self.extractFieldFromJSON(json: json!, fields: ["product", "product_name"])
                self.brandName = self.extractFieldFromJSON(json: json!, fields: ["product", "brands"])
                self.score = self.extractFieldFromJSON(json: json!, fields: ["product", "nutriscore_grade"])
                
                if self.score == "nil" {
                    self.score = self.computeNutriscore(json: json!)
                }
                    
                self.imageURL = self.extractFieldFromJSON(json: json!, fields: ["product", "image_url"])
                
                // Nutritional facts
                self.calories = self.extractFieldFromJSON(json: json!, fields: ["product", "nutriments", "energy-kcal_100g"])
                self.carbs = self.extractFieldFromJSON(json: json!, fields: ["product", "nutriments", "carbohydrates_100g"])
                self.sugar = self.extractFieldFromJSON(json: json!, fields: ["product", "nutriments", "sugars_100g"])
                self.fibers = self.extractFieldFromJSON(json: json!, fields: ["product", "nutriments", "fiber_100g"])
                self.fat = self.extractFieldFromJSON(json: json!, fields: ["product", "nutriments", "fat_100g"])
                self.saturatedFat = self.extractFieldFromJSON(json: json!, fields: ["product", "nutriments", "saturated-fat_100g"])
                self.proteins = self.extractFieldFromJSON(json: json!, fields: ["product", "nutriments", "proteins_100g"])
                self.sodium = self.extractFieldFromJSON(json: json!, fields: ["product", "nutriments", "sodium_100g"])
                
                DispatchQueue.main.async {
                    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                        return
                    }
                    
                    let managedContext = appDelegate.persistentContainer.viewContext
                    
                    let product: Product = Product.init(entity: NSEntityDescription.entity(forEntityName: "Product", in: managedContext)!, insertInto: managedContext)
                    
                    product.productName = self.productName
                    product.brandName = self.brandName
                    product.nutriscore = self.score
                    product.imageURL = self.imageURL
                    product.calories = self.calories
                    product.carbs = self.carbs
                    product.sugars = self.sugar
                    product.fibers = self.fibers
                    product.fat = self.fat
                    product.saturatedFat = self.saturatedFat
                    product.proteins = self.proteins
                    product.sodium = self.sodium
                    
                    do {
                        try managedContext.save()
                    } catch let error as NSError {
                        print("Erreur d'enregistrement : \(error), \(error.userInfo)")
                    }
                    
                    self.performSegue(withIdentifier: "DisplayScanResult", sender: self)
                }
            }
        }
        task.resume()
    }

    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        // captureSession.stopRunning()

        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            found(code: stringValue)
        }

        dismiss(animated: true)
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextField = self.view.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return false
    }
    
    @IBAction func fetchProduct(_ sender: Any) {
        launchScan()
    }
}
