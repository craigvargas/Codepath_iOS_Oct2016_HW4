//
//  ComposeTweetViewController.swift
//  TwitterJockey
//
//  Created by Craig Vargas on 10/31/16.
//  Copyright © 2016 Cvar. All rights reserved.
//

import UIKit

class ComposeTweetViewController: UIViewController, UITextFieldDelegate {
    
    private let maxTweetLength = 140
    
    @IBOutlet weak var userProfilePicImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userScreenNameLabel: UILabel!
    @IBOutlet weak var tweetTextField: UITextField!
    @IBOutlet weak var numCharsLeftInTweetLabel: UILabel!
    
    var tweet = Tweet(dict: [:])
    
    var tweetType = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUserHeader()
        setupTweetTextField()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        print("Replacement String: \(string)")
        print("Range - location: \(range.location)  length: \(range.length)")
        if let currentText = textField.text{
            if range.length > 0{
                return true
            }else{
                let currentChars = currentText.characters
                let length = currentChars.count
                return length < maxTweetLength
            }
//            let currentChars = currentText.characters
//            let index = currentChars.index(<#T##i: String.CharacterView.Index##String.CharacterView.Index#>, offsetBy: <#T##Int#>)
//            let length = currentChars.count
//            let newRange = Range(uncheckedBounds: (lower: range.location, upper: (range.location + range.length)))
//            let newText = currentText.replacingCharacters(in: newRange, with: string)
//            return length < maxTweetLength
        }else{
            return true
        }
    }
    

    @IBAction func onCancelTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onTweetTapped(_ sender: UIBarButtonItem) {
        if let tweetText = self.tweetTextField.text{
            if(self.tweetType == Tweet.replyTweetType){
                self.tweet.reply(
                    status: tweetText,
                    success: {(tweet: Tweet)->Void in
                        print("Reply successful")},
                    failure: {(error: Error)->Void in
                        print("error in reply: \(error.localizedDescription)")})
            }else if(self.tweetType == Tweet.newTweetType){
                Tweet.tweet(
                    status: tweetText,
                    success: {(tweet: Tweet)->Void in
                        print("Reply successful")},
                    failure: {(error: Error)->Void in
                        print("error in reply: \(error.localizedDescription)")})
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    func setupTweetTextField(){
        tweetTextField.delegate = self
        tweetTextField.addTarget(self, action: #selector(onTextFieldValueChanged), for: UIControlEvents.editingChanged)
        if self.tweetType == Tweet.replyTweetType{
            if self.tweet.userScreenName != nil {
                self.tweetTextField.text = "@\(self.tweet.userScreenName!)"
            }
        }
    }
    
    func onTextFieldValueChanged(){
        if let tweetText = tweetTextField.text{
            let charsLeft = maxTweetLength - tweetText.characters.count
            self.numCharsLeftInTweetLabel.text = "\(charsLeft)"
            print("\(charsLeft)")
        }else{
            let charsLeft = 140
            self.numCharsLeftInTweetLabel.text = "\(charsLeft)"
            print("\(charsLeft)")
        }
    }
    
    func setupUserHeader(){
        if let currentUser = User.currentUser{
            if currentUser.profileUrl != nil{
                self.userProfilePicImageView.setImageWith((currentUser.profileUrl)!, placeholderImage: #imageLiteral(resourceName: "iconmonstr-user-gray-20-72"))
            }
            self.userNameLabel.text = currentUser.name
            if currentUser.screenName != nil{
                self.userScreenNameLabel.text = "@\(currentUser.screenName!)"
            }
        }
    }
    
    func acceptTweet(tweet: Tweet){
        self.tweet = tweet
    }
    
    func acceptTweetType(tweetType: String){
        self.tweetType = tweetType
    }
}
