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
//                self.performSegue(withIdentifier: "loginSegue", sender: nil)},
                self.performSegue(withIdentifier: "loginToMasterSegue", sender: nil)},
            failure: {(error: Error?)->Void in
                if let error = error{
                    print("\(error.localizedDescription)")
                }else{
                    print("Login returned a nil erorr inside the failure block, WTF???")
                }})
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
