//
//  LoginViewController.swift
//  TwitterJockey
//
//  Created by Craig Vargas on 10/28/16.
//  Copyright © 2016 Cvar. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var loginBtnHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var loginBtnWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func onTwitterLoginButtonTapped(_ sender: UIButton) {
        
        UIView.animate(
            withDuration: 0.7,
            animations: {
                self.loginButton.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI))})
        
        UIView.animate(
            withDuration: 0.7,
            delay: 0.35,
            options: [],
            animations: {
                self.loginButton.transform = CGAffineTransform(rotationAngle: 2.0*CGFloat(M_PI))},
            completion: nil)
        
        UIView.animate(
            withDuration: 0.3,
            delay: 1.4,
            options: [],
            animations: {
                self.loginButton.transform = CGAffineTransform(scaleX: 1.8, y: 1.8)},
            completion: {(isInnerCompleted: Bool)-> Void in
                self.loginWithTwitter()})
        
//        UIView.animate(
//            withDuration: 0.8,
//            animations: {
//                self.loginButton.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI))
//            },
//            completion: {(isCompleted: Bool)->Void in
//                UIView.animate(
//                    withDuration: 0.8,
//                    animations: {
//                        self.loginButton.transform = CGAffineTransform(rotationAngle: 2.0*CGFloat(M_PI))
//                        self.loginButton.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)},
//                    completion: {(isInnerCompleted: Bool)-> Void in
//                        self.loginWithTwitter()})})
        
//        let twitterClient = TwitterClient.sharedInstance
//        twitterClient?.login(
//            success: {()->Void in
//                print("Logged in!")
////                self.performSegue(withIdentifier: "loginSegue", sender: nil)},
//                self.performSegue(withIdentifier: "loginToMasterSegue", sender: nil)},
//            failure: {(error: Error?)->Void in
//                if let error = error{
//                    print("\(error.localizedDescription)")
//                }else{
//                    print("Login returned a nil erorr inside the failure block, WTF???")
//                }})
    }
    
    func loginWithTwitter(){
        let twitterClient = TwitterClient.sharedInstance
        twitterClient?.login(
            success: {()->Void in
                print("Logged in!")
                self.performSegue(withIdentifier: "loginToMasterSegue", sender: self.loginButton)},
            failure: {(error: Error?)->Void in
                if let error = error{
                    print("\(error.localizedDescription)")
                }else{
                    print("Login returned a nil erorr inside the failure block, WTF???")
                }})
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let masterViewCtrl = segue.destination as! MasterViewController
        masterViewCtrl.setupMenuViewCtrl()
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
