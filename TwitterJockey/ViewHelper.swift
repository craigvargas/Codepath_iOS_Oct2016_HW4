//
//  ViewHelper.swift
//  TwitterJockey
//
//  Created by Craig Vargas on 11/6/16.
//  Copyright © 2016 Cvar. All rights reserved.
//

import UIKit

class ViewHelper: NSObject {
    
    class func setImageIfPossibleFor(imageView: UIImageView, withUrl url: URL?){
        if(url != nil){
            imageView.setImageWith(url!)
        }
    }
    
    class func setTextIfPossibleFor(label: UILabel, withInteger integer: Int?){
        if(integer != nil){
            label.text = "\(integer!)"
        }
    }
    
    class func setImageIfPossibleFor(imageView: UIImageView, withUrl url: URL?, orColor color: UIColor){
        if(url != nil){
            imageView.setImageWith(url!)
        }else{
            imageView.backgroundColor = color
        }
    }
    
    class Colors{
        static let dogerBlue = ViewHelper.getColor(colorHex: 0x1DA1F2, withAlphaHex: nil)
    }
    
    class func getColor(colorHex: Int, withAlphaHex alphaHex: Int?) -> UIColor{
        var alpha: CGFloat!
        let red = CGFloat((colorHex & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((colorHex & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat((colorHex & 0x0000FF)) / 255.0
        if alphaHex != nil{
            alpha = CGFloat((alphaHex! & 0x0000FF))
        }else{
            alpha = 1.0
        }
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
}
