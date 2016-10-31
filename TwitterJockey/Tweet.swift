//
//  Tweet.swift
//  TwitterJockey
//
//  Created by Craig Vargas on 10/28/16.
//  Copyright © 2016 Cvar. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    
    var text: String?
    var timeStamp: Date?
    var retweetCount: Int = 0
    var favoritesCount: Int = 0
    var user: Dictionary<String,Any>?
    var userProfilePicUrlString: String?
    var userProfilePicUrl: URL?
    var userName: String?
    var userScreenName: String?
    
    init(dict: Dictionary<String,Any>) {
        self.user = dict["user"] as? Dictionary<String,Any>
        self.text = dict["text"] as? String
        self.retweetCount = dict["retweet_count"] as? Int ?? 0
        self.favoritesCount = dict["favourites_count"] as? Int ?? 0
        self.userProfilePicUrlString = self.user?["profile_image_url_https"] as? String
        self.userName = self.user?["name"] as? String
        self.userScreenName = self.user?["screen_name"] as? String
        
        if let unwrappedUrlString = self.userProfilePicUrlString{
            self.userProfilePicUrl = URL(string: unwrappedUrlString)
        }
        
        if let timeStampString = dict["created_at"] as? String{
            let formatter = DateFormatter()
//            formatter.dateFormat = "EEE MMM d HH:mm:ss Z Y"
            formatter.dateFormat = "EEE MMM d HH:mm:ss ZZZZ yyyy"
            self.timeStamp = formatter.date(from: timeStampString)
        }
        
        print("********************")
//        print(self.text)
//        print(dict["created_at"] as? String)
//        print(self.timeStamp?.timeIntervalSinceNow)
//        print(self.timeStamp?.description)
//        print(self.retweetCount)
//        print(self.favoritesCount)
        print(self.userProfilePicUrlString)
        print(self.userProfilePicUrl)
        print("********************")
    }
    
    class func tweets(withArray dicts: [Dictionary<String,Any>])->[Tweet]{
        var tweets = [Tweet]()
        var tweet = Tweet(dict: [:])
        for dict in dicts{
            tweet = Tweet(dict: dict)
            tweets.append(tweet)
        }
        
        return tweets
    }

}
