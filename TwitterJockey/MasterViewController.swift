//
//  MasterViewController.swift
//  TwitterJockey
//
//  Created by Craig Vargas on 11/4/16.
//  Copyright © 2016 Cvar. All rights reserved.
//

import UIKit

//@objc protocol MasterViewCtrlControlCenter {
//    @objc optional func tweetsTableViewCell(_ tweetsTableViewCell: TweetsTableViewCell, didRequestProfileViewFor userId: String)
//}

class MasterViewController: UIViewController {
    
    @IBOutlet weak var menuViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var menuViewBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet var parentView: UIView!
    @IBOutlet weak var mainContentView: UIView!
    @IBOutlet var menuViewPanGestureRecognizer: UIPanGestureRecognizer!
    @IBOutlet weak var menuContentView: UIView!
    @IBOutlet weak var menuView: UIView!
    
    
    @IBOutlet weak var expandContractLeftImageView: UIImageView!
    @IBOutlet weak var expandContractRightImageView: UIImageView!

    
    let originalMenuViewConstraintConst: CGFloat = 0.0
    let menuViewTabHeight: CGFloat = 40.0
    var menuViewOpenConst: CGFloat!
    var menuViewClosedConst: CGFloat!
    var menuState: MenuState = .closed
    
    var profileNavCtrl: UINavigationController!
    var profileViewCtrl: ProfileViewController!
    
    var menuViewController: UIViewController!{
        didSet{
            view.layoutIfNeeded()
            menuViewController.willMove(toParentViewController: self)
            menuContentView.addSubview(menuViewController.view)
            menuViewController.didMove(toParentViewController: self)
        }
    }
    
    var contentViewController: UIViewController!{
        didSet(oldContentViewController){
            //Remove old view controller if it exists
            if oldContentViewController != nil {
                oldContentViewController.willMove(toParentViewController: nil)
                oldContentViewController.view.removeFromSuperview()
                oldContentViewController.didMove(toParentViewController: nil)
            }
            //Call a view method to make sure viewDidLoad gets called before I try to access view elements
            view.layoutIfNeeded()
            contentViewController.willMove(toParentViewController: self)
            mainContentView.addSubview(contentViewController.view)
            contentViewController.didMove(toParentViewController: self)
            
            closeMenu()
        }
    }
    
    enum MenuState: String {
        case open = "opened"
        case closed = "closed"
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.menuView.layer.cornerRadius = 10.0
        self.menuView.clipsToBounds = true
        calcMenuConstraints()
        closeMenu();
        addObservers()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //*
    //**
    //Actions
    //**
    //*
    
    @IBAction func didPanMenuView(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
        case UIGestureRecognizerState.began:
            break
        case UIGestureRecognizerState.changed:
            break
        case UIGestureRecognizerState.ended:
            let velocity = sender.velocity(in: self.parentView)
            if(velocity.y > 0){
                closeMenu()
            }else if(velocity.y < 0){
                openMenu()
            }
            break
        case UIGestureRecognizerState.cancelled:
            break
        default:
            break
        }
        
    }
    
    @IBAction func didPanMainContentView(_ sender: UIPanGestureRecognizer) {
        moveMenu(sender)
    }
    
    @IBAction func didTapMenuButton(_ sender: UIButton) {
        switch self.menuState {
        case .open:
            closeMenu()
            break
        case .closed:
            openMenu()
            break
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
    
    func calcMenuConstraints(){
        
        self.menuViewOpenConst = self.originalMenuViewConstraintConst
        self.menuViewClosedConst = -1*(self.menuViewHeightConstraint.constant - self.menuViewTabHeight)
        print("Open Constant: \(self.menuViewOpenConst)")
        print("Closed Constant: \(self.menuViewClosedConst)")
        print("menu view bounds size height: \(self.menuView.bounds.size.height)")
        print("content view bounds size height: \(self.mainContentView.bounds.size.height)")
    }
    
    func openMenu(){
        UIView.animate(
            withDuration: 1.5, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1.0, options: [],
            animations: {
                self.menuViewBottomConstraint.constant = self.menuViewOpenConst
                self.view.layoutIfNeeded()
            },
            completion: { (wasSuccessful: Bool)-> Void in
                if(wasSuccessful){
                    self.menuState = .open
                }})
        
        UIView.animate(withDuration: 1.0, animations: {
            self.expandContractLeftImageView.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI))
            self.expandContractRightImageView.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI))

        })
    }
    
    func closeMenu(){
        UIView.animate(
            withDuration: 1.5, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1.0, options: [],
            animations: {
                self.menuViewBottomConstraint.constant = self.menuViewClosedConst
                self.view.layoutIfNeeded()
            },
            completion: { (wasSuccessful: Bool)-> Void in
                if(wasSuccessful){
                    self.menuState = .closed
                }})
        
        UIView.animate(withDuration: 1.0, animations: {
            self.expandContractLeftImageView.transform = CGAffineTransform(rotationAngle: 2.0*CGFloat(M_PI))
            self.expandContractRightImageView.transform = CGAffineTransform(rotationAngle: 2.0*CGFloat(M_PI))
        })
    }
    
    func moveMenu(_ sender: UIPanGestureRecognizer){
        switch sender.state {
        case UIGestureRecognizerState.began:
            break
        case UIGestureRecognizerState.changed:
            break
        case UIGestureRecognizerState.ended:
            let velocity = sender.velocity(in: self.parentView)
            if(velocity.y > 0){
                closeMenu()
            }else if(velocity.y < 0){
                openMenu()
            }
            break
        case UIGestureRecognizerState.cancelled:
            break
        default:
            break
        }
    }
    
    func addObservers(){
        //From TweetsTableViewCell
        NotificationCenter.default.addObserver(
            forName: TweetsTableViewCell.profilePicTappedNotification, object: nil, queue: OperationQueue.main,
            using: {(notification: Notification)->Void in
                let userId = notification.userInfo?[TweetsTableViewCell.userIdKey] as? String
                self.showProfileViewCtrl(userId: userId)
        })
        
        //From HomeTimelineTableViewCell
        NotificationCenter.default.addObserver(
            forName: HomeTimelineTableViewCell.profilePicTappedNotification, object: nil, queue: OperationQueue.main,
            using: {(notification: Notification)->Void in
                let userId = notification.userInfo?[TweetsTableViewCell.userIdKey] as? String
                print("userId inside MasterViewController add observer: \(userId)")
                self.showProfileViewCtrl(userId: userId)
        })
    }
    
    func showProfileViewCtrl(userId: String?){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        self.profileNavCtrl = storyboard.instantiateViewController(withIdentifier: TwitterJockey.ProfileNavCtrlId) as! UINavigationController
        self.profileViewCtrl = self.profileNavCtrl.topViewController as! ProfileViewController
        print("userId inside MasterViewController showProfileViewCtrl: \(userId)")
        self.profileViewCtrl.userId = userId
        self.profileViewCtrl.didRequestAuthenticatedUserProfile = false
        self.contentViewController = self.profileNavCtrl
    }
    
    func setupMenuViewCtrl(){
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let menuVC = storyBoard.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
        
        //Wire master and menu vc's so then can speak to each other
        menuVC.masterViewConroller = self
        self.menuViewController = menuVC
    }

}
