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
    
    var originalFont: UIFont!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.originalFont = self.menuItemNameLabel.font
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func fillCell(itemName: String?){
        self.menuItemNameLabel.text = itemName
    }
    
    func animateMenuItem(doneAnimating: @escaping ()->Void){
        print("Animating Menu Item")
        
        UIView.animate(
            withDuration: 0.4,
            delay: 0.0,
            options: [],
            animations: {
                self.menuItemNameLabel.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)},
            completion: nil)
        
        UIView.animate(
            withDuration: 0.4,
            delay: 0.4, options: [],
            animations: {
                self.menuItemNameLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)},
            completion: {(isCompleted: Bool)->Void in
                doneAnimating()})
    }

}
