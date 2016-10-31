//
//  User.swift
//  TwitterJockey
//
//  Created by Craig Vargas on 10/28/16.
//  Copyright © 2016 Cvar. All rights reserved.
//

import UIKit

class User: NSObject {
    
    static let currentUserKey = "currentUser"
    
    var name: String?
    var screenName: String?
    var profileUrl: URL?
    var tagline: String?
    var dictionary: Dictionary<String,Any>
    
    init(dict: Dictionary<String,Any>) {
        self.name = dict["name"] as? String
        self.screenName = dict["screen_name"] as? String
        
        if let profileUrlString = dict["profile_image_url_https"] as? String{
            self.profileUrl = URL(string: profileUrlString)
        }
        
        self.tagline = dict["tagline"] as? String
        self.dictionary = dict
    }
    
    static var _currentUser: User?
    
    class var currentUser: User?{
        get{
            if(_currentUser == nil){
                let defaults = UserDefaults.standard
                if let userData = defaults.object(forKey: User.currentUserKey) as? Data{
                    if let userDict = try!JSONSerialization.jsonObject(with: userData, options: []) as? Dictionary<String,Any>{
                        _currentUser = User(dict: userDict)
                    }
                }
            }else{
                print("Error retreiving current user from defaults")
            }
            return _currentUser
        }
        set(user){
            _currentUser = user
            let defaults = UserDefaults.standard
            if let user = user {
                let userData = try!JSONSerialization.data(withJSONObject: user.dictionary, options: [])
                defaults.set(userData, forKey: User.currentUserKey)
            }else{
                defaults.removeObject(forKey: User.currentUserKey)
            }
            defaults.synchronize()
        }

    }

}
