//
//  Tweet.swift
//  TwitterJockey
//
//  Created by Craig Vargas on 10/28/16.
//  Copyright © 2016 Cvar. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    
    public static let newTweetType = "newTweet"
    public static let replyTweetType = "replyTweet"
    public static let tweetKey = "tweet"
    public static let tweetNotification = NSNotification.Name("tweetNotification")
    
    var text: String?
    var timeStamp: Date?
    var retweetCount: Int = 0
    var favoritesCount: Int = 0
    var user: Dictionary<String,Any>?
    var userProfilePicUrlString: String?
    var userProfilePicUrl: URL?
    var userName: String?
    var userScreenName: String?
    var userId: String?
    var favorited: Bool?
    var retweeted: Bool?
    var tweetId: String?
    var retweetTweet: Dictionary<String, Any>?
    
    init(dict: Dictionary<String,Any>) {
        self.user = dict["user"] as? Dictionary<String,Any>
        self.text = dict["text"] as? String
        self.retweetCount = dict["retweet_count"] as? Int ?? 0
        self.favoritesCount = dict["favorite_count"] as? Int ?? 0
//        self.favoritesCount = self.user?["favourites_count"] as? Int ?? 0
        self.userProfilePicUrlString = self.user?["profile_image_url_https"] as? String
        self.userName = self.user?["name"] as? String
        self.userScreenName = self.user?["screen_name"] as? String
        self.userId = self.user?["id_str"] as? String
        self.favorited = dict["favorited"] as? Bool
        self.retweeted = dict["retweeted"] as? Bool
        self.tweetId = dict["id_str"] as? String
        self.retweetTweet = dict["retweeted_status"] as? Dictionary<String,Any>
        
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
//        print(self.userProfilePicUrlString)
//        print(self.userProfilePicUrl)
        print(self.retweeted)
        print(self.favorited)
        print(self.tweetId)
        print("********************")
    }
    
    enum TweetType: String {
        case homeTimeline = "homeTimeline"
        case mentions = "mentions"
        case userTimeline = "userTimeline"
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
    
    func likeTweet(success: @escaping (Tweet)->Void, failure: @escaping (Error)->Void){
        print("inside likeTweet. Id = \(self.tweetId)")
        if(self.tweetId != nil){
            TwitterClient.sharedInstance?.likeTweet(
                statusId: self.tweetId!,
                success: {(tweet: Tweet)->Void in
                    success(tweet)},
                failure: {(error: Error)->Void in
                    failure(error)})
        }else{
            print("likeTweetFailed, could not find tweetId")
        }
    }
    
    func retweet(success: @escaping (Tweet)->Void, failure: @escaping (Error)->Void){
        print("inside retweet. Id = \(self.tweetId)")
        if(self.tweetId != nil){
            TwitterClient.sharedInstance?.retweet(
                statusId: self.tweetId!,
                success: {(tweet: Tweet)->Void in
                    success(tweet)},
                failure: {(error: Error)->Void in
                    failure(error)})
        }else{
            print("likeTweetFailed, could not find tweetId")
        }
    }
    
    func reply(status: String, success: @escaping (Tweet)->Void, failure: @escaping (Error)->Void){
        print("inside reply to tweet. Id = \(self.tweetId)")
        if(self.tweetId != nil){
            TwitterClient.sharedInstance?.tweet(
                status: status,
                statusId: self.tweetId!,
                success: {(tweet: Tweet)->Void in
                    success(tweet)},
                failure: {(error: Error)->Void in
                    failure(error)})
        }else{
            print("likeTweetFailed, could not find tweetId")
        }
    }
    
    class func tweet(status: String, success: @escaping (Tweet)->Void, failure: @escaping (Error)->Void){
        print("inside Tweet.tweet new tweet call")
        TwitterClient.sharedInstance?.tweet(
            status: status,
            statusId: nil,
            success: {(tweet: Tweet)->Void in
                success(tweet)},
            failure: {(error: Error)->Void in
                failure(error)})
    }


}
