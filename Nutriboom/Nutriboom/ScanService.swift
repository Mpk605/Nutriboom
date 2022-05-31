//
//  ScanService.swift
//  Nutriboom
//
//  Created by Louis Collin on 31/05/2022.
//

import Foundation
import CloudKit


class ScanService {
    
    static let shared = ScanService()
    
    private init() {}
    
    private(set) var scans: [Scan] = []
    
    func ajout(scan: Scan) {
        scans.append(scan)
    }
    
}
