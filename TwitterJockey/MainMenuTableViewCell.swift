//
//  MainMenuTableViewCell.swift
//  TwitterJockey
//
//  Created by Craig Vargas on 11/4/16.
//  Copyright © 2016 Cvar. All rights reserved.
//

import UIKit

class MainMenuTableViewCell: UITableViewCell {
    
    @IBOutlet weak var menuItemNameLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func fillCell(itemName: String?){
        self.menuItemNameLabel.text = itemName
    }

}
