//
//  HistoryViewController.swift
//  Nutriboom
//
//  Created by Louis Collin on 07/06/2022.
//

import UIKit

class HistoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextViewDelegate {

    static var scanCellIdentifier = "test"
    
    var data: [Scan] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //data.append(Scan(nom: productNameLabel.text, score: scoreLabel.text))
        
        
        //data.append(Scan(nom: "Banane", score: "A"))
        //data.append(Scan(nom: "Pomme", score: "B"))
        
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HistoryViewController.scanCellIdentifier, for: indexPath)
        cell.textLabel?.text = data[indexPath.row].nom
        cell.detailTextLabel?.text = data[indexPath.row].score
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
}
