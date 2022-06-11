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
    @IBOutlet weak var loadingLabel: UILabel!
    @IBOutlet weak var loadingAnimation: UIActivityIndicatorView!
    
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    var productName: String = ""
    var brandName: String = ""
    var quantity: String = ""
    var score: String = ""
    var imageURL: String = ""
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DisplayScanResult" {
            let destinationVC = segue.destination as! ScanResultViewController
            
            destinationVC.productName = productName
            destinationVC.brandName = brandName
            destinationVC.quantity = quantity
            destinationVC.score = score
            destinationVC.imageURL = imageURL
        }
    }
    
    func toggleLoading() {
        loadingLabel.isHidden = !loadingLabel.isHidden
        loadingAnimation.isHidden = !loadingAnimation.isHidden
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        toggleLoading()
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
            } else {
                return ""
            }
        }
    }
    
    func found(code: String) {
        captureSession.stopRunning()
        self.view.layer.sublayers = self.view.layer.sublayers?.filter { theLayer in
            !theLayer.isKind(of: AVCaptureVideoPreviewLayer.classForCoder())
        }
        
        toggleLoading()
        
        let url = URL(string: "https://world.openfoodfacts.org/api/v0/product/" + code + ".json")!
                
        let task = URLSession.shared.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) -> Void in

            if (data != nil) {
                let json = try? JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any]
                                
                self.productName = self.extractFieldFromJSON(json: json!, fields: ["product", "product_name_fr"])
                self.brandName = self.extractFieldFromJSON(json: json!, fields: ["product", "brands"])
                self.quantity = self.extractFieldFromJSON(json: json!, fields: ["product", "quantity"])
                self.score = self.extractFieldFromJSON(json: json!, fields: ["product", "nutriscore_grade"])
                self.imageURL = self.extractFieldFromJSON(json: json!, fields: ["product", "image_url"])
                
                DispatchQueue.main.async {
                    self.toggleLoading()
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
