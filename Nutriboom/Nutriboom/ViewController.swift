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
    @IBOutlet weak var barcode: UITextField!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var brandNameLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        barcode.delegate = self
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
            print(error)
            
            let json = try? JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any]
            
            DispatchQueue.main.async {
                self.productNameLabel.text = (json!["product"] as? [String: Any])!["product_name_fr"] as! String + ""
                self.brandNameLabel.text = (json!["product"] as? [String: Any])!["brands"] as! String + ""
                self.quantityLabel.text = (json!["product"] as? [String: Any])!["quantity"] as! String + ""
                
                
                self.scoreLabel.text = (json!["product"] as? [String: Any])!["nutriscore_grade"] as! String + ""
                
                if(self.scoreLabel.text == "a"){
                    let newImg: UIImage? = UIImage(named: "Nutri-score-A.svg")
                            self.imageView.image = newImg

                }
                else if(self.scoreLabel.text == "b"){
                    let newImg: UIImage? = UIImage(named: "Nutri-score-B.svg")
                            self.imageView.image = newImg

                }
                else if(self.scoreLabel.text == "c"){
                    let newImg: UIImage? = UIImage(named: "Nutri-score-C.svg")
                            self.imageView.image = newImg

                }
                else if(self.scoreLabel.text == "d"){
                    let newImg: UIImage? = UIImage(named: "Nutri-score-D.svg")
                            self.imageView.image = newImg

                }
                else if(self.scoreLabel.text == "e"){
                    let newImg: UIImage? = UIImage(named: "Nutri-score-E.svg")
                            self.imageView.image = newImg

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
    
    @IBAction func fetchProduct(_ sender: Any) {
        launchScan()
    }
}

