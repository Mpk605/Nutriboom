//
//  ViewController.swift
//  Nutriboom
//
//  Created by Yannis Amzal on 24/05/2022.
//

import UIKit
import Foundation
import AVFoundation

class ViewController: UIViewController, UITextFieldDelegate, AVCaptureMetadataOutputObjectsDelegate {
    
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
            }
            else {
                return "nil"
            }
            
        }
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
    
    func found(code: String) {
        captureSession.stopRunning()
        self.view.layer.sublayers = self.view.layer.sublayers?.filter { theLayer in
            !theLayer.isKind(of: AVCaptureVideoPreviewLayer.classForCoder())
        }
        
        let url = URL(string: "https://world.openfoodfacts.org/api/v0/product/" + code + ".json")!
        
        let task = URLSession.shared.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            print(error as Any)
            
            let json = try? JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any]
            
            
            //            //Si la clé "error" existe dans le json, on print l'erreur
            //            if let error = json!["error"] {
            //                print("Result error: \(error)")
            //            }
            
            
            var nutriscore = "Désolé, nous ne connaissons pas le nutriscore de ce produit"
            
            DispatchQueue.main.async {
                
                
                //Si le nom francais du produit n'existe pas, on prend le nom international
                if (json!["product_name_fr"] != nil) {
                    self.productNameLabel.text = (json!["product"] as? [String: Any])!["product_name_fr"] as! String + ""
                }
                else{
                    self.productNameLabel.text = (json!["product"] as? [String: Any])!["product_name"] as! String + ""
                }
                
                
                
                //Si le nutriscore existe déjà pas besoin de le calculer
                if((json!["product"] as? [String: Any])!["nutriscore_grade"] as? String != nil){
                    nutriscore = (json!["product"] as? [String: Any])!["nutriscore_grade"] as! String + ""
                    print("SCORE CONNU : "+nutriscore)
                }
                else{
                    //Ici on devrait calculer le nutriscore
                    
                    /* Pour afficher une erreur au lieu de le calculer
                     nutriscore = (json!["product"] as? [String: AnyObject])!["nutrition_score_debug"] as! String + ""
                     if(nutriscore == "no score when the product does not have a category"){
                     nutriscore = "Désolé, la catégorie de ce produit n'est pas connue. Impossible de calculer le nutriscore"
                     }
                     */
                    
                    
                    //On attribue des points en fonction des valeurs nutritionnelles du produit scanné
                    let kcal = self.extractFieldFromJSON(json: json!, fields: ["product", "nutriments", "energy-kcal_100g"])
                    let pt_energie = pt_energie(number: Int(kcal) ?? -1)
                    
                    let sucres = self.extractFieldFromJSON(json: json!, fields: ["product", "nutriments", "sugars_100g"])
                    let pt_sucres = pt_sucres(number: Double(sucres) ?? 0)
                    
                    let graisses = self.extractFieldFromJSON(json: json!, fields: ["product", "nutriments", "saturated-fat_100g"])
                    let pt_graisses_sat = pt_graisses_sat(number: Double(graisses) ?? 0)
                    
                    let sels = self.extractFieldFromJSON(json: json!, fields: ["product", "nutriments", "salt_100g"])
                    let pt_sodium = pt_sodium(number: Double(sels) ?? 0)
                    
                    
                    let fruits_legumes = self.extractFieldFromJSON(json: json!, fields: ["product", "nutriments", "fruits-vegetables-nuts-estimate-from-ingredients_100g"])
                    let pt_fruits_legumes = pt_fruits_legumes(number: Double(fruits_legumes) ?? 0)
                    
                    let fibres = self.extractFieldFromJSON(json: json!, fields: ["product", "nutriments", "fiber_100g"])
                    let pt_fibres = pt_fibres(number: Double(fibres) ?? 0)
                    
                    let proteines = self.extractFieldFromJSON(json: json!, fields: ["product", "nutriments", "proteins_100g"])
                    let pt_proteines = pt_proteines(number: Double(proteines) ?? 0)
                    
                    
                    let PointsN = pt_sodium + pt_graisses_sat + pt_sucres + pt_energie
                    let PointsP = pt_fruits_legumes + pt_fibres + pt_proteines
                    
                    //Calcul du score et de la lettre correspondante
                    let score = score(PointsP: PointsP, PointsN: PointsN, pt_fruits_legumes: pt_fruits_legumes, pt_fibres: pt_fibres)
                    nutriscore = lettre(score_final: score)
                    
                    //Si on les calories ne sont pas renseignées dans openfoodfacts
                    if(pt_energie == -1){
                        nutriscore = "Données nutritionelles inconnues"
                    }
                    
                    
                }
                
                
                
                //On affiche l'image qui correspond au nutriscore
                if(nutriscore == "a"){
                    let newImg: UIImage? = UIImage(named: "Nutri-score-A.svg")
                    self.imageView.image = newImg
                    self.view.backgroundColor = UIColor(red: 227/255.0, green: 241/255.0, blue: 234/255.0, alpha: 1)
                    self.scoreLabel.text=""
                    
                    
                }
                else if(nutriscore == "b"){
                    let newImg: UIImage? = UIImage(named: "Nutri-score-B.svg")
                    self.imageView.image = newImg
                    self.view.backgroundColor = UIColor(red: 205/255.0, green: 230/255.0, blue: 217/255.0, alpha: 1)
                    self.scoreLabel.text=""
                    
                    
                }
                else if(nutriscore == "c"){
                    let newImg: UIImage? = UIImage(named: "Nutri-score-C.svg")
                    self.imageView.image = newImg
                    self.view.backgroundColor = UIColor(red: 255/255.0, green: 249/255.0, blue: 227/255.0, alpha: 1.0)
                    self.scoreLabel.text=""
                    
                }
                else if(nutriscore == "d"){
                    let newImg: UIImage? = UIImage(named: "Nutri-score-D.svg")
                    self.imageView.image = newImg
                    self.view.backgroundColor = UIColor(red: 253/255.0, green: 241/255.0, blue: 227/255.0, alpha: 1.0)
                    self.scoreLabel.text=""
                    
                }
                else if(nutriscore == "e"){
                    let newImg: UIImage? = UIImage(named: "Nutri-score-E.svg")
                    self.imageView.image = newImg
                    self.view.backgroundColor = UIColor(red: 252/255.0, green: 234/255.0, blue: 229/255.0, alpha: 1.0)
                    self.scoreLabel.text=""
                    
                }
                else{
                    //scoreLabel sert en réalité a afficher des messages d'erreur lorsque l'on ne trouve pas le nutriscore
                    self.scoreLabel.text = nutriscore
                    self.imageView.image = nil
                    self.view.backgroundColor = (UIColor.white )
                }
                
                
                
            }
        }
        task.resume()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
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
    
    @IBOutlet weak var btnScan: UIButton!
    @IBAction func fetchProduct(_ sender: Any) {
        launchScan()
        (sender as AnyObject).setTitle("Scanner un autre produit", for: [])
    }
}
