//
//  ScanViewController.swift
//  Nutriboom
//
//  Created by Louis Collin on 31/05/2022.
//

import Foundation
import UIKit


extension ViewController : UITableViewDataSource {
    
    
    static var scanCellIdentifier = "ScanCell"
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = tableView.dequeueReusableCell(withIdentifier: ViewController.scanCellIdentifier, for: indexPath)
       let scan = ScanService.shared.scans[indexPath.row]
       cell.textLabel?.text = scan.nom
       cell.detailTextLabel?.text = scan.score
       return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 0
    }
}
