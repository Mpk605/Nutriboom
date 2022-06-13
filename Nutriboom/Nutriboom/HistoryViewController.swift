//
//  HistoryViewController.swift
//  Nutriboom
//
//  Created by Louis Collin on 07/06/2022.
//

import UIKit
import CoreData

class HistoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    static var scanCellIdentifier = "test"
    
    var data: [NSManagedObject] = []

    var localIndexPath: IndexPath = IndexPath()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        do {
            data = try managedContext.fetch(NSFetchRequest<NSManagedObject>(entityName: "Product"))
            
        } catch let error as NSError {
            print("Erreur lors de la récupération des données \(error), \(error.userInfo)")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        do {
            data = try managedContext.fetch(NSFetchRequest<NSManagedObject>(entityName: "Product"))
            
            tableView.reloadData()
        } catch let error as NSError {
            print("Erreur lors de la récupération des données \(error), \(error.userInfo)")
        }
    }
    
    // Nombre de ligne de la tableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "ElementCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) ?? UITableViewCell(style: .subtitle, reuseIdentifier: cellIdentifier)
        
        cell.textLabel?.text = (data[indexPath.row] as! Product).productName
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "ShowProduct") {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
            }
            
            let managedContext = appDelegate.persistentContainer.viewContext
            
            do {
                let product = try managedContext.fetch(NSFetchRequest<NSManagedObject>(entityName: "Product"))[localIndexPath.row] as! Product
                
                let destinationVC = segue.destination as! ScanResultViewController
                
                destinationVC.popoverPresentationController?.sourceView = tableView.cellForRow(at: localIndexPath)
                
                destinationVC.productName = product.productName!
                destinationVC.brandName = product.brandName!
                destinationVC.score = product.nutriscore!
                destinationVC.imageURL = product.imageURL!
                destinationVC.calories = product.calories!
                destinationVC.carbs = product.carbs!
                destinationVC.sugar = product.sugars!
                destinationVC.fibers = product.fibers!
                destinationVC.fat = product.fat!
                destinationVC.saturatedFat = product.saturatedFat!
                destinationVC.proteins = product.proteins!
                destinationVC.sodium = product.sodium!
            } catch let error as NSError {
                print("Erreur lors de la récupération des données \(error), \(error.userInfo)")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        localIndexPath = indexPath
        
        performSegue(withIdentifier: "ShowProduct", sender: self)
    }
}
