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
    @IBOutlet var parentView: UIView!
    
    @IBOutlet weak var backgroundIvHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var backgroundIvLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var backgroundIvTrailingConstraint: NSLayoutConstraint!
    
    
    private var timelineViewCtrl: TweetsTwoViewController!
        
    var userId: String?
    var selectedUser: User?
    var didRequestAuthenticatedUserProfile = true
    var origBackgroundImageViewHeight = CGFloat(150.0)
    var origBackgroundImageViewLeadingConstraint = CGFloat(0.0)
    var origBackgroundImageViewTrailingConstraint = CGFloat(0.0)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.profileImageView.layer.cornerRadius = 5
        self.profileImageView.clipsToBounds = true
        
        loadProfile()
        setupGestureRecognizers()

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
        if self.didRequestAuthenticatedUserProfile {
            //get authenticated user
            print("Getting current user")
            User.refreshCurrentUser(
                success: {(userObj: User)->Void in
                    ViewHelper.setImageIfPossibleFor(imageView: self.profileImageView, withUrl: userObj.profileUrl)
//                    ViewHelper.setImageIfPossibleFor(imageView: self.backgroundImageView, withUrl: userObj.backgroundUrl, orColor: ViewHelper.Colors.dogerBlue)
                    ViewHelper.setImageIfPossibleFor(imageView: self.backgroundImageView, withUrl: userObj.bannerUrl, orColor: ViewHelper.Colors.dogerBlue)
                    ViewHelper.setTextIfPossibleFor(label: self.tweetsCountLabel, withInteger: userObj.statusesCount)
                    ViewHelper.setTextIfPossibleFor(label: self.friendsCountLabel, withInteger: userObj.friendsCount)
                    ViewHelper.setTextIfPossibleFor(label: self.followersCountLabel, withInteger: userObj.followersCount)
                    self.nameLabel.text = userObj.name
                    self.screenNameLabel.text = userObj.getFormattedScreenName()
                    self.userId = userObj.id
                    self.loadTimeline()
            },
            failure: {(error: Error)->Void in
                print("ProfileViewController: error refreshing current user")
                print(error.localizedDescription)})
        }else{
            //get specific user
            print("Getting user with userId")
            if let unwrappedUserId = self.userId{
                User.getUser(
                    withUserId: unwrappedUserId,
                    success: {(userObj: User)->Void in
                        ViewHelper.setImageIfPossibleFor(imageView: self.profileImageView, withUrl: userObj.profileUrl)
//                        ViewHelper.setImageIfPossibleFor(imageView: self.backgroundImageView, withUrl: userObj.backgroundUrl, orColor: ViewHelper.Colors.dogerBlue)
                        ViewHelper.setImageIfPossibleFor(imageView: self.backgroundImageView, withUrl: userObj.bannerUrl, orColor: ViewHelper.Colors.dogerBlue)
                        ViewHelper.setTextIfPossibleFor(label: self.tweetsCountLabel, withInteger: userObj.statusesCount)
                        ViewHelper.setTextIfPossibleFor(label: self.friendsCountLabel, withInteger: userObj.friendsCount)
                        ViewHelper.setTextIfPossibleFor(label: self.followersCountLabel, withInteger: userObj.followersCount)
                        self.nameLabel.text = userObj.name
                        self.screenNameLabel.text = userObj.getFormattedScreenName()
                        self.loadTimeline()
                        self.userId = userObj.id
                    },
                    failure: {(error: Error)->Void in
                        print("ProfileViewController: error searching for specific user")
                        print(error.localizedDescription)})
            }else{
                print("ProfileViewController: Must set userId")
            }

        }
        
    }
    
    func loadTimeline(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        self.timelineViewCtrl = storyboard.instantiateViewController(withIdentifier: TwitterJockey.TweetsTwoViewCtrlId) as! TweetsTwoViewController
        self.timelineViewCtrl.tweetType = .userTimeline
        self.timelineViewCtrl.userId = self.userId
        self.timelineViewCtrl.willMove(toParentViewController: self)
        self.tweetsView.addSubview(self.timelineViewCtrl.view)
        self.timelineViewCtrl.didMove(toParentViewController: self)
        
    }
    
    func setupGestureRecognizers (){
        self.origBackgroundImageViewHeight = self.backgroundIvHeightConstraint.constant
        self.origBackgroundImageViewLeadingConstraint = self.backgroundIvLeadingConstraint.constant
        self.origBackgroundImageViewTrailingConstraint = self.backgroundIvTrailingConstraint.constant
        let panView = UIPanGestureRecognizer(target: self, action: #selector(didPanView(sender:)))
        self.backgroundImageView.isUserInteractionEnabled = true
        self.backgroundImageView.addGestureRecognizer(panView)
    }
    
    func didPanView(sender: UIPanGestureRecognizer){
        print("ProfileViewController: inside didPanView")
        switch sender.state {
        case UIGestureRecognizerState.began:
            break
        case UIGestureRecognizerState.changed:
            let velocity = sender.velocity(in: self.parentView)
            if(velocity.y > 0){
                print(velocity.y)
//                var multiplier: CGFloat = 1.0
//                let integerVelocityY: Int = Int(velocity.y)
//                switch integerVelocityY {
//                case 0:
//                    multiplier = 1.0
//                    break
//                case 10:
//                    multiplier = 1.1
//                    break
//                case 20:
//                    multiplier = 1.2
//                    break
//                case 30:
//                    multiplier = 1.3
//                    break
//                case 40:
//                    multiplier = 1.4
//                    break
//                case 50:
//                    multiplier = 1.5
//                    break
//                default:
//                    multiplier = 1.6
//                    break
//                }
                UIView.animate(
                    withDuration: 1.0,
                    delay: 0.0,
                    usingSpringWithDamping: 0.8,
                    initialSpringVelocity: 1.0,
                    options: [],
                    animations: {
                        self.backgroundIvHeightConstraint.constant = self.origBackgroundImageViewHeight * 1.5
                        self.backgroundIvLeadingConstraint.constant = 50
                        self.backgroundIvTrailingConstraint.constant = 50
                        self.view.layoutIfNeeded()
                    },
                    completion: nil)
                //panning down
            }else if(velocity.y < 0){
                //panning up
            }
            break
        case UIGestureRecognizerState.ended:
            UIView.animate(
                withDuration: 1.0,
                delay: 0.0,
                usingSpringWithDamping: 0.8,
                initialSpringVelocity: 1.0,
                options: [],
                animations: {
                    self.backgroundIvHeightConstraint.constant = self.origBackgroundImageViewHeight
                    self.backgroundIvLeadingConstraint.constant = self.origBackgroundImageViewLeadingConstraint
                    self.backgroundIvTrailingConstraint.constant = self.origBackgroundImageViewTrailingConstraint
                    self.view.layoutIfNeeded()
                },
                completion: nil)
            break
        case UIGestureRecognizerState.cancelled:
            break
        default:
            break
        }
    }

}
