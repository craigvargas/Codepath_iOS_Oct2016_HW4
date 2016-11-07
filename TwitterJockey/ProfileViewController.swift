//
//  ProfileViewController.swift
//  TwitterJockey
//
//  Created by Craig Vargas on 11/5/16.
//  Copyright © 2016 Cvar. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var tweetsCountLabel: UILabel!
    @IBOutlet weak var friendsCountLabel: UILabel!
    @IBOutlet weak var followersCountLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var tweetsView: UIView!
    
    var timelineNavCtrl: UINavigationController!
    var timelineViewCtrl: TweetsViewController!
    
    private var currentUser: User?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadProfile()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    //Low level detail functions
    //**
    //*
    
    func loadProfile(){
        User.refreshCurrentUser(
            success: {(userObj: User)->Void in
                ViewHelper.setImageIfPossibleFor(imageView: self.profileImageView, withUrl: userObj.profileUrl)
                ViewHelper.setImageIfPossibleFor(imageView: self.backgroundImageView, withUrl: userObj.backgroundUrl, orColor: ViewHelper.Colors.dogerBlue)
                ViewHelper.setTextIfPossibleFor(label: self.tweetsCountLabel, withInteger: userObj.statusesCount)
                ViewHelper.setTextIfPossibleFor(label: self.friendsCountLabel, withInteger: userObj.friendsCount)
                ViewHelper.setTextIfPossibleFor(label: self.followersCountLabel, withInteger: userObj.followersCount)
                self.nameLabel.text = userObj.name
                self.screenNameLabel.text = userObj.getFormattedScreenName()
                self.loadTimeline()
            },
            failure: {(error: Error)->Void in
                print("ProfileViewController: error refreshing current user")
                print(error.localizedDescription)})
    }
    
    func loadTimeline(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        self.timelineNavCtrl = storyboard.instantiateViewController(withIdentifier: TwitterJockey.TweetsNavCtrlId) as! UINavigationController
        self.timelineViewCtrl = timelineNavCtrl.topViewController as! TweetsViewController
        self.timelineViewCtrl.tweetType = .homeTimeline
        self.timelineNavCtrl.willMove(toParentViewController: self)
        self.tweetsView.addSubview(self.timelineNavCtrl.view)
        self.timelineNavCtrl.didMove(toParentViewController: self)
        
    }

}
