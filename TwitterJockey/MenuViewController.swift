//
//  MenuViewController.swift
//  TwitterJockey
//
//  Created by Craig Vargas on 11/4/16.
//  Copyright © 2016 Cvar. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var menuTableView: UITableView!
    
    let profileScreenKey = "Profile"
    let timelineScreenKey = "Timeline"
    let mentionsScreenKey = "Mentions"
    let logoutScreenKey = "Logout"
    
    let tweetsNavCtrlIdentifier = "TweetsNavController"
    let profileNavCtrlIdentifier = "ProfileNavController"
    
    var menuItems: [String] = Array()
    var menuDict: [String:UIViewController] = [:]
    
    
    var masterViewConroller: MasterViewController!
    
    var timelineNavCtrl: UINavigationController!
    var timelineViewController: TweetsViewController!
    var profileNavCtrl: UINavigationController!
    var profileViewController: ProfileViewController!
    var mentionsNavCtrl: UINavigationController!
    var mentionsViewController: TweetsViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        instantiateViewControllers()
        setupMenu()
        selectInitialScreen()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MainMenuTableViewCell", for: indexPath) as! MainMenuTableViewCell
        
        cell.fillCell(itemName: self.menuItems[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        if menuItems[indexPath.row] == self.logoutScreenKey{
            TwitterClient.sharedInstance?.logout()
        }else{
            let cell = tableView.cellForRow(at: indexPath) as! MainMenuTableViewCell
            cell.animateMenuItem(doneAnimating: {
                self.masterViewConroller.contentViewController = self.menuDict[self.menuItems[indexPath.row]]
            })
//            masterViewConroller.contentViewController = menuDict[menuItems[indexPath.row]]
        }
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
    func setupMenu(){
        self.menuTableView.dataSource = self
        self.menuTableView.delegate = self
    }
    
    func instantiateViewControllers(){
        self.menuItems.append(self.profileScreenKey)
        self.menuItems.append(self.timelineScreenKey)
        self.menuItems.append(self.mentionsScreenKey)
        self.menuItems.append(self.logoutScreenKey)
        //Get Storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        //Setup the tweets View Controller
        self.timelineNavCtrl = storyboard.instantiateViewController(withIdentifier: self.tweetsNavCtrlIdentifier) as! UINavigationController
        self.timelineViewController = self.timelineNavCtrl.topViewController as! TweetsViewController
        self.timelineViewController.tweetType = Tweet.TweetType.homeTimeline
        
        //Setup profile View Controller
        self.profileNavCtrl = storyboard.instantiateViewController(withIdentifier: self.profileNavCtrlIdentifier) as! UINavigationController
        self.profileViewController = profileNavCtrl.topViewController as! ProfileViewController
        self.profileViewController.didRequestAuthenticatedUserProfile = true;
        
        //Setup mentions View Controller
        self.mentionsNavCtrl = storyboard.instantiateViewController(withIdentifier: self.tweetsNavCtrlIdentifier) as! UINavigationController
        self.mentionsViewController = self.mentionsNavCtrl.topViewController as! TweetsViewController
        self.mentionsViewController.tweetType = .mentions
        
        for menuItem in self.menuItems{
            switch menuItem {
            case self.timelineScreenKey:
                menuDict[self.timelineScreenKey] = self.timelineNavCtrl
                break
            case self.profileScreenKey:
                menuDict[self.profileScreenKey] = self.profileNavCtrl
                break
            case self.mentionsScreenKey:
                menuDict[self.mentionsScreenKey] = self.mentionsNavCtrl
            default:
                break
            }
        }
    }
    
    func selectInitialScreen(){
        self.masterViewConroller.contentViewController = menuDict[timelineScreenKey]
    }

}
