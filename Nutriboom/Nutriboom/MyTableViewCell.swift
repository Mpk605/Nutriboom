//
//  MyTableViewCell.swift
//  Nutriboom
//
//  Created by Marine Kazemi on 31/05/2022.
//

import UIKit

class MyTableViewCell: UITableViewCell {

    static let identifier = "MyTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "MyTableViewCell", bundle: nil)
    }
    
    @IBOutlet var button: UIButton!
    
    @IBAction func didTapButton() {
        
    }
    
    func configure(with title: String) {
        button.setTitle(title, for: .normal)
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        button.setTitleColor(.link, for: .normal)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
