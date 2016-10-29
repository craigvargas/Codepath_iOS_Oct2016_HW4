//
//  TwitterClient.swift
//  TwitterJockey
//
//  Created by Craig Vargas on 10/28/16.
//  Copyright © 2016 Cvar. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {
    
    static let logoutNotification = NSNotification.Name("userDidLogout")
    
    static let sharedInstance = TwitterClient(baseURL: URL(string:"https://api.twitter.com"), consumerKey: "Z8VdpjFaM1kuibhcbVK0A0AHA", consumerSecret: "jNEovWyUNcXVdMuwUXQtjzzCIMJFZe2Y9SXiVzv70XJtpBfjs3")
    
    var loginSuccess: (()->())?
    var loginFailure: ((Error?)->Void)?
    
    func login(success: @escaping ()->(), failure: @escaping (Error?)->()){
        self.loginSuccess = success
        self.loginFailure = failure
        
        deauthorize()
        
        fetchRequestToken(
            withPath: "oauth/request_token", method: "GET", callbackURL: URL(string:"twitterjockey://oauth"), scope: nil,
            success: {(requestToken: BDBOAuth1Credential?)->Void in
                print("Got Request Token: \(requestToken!.token!)")
                if let authorizeUrl = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken!.token!)") {
                    print("inside if statement")
                    UIApplication.shared.open(
                        authorizeUrl, options: [:],
                        completionHandler: {(wasSuccessful:Bool)->Void in
                            print("wasSuccessful \(wasSuccessful)")})}},
            failure: {(error: Error?)->Void in
                self.loginFailure?(error)})}
    
    func logout(){
        User.currentUser = nil
        deauthorize()
        NotificationCenter.default.post(name: TwitterClient.logoutNotification, object: nil)
    }
    
    func handleOpenUrl(url: URL, failure: @escaping (_ message: String)->Void){
        if let requestToken = BDBOAuth1Credential(queryString: url.query){

            TwitterClient.sharedInstance?.fetchAccessToken(
                withPath: "oauth/access_token", method: "POST", requestToken: requestToken,
                success: {(accessToken: BDBOAuth1Credential?)->Void in
                    self.currentAccount(
                        success: {(currentUser: User)->Void in
                            User.currentUser = currentUser
                            self.loginSuccess?()},
                        failure: {(error: Error?)->Void in
                            self.loginFailure?(error)})},
                failure: {(error: Error?)->Void in
                    self.loginFailure?(error)})
        }else{
            failure("request Token could not be parsed out of the url query")
        }
    }

    func homeTimeline(success: @escaping ( [Tweet])->(), failure: @escaping (Error)->() ){
        _ = get(
            "1.1/statuses/home_timeline.json", parameters: nil, progress: nil,
            success: {(task: URLSessionDataTask, response: Any?)->Void in

                if let dicts = response as? [Dictionary<String,Any>]{
                    let tweets = Tweet.tweets(withArray: dicts)
                    success(tweets)
                }
            },
            failure: {(task: URLSessionDataTask?, error: Error)->Void in
                failure(error)
            }
        )
    }
    
    func currentAccount( success: @escaping (User)->(), failure: @escaping (Error?)->() ){
        _ = get(
            "1.1/account/verify_credentials.json", parameters: nil, progress: nil,
            success: {(task: URLSessionDataTask, response: Any?)->Void in
                
                if let userDict = response as? Dictionary<String,Any>{
                    let currentUser = User(dict: userDict)
                    success(currentUser)
                }
            },
            failure: {(task: URLSessionDataTask?, error: Error)->Void in
                failure(error)
            }
        )
    }

}
