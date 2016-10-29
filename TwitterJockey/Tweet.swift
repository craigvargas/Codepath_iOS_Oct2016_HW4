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
    
    init(dict: Dictionary<String,Any>) {
        self.text = dict["text"] as? String
        self.retweetCount = dict["retweet_count"] as? Int ?? 0
        self.favoritesCount = dict["favourites_count"] as? Int ?? 0
        
        if let timeStampString = dict["created_at"] as? String{
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z Y"
            self.timeStamp = formatter.date(from: timeStampString)
        }
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
