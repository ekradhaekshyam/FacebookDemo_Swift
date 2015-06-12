//
//  ViewController.swift
//  AirStream
//
//  Created by Shyam Gosavi on 01/06/15.
//  Copyright (c) 2015 Shyam Gosavi. All rights reserved.
//

import UIKit

class ViewController: UIViewController, FBSDKLoginButtonDelegate ,FBhelperClassDelegate{

    @IBOutlet weak var loginButtonView: UIView!
    let fbPermissionList = ["public_profile", "email", "user_friends","user_photos","user_videos"]

    @IBOutlet weak var loaderView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let loginView : FBSDKLoginButton = FBSDKLoginButton()
        loginView.frame  = CGRectMake(0,0,self.loginButtonView.frame.size.width,self.loginButtonView.frame.size.height)
        self.loginButtonView.addSubview(loginView)
        loginView.readPermissions = fbPermissionList
        loginView.delegate = self
        self.checkFBLogin()
        self.loaderView.hidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /** Checking if user already login or not, if it already login show profile page with photos and video
    * @param empty
    * @return void
    */
    func checkFBLogin(){
        if (FBSDKAccessToken.currentAccessToken() != nil)
        {
            // User is already logged in, Show userProfile , fetch album list
            self.fillUserData()
        }
        else{
            self.loaderView.hidden = true
        }
    }
    /**
    Call facebook API for getting user details
    
    :param: empty
    
    :returns:
    */
    func fillUserData()
    {
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: nil)
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            
            if ((error) != nil)
            {
                // Process error
                println("Error: \(error)")
                ///Try one more time
                self.fillUserData()
            }
            else
            {
                println("fetched user: \(result)")
                var user = User.sharedInstance()

                let userName : NSString = result.valueForKey("name") as! NSString
                user.userDict.setObject(userName, forKey: "name")
                
                let userEmail : NSString = result.valueForKey("email") as! NSString
                user.userDict.setObject(userEmail, forKey: "email")
                user.userDict = result as! NSMutableDictionary
                FacebookHelper.delegate = self
                FacebookHelper.getPhotoAlbumList()
                
            }
        })
    }

    

    /*
    * Facebook delegate methods
    *  
    */
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        println("User Logged In")
        
        if ((error) != nil)
        {
            // Process error
        }
        else if result.isCancelled {
            // Handle cancellations
        }
        else {
            // If you ask for multiple permissions at once, you
            // should check if specific permissions missing
            if result.grantedPermissions.contains("user_photos") && result.grantedPermissions.contains("user_videos") && result.grantedPermissions.contains("email")
            {
                self.fillUserData()
            }
        }
    }

///    FBSDKLoginButton delegate
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        println("User Logged Out")
    }

///    FBhelperDelegate
    func albumResult() {
        //Go to Next viewController
         self.loaderView.hidden = true
        self.performSegueWithIdentifier("userProfileSegue", sender: self)
    }
}

