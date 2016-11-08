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
    var id: String?
    
    var backgroundUrl: URL?
    var bannerUrl: URL?
    var statusDict: Dictionary<String,Any>?
    var status: String?
    var userDescription: String?
    var followersCount: Int?
    var friendsCount: Int?
    var statusesCount: Int?
    
    
    init(dict: Dictionary<String,Any>) {
        self.id = dict["id_str"] as? String
        self.name = dict["name"] as? String
        self.screenName = dict["screen_name"] as? String
        
        if let profileUrlString = dict["profile_image_url_https"] as? String{
            self.profileUrl = URL(string: profileUrlString)
        }
        
        self.tagline = dict["tagline"] as? String
        self.dictionary = dict
        
        //Divider
        if let backgroundUrlString = dict["profile_background_image_url_https"] as? String {
            self.backgroundUrl = URL(string: backgroundUrlString)
        }
        
        if let bannerUrlString = dict["profile_banner_url"] as? String {
            self.bannerUrl = URL(string: bannerUrlString)
        }
        
//        self.statusDict = dict["status"] as? Dictionary<String, Any>
        self.status = (dict["status"] as? Dictionary<String, Any>)?["text"] as? String
        self.userDescription = dict["description"] as? String
        self.followersCount = dict["followers_count"] as? Int
        self.friendsCount = dict["friends_count"] as? Int
        self.statusesCount = dict["statuses_count"] as? Int
    }
    
    func getFormattedScreenName() -> String?{
        if(self.screenName != nil){
            return "@\(self.screenName!)"
        }else{
            return nil
        }
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
    
    class func refreshCurrentUser(success: @escaping (User)->Void, failure: @escaping (Error)->Void) -> Void{
        if let oldUserObject = currentUser{
            if let userId = oldUserObject.id{
                TwitterClient.sharedInstance?.user(
                    userId: userId,
                    success: {(user: User) -> Void in
                        self.currentUser = user
                        success(user)},
                    failure: {(error: Error) -> Void in
                        print(error.localizedDescription)
                        failure(error)})
            }else{
                //No userId
            }
        }else{
            //User is not logged in
        }
    }
    
    class func getUser(withUserId userId: String, success: @escaping (User)->Void, failure: @escaping (Error)->Void) -> Void{
        TwitterClient.sharedInstance?.user(
            userId: userId,
            success: {(requestedUser: User) -> Void in
                success(requestedUser)},
            failure: {(error: Error)->Void in
                failure(error)})
    }
    
    class func getUserMentions(success: @escaping ([Tweet])->Void, failure: @escaping (Error)->Void) -> Void{
        TwitterClient.sharedInstance?.mentions(
            success: {(tweets: [Tweet])->Void in
                success(tweets)},
            failure: {(error: Error)->Void in
                failure(error)})
    }

}
