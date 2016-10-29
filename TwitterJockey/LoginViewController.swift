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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func onTwitterLoginButtonTapped(_ sender: UIButton) {
        
        let twitterClient = TwitterClient.sharedInstance
        twitterClient?.login(
            success: {()->Void in
                print("Logged in!")
                self.performSegue(withIdentifier: "loginSegue", sender: nil)},
            failure: {(error: Error?)->Void in
                if let error = error{
                    print("\(error.localizedDescription)")
                }else{
                    print("Login returned a nil erorr inside the failure block, WTF???")
                }})
        
//        twitterClient?.deauthorize()
//        
//        twitterClient?
//            .fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: URL(string:"twitterjockey://oauth"), scope: nil,
//                               success: {(requestToken: BDBOAuth1Credential?)->Void in
//                                
//                                print("Got Request Token: \(requestToken!.token!)")
//                                if let authorizeUrl = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken!.token!)") {
//                                    print("inside if statement")
//                                UIApplication.shared.open(authorizeUrl, options: [:], completionHandler: {(wasSuccessful:Bool)->Void in
//                                    print("wasSuccessful \(wasSuccessful)")})
//                                }},
//                               failure: {(error: Error?)->Void in
//                                
//                                print("\(error)")})
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
