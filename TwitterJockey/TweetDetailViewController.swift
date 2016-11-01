//
//  TweetDetailViewController.swift
//  TwitterJockey
//
//  Created by Craig Vargas on 10/31/16.
//  Copyright © 2016 Cvar. All rights reserved.
//

import UIKit

class TweetDetailViewController: UIViewController {
    
    @IBOutlet weak var profilePicImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var numberOfRetweetsLabel: UILabel!
    @IBOutlet weak var numberOfFavoritesLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var replyIconButton: UIButton!
    @IBOutlet weak var replyBarButton: UIBarButtonItem!
    
    
    var tweet: Tweet = Tweet(dict: [:])
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadTweet()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onBackTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onReplyTapped(_ sender: AnyObject) {
    }
    
    @IBAction func onRetweetTapped(_ sender: UIButton) {
        print("Retweet button Tapped")
        self.tweet.retweet(
            success: {(tweet: Tweet)->Void in
                if let retweetDict = tweet.retweetTweet{
                    let retweet = Tweet(dict: retweetDict)
                    self.tweet = retweet
                    self.loadTweet()
//                    NotificationCenter.default.post(
//                        name: Tweet.tweetNotification,
//                        object: nil,
//                        userInfo: [Tweet.tweetKey: tweet])
                }},
            failure: {(error: Error)->Void in
                print("Error liking tweet: \(error.localizedDescription)")})
    }
    
    
    @IBAction func onLikeTapped(_ sender: UIButton) {
        print("Like button Tapped")
        self.tweet.likeTweet(
            success: {(tweet: Tweet)->Void in
                self.tweet = tweet
                self.loadTweet()},
            failure: {(error: Error)->Void in
                print("Error liking tweet: \(error.localizedDescription)")})
    }
    
    func acceptTweetToLoad(tweet: Tweet){
        self.tweet = tweet
    }
    
    
    
    
    func loadTweet() {
        if(self.tweet.userProfilePicUrl != nil){
            self.profilePicImageView.setImageWith(self.tweet.userProfilePicUrl!, placeholderImage: #imageLiteral(resourceName: "iconmonstr-user-gray-20-72"))
        }
        
        self.nameLabel.text = self.tweet.userName
        if(self.tweet.userScreenName != nil){
            self.screenNameLabel.text = "@\(self.tweet.userScreenName!)"
        }
        self.tweetTextLabel.text = self.tweet.text
        self.timestampLabel.text = self.tweet.timeStamp?.description
        self.numberOfRetweetsLabel.text = "\(tweet.retweetCount)"
        self.numberOfFavoritesLabel.text = "\(tweet.favoritesCount)"
        
        if let favorited = tweet.favorited{
            if favorited{
                print("Favorited check: true")
                self.likeButton.tintColor = UIColor.red
            }else{
                print("Favorited check: false")
                self.likeButton.tintColor = UIColor.gray
            }
        }else{
            print("favorited was nil")
            self.likeButton.tintColor = UIColor.gray
        }

        if let retweeted = tweet.retweeted{
            if retweeted{
                print("Retweeted check: true")
                self.retweetButton.tintColor = UIColor.green
            }else{
                print("Retweeted check: false")
                self.retweetButton.tintColor = UIColor.gray
            }
        }else{
            print("retweeted was nil")
            self.retweetButton.tintColor = UIColor.gray
        }
        
    }
    
//    func loadTweetAfterRetweet() {
//        //Response comes back with logged in user as the tweet author and we don't want to loose the info of the original tweeter
////        if(self.tweet.userProfilePicUrl != nil){
////            self.profilePicImageView.setImageWith(self.tweet.userProfilePicUrl!, placeholderImage: #imageLiteral(resourceName: "iconmonstr-user-gray-20-72"))
////        }
//        
////        self.nameLabel.text = self.tweet.userName
////        if(self.tweet.userScreenName != nil){
////            self.screenNameLabel.text = "@\(self.tweet.userScreenName!)"
////        }
//        
//        self.tweetTextLabel.text = self.tweet.text
//        self.timestampLabel.text = self.tweet.timeStamp?.description
//        self.numberOfRetweetsLabel.text = "\(tweet.retweetCount)"
//        self.numberOfFavoritesLabel.text = "\(tweet.favoritesCount)"
//        
//        if let favorited = tweet.favorited{
//            if favorited{
//                print("Favorited check: true")
//                self.likeButton.tintColor = UIColor.red
//            }else{
//                print("Favorited check: false")
//                self.likeButton.tintColor = UIColor.gray
//            }
//        }else{
//            print("favorited was nil")
//            self.likeButton.tintColor = UIColor.gray
//        }
//        
//        if let retweeted = tweet.retweeted{
//            if retweeted{
//                print("Retweeted check: true")
//                self.retweetButton.tintColor = UIColor.green
//            }else{
//                print("Retweeted check: false")
//                self.retweetButton.tintColor = UIColor.gray
//            }
//        }else{
//            print("retweeted was nil")
//            self.retweetButton.tintColor = UIColor.gray
//        }
//        
//    }



    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var userWantsToComposeTweet = false
        if (sender as? UIBarButtonItem) == self.replyBarButton{
            userWantsToComposeTweet = true
            print("Reply Bar Button Pressed")
        }else if (sender as? UIButton) == self.replyIconButton{
            userWantsToComposeTweet = true
            print("Reply icon Button Pressed")
        }
        
        if userWantsToComposeTweet{
            let destinationNavCont = segue.destination as! UINavigationController
            let destinationViewCont = destinationNavCont.topViewController as! ComposeTweetViewController
            destinationViewCont.acceptTweet(tweet: self.tweet)
            destinationViewCont.acceptTweetType(tweetType: Tweet.replyTweetType)
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
