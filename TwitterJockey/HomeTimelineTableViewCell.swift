//
//  HomeTimelineTableViewCell.swift
//  TwitterJockey
//
//  Created by Craig Vargas on 10/30/16.
//  Copyright © 2016 Cvar. All rights reserved.
//

import UIKit

class HomeTimelineTableViewCell: UITableViewCell {
    
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userScreenNameLabel: UILabel!
    @IBOutlet weak var timeSinceTweetLabel: UILabel!
    @IBOutlet weak var userProfileImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var tweet: Tweet! {

        willSet{
            //Set profile pic
            if(newValue.userProfilePicUrl != nil){
                self.userProfileImageView.setImageWith(newValue.userProfilePicUrl!, placeholderImage: #imageLiteral(resourceName: "iconmonstr-user-gray-20-72"))
            }else{
                self.userProfileImageView.image = #imageLiteral(resourceName: "iconmonstr-user-gray-20-72")
            }
            
            self.userProfileImageView.layer.cornerRadius = 5
            self.userProfileImageView.clipsToBounds = true
            
            //Set label texts
            self.tweetTextLabel.text = newValue.text
            self.userNameLabel.text = newValue.userName
            if(newValue.userScreenName != nil){
                self.userScreenNameLabel.text = "@\(newValue.userScreenName!)"
            }
            self.timeSinceTweetLabel.text = getTimeSinceTweet(timeStamp: newValue.timeStamp)
        }
    }
    
//    func parseTweet(tweet: Tweet){
//        self.tweetTextLabel.text = tweet.text
//        self.userNameLabel.text = tweet.userName
//        self.userScreenNameLabel.text = tweet.userScreenName
//        self.timeSinceTweetLabel.text = getTimeSinceTweet(timeStamp: tweet.timeStamp)
//        
////        if(tweet.userProfilePicUrl != nil){
////            print("unwrapped Url: \(tweet.userProfilePicUrl!)")
////            self.userProfileImageView.setImageWith(tweet.userProfilePicUrl!)
//////            self.userProfileImageView.setImageWith(tweet.userProfilePicUrl!, placeholderImage: #imageLiteral(resourceName: "iconmonstr-user-gray-20-72"))
////        }
//        
//        if let unwrappedUrl = tweet.userProfilePicUrl{
//            self.userProfileImageView.setImageWith(unwrappedUrl, placeholderImage: #imageLiteral(resourceName: "iconmonstr-user-gray-20-72"))
//        }
//    }
    
    func getTimeSinceTweet(timeStamp: Date?) -> String {
        if let unwrappedTimeStamp = timeStamp{
            let secondsSinceNow = -1.0 * unwrappedTimeStamp.timeIntervalSinceNow
//            print("***")
//            print(TimeHelper.secondsToMinutes(seconds: secondsSinceNow))
//            print(TimeHelper.secondsToHours(seconds: secondsSinceNow))
//            print(TimeHelper.secondsToDays(seconds: secondsSinceNow))


            
            
            if(TimeHelper.secondsToMinutes(seconds: secondsSinceNow) < 1){
                let newUnitsTimeInterval = Int(secondsSinceNow) //as! Int
                return "- \(newUnitsTimeInterval)s"
            }else if(TimeHelper.secondsToHours(seconds: secondsSinceNow) < 1){
                let newUnitsTimeInterval = Int(TimeHelper.secondsToMinutes(seconds: secondsSinceNow))
                return "- \(newUnitsTimeInterval)m"
            }else if(TimeHelper.secondsToDays(seconds: secondsSinceNow) < 1){
                let newUnitsTimeInterval = Int(TimeHelper.secondsToHours(seconds: secondsSinceNow))
                return "- \(newUnitsTimeInterval)h"
            }else{
                let newUnitsTimeInterval = Int(TimeHelper.secondsToDays(seconds: secondsSinceNow))
                return "- \(newUnitsTimeInterval)d"
            }
        }else{
            return "- ?m"
        }
    }

}
