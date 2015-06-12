//
//  UserProfile.swift
//  FacebookTutorial
//
//  Created by Shyam Gosavi on 01/06/15.
//  Copyright (c) 2015 Brian Coleman. All rights reserved.
//

import Foundation
import UIKit

class UserProfile : UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,AlbumCellDelegate{
    
    @IBOutlet weak var photoTab: UIButton!
    @IBOutlet weak var videoTab: UIButton!
    @IBOutlet weak var mediaCollectionView: UICollectionView!
    @IBOutlet weak var userProfileView: UIView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileNameLabel: UILabel!
    @IBOutlet weak var valueOfEmail: UILabel!
    @IBOutlet weak var valueOfGender: UILabel!
    
    var selectedIndex:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var cellNib = UINib(nibName: "AlbumViewCell", bundle: nil)
        
        self.mediaCollectionView.registerNib(cellNib, forCellWithReuseIdentifier: "albumViewCell")
        
        var flowLayout = UICollectionViewFlowLayout()
        
        flowLayout.itemSize = CGSizeMake(100, 100)
        flowLayout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        self.mediaCollectionView.setCollectionViewLayout(flowLayout, animated: true)
        self.photoTab.selected = true
        self.videoTab.selected = false
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.title = ""
        var logout  = UIBarButtonItem(title: "Logout", style: UIBarButtonItemStyle.Plain, target: self, action: "logoutButtonClicked")
        
        navigationItem.rightBarButtonItem = logout
        
        let userName = User.sharedInstance().userDict["name"] as! String
        var profileButton  = UIBarButtonItem(title:userName, style: UIBarButtonItemStyle.Plain, target: self, action: "profileButtonClicked")
        
        navigationItem.leftBarButtonItem = profileButton
        
        
        let userGender = User.sharedInstance().userDict["gender"] as! String
        let userID = User.sharedInstance().userDict["id"] as! String
        self.valueOfGender.text = userGender
        self.valueOfEmail.text = User.sharedInstance().userDict["email"] as? String
        self.profileNameLabel.text = userName.capitalizedString
        
        
        
        let url = NSURL(string: "https://graph.facebook.com/\(userID)/picture?type=large")
        let urlRequest = NSURLRequest(URL: url!)
        
        NSURLConnection.sendAsynchronousRequest(urlRequest, queue: NSOperationQueue.mainQueue()) { (response:NSURLResponse!, data:NSData!, error:NSError!) -> Void in
            
            // Display the image
            let image = UIImage(data: data)
            if image != nil {
            self.profileImage.image = image
            }
            else{
                if userGender == "male"{
                    self.profileImage.image = UIImage(named: "maleAvtar")
                }
                else {
                    self.profileImage.image = UIImage(named: "femaleAvtar")
                }
            }
            
        }
        self.mediaCollectionView.layer.shadowColor = UIColor.grayColor().CGColor
        self.mediaCollectionView.layer.shadowOffset = CGSizeMake(-15, 20);
        self.mediaCollectionView.layer.shadowRadius = 5;
        self.mediaCollectionView.layer.shadowOpacity = 0.5;
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    ///UICollectionView Datasource
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
    
        return 1
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cellIdentifier = "albumViewCell"
        
        var cell:AlbumViewCell = self.mediaCollectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifier, forIndexPath: indexPath) as! AlbumViewCell
        
        let album:Album = FacebookHelper.albumArray[indexPath.row]
        
            cell.albumName.text = album.name
            cell.album = album
            cell.horizentalView.hidden = true
            cell.verticalView.hidden = true
            cell.horizentalImageView.image = nil
            cell.verticalImageView.image = nil
            cell.cellIndex = indexPath.row
            cell.album?.delegate = cell
            if  album.coverImage == nil{
                cell.loadImage()
            }
            else{
                cell.assigncoverImage(album)
                println("image present")
            }
            cell.delegate = self
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return FacebookHelper.albumArray.count
    }
    
    
  /**
    * Logout from facebook
    */
    func logoutButtonClicked(){
//        FBSession.activeSession().closeAndClearTokenInformation()
        
        let loginManager = FBSDKLoginManager()
        loginManager.logOut()
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    func profileButtonClicked(){
        //Show user profile
        self.userProfileView.hidden = !self.userProfileView.hidden
        
    }
    
    
    @IBAction func photoTabSelected(sender: AnyObject) {
        self.photoTab.selected = true
        self.videoTab.selected = false

    }
    @IBAction func videoTabSelected(sender: AnyObject) {
//        self.photoTab.selected = false
//        self.videoTab.selected = true
        
        //For Now
        self.photoTab.selected = true
        self.videoTab.selected = false
        
        var alert = UIAlertController(title: "AirStream", message: "Work in process", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { action in
            switch action.style{
            case .Default:
                println("default")
                
            case .Cancel:
                println("cancel")
                
            case .Destructive:
                println("destructive")
            }
        }))

    }
    
    //AlbumCellDelegate method
    func seletedAlbum(index: Int) {
        self.selectedIndex = index
        self.performSegueWithIdentifier("photoViews", sender: self)
    }
    
    func assignCoverImage(album: Album, index:Int) {
        FacebookHelper.albumArray[index] = album
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "photoViews") {
            var photoController = segue.destinationViewController as! PhotosViewController
            let tempalbum:Album =  FacebookHelper.albumArray[self.selectedIndex]
            
            photoController.albumId = "\(tempalbum.aid)"
            photoController.albumname = tempalbum.name
        }
    }
    
}
