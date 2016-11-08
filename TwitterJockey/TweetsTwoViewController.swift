//
//  TweetsTwoViewController.swift
//  TwitterJockey
//
//  Created by Craig Vargas on 11/7/16.
//  Copyright © 2016 Cvar. All rights reserved.
//

import UIKit



class TweetsTwoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private static let homeTimelineCellKey = "HomeTimelineTableViewCell"
    private let firstRowIndex = 0
    
    @IBOutlet weak var homeTimelineTableView: UITableView!
        
    var homeTimelineTweets = [Tweet]()
    
    let refreshControl = UIRefreshControl()
    
    var tweetType: Tweet.TweetType = .homeTimeline
    
    var userId: String?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeTableView()
        initializeTableViewData()
        setupRefreshConrol()
        
        NotificationCenter.default.addObserver(
            forName: Tweet.tweetNotification,
            object: nil,
            queue: OperationQueue.main,
            using: {(notification: Notification)->Void in
                if let newTweet = notification.userInfo?[Tweet.tweetKey] as? Tweet{
                    self.homeTimelineTweets.insert(newTweet, at: self.homeTimelineTweets.startIndex)
                    self.homeTimelineTableView.reloadData()}})
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.homeTimelineTweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = homeTimelineTableView.dequeueReusableCell(
            withIdentifier: TweetsTwoViewController.homeTimelineCellKey,
            for: indexPath) as! TweetsTableViewCell
        cell.tweet = homeTimelineTweets[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    /*
    //(sender as! HomeTimelineTableViewCell)
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let segueSender = (sender as? HomeTimelineTableViewCell){
            let selectedIndexPath = homeTimelineTableView.indexPath(for: segueSender)
            if selectedIndexPath != nil{
                let selectedTweet = homeTimelineTweets[selectedIndexPath!.row]
                let nextNavCont = segue.destination as? UINavigationController ?? nil
                let nextViewCont = nextNavCont?.topViewController as? TweetDetailViewController
                if(nextViewCont != nil){
                    nextViewCont!.acceptTweetToLoad(tweet: selectedTweet)
                }else{
                    print("Something went wrong in the segue")
                }
            }else{
                print("indexPath was nil on segue")
            }
        }else if (sender as? UIBarButtonItem) == self.newTweetBarButton{
            print("New Tweet Bar Button pressed")
            let nextNavCont = segue.destination as? UINavigationController ?? nil
            let nextViewCont = nextNavCont?.topViewController as? ComposeTweetViewController
            if(nextViewCont != nil){
                nextViewCont!.acceptTweetType(tweetType: Tweet.newTweetType)
            }
        }
        
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    
    
    //*
    //**
    //***
    //Helper functions
    //***
    //**
    //*
    
    func initializeTableView(){
        self.homeTimelineTableView.dataSource = self
        self.homeTimelineTableView.delegate = self
        self.homeTimelineTableView.estimatedRowHeight = 120
        self.homeTimelineTableView.rowHeight = UITableViewAutomaticDimension
    }
    
    func initializeTableViewData(){
        print("Tweet data is of type: \(self.tweetType.rawValue)")
        switch self.tweetType {
        case .homeTimeline:
            TwitterClient.sharedInstance?.homeTimeline(
                success: {(tweets: [Tweet])->Void in
                    self.homeTimelineTweets = tweets
                    self.homeTimelineTableView.reloadData()
                    self.refreshControl.endRefreshing()},
                failure: {(error: Error)->Void in
                    print(error.localizedDescription)
                    self.homeTimelineTweets = [Tweet]()
                    self.homeTimelineTableView.reloadData()
                    self.refreshControl.endRefreshing()})
            break
        case .mentions:
            User.getUserMentions(
                success: {(tweets: [Tweet])->Void in
                    self.homeTimelineTweets = tweets
                    self.homeTimelineTableView.reloadData()
                    self.refreshControl.endRefreshing()},
                failure: {(error: Error)->Void in
                    print(error.localizedDescription)
                    self.homeTimelineTweets = [Tweet]()
                    self.homeTimelineTableView.reloadData()
                    self.refreshControl.endRefreshing()})
            break
        case .userTimeline:
            if let unwrappedUserId = self.userId{
                TwitterClient.sharedInstance?.userTimeline(
                    userId: unwrappedUserId,
                    success: {(tweets: [Tweet])->Void in
                        self.homeTimelineTweets = tweets
                        self.homeTimelineTableView.reloadData()
                        self.refreshControl.endRefreshing()},
                    failure: {(error: Error)->Void in
                        print(error.localizedDescription)
                        self.homeTimelineTweets = [Tweet]()
                        self.homeTimelineTableView.reloadData()
                        self.refreshControl.endRefreshing()})
            }else{
                print("TweetsTwoViewController: need to set userId")
            }
            break
        }
        
//        if self.tweetType == .homeTimeline{
//            TwitterClient.sharedInstance?.homeTimeline(
//                success: {(tweets: [Tweet])->Void in
//                    self.homeTimelineTweets = tweets
//                    self.homeTimelineTableView.reloadData()
//                    self.refreshControl.endRefreshing()},
//                failure: {(error: Error)->Void in
//                    print(error.localizedDescription)
//                    self.homeTimelineTweets = [Tweet]()
//                    self.homeTimelineTableView.reloadData()
//                    self.refreshControl.endRefreshing()})
//        }else if self.tweetType == .mentions{
//            User.getUserMentions(
//                success: {(tweets: [Tweet])->Void in
//                    self.homeTimelineTweets = tweets
//                    self.homeTimelineTableView.reloadData()
//                    self.refreshControl.endRefreshing()},
//                failure: {(error: Error)->Void in
//                    print(error.localizedDescription)
//                    self.homeTimelineTweets = [Tweet]()
//                    self.homeTimelineTableView.reloadData()
//                    self.refreshControl.endRefreshing()})
//        }
    }
    
    func setupRefreshConrol(){
        // Initialize a UIRefreshControl
        refreshControl.addTarget(self, action: #selector(initializeTableViewData), for: UIControlEvents.valueChanged)
        self.homeTimelineTableView.insertSubview(refreshControl, at: firstRowIndex)
    }
    
}
