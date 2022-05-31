//
//  ViewController.swift
//  Nutriboom
//
//  Created by Yannis Amzal on 24/05/2022.
//

import UIKit


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
       let s1 = Scan(id: 1, nom: "Banane", score: "A")
       let s2 = Scan(id: 2, nom: "Pomme", score: "B")
    }
    @IBOutlet weak var tableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {

       super.viewWillAppear(animated)

       tableView.reloadData()

    }
    
    


}

