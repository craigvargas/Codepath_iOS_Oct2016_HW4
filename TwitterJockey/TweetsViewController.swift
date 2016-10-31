//
//  TweetsViewController.swift
//  TwitterJockey
//
//  Created by Craig Vargas on 10/28/16.
//  Copyright © 2016 Cvar. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private static let homeTimelineCellKey = "HomeTimelineTableViewCell"
    private let firstRowIndex = 0
    
    @IBOutlet weak var homeTimelineTableView: UITableView!
    
    var homeTimelineTweets = [Tweet]()
    
    let refreshControl = UIRefreshControl()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeTableView()
        initializeTableViewData()
        setupRefreshConrol()

        // Do any additional setup after loading the view.
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
            withIdentifier: TweetsViewController.homeTimelineCellKey,
            for: indexPath) as! HomeTimelineTableViewCell
//        cell.parseTweet(tweet: homeTimelineTweets[indexPath.row])
        cell.tweet = homeTimelineTweets[indexPath.row]
        return cell
    }
    
    
    @IBAction func onLogoutButtonTapped(_ sender: UIBarButtonItem) {
        TwitterClient.sharedInstance?.logout()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
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
    }
    
    func setupRefreshConrol(){
        // Initialize a UIRefreshControl
        refreshControl.addTarget(self, action: #selector(initializeTableViewData), for: UIControlEvents.valueChanged)
        self.homeTimelineTableView.insertSubview(refreshControl, at: firstRowIndex)
    }

}
